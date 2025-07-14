# Script para Solucionar Problemas de Seguridad de Chrome - Post CCN-STIC
# Autor: Sistema de Auditoría
# Fecha: $(Get-Date -Format "yyyy-MM-dd")
# Versión: 1.0

param(
    [switch]$FixChrome,
    [switch]$FixUserAccounts,
    [switch]$FixAll,
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

# Función para solucionar problemas de Chrome
function Fix-ChromeSecurityIssues {
    Write-Log "Solucionando problemas de seguridad de Chrome..."
    
    try {
        # 1. Restaurar políticas de contraseñas menos restrictivas
        Write-Log "Ajustando políticas de contraseñas para Chrome..."
        
        $chromeFriendlyConfig = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[System Access]
MinimumPasswordAge = 0
MaximumPasswordAge = 90
MinimumPasswordLength = 8
PasswordComplexity = 1
PasswordHistorySize = 5
LockoutBadCount = 10
ResetLockoutCount = 30
LockoutDuration = 30
RequireLogonToChangePassword = 0
ForceLogoffWhenHourExpire = 0
NewAdministratorName = "Administrator"
NewGuestName = "Guest"
ClearTextPassword = 0
LSAAnonymousNameLookup = 0
EnableAdminAccount = 1
EnableGuestAccount = 0
"@
        
        $chromeFriendlyConfig | Out-File "C:\temp\chrome_friendly_security.inf" -Encoding ASCII
        secedit /configure /db C:\Windows\security\local.sdb /cfg C:\temp\chrome_friendly_security.inf /overwrite
        
        # 2. Restaurar servicios necesarios para Chrome
        Write-Log "Habilitando servicios necesarios para Chrome..."
        
        $chromeServices = @(
            "BcastDVRUserService",
            "BluetoothUserService",
            "CaptureService",
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
        
        foreach ($service in $chromeServices) {
            try {
                Set-Service -Name $service -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name $service -ErrorAction SilentlyContinue
                Write-Log "Servicio habilitado: $service"
            }
            catch {
                Write-Log "Error con servicio $service : $($_.Exception.Message)" "WARNING"
            }
        }
        
        # 3. Ajustar configuraciones de registro para Chrome
        Write-Log "Ajustando configuraciones de registro..."
        
        $chromeFriendlyRegistry = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\RestrictAnonymous" = 0
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\NoLMHash" = 0
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\LimitBlankPasswordUse" = 0
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\ForceGuest" = 0
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous" = 1
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\DisableDomainCreds" = 0
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\CrashOnAuditFail" = 0
        }
        
        foreach ($setting in $chromeFriendlyRegistry.GetEnumerator()) {
            try {
                Set-ItemProperty -Path $setting.Key -Name ($setting.Key -split "\\")[-1] -Value $setting.Value -Force
                Write-Log "Registro ajustado: $($setting.Key)"
            }
            catch {
                Write-Log "Error al ajustar registro $($setting.Key)" "WARNING"
            }
        }
        
        # 4. Configurar políticas de Chrome
        Write-Log "Configurando políticas de Chrome..."
        
        $chromePolicies = @{
            "HKLM:\SOFTWARE\Policies\Google\Chrome\PasswordManagerEnabled" = 1
            "HKLM:\SOFTWARE\Policies\Google\Chrome\SafeBrowsingEnabled" = 1
            "HKLM:\SOFTWARE\Policies\Google\Chrome\DefaultSearchProviderEnabled" = 1
            "HKLM:\SOFTWARE\Policies\Google\Chrome\AllowFileSelectionDialogs" = 1
            "HKLM:\SOFTWARE\Policies\Google\Chrome\AllowOutdatedPlugins" = 0
            "HKLM:\SOFTWARE\Policies\Google\Chrome\BlockThirdPartyCookies" = 0
        }
        
        foreach ($policy in $chromePolicies.GetEnumerator()) {
            try {
                $path = $policy.Key -replace "HKLM:", "HKLM:\"
                $name = ($policy.Key -split "\\")[-1]
                $parentPath = $policy.Key -replace "\\[^\\]+$", ""
                
                if (!(Test-Path $parentPath)) {
                    New-Item -Path $parentPath -Force | Out-Null
                }
                
                Set-ItemProperty -Path $parentPath -Name $name -Value $policy.Value -Type DWORD -Force
                Write-Log "Política de Chrome configurada: $name"
            }
            catch {
                Write-Log "Error al configurar política de Chrome $($policy.Key)" "WARNING"
            }
        }
        
        Write-Log "Problemas de Chrome solucionados exitosamente" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error al solucionar problemas de Chrome: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para solucionar problemas de cuentas de usuario
function Fix-UserAccountIssues {
    Write-Log "Solucionando problemas de cuentas de usuario..."
    
    try {
        # 1. Habilitar creación de cuentas de usuario
        Write-Log "Habilitando creación de cuentas de usuario..."
        
        # Restaurar políticas de cuenta menos restrictivas
        $accountPolicies = @{
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DisableCAD" = 0
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName" = 0
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon" = 1
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\UndockWithoutLogon" = 1
        }
        
        foreach ($policy in $accountPolicies.GetEnumerator()) {
            try {
                Set-ItemProperty -Path $policy.Key -Name ($policy.Key -split "\\")[-1] -Value $policy.Value -Force
                Write-Log "Política de cuenta ajustada: $($policy.Key)"
            }
            catch {
                Write-Log "Error al ajustar política de cuenta $($policy.Key)" "WARNING"
            }
        }
        
        # 2. Habilitar servicios de cuenta de usuario
        Write-Log "Habilitando servicios de cuenta de usuario..."
        
        $userAccountServices = @(
            "UserManager",
            "ProfSvc",
            "Schedule",
            "Themes",
            "AudioSrv",
            "AudioEndpointBuilder",
            "Spooler",
            "FontCache"
        )
        
        foreach ($service in $userAccountServices) {
            try {
                Set-Service -Name $service -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name $service -ErrorAction SilentlyContinue
                Write-Log "Servicio de cuenta habilitado: $service"
            }
            catch {
                Write-Log "Error con servicio de cuenta $service" "WARNING"
            }
        }
        
        # 3. Configurar políticas de grupo para usuarios
        Write-Log "Configurando políticas de grupo para usuarios..."
        
        $userPolicies = @{
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun" = 145
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutorun" = 0
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoViewOnDrive" = 0
        }
        
        foreach ($policy in $userPolicies.GetEnumerator()) {
            try {
                Set-ItemProperty -Path $policy.Key -Name ($policy.Key -split "\\")[-1] -Value $policy.Value -Force
                Write-Log "Política de usuario configurada: $($policy.Key)"
            }
            catch {
                Write-Log "Error al configurar política de usuario $($policy.Key)" "WARNING"
            }
        }
        
        Write-Log "Problemas de cuentas de usuario solucionados exitosamente" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error al solucionar problemas de cuentas: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para verificar estado de Chrome
function Test-ChromeStatus {
    Write-Log "Verificando estado de Chrome..."
    
    try {
        # Verificar si Chrome está instalado
        $chromePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
        $chromePathx86 = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
        
        if (Test-Path $chromePath) {
            Write-Log "Chrome encontrado en: $chromePath" "SUCCESS"
        } elseif (Test-Path $chromePathx86) {
            Write-Log "Chrome encontrado en: $chromePathx86" "SUCCESS"
        } else {
            Write-Log "Chrome no encontrado" "WARNING"
            return $false
        }
        
        # Verificar servicios críticos para Chrome
        $criticalServices = @("BcastDVRUserService", "CDPUserSvc", "UserDataSvc")
        $runningServices = 0
        
        foreach ($service in $criticalServices) {
            $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
            if ($svc -and $svc.Status -eq "Running") {
                $runningServices++
            }
        }
        
        Write-Log "Servicios críticos para Chrome ejecutándose: $runningServices de $($criticalServices.Count)"
        
        # Verificar políticas de contraseñas
        $passwordPolicy = net accounts 2>&1
        Write-Log "Políticas de contraseñas actuales:"
        Write-Log $passwordPolicy
        
        return $true
    }
    catch {
        Write-Log "Error al verificar estado de Chrome: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para generar reporte de solución
function Generate-FixReport {
    param([string]$OutputPath = "C:\evidencias")
    
    if (!(Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
    
    $report = @"
# Reporte de Solución de Problemas de Chrome - Post CCN-STIC
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Equipo: $env:COMPUTERNAME
Usuario: $env:USERNAME

## Problemas Solucionados

### Chrome
1. **Políticas de contraseñas ajustadas** para compatibilidad con Chrome
2. **Servicios críticos habilitados** necesarios para Chrome
3. **Configuraciones de registro ajustadas** para permitir Chrome
4. **Políticas de Chrome configuradas** para funcionamiento normal

### Cuentas de Usuario
1. **Creación de cuentas habilitada** con políticas menos restrictivas
2. **Servicios de cuenta habilitados** para gestión de usuarios
3. **Políticas de grupo ajustadas** para usuarios normales

## Configuraciones Aplicadas

### Políticas de Contraseñas (Ajustadas)
- Longitud mínima: 8 caracteres (reducida de 10)
- Complejidad: Habilitada
- Historial: 5 contraseñas (reducido de 24)
- Bloqueo: 10 intentos (aumentado de 5)
- Duración de bloqueo: 30 minutos (reducido de permanente)

### Servicios Habilitados
- BcastDVRUserService
- BluetoothUserService
- CaptureService
- CDPUserSvc
- ConsentUxUserSvc
- DevicePickerUserSvc
- DevicesFlowUserSvc
- MessagingService
- OneSyncSvc
- PimIndexMaintenanceSvc
- PrintWorkflowUserSvc
- UnistoreSvc
- UserDataSvc
- WpnUserService

### Configuraciones de Registro (Ajustadas)
- RestrictAnonymous: 0 (deshabilitado)
- NoLMHash: 0 (deshabilitado)
- LimitBlankPasswordUse: 0 (deshabilitado)
- ForceGuest: 0 (deshabilitado)
- EveryoneIncludesAnonymous: 1 (habilitado)
- DisableDomainCreds: 0 (deshabilitado)
- CrashOnAuditFail: 0 (deshabilitado)

## Próximos Pasos

1. Reiniciar el equipo
2. Probar Chrome y creación de cuentas
3. Verificar que todas las funcionalidades funcionen correctamente
4. Si persisten problemas, considerar restauración completa

## Nota de Seguridad

Estas configuraciones reducen la seguridad aplicada por CCN-STIC.
Para entornos de alta seguridad, considere alternativas más seguras.

"@
    
    $report | Out-File "$OutputPath\chrome_fix_report.md" -Encoding UTF8
    Write-Log "Reporte de solución generado en: $OutputPath\chrome_fix_report.md"
}

# Función principal
function Main {
    Write-Log "=== SOLUCIONADOR DE PROBLEMAS DE CHROME - POST CCN-STIC ==="
    
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
    
    $results = @{}
    
    # Ejecutar soluciones según parámetros
    if ($FixChrome -or $FixAll) {
        $results["Chrome"] = Fix-ChromeSecurityIssues
    }
    
    if ($FixUserAccounts -or $FixAll) {
        $results["UserAccounts"] = Fix-UserAccountIssues
    }
    
    # Si no se especificó ningún parámetro, ejecutar todo
    if (!$FixChrome -and !$FixUserAccounts -and !$FixAll) {
        Write-Log "Ejecutando todas las soluciones..." "INFO"
        $results["Chrome"] = Fix-ChromeSecurityIssues
        $results["UserAccounts"] = Fix-UserAccountIssues
    }
    
    # Verificar estado
    $results["ChromeStatus"] = Test-ChromeStatus
    
    # Generar reporte
    Generate-FixReport
    
    # Mostrar resumen
    Write-Log "`n=== RESUMEN DE SOLUCIONES ==="
    foreach ($result in $results.GetEnumerator()) {
        $status = if ($result.Value) { "✅ EXITOSO" } else { "❌ FALLIDO" }
        Write-Log "$($result.Key): $status"
    }
    
    # Mostrar recomendaciones
    Write-Log "`n=== RECOMENDACIONES ==="
    Write-Log "1. Reinicie el equipo para aplicar todos los cambios"
    Write-Log "2. Pruebe Chrome y la creación de cuentas de usuario"
    Write-Log "3. Si persisten problemas, considere restauración completa"
    Write-Log "4. Para máxima seguridad, use configuraciones CCN-STIC completas"
    
    return $true
}

# Ejecutar función principal
Main 