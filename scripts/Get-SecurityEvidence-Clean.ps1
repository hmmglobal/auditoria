# Script de Recoleccion de Evidencias de Seguridad
# Autor: Equipo de Seguridad
# Version: 1.0

param(
    [Parameter(Mandatory=$true)]
    [string]$OutputPath,
    
    [Parameter(Mandatory=$true)]
    [string]$SystemName,
    
    [Parameter(Mandatory=$true)]
    [string]$AuditorName,
    
    [switch]$IncludeScreenshots,
    [switch]$IncludeLogs
)

# Configuracion inicial
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Crear directorios de salida
$ReportsPath = Join-Path $OutputPath "reportes"
$LogsPath = Join-Path $OutputPath "logs"
$ScreenshotsPath = Join-Path $OutputPath "capturas-pantalla"

New-Item -ItemType Directory -Path $ReportsPath -Force | Out-Null
New-Item -ItemType Directory -Path $LogsPath -Force | Out-Null
New-Item -ItemType Directory -Path $ScreenshotsPath -Force | Out-Null

# Funcion para escribir logs
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    $logFile = Join-Path $LogsPath "audit-log.txt"
    
    Write-Host $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

# Funcion para capturar pantalla
function Capture-Screenshot {
    param([string]$FileName)
    
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $screen.Size)
        
        $screenshotPath = Join-Path $ScreenshotsPath "$FileName-$(Get-Date -Format 'yyyyMMdd-HHmmss').png"
        $bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose()
        $bitmap.Dispose()
        
        Write-Log "Captura de pantalla guardada: $screenshotPath"
    }
    catch {
        Write-Log "Error capturando pantalla: $($_.Exception.Message)" "ERROR"
    }
}

