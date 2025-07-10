# Script de Evidencias CN-CERT - Op.exp.2 Configuración de Seguridad
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
    
    [Parameter(Mandatory=$true)]
    [string]$ResponsableName,
    
    [switch]$IncludeScreenshots,
    [switch]$IncludeLogs,
    [switch]$Verbose
)

# Configuración inicial
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Crear directorio de salida
$Date = Get-Date -Format "yyyy-MM-dd"
$BasePath = Join-Path $OutputPath "cn-cert-op-exp-2-$SystemName-$Date"
$ScreenshotsPath = Join-Path $BasePath "capturas-pantalla"
$ReportsPath = Join-Path $BasePath "reportes"
$LogsPath = Join-Path $BasePath "logs"

# Crear directorios
New-Item -ItemType Directory -Path $BasePath -Force | Out-Null
New-Item -ItemType Directory -Path $ScreenshotsPath -Force | Out-Null
New-Item -ItemType Directory -Path $ReportsPath -Force | Out-Null
New-Item -ItemType Directory -Path $LogsPath -Force | Out-Null

Write-Host "=== EVIDENCIAS CN-CERT - Op.exp.2 Configuración de Seguridad ===" -ForegroundColor Green
Write-Host "Sistema: $SystemName" -ForegroundColor Yellow
Write-Host "Auditor: $AuditorName" -ForegroundColor Yellow
Write-Host "Responsable: $ResponsableName" -ForegroundColor Yellow
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
Responsable: $ResponsableName

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
Write-Log "Iniciando recolección de evidencias CN-CERT Op.exp.2"

# ASPECTO 1: Configuración de Seguridad Previa a Producción
Write-Host "=== ASPECTO 1: Configuración de Seguridad Previa a Producción ===" -ForegroundColor Cyan

Write-Host "1.1 Verificando políticas de grupo aplicadas..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "gpresult /r" -FileName "politicas-grupo" -Description "POLÍTICAS DE GRUPO APLICADAS"

Write-Host "1.2 Verificando configuraciones de seguridad..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'" -FileName "configuraciones-seguridad" -Description "CONFIGURACIONES DE SEGURIDAD"

Write-Host "1.3 Verificando herramientas de seguridad..." -ForegroundColor Yellow
$DefenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
if ($DefenderStatus) {
    $DefenderOutput = @"
=== HERRAMIENTAS DE SEGURIDAD ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName
Responsable: $ResponsableName

WINDOWS DEFENDER:
- Nombre: $($DefenderStatus.AntivirusProductName)
- Estado: $($DefenderStatus.AntivirusEnabled)
- Protección en tiempo real: $($DefenderStatus.RealTimeProtectionEnabled)
- Protección basada en la nube: $($DefenderStatus.CloudProtectionEnabled)
- Control de acceso a carpetas: $($DefenderStatus.ControlledFolderAccessEnabled)
- Última actualización: $($DefenderStatus.AntivirusSignatureLastUpdated)

=== FIN DE HERRAMIENTAS DE SEGURIDAD ===
"@
    $DefenderOutput | Out-File -FilePath (Join-Path $ReportsPath "herramientas-seguridad.txt") -Encoding UTF8
    Write-Log "Estado de herramientas de seguridad guardado"
}

# ASPECTO 2: Eliminación de Cuentas y Contraseñas Estándar
Write-Host "=== ASPECTO 2: Eliminación de Cuentas y Contraseñas Estándar ===" -ForegroundColor Cyan

Write-Host "2.1 Verificando políticas de contraseñas..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "net accounts" -FileName "politicas-contrasenas" -Description "POLÍTICAS DE CONTRASEÑAS"

Write-Host "2.2 Verificando cuentas de usuario..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "wmic useraccount get name,disabled,lockout" -FileName "cuentas-usuario" -Description "CUENTAS DE USUARIO"

Write-Host "2.3 Verificando cuentas por defecto..." -ForegroundColor Yellow
$DefaultUsers = Get-LocalUser | Where-Object {$_.Name -in @('Administrator', 'Guest')} | Select-Object Name, Enabled, Description
$DefaultUsersOutput = @"
=== CUENTAS POR DEFECTO ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName
Responsable: $ResponsableName

CUENTAS ENCONTRADAS:
$($DefaultUsers | Format-Table -AutoSize | Out-String)

