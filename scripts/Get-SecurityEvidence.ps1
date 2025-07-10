# Script de Recolección de Evidencias de Seguridad - CN-CERT
# Autor: Equipo de Seguridad
# Versión: 1.0
# Fecha: $(Get-Date -Format "yyyy-MM-dd")

param(
    [Parameter(Mandatory=$true)]
    [string]$OutputPath,
    
    [Parameter(Mandatory=$true)]
    [string]$SystemName,
    
    [Parameter(Mandatory=$true)]
    [string]$AuditorName,
    
    [switch]$IncludeLogs,
    [switch]$IncludeScreenshots,
    [switch]$Verbose
)

# Configuración inicial
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Crear directorio de salida
$Date = Get-Date -Format "yyyy-MM-dd"
$BasePath = Join-Path $OutputPath "evidencias-$SystemName-$Date"
$ScreenshotsPath = Join-Path $BasePath "capturas-pantalla"
$ReportsPath = Join-Path $BasePath "reportes"
$LogsPath = Join-Path $BasePath "logs"

# Crear directorios
New-Item -ItemType Directory -Path $BasePath -Force | Out-Null
New-Item -ItemType Directory -Path $ScreenshotsPath -Force | Out-Null
New-Item -ItemType Directory -Path $ReportsPath -Force | Out-Null
New-Item -ItemType Directory -Path $LogsPath -Force | Out-Null

Write-Host "=== RECOLECCIÓN DE EVIDENCIAS DE SEGURIDAD - CN-CERT ===" -ForegroundColor Green
Write-Host "Sistema: $SystemName" -ForegroundColor Yellow
Write-Host "Auditor: $AuditorName" -ForegroundColor Yellow
Write-Host "Fecha: $Date" -ForegroundColor Yellow
Write-Host "Directorio de salida: $BasePath" -ForegroundColor Yellow
Write-Host ""

# Función para escribir logs
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path (Join-Path $BasePath "audit-log.txt") -Value $LogMessage
}

# Función para capturar pantalla
function Capture-Screenshot {
    param([string]$FileName)
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        $Screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $Bitmap = New-Object System.Drawing.Bitmap $Screen.Width, $Screen.Height
        $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
        $Graphics.CopyFromScreen($Screen.Left, $Screen.Top, 0, 0, $Screen.Size)
        
        $FilePath = Join-Path $ScreenshotsPath "$FileName.png"
        $Bitmap.Save($FilePath, [System.Drawing.Imaging.ImageFormat]::Png)
        $Graphics.Dispose()
        $Bitmap.Dispose()
        
        Write-Log "Captura de pantalla guardada: $FileName.png"
    }
    catch {
        Write-Log "Error al capturar pantalla $FileName : $($_.Exception.Message)" "ERROR"
    }
}

