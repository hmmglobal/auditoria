# Script de Instalacion Rapida - CN-CERT Bastionado
# Version: 1.0

param(
    [Parameter(Mandatory=$false)]
    [string]$InstallPath = "C:\cn-cert-bastionado"
)

Write-Host "=== INSTALACION RAPIDA - CN-CERT BASTIONADO ===" -ForegroundColor Green
Write-Host ""

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "ADVERTENCIA: Este script no se esta ejecutando como administrador." -ForegroundColor Yellow
    Write-Host "   Algunas verificaciones pueden requerir permisos elevados." -ForegroundColor Yellow
    Write-Host ""
}

# Crear directorio de instalacion
Write-Host "Creando directorio de instalacion..." -ForegroundColor Cyan
if (-not (Test-Path $InstallPath)) {
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
    Write-Host "Directorio creado: $InstallPath" -ForegroundColor Green
} else {
    Write-Host "Directorio ya existe: $InstallPath" -ForegroundColor Green
}

# Configurar PowerShell
Write-Host "Configurando PowerShell..." -ForegroundColor Cyan
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "Politica de ejecucion configurada" -ForegroundColor Green
} catch {
    Write-Host "No se pudo configurar la politica de ejecucion" -ForegroundColor Yellow
}

# Verificar requisitos
Write-Host "Verificando requisitos del sistema..." -ForegroundColor Cyan

# Verificar PowerShell
$psVersion = $PSVersionTable.PSVersion
Write-Host "   PowerShell: $psVersion" -ForegroundColor White

# Verificar Windows
$osInfo = Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion
Write-Host "   Sistema Operativo: $($osInfo.WindowsProductName) $($osInfo.WindowsVersion)" -ForegroundColor White

# Verificar permisos
if ($isAdmin) {
    Write-Host "   Permisos: Administrador" -ForegroundColor Green
} else {
    Write-Host "   Permisos: Usuario estandar" -ForegroundColor Yellow
}

Write-Host ""

# Crear estructura de directorios
Write-Host "Creando estructura de directorios..." -ForegroundColor Cyan
$directories = @(
    "evidencias",
    "evidencias\capturas-pantalla",
    "evidencias\reportes",
    "evidencias\logs",
    "evidencias\checklists"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $InstallPath $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "   $dir" -ForegroundColor Green
    } else {
        Write-Host "   $dir (ya existe)" -ForegroundColor Green
    }
}

Write-Host ""

# Crear archivo de configuracion
Write-Host "Creando archivo de configuracion..." -ForegroundColor Cyan
$configContent = @"
# Configuracion CN-CERT Bastionado
# Fecha de instalacion: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

[General]
InstallPath = "$InstallPath"
InstallDate = "$(Get-Date -Format "yyyy-MM-dd")"
PowerShellVersion = "$psVersion"
WindowsVersion = "$($osInfo.WindowsProductName) $($osInfo.WindowsVersion)"

[Paths]
Evidencias = "$InstallPath\evidencias"
Capturas = "$InstallPath\evidencias\capturas-pantalla"
Reportes = "$InstallPath\evidencias\reportes"
Logs = "$InstallPath\evidencias\logs"
Checklists = "$InstallPath\evidencias\checklists"

[Scripts]
Get-SecurityEvidence = "scripts\Get-SecurityEvidence.ps1"
Get-CNCertEvidence = "scripts\Get-CNCertEvidence.ps1"
Get-LinuxSecurityEvidence = "scripts\Get-LinuxSecurityEvidence.sh"
"@

$configPath = Join-Path $InstallPath "config.ini"
$configContent | Out-File -FilePath $configPath -Encoding UTF8
Write-Host "Archivo de configuracion creado: $configPath" -ForegroundColor Green

Write-Host ""

# Crear script de ejecucion rapida
Write-Host "Creando script de ejecucion rapida..." -ForegroundColor Cyan
$quickRunContent = @"
# Script de Ejecucion Rapida - CN-CERT Bastionado