=== FIN DE CUENTAS POR DEFECTO ===
"@
$DefaultUsersOutput | Out-File -FilePath (Join-Path $ReportsPath "cuentas-por-defecto.txt") -Encoding UTF8
Write-Log "Verificación de cuentas por defecto guardada"

Write-Host "2.4 Verificando grupo de administradores..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "net localgroup administrators" -FileName "grupo-administradores" -Description "GRUPO DE ADMINISTRADORES"

# ASPECTO 3: Mínima Funcionalidad
Write-Host "=== ASPECTO 3: Mínima Funcionalidad ===" -ForegroundColor Cyan

Write-Host "3.1 Verificando servicios críticos..." -ForegroundColor Yellow
$CriticalServices = @("Windows Defender", "Windows Firewall", "Windows Update")
foreach ($Service in $CriticalServices) {
    $ServiceStatus = sc query $Service 2>&1
    $ServiceOutput = @"
=== SERVICIO CRÍTICO: $Service ===
$ServiceStatus

"@
    $ServiceOutput | Out-File -FilePath (Join-Path $ReportsPath "servicios-criticos.txt") -Encoding UTF8 -Append
}

Write-Host "3.2 Verificando servicios innecesarios..." -ForegroundColor Yellow
$UnnecessaryServices = @("Telnet", "TFTP", "SNMP", "Alerter", "Messenger", "Remote Registry")
foreach ($Service in $UnnecessaryServices) {
    $ServiceStatus = sc query $Service 2>&1
    $ServiceOutput = @"
=== SERVICIO INNECESARIO: $Service ===
$ServiceStatus

"@
    $ServiceOutput | Out-File -FilePath (Join-Path $ReportsPath "servicios-innecesarios.txt") -Encoding UTF8 -Append
}

Write-Host "3.3 Verificando puertos abiertos..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "netstat -an | findstr LISTENING" -FileName "puertos-abiertos" -Description "PUERTOS ABIERTOS"

Write-Host "3.4 Verificando aplicaciones instaladas..." -ForegroundColor Yellow
$Apps = Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Sort-Object Name
$AppsOutput = @"
=== APLICACIONES INSTALADAS ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName
Responsable: $ResponsableName

APLICACIONES:
$($Apps | Format-Table -AutoSize | Out-String)

=== FIN DE APLICACIONES INSTALADAS ===
"@
$AppsOutput | Out-File -FilePath (Join-Path $ReportsPath "aplicaciones-instaladas.txt") -Encoding UTF8
Write-Log "Lista de aplicaciones guardada"

# ASPECTO 4: Seguridad por Defecto
Write-Host "=== ASPECTO 4: Seguridad por Defecto ===" -ForegroundColor Cyan

Write-Host "4.1 Verificando configuración de firewall..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "netsh advfirewall show allprofiles" -FileName "configuracion-firewall" -Description "CONFIGURACIÓN DE FIREWALL"

Write-Host "4.2 Verificando configuración de UAC..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA" -FileName "configuracion-uac" -Description "CONFIGURACIÓN DE UAC"

Write-Host "4.3 Verificando configuración de SmartScreen..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name SmartScreenEnabled" -FileName "configuracion-smartscreen" -Description "CONFIGURACIÓN DE SMARTSCREEN"

Write-Host "4.4 Verificando estado de Windows Update..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "Get-Service -Name wuauserv | Select-Object Name, Status" -FileName "estado-windows-update" -Description "ESTADO DE WINDOWS UPDATE"

Write-Host "4.5 Verificando configuraciones automáticas..." -ForegroundColor Yellow
$AutoConfigOutput = @"
=== CONFIGURACIONES AUTOMÁTICAS ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName
Responsable: $ResponsableName

WINDOWS DEFENDER:
- Protección en tiempo real: $($DefenderStatus.RealTimeProtectionEnabled)
- Protección basada en la nube: $($DefenderStatus.CloudProtectionEnabled)
- Control de acceso a carpetas: $($DefenderStatus.ControlledFolderAccessEnabled)

FIREWALL:
$(netsh advfirewall show allprofiles | Select-String "State")

UAC:
$(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -ErrorAction SilentlyContinue)

=== FIN DE CONFIGURACIONES AUTOMÁTICAS ===
"@
$AutoConfigOutput | Out-File -FilePath (Join-Path $ReportsPath "configuraciones-automaticas.txt") -Encoding UTF8
Write-Log "Configuraciones automáticas guardadas"

