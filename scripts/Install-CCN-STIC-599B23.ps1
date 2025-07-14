# Script de Instalación Automatizada CCN-STIC 599B23
# Autor: Sistema de Auditoría
# Fecha: $(Get-Date -Format "yyyy-MM-dd")
# Versión: 1.0

param(
    [string]$ScriptsPath = "C:\Scripts\ESTANDAR",
    [string]$LogPath = "C:\evidencias",
    [switch]$SkipBackup,
    [switch]$Force,
    [switch]$Verbose
)

# Verificar si se ejecuta como administrador
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Función para escribir logs
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "$LogPath\installation.log" -Value $logMessage
}

# Función para crear backup del sistema
function New-SystemBackup {
    Write-Log "Creando backup del sistema..."
    
    try {
        $backupPath = "$LogPath\backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        
        # Exportar configuración de seguridad actual
        secedit /export /cfg "$backupPath\security_backup.inf" /log "$backupPath\security_backup.log" 2>$null
        
        # Exportar configuración de servicios
        Get-Service | Export-Csv "$backupPath\services_backup.csv" -NoTypeInformation
        
        # Exportar configuración de registro crítica
        $registryPaths = @(
            "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa",
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        )
        
        foreach ($path in $registryPaths) {
            $name = ($path -split "\\")[-1]
            reg export $path "$backupPath\registry_${name}.reg" /y 2>$null
        }
        
        Write-Log "Backup creado en: $backupPath"
        return $backupPath
    }
    catch {
        Write-Log "Error al crear backup: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Función para verificar archivos requeridos
function Test-RequiredFiles {
    Write-Log "Verificando archivos requeridos..."
    
    $requiredFiles = @(
        "CCN-STIC-599B23 Incremental Servicios (Estandar).inf",
        "CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).inf",
        "CCN-STIC-599B23 Cliente Independiente - Paso 1 - Servicios.bat",
        "CCN-STIC-599B23 Cliente Independiente - Paso 2 - GPO.bat",
        "CCN-STIC-599B23 Cliente Independiente - Paso 3 - Firewall.bat",
        "CCN-STIC-599B23 Cliente Independiente - Paso 4 - Aplica plantilla y reinicia.bat"
    )
    
    $missingFiles = @()
    
    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $ScriptsPath $file
        if (!(Test-Path $filePath)) {
            $missingFiles += $file
        }
    }
    
    if ($missingFiles.Count -gt 0) {
        Write-Log "Archivos faltantes:" "ERROR"
        foreach ($file in $missingFiles) {
            Write-Log "  - $file" "ERROR"
        }
        return $false
    }
    
    Write-Log "Todos los archivos requeridos están presentes"
    return $true
}

# Función para ejecutar paso 1 (Servicios)
function Invoke-Step1-Services {
    Write-Log "Ejecutando Paso 1: Configuración de Servicios..."
    
    try {
        $templatePath = Join-Path $ScriptsPath "CCN-STIC-599B23 Incremental Servicios (Estandar).inf"
        $dbPath = Join-Path $ScriptsPath "servicios_windows.sdb"
        $logPath = Join-Path $ScriptsPath "servicios_windows.log"
        
        $result = secedit /configure /quiet /db $dbPath /cfg $templatePath /overwrite /log $logPath 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Paso 1 completado exitosamente"
            return $true
        } else {
            Write-Log "Error en Paso 1: $result" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Error al ejecutar Paso 1: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para ejecutar paso 2 (GPO)
function Invoke-Step2-GPO {
    Write-Log "Ejecutando Paso 2: Configuración de GPO..."
    
    try {
        $templatePath = Join-Path $ScriptsPath "CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).inf"
        $dbPath = Join-Path $ScriptsPath "gpo_windows.sdb"
        $logPath = Join-Path $ScriptsPath "gpo_windows.log"
        
        $result = secedit /configure /quiet /db $dbPath /cfg $templatePath /overwrite /log $logPath 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Paso 2 completado exitosamente"
            return $true
        } else {
            Write-Log "Error en Paso 2: $result" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Error al ejecutar Paso 2: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para ejecutar paso 3 (Firewall)
function Invoke-Step3-Firewall {
    Write-Log "Ejecutando Paso 3: Configuración de Firewall..."
    
    try {
        $wfwPath = Join-Path $ScriptsPath "CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).wfw"
        $logPath = Join-Path $ScriptsPath "firewall_windows.log"
        
        if (Test-Path $wfwPath) {
            $result = netsh advfirewall import $wfwPath 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Paso 3 completado exitosamente"
                return $true
            } else {
                Write-Log "Error en Paso 3: $result" "ERROR"
                return $false
            }
        } else {
            Write-Log "Archivo de firewall no encontrado: $wfwPath" "WARNING"
            return $true  # No es crítico
        }
    }
    catch {
        Write-Log "Error al ejecutar Paso 3: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para ejecutar paso 4 (Aplicar plantilla y reiniciar)
function Invoke-Step4-Template {
    Write-Log "Ejecutando Paso 4: Aplicar plantilla final..."
    
    try {
        $templatePath = Join-Path $ScriptsPath "CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).inf"
        $dbPath = Join-Path $ScriptsPath "final_windows.sdb"
        $logPath = Join-Path $ScriptsPath "final_windows.log"
        
        $result = secedit /configure /quiet /db $dbPath /cfg $templatePath /overwrite /log $logPath 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Paso 4 completado exitosamente"
            return $true
        } else {
            Write-Log "Error en Paso 4: $result" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Error al ejecutar Paso 4: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para aplicar configuraciones adicionales
function Invoke-AdditionalConfigurations {
    Write-Log "Aplicando configuraciones adicionales..."
    
    $additionalScripts = @(
        "CCN-STIC-599B23 Cliente Independiente - Windows Defender (Estandar).bat",
        "CCN-STIC-599B23 Cliente Independiente - Control Dispositivos.bat",
        "CCN-STIC-599B23 Cliente Independiente - Actualizaciones WU.bat",
        "CCN-STIC-599B23 Cliente Independiente - Acceso Remoto RDP (Estandar).bat"
    )
    
    $results = @{}
    
    foreach ($script in $additionalScripts) {
        $scriptPath = Join-Path $ScriptsPath $script
        if (Test-Path $scriptPath) {
            Write-Log "Ejecutando: $script"
            try {
                $result = & cmd /c $scriptPath 2>&1
                $results[$script] = $LASTEXITCODE -eq 0
                if ($results[$script]) {
                    Write-Log "$script completado exitosamente"
                } else {
                    Write-Log "Error en $script: $result" "WARNING"
                }
            }
            catch {
                Write-Log "Error al ejecutar $script: $($_.Exception.Message)" "WARNING"
                $results[$script] = $false
            }
        } else {
            Write-Log "Script no encontrado: $script" "WARNING"
            $results[$script] = $false
        }
    }
    
    return $results
}

# Función para verificar instalación
function Test-Installation {
    Write-Log "Verificando instalación..."
    
    $verificationResults = @{}
    
    # Verificar políticas de contraseñas
    try {
        $securityPolicy = secedit /export /cfg "$LogPath\verification_security.inf" 2>$null
        if (Test-Path "$LogPath\verification_security.inf") {
            $content = Get-Content "$LogPath\verification_security.inf"
            
            $passwordChecks = @{
                MinimumPasswordLength = ($content | Select-String "MinimumPasswordLength\s*=\s*10").Count -gt 0
                PasswordComplexity = ($content | Select-String "PasswordComplexity\s*=\s*1").Count -gt 0
                LockoutBadCount = ($content | Select-String "LockoutBadCount\s*=\s*5").Count -gt 0
            }
            
            $verificationResults["Políticas de Contraseñas"] = ($passwordChecks.Values | Where-Object { $_ -eq $false }).Count -eq 0
        }
    }
    catch {
        $verificationResults["Políticas de Contraseñas"] = $false
    }
    
    # Verificar servicios críticos
    $criticalServices = @("BcastDVRUserService", "BluetoothUserService", "CaptureService")
    $disabledServices = 0
    foreach ($service in $criticalServices) {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc -and $svc.StartType -eq "Disabled") {
            $disabledServices++
        }
    }
    $verificationResults["Servicios Críticos"] = $disabledServices -eq $criticalServices.Count
    
    # Verificar Windows Defender
    try {
        $defenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
        if ($defenderStatus) {
            $verificationResults["Windows Defender"] = $defenderStatus.RealTimeProtectionEnabled
        } else {
            $verificationResults["Windows Defender"] = $false
        }
    }
    catch {
        $verificationResults["Windows Defender"] = $false
    }
    
    return $verificationResults
}

# Función principal
function Main {
    Write-Log "Iniciando instalación CCN-STIC 599B23..."
    
    # Verificar permisos de administrador
    if (!(Test-Administrator)) {
        Write-Log "Este script requiere permisos de administrador" "ERROR"
        return $false
    }
    
    # Crear directorios necesarios
    if (!(Test-Path $LogPath)) {
        New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
    }
    
    if (!(Test-Path $ScriptsPath)) {
        Write-Log "Directorio de scripts no encontrado: $ScriptsPath" "ERROR"
        return $false
    }
    
    # Verificar archivos requeridos
    if (!(Test-RequiredFiles)) {
        Write-Log "Faltan archivos requeridos. Verifique que todos los scripts CCN-STIC estén en: $ScriptsPath" "ERROR"
        return $false
    }
    
    # Crear backup si no se omite
    if (!$SkipBackup) {
        $backupPath = New-SystemBackup
        if (!$backupPath) {
            if (!$Force) {
                Write-Log "No se pudo crear backup. Use -Force para continuar sin backup" "ERROR"
                return $false
            } else {
                Write-Log "Continuando sin backup (modo forzado)" "WARNING"
            }
        }
    }
    
    # Ejecutar pasos en orden
    $stepResults = @{}
    
    Write-Log "=== INICIANDO INSTALACIÓN CCN-STIC 599B23 ==="
    
    # Paso 1: Servicios
    $stepResults["Paso 1 - Servicios"] = Invoke-Step1-Services
    if (!$stepResults["Paso 1 - Servicios"] -and !$Force) {
        Write-Log "Error en Paso 1. Instalación abortada." "ERROR"
        return $false
    }
    
    # Paso 2: GPO
    $stepResults["Paso 2 - GPO"] = Invoke-Step2-GPO
    if (!$stepResults["Paso 2 - GPO"] -and !$Force) {
        Write-Log "Error en Paso 2. Instalación abortada." "ERROR"
        return $false
    }
    
    # Paso 3: Firewall
    $stepResults["Paso 3 - Firewall"] = Invoke-Step3-Firewall
    if (!$stepResults["Paso 3 - Firewall"] -and !$Force) {
        Write-Log "Error en Paso 3. Instalación abortada." "ERROR"
        return $false
    }
    
    # Paso 4: Plantilla final
    $stepResults["Paso 4 - Plantilla"] = Invoke-Step4-Template
    if (!$stepResults["Paso 4 - Plantilla"] -and !$Force) {
        Write-Log "Error en Paso 4. Instalación abortada." "ERROR"
        return $false
    }
    
    # Configuraciones adicionales
    $stepResults["Configuraciones Adicionales"] = Invoke-AdditionalConfigurations
    
    # Verificar instalación
    $verificationResults = Test-Installation
    
    # Generar reporte final
    $report = @"
# Reporte de Instalación CCN-STIC 599B23
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Equipo: $env:COMPUTERNAME
Usuario: $env:USERNAME

## Resultados de Instalación

"@
    
    foreach ($step in $stepResults.Keys) {
        $status = if ($stepResults[$step] -eq $true) { "✅ EXITOSO" } else { "❌ FALLIDO" }
        $report += "`n### $step : $status`n"
    }
    
    $report += "`n## Verificación de Instalación`n"
    foreach ($check in $verificationResults.Keys) {
        $status = if ($verificationResults[$check]) { "✅ CUMPLE" } else { "❌ NO CUMPLE" }
        $report += "`n- $check : $status`n"
    }
    
    $report | Out-File "$LogPath\installation_report.md" -Encoding UTF8
    
    # Mostrar resumen
    $successfulSteps = ($stepResults.Values | Where-Object { $_ -eq $true }).Count
    $totalSteps = $stepResults.Count
    
    Write-Log "=== INSTALACIÓN COMPLETADA ==="
    Write-Log "Pasos exitosos: $successfulSteps de $totalSteps"
    Write-Log "Reporte guardado en: $LogPath\installation_report.md"
    
    if ($Verbose) {
        Write-Log "Detalles de verificación:"
        foreach ($check in $verificationResults.Keys) {
            $status = if ($verificationResults[$check]) { "CUMPLE" } else { "NO CUMPLE" }
            Write-Log "  $check : $status"
        }
    }
    
    return $true
}

# Ejecutar función principal
Main 