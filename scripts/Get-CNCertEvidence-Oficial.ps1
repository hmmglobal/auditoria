# Script de Evidencias CN-CERT - Integración con Scripts Oficiales
# Autor: Equipo de Seguridad
# Versión: 2.0 (Integrado con Scripts Oficiales CN-CERT)
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
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("MIEMBRO", "INDEPENDIENTE")]
    [string]$TipoCliente,
    
    [switch]$IncludeScreenshots,
    [switch]$IncludeLogs,
    [switch]$ExecuteScripts,
    [switch]$Verbose
)

# Configuración inicial
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Crear directorio de salida
$Date = Get-Date -Format "yyyy-MM-dd"
$BasePath = Join-Path $OutputPath "cn-cert-oficial-$SystemName-$Date"
$ScreenshotsPath = Join-Path $BasePath "capturas-pantalla"
$ReportsPath = Join-Path $BasePath "reportes"
$LogsPath = Join-Path $BasePath "logs"
$ScriptsPath = Join-Path $BasePath "scripts-ejecutados"

# Crear directorios
New-Item -ItemType Directory -Path $BasePath -Force | Out-Null
New-Item -ItemType Directory -Path $ScreenshotsPath -Force | Out-Null
New-Item -ItemType Directory -Path $ReportsPath -Force | Out-Null
New-Item -ItemType Directory -Path $LogsPath -Force | Out-Null
New-Item -ItemType Directory -Path $ScriptsPath -Force | Out-Null

Write-Host "=== EVIDENCIAS CN-CERT OFICIAL - Op.exp.2 Configuración de Seguridad ===" -ForegroundColor Green
Write-Host "Sistema: $SystemName" -ForegroundColor Yellow
Write-Host "Tipo de Cliente: $TipoCliente" -ForegroundColor Yellow
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
Tipo de Cliente: $TipoCliente
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