param(
    [Parameter(Mandatory=`$true)]
    [string]`$SystemName,
    
    [Parameter(Mandatory=`$true)]
    [string]`$AuditorName,
    
    [switch]`$IncludeScreenshots,
    [switch]`$IncludeLogs
)

# Configuracion
`$InstallPath = "$InstallPath"
`$ScriptsPath = Join-Path `$InstallPath "scripts"
`$OutputPath = Join-Path `$InstallPath "evidencias"

Write-Host "=== EJECUCION RAPIDA - CN-CERT BASTIONADO ===" -ForegroundColor Green
Write-Host "Sistema: `$SystemName" -ForegroundColor Yellow
Write-Host "Auditor: `$AuditorName" -ForegroundColor Yellow
Write-Host "Directorio de salida: `$OutputPath" -ForegroundColor Yellow
Write-Host ""

# Verificar que los scripts existen
if (-not (Test-Path (Join-Path `$ScriptsPath "Get-SecurityEvidence.ps1"))) {
    Write-Host "Error: Scripts no encontrados en `$ScriptsPath" -ForegroundColor Red
    Write-Host "   Asegurate de que los scripts esten en el directorio correcto." -ForegroundColor Red
    exit 1
}

# Ejecutar script principal
Write-Host "Iniciando recoleccion de evidencias..." -ForegroundColor Cyan
`$scriptPath = Join-Path `$ScriptsPath "Get-SecurityEvidence.ps1"

`$params = @{
    OutputPath = `$OutputPath
    SystemName = `$SystemName
    AuditorName = `$AuditorName
}

if (`$IncludeScreenshots) { `$params.IncludeScreenshots = `$true }
if (`$IncludeLogs) { `$params.IncludeLogs = `$true }

try {
    & `$scriptPath @params
    Write-Host ""
    Write-Host "Auditoria completada exitosamente!" -ForegroundColor Green
    Write-Host "Evidencias disponibles en: `$OutputPath" -ForegroundColor Green
} catch {
    Write-Host "Error durante la ejecucion: `$(`$_.Exception.Message)" -ForegroundColor Red
}
"@

$quickRunPath = Join-Path $InstallPath "ejecutar-auditoria.ps1"
$quickRunContent | Out-File -FilePath $quickRunPath -Encoding UTF8
Write-Host "Script de ejecucion rapida creado: $quickRunPath" -ForegroundColor Green

Write-Host ""

# Mostrar instrucciones de uso
Write-Host "=== INSTRUCCIONES DE USO ===" -ForegroundColor Green
Write-Host ""
Write-Host "Directorio de instalacion: $InstallPath" -ForegroundColor White
Write-Host ""
Write-Host "Para ejecutar una auditoria:" -ForegroundColor Cyan
Write-Host "   cd $InstallPath" -ForegroundColor White
Write-Host "   .\ejecutar-auditoria.ps1 -SystemName 'PC-001' -AuditorName 'Tu Nombre' -IncludeScreenshots" -ForegroundColor White
Write-Host ""
Write-Host "Para ver documentacion:" -ForegroundColor Cyan
Write-Host "   cd $InstallPath" -ForegroundColor White
Write-Host "   start README.md" -ForegroundColor White
Write-Host ""
Write-Host "Para ver evidencias:" -ForegroundColor Cyan
Write-Host "   cd $InstallPath\evidencias" -ForegroundColor White
Write-Host "   explorer ." -ForegroundColor White
Write-Host ""

Write-Host "=== INSTALACION COMPLETADA ===" -ForegroundColor Green
Write-Host "Todo listo para usar las herramientas de CN-CERT Bastionado!" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Cyan
Write-Host "   1. Revisar la documentacion en README.md" -ForegroundColor White
Write-Host "   2. Ejecutar una auditoria de prueba" -ForegroundColor White
Write-Host "   3. Revisar las evidencias generadas" -ForegroundColor White
Write-Host "   4. Adaptar a tus necesidades especificas" -ForegroundColor White 