# ASPECTO 5: Gestión de Máquinas Virtuales
Write-Host "=== ASPECTO 5: Gestión de Máquinas Virtuales ===" -ForegroundColor Cyan

Write-Host "5.1 Verificando si es máquina virtual..." -ForegroundColor Yellow
$VMInfo = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Model, Manufacturer
$VMOutput = @"
=== INFORMACIÓN DE MÁQUINA VIRTUAL ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName
Responsable: $ResponsableName

INFORMACIÓN DEL SISTEMA:
- Modelo: $($VMInfo.Model)
- Fabricante: $($VMInfo.Manufacturer)

DETERMINACIÓN:
$(if ($VMInfo.Model -match "Virtual|VMware|VirtualBox|Hyper-V") { "ES MÁQUINA VIRTUAL" } else { "ES MÁQUINA FÍSICA" })

=== FIN DE INFORMACIÓN DE MÁQUINA VIRTUAL ===
"@
$VMOutput | Out-File -FilePath (Join-Path $ReportsPath "informacion-vm.txt") -Encoding UTF8
Write-Log "Información de máquina virtual guardada"

# Si es máquina virtual, verificar configuraciones específicas
if ($VMInfo.Model -match "Virtual|VMware|VirtualBox|Hyper-V") {
    Write-Host "5.2 Verificando configuraciones específicas de VM..." -ForegroundColor Yellow
    
    # Verificar herramientas de virtualización
    $VMwareTools = Get-Service -Name "VMTools" -ErrorAction SilentlyContinue
    $HyperVIntegration = Get-Service -Name "vmms" -ErrorAction SilentlyContinue
    
    $VMConfigOutput = @"
=== CONFIGURACIONES ESPECÍFICAS DE VM ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName
Responsable: $ResponsableName

HERRAMIENTAS DE VIRTUALIZACIÓN:
- VMware Tools: $(if ($VMwareTools) { "Instalado" } else { "No instalado" })
- Hyper-V Integration: $(if ($HyperVIntegration) { "Disponible" } else { "No disponible" })

CONFIGURACIONES DE SEGURIDAD:
- Antivirus: $(if ($DefenderStatus.AntivirusEnabled) { "Habilitado" } else { "Deshabilitado" })
- Firewall: $(if ((netsh advfirewall show allprofiles | Select-String "ON").Count -gt 0) { "Habilitado" } else { "Deshabilitado" })
- Actualizaciones: $(if ((Get-Service -Name wuauserv).Status -eq "Running") { "Habilitadas" } else { "Deshabilitadas" })

=== FIN DE CONFIGURACIONES ESPECÍFICAS DE VM ===
"@
    $VMConfigOutput | Out-File -FilePath (Join-Path $ReportsPath "configuraciones-vm.txt") -Encoding UTF8
    Write-Log "Configuraciones específicas de VM guardadas"
}

# Capturas de Pantalla (si se solicita)
if ($IncludeScreenshots) {
    Write-Host "Capturando pantallas para evidencias..." -ForegroundColor Cyan
    Write-Log "Iniciando capturas de pantalla"
    
    Write-Host "Abra las siguientes ventanas para capturar:" -ForegroundColor Yellow
    Write-Host "- Windows Defender" -ForegroundColor Yellow
    Write-Host "- Configuración de Firewall" -ForegroundColor Yellow
    Write-Host "- Usuarios y Grupos" -ForegroundColor Yellow
    Write-Host "- Servicios" -ForegroundColor Yellow
    Write-Host "- Políticas de Contraseñas" -ForegroundColor Yellow
    Write-Host "Presione Enter cuando esté listo..." -ForegroundColor Yellow
    Read-Host
    
    Capture-Screenshot -FileName "windows-defender"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "firewall-configuracion"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "usuarios-grupos"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "servicios-sistema"
    Start-Sleep -Seconds 2
    Capture-Screenshot -FileName "politicas-contrasenas"
}

# Generar reporte resumen CN-CERT
Write-Host "Generando reporte resumen CN-CERT..." -ForegroundColor Cyan
$SummaryOutput = @"
=== REPORTE RESUMEN CN-CERT - Op.exp.2 ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName
Responsable: $ResponsableName