# Función para ejecutar comando y guardar resultado
function Invoke-CommandAndSave {
    param([string]$Command, [string]$FileName, [string]$Description)
    
    Write-Log "Ejecutando: $Description"
    
    try {
        $Result = Invoke-Expression $Command 2>&1
        $Output = @"
=== $Description ===
Comando: $Command
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

# Inicio de la recolección
Write-Log "Iniciando recolección de evidencias de seguridad"

# 1. Información del Sistema
Write-Host "1. Recolectando información del sistema..." -ForegroundColor Cyan
Invoke-CommandAndSave -Command "systeminfo" -FileName "informacion-sistema" -Description "INFORMACIÓN DEL SISTEMA"
Invoke-CommandAndSave -Command "ipconfig /all" -FileName "configuracion-red" -Description "CONFIGURACIÓN DE RED"
Invoke-CommandAndSave -Command "systeminfo | findstr /C:'Domain'" -FileName "informacion-dominio" -Description "INFORMACIÓN DE DOMINIO"

# 2. Configuración de Seguridad
Write-Host "2. Recolectando configuración de seguridad..." -ForegroundColor Cyan

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
Invoke-CommandAndSave -Command "netsh advfirewall show allprofiles" -FileName "firewall" -Description "CONFIGURACIÓN DE FIREWALL"

# Políticas de Contraseñas
Invoke-CommandAndSave -Command "net accounts" -FileName "politicas-contrasenas" -Description "POLÍTICAS DE CONTRASEÑAS"

# Políticas de Auditoría
Invoke-CommandAndSave -Command "auditpol /get /category:*" -FileName "politicas-auditoria" -Description "POLÍTICAS DE AUDITORÍA"

# 3. Usuarios y Grupos
Write-Host "3. Recolectando información de usuarios..." -ForegroundColor Cyan
Invoke-CommandAndSave -Command "wmic useraccount get name,disabled,lockout" -FileName "usuarios-sistema" -Description "USUARIOS DEL SISTEMA"
Invoke-CommandAndSave -Command "net localgroup administrators" -FileName "grupo-administradores" -Description "GRUPO DE ADMINISTRADORES"

# 4. Servicios
Write-Host "4. Verificando servicios críticos..." -ForegroundColor Cyan
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

# 6. Configuración de Office
Write-Host "6. Verificando configuración de Office..." -ForegroundColor Cyan
$OfficeConfig = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office" -ErrorAction SilentlyContinue
if ($OfficeConfig) {
    $OfficeOutput = @"
=== CONFIGURACIÓN DE OFFICE ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

CONFIGURACIÓN:
$($OfficeConfig | Format-List | Out-String)

=== FIN DE CONFIGURACIÓN DE OFFICE ===
"@
    $OfficeOutput | Out-File -FilePath (Join-Path $ReportsPath "configuracion-office.txt") -Encoding UTF8
    Write-Log "Configuración de Office guardada"
}

# 7. Configuración de Proxy
Invoke-CommandAndSave -Command "netsh winhttp show proxy" -FileName "configuracion-proxy" -Description "CONFIGURACIÓN DE PROXY"

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

# 9. Últimas Actualizaciones
Write-Host "9. Verificando últimas actualizaciones..." -ForegroundColor Cyan
$HotFixes = Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10
$HotFixesOutput = @"
=== ÚLTIMAS ACTUALIZACIONES ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

ACTUALIZACIONES (Últimas 10):
$($HotFixes | Format-Table -AutoSize | Out-String)

=== FIN DE ÚLTIMAS ACTUALIZACIONES ===
"@
$HotFixesOutput | Out-File -FilePath (Join-Path $ReportsPath "ultimas-actualizaciones.txt") -Encoding UTF8
Write-Log "Últimas actualizaciones guardadas"

# 10. Capturas de Pantalla (si se solicita)
if ($IncludeScreenshots) {
    Write-Host "10. Capturando pantallas..." -ForegroundColor Cyan
    Write-Log "Iniciando capturas de pantalla"
    
    # Dar tiempo para abrir las ventanas necesarias
    Write-Host "Abra las siguientes ventanas para capturar:" -ForegroundColor Yellow
    Write-Host "- Windows Defender" -ForegroundColor Yellow
    Write-Host "- Configuración de BitLocker" -ForegroundColor Yellow
    Write-Host "- Firewall de Windows" -ForegroundColor Yellow
    Write-Host "- Usuarios y Grupos" -ForegroundColor Yellow
    Write-Host "- Servicios" -ForegroundColor Yellow
    Write-Host "Presione Enter cuando esté listo..." -ForegroundColor Yellow
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

# 11. Logs de Eventos (si se solicita)
if ($IncludeLogs) {
    Write-Host "11. Exportando logs de eventos..." -ForegroundColor Cyan
    Write-Log "Iniciando exportación de logs"
    
    try {
        # Exportar log de seguridad (últimos 30 días)
        $SecurityLogPath = Join-Path $LogsPath "logs-seguridad-$Date.evtx"
        wevtutil epl Security $SecurityLogPath
        Write-Log "Log de seguridad exportado: logs-seguridad-$Date.evtx"
        
        # Exportar log de sistema (últimos 7 días)
        $SystemLogPath = Join-Path $LogsPath "logs-sistema-$Date.evtx"
        wevtutil epl System $SystemLogPath
        Write-Log "Log de sistema exportado: logs-sistema-$Date.evtx"
        
        # Exportar log de aplicación (últimos 7 días)
        $AppLogPath = Join-Path $LogsPath "logs-aplicacion-$Date.evtx"
        wevtutil epl Application $AppLogPath
        Write-Log "Log de aplicación exportado: logs-aplicacion-$Date.evtx"
    }
    catch {
        Write-Log "Error exportando logs: $($_.Exception.Message)" "ERROR"
    }
}

# 12. Generar reporte resumen
Write-Host "12. Generando reporte resumen..." -ForegroundColor Cyan
$SummaryOutput = @"
=== REPORTE RESUMEN DE AUDITORÍA ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

INFORMACIÓN DEL SISTEMA:
- Hostname: $env:COMPUTERNAME
- Usuario: $env:USERNAME
- Dominio: $env:USERDOMAIN
- Versión de Windows: $(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
- Build: $(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild

ARCHIVOS GENERADOS:
$(Get-ChildItem -Path $ReportsPath -Name | ForEach-Object { "- $_" })

CAPTURAS DE PANTALLA:
$(if ($IncludeScreenshots) { (Get-ChildItem -Path $ScreenshotsPath -Name | ForEach-Object { "- $_" }) } else { "- No solicitadas" })

LOGS EXPORTADOS:
$(if ($IncludeLogs) { (Get-ChildItem -Path $LogsPath -Name | ForEach-Object { "- $_" }) } else { "- No solicitados" })

ESTADO DE WINDOWS DEFENDER:
$(if ($DefenderStatus) { "- Habilitado: $($DefenderStatus.AntivirusEnabled)" } else { "- No disponible" })

ESTADO DE BITLOCKER:
$(if ($BitLockerStatus -and $BitLockerStatus -notmatch "Error") { "- Configurado" } else { "- No configurado o error" })

USUARIOS ACTIVOS:
$(($Users = wmic useraccount get name,disabled 2>$null | Where-Object { $_ -match "False" }).Count - 1)

SERVICIOS CRÍTICOS:
- Windows Defender: $(if ((sc query "Windows Defender" 2>$null) -match "RUNNING") { "Ejecutándose" } else { "No ejecutándose" })
- Windows Firewall: $(if ((sc query "Windows Firewall" 2>$null) -match "RUNNING") { "Ejecutándose" } else { "No ejecutándose" })
- Windows Update: $(if ((sc query "Windows Update" 2>$null) -match "RUNNING") { "Ejecutándose" } else { "No ejecutándose" })

=== FIN DEL REPORTE RESUMEN ===
"@
$SummaryOutput | Out-File -FilePath (Join-Path $BasePath "reporte-resumen.txt") -Encoding UTF8

# 13. Crear archivo ZIP con todas las evidencias
Write-Host "13. Creando archivo ZIP con evidencias..." -ForegroundColor Cyan
$ZipPath = "$BasePath.zip"
try {
    Compress-Archive -Path $BasePath -DestinationPath $ZipPath -Force
    Write-Log "Archivo ZIP creado: $ZipPath"
    Write-Host "Archivo ZIP creado exitosamente: $ZipPath" -ForegroundColor Green
}
catch {
    Write-Log "Error creando archivo ZIP: $($_.Exception.Message)" "ERROR"
}

# Finalización
Write-Host ""
Write-Host "=== RECOLECCIÓN COMPLETADA ===" -ForegroundColor Green
Write-Host "Directorio de evidencias: $BasePath" -ForegroundColor Yellow
Write-Host "Archivo ZIP: $ZipPath" -ForegroundColor Yellow
Write-Host "Log de auditoría: $(Join-Path $BasePath "audit-log.txt")" -ForegroundColor Yellow
Write-Log "Recolección de evidencias completada exitosamente"

# Mostrar estadísticas finales
$TotalFiles = (Get-ChildItem -Path $BasePath -Recurse -File).Count
Write-Host "Total de archivos generados: $TotalFiles" -ForegroundColor Cyan
Write-Host "Tamaño total: $([math]::Round((Get-ChildItem -Path $BasePath -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB" -ForegroundColor Cyan 