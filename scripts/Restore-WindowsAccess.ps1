# Script de Emergencia - Restaurar Acceso a Windows
# USAR SOLO EN CASO DE EMERGENCIA - Después de aplicar CCN-STIC
# Autor: Sistema de Auditoría
# Fecha: $(Get-Date -Format "yyyy-MM-dd")
# Versión: 1.0

param(
    [string]$NewPassword = "NuevaContraseña123!",
    [switch]$Force,
    [switch]$Verbose
)

# Función para escribir logs
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
}

# Función para verificar permisos de administrador
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Función para restaurar políticas de contraseñas
function Restore-PasswordPolicies {
    Write-Log "Restaurando políticas de contraseñas por defecto..."
    
    try {
        # Crear archivo de configuración por defecto
        $restoreConfig = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[System Access]
MinimumPasswordAge = 0
MaximumPasswordAge = 42
MinimumPasswordLength = 0
PasswordComplexity = 0
PasswordHistorySize = 0
LockoutBadCount = 0
ResetLockoutCount = 0
LockoutDuration = 0
RequireLogonToChangePassword = 0
ForceLogoffWhenHourExpire = 0
NewAdministratorName = "Administrator"
NewGuestName = "Guest"
ClearTextPassword = 0
LSAAnonymousNameLookup = 0
EnableAdminAccount = 1
EnableGuestAccount = 0
"@
        
        $restoreConfig | Out-File "C:\temp\restore_security.inf" -Encoding ASCII
        
        # Aplicar configuración
        $result = secedit /configure /db C:\Windows\security\local.sdb /cfg C:\temp\restore_security.inf /overwrite 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Políticas de contraseñas restauradas exitosamente" "SUCCESS"
            return $true
        } else {
            Write-Log "Error al restaurar políticas: $result" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Error al restaurar políticas de contraseñas: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para restaurar servicios críticos
function Restore-CriticalServices {
    Write-Log "Restaurando servicios críticos..."
    
    $criticalServices = @(
        "BcastDVRUserService",
        "BluetoothUserService", 
        "CaptureService",
        "cbdhsvc",
        "CDPUserSvc",
        "ConsentUxUserSvc",
        "DevicePickerUserSvc",
        "DevicesFlowUserSvc",
        "MessagingService",
        "OneSyncSvc",
        "PimIndexMaintenanceSvc",
        "PrintWorkflowUserSvc",
        "UnistoreSvc",
        "UserDataSvc",
        "WpnUserService"
    )
    
    $restoredCount = 0
    
    foreach ($service in $criticalServices) {
        try {
            $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
            if ($svc) {
                Set-Service -Name $service -StartupType Automatic
                Start-Service -Name $service -ErrorAction SilentlyContinue
                $restoredCount++
                Write-Log "Servicio restaurado: $service"
            }
        }
        catch {
            Write-Log "Error al restaurar servicio $service : $($_.Exception.Message)" "WARNING"
        }
    }
    
    Write-Log "Servicios restaurados: $restoredCount de $($criticalServices.Count)" "SUCCESS"
    return $restoredCount
}

# Función para restaurar configuración de registro
function Restore-RegistrySettings {
    Write-Log "Restaurando configuración de registro..."
    
    $registrySettings = @{
        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\RestrictAnonymous" = 0
        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\NoLMHash" = 0
        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\LimitBlankPasswordUse" = 0
        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\ForceGuest" = 0
        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous" = 1
        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\DisableDomainCreds" = 0
        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\CrashOnAuditFail" = 0
    }
    
    $restoredCount = 0
    
    foreach ($setting in $registrySettings.GetEnumerator()) {
        try {
            Set-ItemProperty -Path $setting.Key -Name ($setting.Key -split "\\")[-1] -Value $setting.Value -Force
            $restoredCount++
            Write-Log "Registro restaurado: $($setting.Key)"
        }
        catch {
            Write-Log "Error al restaurar registro $($setting.Key) : $($_.Exception.Message)" "WARNING"
        }
    }
    
    Write-Log "Configuraciones de registro restauradas: $restoredCount" "SUCCESS"
    return $restoredCount
}

# Función para restaurar política de ejecución
function Restore-ExecutionPolicy {
    Write-Log "Restaurando política de ejecución de PowerShell..."
    
    try {
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
        
        Write-Log "Política de ejecución restaurada exitosamente" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error al restaurar política de ejecución: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para habilitar cuentas de usuario
function Enable-UserAccounts {
    param([string]$Password)
    
    Write-Log "Habilitando cuentas de usuario..."
    
    try {
        # Habilitar cuenta de administrador
        $adminResult = net user administrator /active:yes 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Cuenta de administrador habilitada" "SUCCESS"
        }
        
        # Cambiar contraseña de administrador
        $passwordResult = net user administrator $Password 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Contraseña de administrador cambiada" "SUCCESS"
        }
        
        # Habilitar cuenta de invitado (opcional)
        $guestResult = net user guest /active:yes 2>&1
        
        Write-Log "Cuentas de usuario configuradas" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error al configurar cuentas: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para generar reporte de restauración
function Generate-RestoreReport {
    param([string]$OutputPath = "C:\evidencias")
    
    if (!(Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
    
    $report = @"
# Reporte de Restauración de Acceso a Windows
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Equipo: $env:COMPUTERNAME
Usuario: $env:USERNAME

## Acciones Realizadas

1. **Políticas de contraseñas restauradas** a configuración por defecto
2. **Servicios críticos habilitados** y configurados como automáticos
3. **Configuración de registro restaurada** a valores por defecto
4. **Política de ejecución de PowerShell** configurada como Unrestricted
5. **Cuenta de administrador habilitada** con nueva contraseña

## Credenciales de Acceso

- **Usuario:** Administrator
- **Contraseña:** $NewPassword

## Próximos Pasos

1. Reiniciar el equipo
2. Iniciar sesión con la cuenta de administrador
3. Verificar que todas las aplicaciones funcionen correctamente
4. Revisar logs en: $OutputPath\restore_emergency.log

## Advertencia

Esta restauración elimina todas las configuraciones de seguridad CCN-STIC.
Para volver a aplicar las configuraciones, use los scripts originales con precaución.

"@
    
    $report | Out-File "$OutputPath\restore_emergency_report.md" -Encoding UTF8
    Write-Log "Reporte de restauración generado en: $OutputPath\restore_emergency_report.md"
}

# Función principal
function Main {
    Write-Log "=== SCRIPT DE EMERGENCIA - RESTAURAR ACCESO A WINDOWS ==="
    Write-Log "ADVERTENCIA: Este script elimina configuraciones de seguridad CCN-STIC"
    
    if (!$Force) {
        Write-Log "Para continuar, use el parámetro -Force" "WARNING"
        Write-Log "Ejemplo: .\Restore-WindowsAccess.ps1 -Force -NewPassword 'MiContraseña123!'" "INFO"
        return $false
    }
    
    # Verificar permisos de administrador
    if (!(Test-Administrator)) {
        Write-Log "Este script requiere permisos de administrador" "ERROR"
        Write-Log "Ejecute PowerShell como Administrador" "INFO"
        return $false
    }
    
    # Crear directorio temporal
    if (!(Test-Path "C:\temp")) {
        New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null
    }
    
    # Ejecutar restauraciones
    $results = @{}
    
    Write-Log "Iniciando proceso de restauración..."
    
    # Restaurar políticas de contraseñas
    $results["PasswordPolicies"] = Restore-PasswordPolicies
    
    # Restaurar servicios críticos
    $results["CriticalServices"] = Restore-CriticalServices
    
    # Restaurar configuración de registro
    $results["RegistrySettings"] = Restore-RegistrySettings
    
    # Restaurar política de ejecución
    $results["ExecutionPolicy"] = Restore-ExecutionPolicy
    
    # Habilitar cuentas de usuario
    $results["UserAccounts"] = Enable-UserAccounts -Password $NewPassword
    
    # Generar reporte
    Generate-RestoreReport
    
    # Mostrar resumen
    Write-Log "`n=== RESUMEN DE RESTAURACIÓN ==="
    foreach ($result in $results.GetEnumerator()) {
        $status = if ($result.Value) { "✅ EXITOSO" } else { "❌ FALLIDO" }
        Write-Log "$($result.Key): $status"
    }
    
    # Mostrar credenciales
    Write-Log "`n=== CREDENCIALES DE ACCESO ==="
    Write-Log "Usuario: Administrator"
    Write-Log "Contraseña: $NewPassword"
    Write-Log "`n⚠️ IMPORTANTE: Reinicie el equipo ahora"
    
    return $true
}

# Ejecutar función principal
Main 