INFORMACIÓN DEL SISTEMA:
- Hostname: $env:COMPUTERNAME
- Usuario: $env:USERNAME
- Dominio: $env:USERDOMAIN
- Versión de Windows: $(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
- Build: $(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild

RESULTADOS POR ASPECTO:

1. CONFIGURACIÓN DE SEGURIDAD PREVIA A PRODUCCIÓN:
   - Políticas de grupo: $(if (Test-Path (Join-Path $ReportsPath "politicas-grupo.txt")) { "Verificado" } else { "No verificado" })
   - Configuraciones de seguridad: $(if (Test-Path (Join-Path $ReportsPath "configuraciones-seguridad.txt")) { "Verificado" } else { "No verificado" })
   - Herramientas de seguridad: $(if (Test-Path (Join-Path $ReportsPath "herramientas-seguridad.txt")) { "Verificado" } else { "No verificado" })

2. ELIMINACIÓN DE CUENTAS Y CONTRASEÑAS ESTÁNDAR:
   - Políticas de contraseñas: $(if (Test-Path (Join-Path $ReportsPath "politicas-contrasenas.txt")) { "Verificado" } else { "No verificado" })
   - Cuentas de usuario: $(if (Test-Path (Join-Path $ReportsPath "cuentas-usuario.txt")) { "Verificado" } else { "No verificado" })
   - Cuentas por defecto: $(if (Test-Path (Join-Path $ReportsPath "cuentas-por-defecto.txt")) { "Verificado" } else { "No verificado" })

3. MÍNIMA FUNCIONALIDAD:
   - Servicios críticos: $(if (Test-Path (Join-Path $ReportsPath "servicios-criticos.txt")) { "Verificado" } else { "No verificado" })
   - Servicios innecesarios: $(if (Test-Path (Join-Path $ReportsPath "servicios-innecesarios.txt")) { "Verificado" } else { "No verificado" })
   - Puertos abiertos: $(if (Test-Path (Join-Path $ReportsPath "puertos-abiertos.txt")) { "Verificado" } else { "No verificado" })

4. SEGURIDAD POR DEFECTO:
   - Firewall: $(if (Test-Path (Join-Path $ReportsPath "configuracion-firewall.txt")) { "Verificado" } else { "No verificado" })
   - UAC: $(if (Test-Path (Join-Path $ReportsPath "configuracion-uac.txt")) { "Verificado" } else { "No verificado" })
   - SmartScreen: $(if (Test-Path (Join-Path $ReportsPath "configuracion-smartscreen.txt")) { "Verificado" } else { "No verificado" })

5. GESTIÓN DE MÁQUINAS VIRTUALES:
   - Información de VM: $(if (Test-Path (Join-Path $ReportsPath "informacion-vm.txt")) { "Verificado" } else { "No verificado" })
   - Configuraciones específicas: $(if (Test-Path (Join-Path $ReportsPath "configuraciones-vm.txt")) { "Verificado" } else { "No verificado" })

CAPTURAS DE PANTALLA:
$(if ($IncludeScreenshots) { (Get-ChildItem -Path $ScreenshotsPath -Name | ForEach-Object { "- $_" }) } else { "- No solicitadas" })

ARCHIVOS GENERADOS:
$(Get-ChildItem -Path $ReportsPath -Name | ForEach-Object { "- $_" })

=== FIN DEL REPORTE RESUMEN ===
"@
$SummaryOutput | Out-File -FilePath (Join-Path $BasePath "reporte-resumen-cn-cert.txt") -Encoding UTF8

# Crear archivo ZIP con todas las evidencias
Write-Host "Creando archivo ZIP con evidencias..." -ForegroundColor Cyan
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
Write-Host "=== RECOLECCIÓN CN-CERT COMPLETADA ===" -ForegroundColor Green
Write-Host "Directorio de evidencias: $BasePath" -ForegroundColor Yellow
Write-Host "Archivo ZIP: $ZipPath" -ForegroundColor Yellow
Write-Host "Log de auditoría: $(Join-Path $BasePath "audit-log.txt")" -ForegroundColor Yellow
Write-Log "Recolección de evidencias CN-CERT completada exitosamente"

# Mostrar estadísticas finales
$TotalFiles = (Get-ChildItem -Path $BasePath -Recurse -File).Count
Write-Host "Total de archivos generados: $TotalFiles" -ForegroundColor Cyan
Write-Host "Tamaño total: $([math]::Round((Get-ChildItem -Path $BasePath -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB" -ForegroundColor Cyan 