# Función para ejecutar script oficial de CN-CERT
function Invoke-CNCertScript {
    param([string]$ScriptPath, [string]$ScriptName, [string]$Description)
    
    Write-Log "Ejecutando script oficial CN-CERT: $ScriptName"
    
    try {
        # Crear directorio temporal para el script
        $TempScriptPath = Join-Path $ScriptsPath $ScriptName
        Copy-Item $ScriptPath $TempScriptPath -Force
        
        # Ejecutar script según su extensión
        if ($ScriptPath -match "\.ps1$") {
            $Result = & $TempScriptPath 2>&1
        } elseif ($ScriptPath -match "\.bat$") {
            $Result = cmd /c $TempScriptPath 2>&1
        }
        
        $Output = @"
=== SCRIPT OFICIAL CN-CERT: $ScriptName ===
Descripción: $Description
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Tipo de Cliente: $TipoCliente
Auditor: $AuditorName
Responsable: $ResponsableName

RESULTADO DE EJECUCIÓN:
$Result

=== FIN DE SCRIPT OFICIAL ===
"@
        
        $FilePath = Join-Path $ReportsPath "script-$ScriptName.txt"
        $Output | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Log "Script oficial ejecutado: $ScriptName"
        
        return $Result
    }
    catch {
        Write-Log "Error ejecutando script oficial $ScriptName : $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Inicio de la recolección
Write-Log "Iniciando recolección de evidencias CN-CERT con scripts oficiales"

# Determinar prefijo de scripts según tipo de cliente
$ScriptPrefix = if ($TipoCliente -eq "MIEMBRO") { "CCN-STIC-599A23" } else { "CCN-STIC-599B23" }
$ClientType = if ($TipoCliente -eq "MIEMBRO") { "CLIENTES MIEMBRO" } else { "CLIENTES INDEPENDIENTES" }

Write-Host "Tipo de Cliente: $TipoCliente" -ForegroundColor Cyan
Write-Host "Prefijo de Scripts: $ScriptPrefix" -ForegroundColor Cyan
Write-Host "Directorio de Scripts: Scripts-599AB23/$ClientType" -ForegroundColor Cyan
Write-Host ""

# ASPECTO 1: Configuración de Seguridad Previa a Producción
Write-Host "=== ASPECTO 1: Configuración de Seguridad Previa a Producción ===" -ForegroundColor Cyan

if ($ExecuteScripts) {
    Write-Host "1.1 Ejecutando script de desinstalación de características..." -ForegroundColor Yellow
    $ScriptPath = "Scripts-599AB23/$ClientType/${ScriptPrefix}_Desinstala_caracteristicas.ps1"
    if (Test-Path $ScriptPath) {
        Invoke-CNCertScript -ScriptPath $ScriptPath -ScriptName "${ScriptPrefix}_Desinstala_caracteristicas.ps1" -Description "Desinstalación de características innecesarias"
    } else {
        Write-Log "Script no encontrado: $ScriptPath" "WARNING"
    }
    
    Write-Host "1.2 Ejecutando script de eliminación de aplicaciones..." -ForegroundColor Yellow
    $ScriptPath = "Scripts-599AB23/$ClientType/${ScriptPrefix}_Eliminar_aplicaciones_aprovisionadas.ps1"
    if (Test-Path $ScriptPath) {
        Invoke-CNCertScript -ScriptPath $ScriptPath -ScriptName "${ScriptPrefix}_Eliminar_aplicaciones_aprovisionadas.ps1" -Description "Eliminación de aplicaciones aprovisionadas"
    } else {
        Write-Log "Script no encontrado: $ScriptPath" "WARNING"
    }
}

Write-Host "1.3 Verificando características habilitadas..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "dism /online /format:list /get-features | findstr 'Habilitado'" -FileName "caracteristicas-habilitadas" -Description "CARACTERÍSTICAS HABILITADAS"

Write-Host "1.4 Verificando aplicaciones aprovisionadas..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "Get-AppxProvisionedPackage -Online" -FileName "aplicaciones-aprovisionadas" -Description "APLICACIONES APROVISIONADAS"

# ASPECTO 2: Eliminación de Cuentas y Contraseñas Estándar
Write-Host "=== ASPECTO 2: Eliminación de Cuentas y Contraseñas Estándar ===" -ForegroundColor Cyan

if ($ExecuteScripts) {
    Write-Host "2.1 Ejecutando script de menú contextual..." -ForegroundColor Yellow
    $ScriptPath = "Scripts-599AB23/$ClientType/${ScriptPrefix}_Antiguo_menu_contextual.ps1"
    if (Test-Path $ScriptPath) {
        Invoke-CNCertScript -ScriptPath $ScriptPath -ScriptName "${ScriptPrefix}_Antiguo_menu_contextual.ps1" -Description "Configuración de menú contextual"
    } else {
        Write-Log "Script no encontrado: $ScriptPath" "WARNING"
    }
}

Write-Host "2.2 Verificando políticas de contraseñas..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "net accounts" -FileName "politicas-contrasenas" -Description "POLÍTICAS DE CONTRASEÑAS"

Write-Host "2.3 Verificando cuentas de usuario..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "wmic useraccount get name,disabled,lockout" -FileName "cuentas-usuario" -Description "CUENTAS DE USUARIO"

# ASPECTO 3: Mínima Funcionalidad
Write-Host "=== ASPECTO 3: Mínima Funcionalidad ===" -ForegroundColor Cyan

Write-Host "3.1 Verificando características que deben mantenerse..." -ForegroundColor Yellow
$CaracteristicasMantener = @(
    "Client-DeviceLockdown",
    "Client-KeyboardFilter", 
    "Client-UnifiedWriteFilter",
    "Windows-Defender-ApplicationGuard",
    "WorkFolders-Client",
    "SmbDirect",
    "MSRDC-Infraestructure",
    "SearchEngine-Client-Package",
    "Windows-Defender-Default-Definitions",
    "Printing-PrintToPDFServices-Features",
    "MicrosoftWindowsPowerShellV2Root",
    "MicrosoftWindowsPowerShellV2",
    "NetFx4-AdvSrvs",
    "Internet-Explorer-Optional-amd64"
)

$CaracteristicasOutput = @"
=== CARACTERÍSTICAS QUE DEBEN MANTENERSE ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Tipo de Cliente: $TipoCliente
Auditor: $AuditorName
Responsable: $ResponsableName

CARACTERÍSTICAS REQUERIDAS:
$($CaracteristicasMantener | ForEach-Object { "- $_" })

VERIFICACIÓN:
"@

foreach ($Caracteristica in $CaracteristicasMantener) {
    $Estado = dism /online /format:list /get-features | Select-String $Caracteristica | Select-String "Habilitado"
    $CaracteristicasOutput += "`n$Caracteristica : $(if ($Estado) { "HABILITADA" } else { "NO HABILITADA" })"
}

$CaracteristicasOutput += "`n`n=== FIN DE CARACTERÍSTICAS ==="
$CaracteristicasOutput | Out-File -FilePath (Join-Path $ReportsPath "caracteristicas-mantener.txt") -Encoding UTF8
Write-Log "Verificación de características requeridas guardada"

# ASPECTO 4: Seguridad por Defecto
Write-Host "=== ASPECTO 4: Seguridad por Defecto ===" -ForegroundColor Cyan

if ($ExecuteScripts) {
    Write-Host "4.1 Configurando análisis de integridad de ficheros..." -ForegroundColor Yellow
    $ScriptPath = "Scripts-599AB23/$ClientType/${ScriptPrefix} Windows Defender - Análisis de integridad de ficheros.bat"
    if (Test-Path $ScriptPath) {
        Invoke-CNCertScript -ScriptPath $ScriptPath -ScriptName "${ScriptPrefix} Windows Defender - Análisis de integridad de ficheros.bat" -Description "Configuración de análisis de integridad"
    }
    
    Write-Host "4.2 Configurando análisis de dispositivos USB..." -ForegroundColor Yellow
    $ScriptPath = "Scripts-599AB23/$ClientType/${ScriptPrefix} Windows Defender - Análisis de dispositivos USB.bat"
    if (Test-Path $ScriptPath) {
        Invoke-CNCertScript -ScriptPath $ScriptPath -ScriptName "${ScriptPrefix} Windows Defender - Análisis de dispositivos USB.bat" -Description "Configuración de análisis USB"
    }
    
    Write-Host "4.3 Configurando análisis en el arranque..." -ForegroundColor Yellow
    $ScriptPath = "Scripts-599AB23/$ClientType/${ScriptPrefix} Windows Defender - Análisis en el arranque.bat"
    if (Test-Path $ScriptPath) {
        Invoke-CNCertScript -ScriptPath $ScriptPath -ScriptName "${ScriptPrefix} Windows Defender - Análisis en el arranque.bat" -Description "Configuración de análisis en arranque"
    }
}

Write-Host "4.4 Verificando Windows Defender..." -ForegroundColor Yellow
$DefenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
if ($DefenderStatus) {
    $DefenderOutput = @"
=== ESTADO DE WINDOWS DEFENDER ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Tipo de Cliente: $TipoCliente
Auditor: $AuditorName
Responsable: $ResponsableName

ESTADO:
- Nombre: $($DefenderStatus.AntivirusProductName)
- Estado: $($DefenderStatus.AntivirusEnabled)
- Protección en tiempo real: $($DefenderStatus.RealTimeProtectionEnabled)
- Protección basada en la nube: $($DefenderStatus.CloudProtectionEnabled)
- Control de acceso a carpetas: $($DefenderStatus.ControlledFolderAccessEnabled)
- Última actualización: $($DefenderStatus.AntivirusSignatureLastUpdated)

=== FIN DE WINDOWS DEFENDER ===
"@
    $DefenderOutput | Out-File -FilePath (Join-Path $ReportsPath "windows-defender.txt") -Encoding UTF8
    Write-Log "Estado de Windows Defender guardado"
}

Write-Host "4.5 Verificando tareas programadas de análisis..." -ForegroundColor Yellow
Invoke-CommandAndSave -Command "schtasks /query /tn 'Analisis integridad ficheros'" -FileName "tarea-analisis-integridad" -Description "TAREA DE ANÁLISIS DE INTEGRIDAD"
Invoke-CommandAndSave -Command "schtasks /query /tn 'Analisis dispositivos USB'" -FileName "tarea-analisis-usb" -Description "TAREA DE ANÁLISIS USB"
Invoke-CommandAndSave -Command "schtasks /query /tn 'Analisis arranque'" -FileName "tarea-analisis-arranque" -Description "TAREA DE ANÁLISIS EN ARRANQUE"

# ASPECTO 5: Gestión de Máquinas Virtuales
Write-Host "=== ASPECTO 5: Gestión de Máquinas Virtuales ===" -ForegroundColor Cyan

Write-Host "5.1 Verificando si es máquina virtual..." -ForegroundColor Yellow
$VMInfo = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Model, Manufacturer
$VMOutput = @"
=== INFORMACIÓN DE MÁQUINA VIRTUAL ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Tipo de Cliente: $TipoCliente
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

# Scripts adicionales de análisis
if ($ExecuteScripts) {
    Write-Host "5.2 Ejecutando scripts adicionales de análisis..." -ForegroundColor Yellow
    
    $ScriptsAdicionales = @(
        @{Path = "Scripts-599AB23/$ClientType/${ScriptPrefix}_Analisis_arranque.ps1"; Name = "${ScriptPrefix}_Analisis_arranque.ps1"},
        @{Path = "Scripts-599AB23/$ClientType/${ScriptPrefix}_Analisis_USBs.ps1"; Name = "${ScriptPrefix}_Analisis_USBs.ps1"},
        @{Path = "Scripts-599AB23/$ClientType/${ScriptPrefix}_Habilitar_registro_conexion_USBs.ps1"; Name = "${ScriptPrefix}_Habilitar_registro_conexion_USBs.ps1"}
    )
    
    foreach ($Script in $ScriptsAdicionales) {
        if (Test-Path $Script.Path) {
            Invoke-CNCertScript -ScriptPath $Script.Path -ScriptName $Script.Name -Description "Script adicional de análisis"
        }
    }
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
    Write-Host "- Tareas Programadas" -ForegroundColor Yellow
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
    Capture-Screenshot -FileName "tareas-programadas"
}

# Generar reporte resumen CN-CERT oficial
Write-Host "Generando reporte resumen CN-CERT oficial..." -ForegroundColor Cyan
$SummaryOutput = @"
=== REPORTE RESUMEN CN-CERT OFICIAL - Op.exp.2 ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Tipo de Cliente: $TipoCliente
Auditor: $AuditorName
Responsable: $ResponsableName

INFORMACIÓN DEL SISTEMA:
- Hostname: $env:COMPUTERNAME
- Usuario: $env:USERNAME
- Dominio: $env:USERDOMAIN
- Versión de Windows: $(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
- Build: $(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild

SCRIPTS OFICIALES CN-CERT EJECUTADOS:
$(if ($ExecuteScripts) { 
    Get-ChildItem -Path $ScriptsPath -Name | ForEach-Object { "- $_" }
} else {
    "- Scripts no ejecutados (modo solo verificación)"
})

RESULTADOS POR ASPECTO:

1. CONFIGURACIÓN DE SEGURIDAD PREVIA A PRODUCCIÓN:
   - Características habilitadas: $(if (Test-Path (Join-Path $ReportsPath "caracteristicas-habilitadas.txt")) { "Verificado" } else { "No verificado" })
   - Aplicaciones aprovisionadas: $(if (Test-Path (Join-Path $ReportsPath "aplicaciones-aprovisionadas.txt")) { "Verificado" } else { "No verificado" })
   - Scripts oficiales: $(if ($ExecuteScripts) { "Ejecutados" } else { "No ejecutados" })

2. ELIMINACIÓN DE CUENTAS Y CONTRASEÑAS ESTÁNDAR:
   - Políticas de contraseñas: $(if (Test-Path (Join-Path $ReportsPath "politicas-contrasenas.txt")) { "Verificado" } else { "No verificado" })
   - Cuentas de usuario: $(if (Test-Path (Join-Path $ReportsPath "cuentas-usuario.txt")) { "Verificado" } else { "No verificado" })

3. MÍNIMA FUNCIONALIDAD:
   - Características requeridas: $(if (Test-Path (Join-Path $ReportsPath "caracteristicas-mantener.txt")) { "Verificado" } else { "No verificado" })

4. SEGURIDAD POR DEFECTO:
   - Windows Defender: $(if (Test-Path (Join-Path $ReportsPath "windows-defender.txt")) { "Verificado" } else { "No verificado" })
   - Tareas de análisis: $(if (Test-Path (Join-Path $ReportsPath "tarea-analisis-integridad.txt")) { "Verificado" } else { "No verificado" })

5. GESTIÓN DE MÁQUINAS VIRTUALES:
   - Información de VM: $(if (Test-Path (Join-Path $ReportsPath "informacion-vm.txt")) { "Verificado" } else { "No verificado" })

CAPTURAS DE PANTALLA:
$(if ($IncludeScreenshots) { (Get-ChildItem -Path $ScreenshotsPath -Name | ForEach-Object { "- $_" }) } else { "- No solicitadas" })

ARCHIVOS GENERADOS:
$(Get-ChildItem -Path $ReportsPath -Name | ForEach-Object { "- $_" })

SCRIPTS EJECUTADOS:
$(if ($ExecuteScripts) { (Get-ChildItem -Path $ScriptsPath -Name | ForEach-Object { "- $_" }) } else { "- No ejecutados" })

=== FIN DEL REPORTE RESUMEN ===
"@
$SummaryOutput | Out-File -FilePath (Join-Path $BasePath "reporte-resumen-cn-cert-oficial.txt") -Encoding UTF8

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
Write-Host "=== RECOLECCIÓN CN-CERT OFICIAL COMPLETADA ===" -ForegroundColor Green
Write-Host "Directorio de evidencias: $BasePath" -ForegroundColor Yellow
Write-Host "Archivo ZIP: $ZipPath" -ForegroundColor Yellow
Write-Host "Log de auditoría: $(Join-Path $BasePath "audit-log.txt")" -ForegroundColor Yellow
Write-Log "Recolección de evidencias CN-CERT oficial completada exitosamente"

# Mostrar estadísticas finales
$TotalFiles = (Get-ChildItem -Path $BasePath -Recurse -File).Count
Write-Host "Total de archivos generados: $TotalFiles" -ForegroundColor Cyan
Write-Host "Tamaño total: $([math]::Round((Get-ChildItem -Path $BasePath -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB" -ForegroundColor Cyan 