# Funcion para ejecutar comando y guardar resultado
function Invoke-CommandAndSave {
    param(
        [string]$Command,
        [string]$FileName,
        [string]$Description
    )
    
    try {
        Write-Log "Ejecutando: $Description"
        
        $Result = Invoke-Expression $Command 2>&1
        $Output = @"
=== $Description ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

RESULTADO:
$Result

=== FIN DE $Description ===
"@
        
        $FilePath = Join-Path $ReportsPath "$FileName.txt"
        $Output | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Log "Resultado guardado: $FileName.txt"
        
        return $Result
    }
    catch {
        Write-Log "Error ejecutando $Description : $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Inicio de la recoleccion
Write-Log "Iniciando recoleccion de evidencias de seguridad"

# 1. Informacion del Sistema
Write-Host "1. Recolectando informacion del sistema..." -ForegroundColor Cyan
Invoke-CommandAndSave -Command "systeminfo" -FileName "informacion-sistema" -Description "INFORMACION DEL SISTEMA"
Invoke-CommandAndSave -Command "ipconfig /all" -FileName "configuracion-red" -Description "CONFIGURACION DE RED"
Invoke-CommandAndSave -Command "systeminfo | findstr /C:'Domain'" -FileName "informacion-dominio" -Description "INFORMACION DE DOMINIO"

# 2. Configuracion de Seguridad
Write-Host "2. Recolectando configuracion de seguridad..." -ForegroundColor Cyan

# Windows Defender
Write-Log "Verificando Windows Defender"
$DefenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
if ($DefenderStatus) {
    $DefenderOutput = @"
=== ESTADO DE WINDOWS DEFENDER ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

ANTIVIRUS:
- Nombre: $($DefenderStatus.AntivirusProductName)
- Estado: $($DefenderStatus.AntivirusEnabled)
- Actualizado: $($DefenderStatus.AntivirusSignatureLastUpdated)

REAL-TIME PROTECTION:
- Habilitado: $($DefenderStatus.RealTimeProtectionEnabled)
- Behavior Monitor: $($DefenderStatus.BehaviorMonitorEnabled)
- On Access Protection: $($DefenderStatus.OnAccessProtectionEnabled)
- IOAV Protection: $($DefenderStatus.IoavProtectionEnabled)

CLOUD PROTECTION:
- Habilitado: $($DefenderStatus.CloudProtectionEnabled)
- Cloud Block Level: $($DefenderStatus.CloudBlockLevel)

CONTROL DE ACCESO A CARPETAS:
- Habilitado: $($DefenderStatus.ControlledFolderAccessEnabled)

=== FIN DE WINDOWS DEFENDER ===
"@
    $DefenderOutput | Out-File -FilePath (Join-Path $ReportsPath "windows-defender.txt") -Encoding UTF8
    Write-Log "Estado de Windows Defender guardado"
}

# BitLocker
Write-Log "Verificando BitLocker"
$BitLockerStatus = manage-bde -status 2>&1
if ($BitLockerStatus) {
    $BitLockerOutput = @"
=== ESTADO DE BITLOCKER ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

RESULTADO:
$BitLockerStatus

=== FIN DE BITLOCKER ===
"@
    $BitLockerOutput | Out-File -FilePath (Join-Path $ReportsPath "bitlocker.txt") -Encoding UTF8
    Write-Log "Estado de BitLocker guardado"
}

# Firewall
Invoke-CommandAndSave -Command "netsh advfirewall show allprofiles" -FileName "firewall" -Description "CONFIGURACION DE FIREWALL"

# Politicas de Contrasenas
Invoke-CommandAndSave -Command "net accounts" -FileName "politicas-contrasenas" -Description "POLITICAS DE CONTRASENAS"

# Politicas de Auditoria
Invoke-CommandAndSave -Command "auditpol /get /category:*" -FileName "politicas-auditoria" -Description "POLITICAS DE AUDITORIA"

# 3. Usuarios y Grupos
Write-Host "3. Recolectando informacion de usuarios..." -ForegroundColor Cyan
Invoke-CommandAndSave -Command "wmic useraccount get name,disabled,lockout" -FileName "usuarios-sistema" -Description "USUARIOS DEL SISTEMA"
Invoke-CommandAndSave -Command "net localgroup administrators" -FileName "grupo-administradores" -Description "GRUPO DE ADMINISTRADORES"

# 4. Servicios
Write-Host "4. Verificando servicios criticos..." -ForegroundColor Cyan
$Services = @("Windows Defender", "Windows Firewall", "Windows Update", "Telnet", "TFTP", "SNMP")
foreach ($Service in $Services) {
    $ServiceStatus = sc query $Service 2>&1
    $ServiceOutput = @"
=== SERVICIO: $Service ===
$ServiceStatus

"@
    $ServiceOutput | Out-File -FilePath (Join-Path $ReportsPath "servicios.txt") -Encoding UTF8 -Append
}
Write-Log "Estado de servicios guardado"

# 5. Aplicaciones Instaladas
Write-Host "5. Recolectando aplicaciones instaladas..." -ForegroundColor Cyan
$Apps = Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Sort-Object Name
$AppsOutput = @"
=== APLICACIONES INSTALADAS ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

APLICACIONES:
$($Apps | Format-Table -AutoSize | Out-String)

=== FIN DE APLICACIONES INSTALADAS ===
"@
$AppsOutput | Out-File -FilePath (Join-Path $ReportsPath "aplicaciones-instaladas.txt") -Encoding UTF8
Write-Log "Lista de aplicaciones guardada"

# 6. Configuracion de Office
Write-Host "6. Verificando configuracion de Office..." -ForegroundColor Cyan
$OfficeConfig = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office" -ErrorAction SilentlyContinue
if ($OfficeConfig) {
    $OfficeOutput = @"
=== CONFIGURACION DE OFFICE ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

CONFIGURACION:
$($OfficeConfig | Format-List | Out-String)

=== FIN DE CONFIGURACION DE OFFICE ===
"@
    $OfficeOutput | Out-File -FilePath (Join-Path $ReportsPath "configuracion-office.txt") -Encoding UTF8
    Write-Log "Configuracion de Office guardada"
}

# 7. Configuracion de Proxy
Invoke-CommandAndSave -Command "netsh winhttp show proxy" -FileName "configuracion-proxy" -Description "CONFIGURACION DE PROXY"

# 8. Conexiones VPN
$VpnConnections = Get-VpnConnection -ErrorAction SilentlyContinue
if ($VpnConnections) {
    $VpnOutput = @"
=== CONEXIONES VPN ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

CONEXIONES:
$($VpnConnections | Format-Table -AutoSize | Out-String)

=== FIN DE CONEXIONES VPN ===
"@
    $VpnOutput | Out-File -FilePath (Join-Path $ReportsPath "conexiones-vpn.txt") -Encoding UTF8
    Write-Log "Conexiones VPN guardadas"
}

# 9. Ultimas Actualizaciones
Write-Host "9. Verificando ultimas actualizaciones..." -ForegroundColor Cyan
$HotFixes = Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10
$HotFixesOutput = @"
=== ULTIMAS ACTUALIZACIONES ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

ACTUALIZACIONES (Ultimas 10):
$($HotFixes | Format-Table -AutoSize | Out-String)

=== FIN DE ULTIMAS ACTUALIZACIONES ===
"@
$HotFixesOutput | Out-File -FilePath (Join-Path $ReportsPath "ultimas-actualizaciones.txt") -Encoding UTF8
Write-Log "Ultimas actualizaciones guardadas"

# 10. Capturas de Pantalla (si se solicita)
if ($IncludeScreenshots) {
    Write-Host "10. Capturando pantallas..." -ForegroundColor Cyan
    Write-Log "Iniciando capturas de pantalla"
    
    # Dar tiempo para abrir las ventanas necesarias
    Write-Host "Abra las siguientes ventanas para capturar:" -ForegroundColor Yellow
    Write-Host "- Windows Defender" -ForegroundColor Yellow
    Write-Host "- Configuracion de BitLocker" -ForegroundColor Yellow
    Write-Host "- Firewall de Windows" -ForegroundColor Yellow
    Write-Host "- Usuarios y Grupos" -ForegroundColor Yellow
    Write-Host "- Servicios" -ForegroundColor Yellow
    Write-Host "Presione Enter cuando este listo..." -ForegroundColor Yellow
    Read-Host
    
    Capture-Screenshot -FileName "windows-defender"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "bitlocker"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "firewall"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "usuarios-grupos"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "servicios"
}

# 11. Generar resumen ejecutivo
Write-Host "11. Generando resumen ejecutivo..." -ForegroundColor Cyan
$SummaryOutput = @"
=== RESUMEN EJECUTIVO DE AUDITORIA ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

INFORMACION DEL SISTEMA:
- Nombre del equipo: $env:COMPUTERNAME
- Usuario actual: $env:USERNAME
- Version de Windows: $(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
- Arquitectura: $env:PROCESSOR_ARCHITECTURE

EVIDENCIAS RECOLECTADAS:
1. INFORMACION DEL SISTEMA:
   - Informacion del sistema: $(if (Test-Path (Join-Path $ReportsPath "informacion-sistema.txt")) { "Verificado" } else { "No verificado" })
   - Configuracion de red: $(if (Test-Path (Join-Path $ReportsPath "configuracion-red.txt")) { "Verificado" } else { "No verificado" })
   - Informacion de dominio: $(if (Test-Path (Join-Path $ReportsPath "informacion-dominio.txt")) { "Verificado" } else { "No verificado" })

2. CONFIGURACION DE SEGURIDAD:
   - Windows Defender: $(if (Test-Path (Join-Path $ReportsPath "windows-defender.txt")) { "Verificado" } else { "No verificado" })
   - BitLocker: $(if (Test-Path (Join-Path $ReportsPath "bitlocker.txt")) { "Verificado" } else { "No verificado" })
   - Firewall: $(if (Test-Path (Join-Path $ReportsPath "firewall.txt")) { "Verificado" } else { "No verificado" })
   - Politicas de contrasenas: $(if (Test-Path (Join-Path $ReportsPath "politicas-contrasenas.txt")) { "Verificado" } else { "No verificado" })
   - Politicas de auditoria: $(if (Test-Path (Join-Path $ReportsPath "politicas-auditoria.txt")) { "Verificado" } else { "No verificado" })

3. USUARIOS Y GRUPOS:
   - Usuarios del sistema: $(if (Test-Path (Join-Path $ReportsPath "usuarios-sistema.txt")) { "Verificado" } else { "No verificado" })
   - Grupo de administradores: $(if (Test-Path (Join-Path $ReportsPath "grupo-administradores.txt")) { "Verificado" } else { "No verificado" })

4. SERVICIOS:
   - Servicios criticos: $(if (Test-Path (Join-Path $ReportsPath "servicios.txt")) { "Verificado" } else { "No verificado" })

5. APLICACIONES:
   - Aplicaciones instaladas: $(if (Test-Path (Join-Path $ReportsPath "aplicaciones-instaladas.txt")) { "Verificado" } else { "No verificado" })
   - Configuracion de Office: $(if (Test-Path (Join-Path $ReportsPath "configuracion-office.txt")) { "Verificado" } else { "No verificado" })

6. CONFIGURACION DE RED:
   - Configuracion de proxy: $(if (Test-Path (Join-Path $ReportsPath "configuracion-proxy.txt")) { "Verificado" } else { "No verificado" })
   - Conexiones VPN: $(if (Test-Path (Join-Path $ReportsPath "conexiones-vpn.txt")) { "Verificado" } else { "No verificado" })

7. ACTUALIZACIONES:
   - Ultimas actualizaciones: $(if (Test-Path (Join-Path $ReportsPath "ultimas-actualizaciones.txt")) { "Verificado" } else { "No verificado" })

8. CAPTURAS DE PANTALLA:
   - Capturas de pantalla: $(if ($IncludeScreenshots) { "Incluidas" } else { "No incluidas" })

=== FIN DE RESUMEN EJECUTIVO ===
"@

$SummaryOutput | Out-File -FilePath (Join-Path $ReportsPath "resumen-ejecutivo.txt") -Encoding UTF8
Write-Log "Resumen ejecutivo generado"

# 12. Crear archivo ZIP con todas las evidencias
Write-Host "12. Creando archivo ZIP con evidencias..." -ForegroundColor Cyan
try {
    $zipPath = Join-Path $OutputPath "evidencias-$SystemName-$(Get-Date -Format 'yyyyMMdd-HHmmss').zip"
    Compress-Archive -Path $ReportsPath, $LogsPath, $ScreenshotsPath -DestinationPath $zipPath -Force
    Write-Log "Archivo ZIP creado: $zipPath"
} catch {
    Write-Log "Error creando archivo ZIP: $($_.Exception.Message)" "ERROR"
}

# Finalizacion
Write-Host ""
Write-Host "=== RECOLECCION COMPLETADA ===" -ForegroundColor Green
Write-Host "Evidencias guardadas en: $OutputPath" -ForegroundColor Yellow
Write-Host "Log de auditoria: $(Join-Path $LogsPath "audit-log.txt")" -ForegroundColor Yellow
Write-Log "Recoleccion de evidencias completada exitosamente"

# Mostrar estadisticas finales
$totalFiles = (Get-ChildItem -Path $OutputPath -Recurse -File).Count
$totalSize = [math]::Round((Get-ChildItem -Path $OutputPath -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

Write-Host ""
Write-Host "Estadisticas finales:" -ForegroundColor Cyan
Write-Host "Archivos generados: $totalFiles" -ForegroundColor White
Write-Host "Tamaño total: $totalSize MB" -ForegroundColor White 