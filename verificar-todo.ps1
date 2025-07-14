# Script Completo de Verificación CCN-STIC 599B23
# Genera un reporte completo para transcribir

Write-Host "=== VERIFICACIÓN COMPLETA CCN-STIC 599B23 ===" -ForegroundColor Green
Write-Host "Fecha: $(Get-Date)" -ForegroundColor Yellow
Write-Host "Equipo: $env:COMPUTERNAME" -ForegroundColor Yellow
Write-Host "Usuario: $env:USERNAME" -ForegroundColor Yellow
Write-Host ""

# Crear archivo de reporte
$reporte = "REPORTE_CCN_STIC_599B23_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$rutaReporte = Join-Path $PSScriptRoot $reporte

"=== REPORTE DE VERIFICACIÓN CCN-STIC 599B23 ===" | Out-File -FilePath $rutaReporte
"Fecha: $(Get-Date)" | Out-File -FilePath $rutaReporte -Append
"Equipo: $env:COMPUTERNAME" | Out-File -FilePath $rutaReporte -Append
"Usuario: $env:USERNAME" | Out-File -FilePath $rutaReporte -Append
"" | Out-File -FilePath $rutaReporte -Append

# 1. SERVICIOS CRÍTICOS
Write-Host "1. VERIFICANDO SERVICIOS CRÍTICOS..." -ForegroundColor Cyan
"1. SERVICIOS CRÍTICOS" | Out-File -FilePath $rutaReporte -Append
"===================" | Out-File -FilePath $rutaReporte -Append

$servicios = @(
    @{Nombre="AuditService"; Descripcion="Servicio de Auditoría"},
    @{Nombre="BFE"; Descripcion="Base Filtering Engine"},
    @{Nombre="MpsSvc"; Descripcion="Windows Firewall"},
    @{Nombre="WdNisSvc"; Descripcion="Windows Defender Network Inspection"},
    @{Nombre="WdFilter"; Descripcion="Windows Defender Filter"},
    @{Nombre="WinDefend"; Descripcion="Windows Defender"},
    @{Nombre="wscsvc"; Descripcion="Centro de seguridad de Windows"}
)

foreach ($servicio in $servicios) {
    $estado = Get-Service -Name $servicio.Nombre -ErrorAction SilentlyContinue
    if ($estado) {
        $resultado = "✓ $($servicio.Nombre) ($($servicio.Descripcion)): $($estado.Status) - $($estado.StartType)"
        Write-Host $resultado -ForegroundColor Green
        $resultado | Out-File -FilePath $rutaReporte -Append
    } else {
        $resultado = "✗ $($servicio.Nombre) ($($servicio.Descripcion)): NO ENCONTRADO"
        Write-Host $resultado -ForegroundColor Red
        $resultado | Out-File -FilePath $rutaReporte -Append
    }
}

# 2. POLÍTICAS DE CONTRASEÑAS
Write-Host "`n2. VERIFICANDO POLÍTICAS DE CONTRASEÑAS..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"2. POLÍTICAS DE CONTRASEÑAS" | Out-File -FilePath $rutaReporte -Append
"=========================" | Out-File -FilePath $rutaReporte -Append

$politicas = net accounts
Write-Host "Políticas de contraseñas:" -ForegroundColor Yellow
Write-Host $politicas
$politicas | Out-File -FilePath $rutaReporte -Append

# 3. WINDOWS DEFENDER
Write-Host "`n3. VERIFICANDO WINDOWS DEFENDER..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"3. WINDOWS DEFENDER" | Out-File -FilePath $rutaReporte -Append
"==================" | Out-File -FilePath $rutaReporte -Append

$defender = Get-MpComputerStatus
Write-Host "Estado de Windows Defender:" -ForegroundColor Yellow
$estadosDefender = @(
    "Antivirus Enabled: $($defender.AntivirusEnabled)",
    "Real-time Protection: $($defender.RealTimeProtectionEnabled)",
    "Behavior Monitor: $($defender.BehaviorMonitorEnabled)",
    "On Access Protection: $($defender.OnAccessProtectionEnabled)",
    "IOAV Protection: $($defender.IoavProtectionEnabled)"
)

foreach ($estado in $estadosDefender) {
    Write-Host $estado
    $estado | Out-File -FilePath $rutaReporte -Append
}

# 4. FIREWALL
Write-Host "`n4. VERIFICANDO FIREWALL..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"4. FIREWALL" | Out-File -FilePath $rutaReporte -Append
"===========" | Out-File -FilePath $rutaReporte -Append

$firewall = Get-NetFirewallProfile
Write-Host "Perfiles de Firewall:" -ForegroundColor Yellow
foreach ($perfil in $firewall) {
    $resultado = "$($perfil.Name): $($perfil.Enabled)"
    Write-Host $resultado
    $resultado | Out-File -FilePath $rutaReporte -Append
}

# 5. AUDITORÍA
Write-Host "`n5. VERIFICANDO AUDITORÍA..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"5. AUDITORÍA" | Out-File -FilePath $rutaReporte -Append
"============" | Out-File -FilePath $rutaReporte -Append

$audit = auditpol /get /category:*
Write-Host "Políticas de Auditoría:" -ForegroundColor Yellow
Write-Host $audit
$audit | Out-File -FilePath $rutaReporte -Append

# 6. ACTUALIZACIONES
Write-Host "`n6. VERIFICANDO ACTUALIZACIONES..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"6. ACTUALIZACIONES" | Out-File -FilePath $rutaReporte -Append
"=================" | Out-File -FilePath $rutaReporte -Append

$wu = Get-Service -Name "wuauserv"
$resultado = "Windows Update: $($wu.Status) - $($wu.StartType)"
Write-Host $resultado -ForegroundColor Yellow
$resultado | Out-File -FilePath $rutaReporte -Append

# 7. ACCESO REMOTO
Write-Host "`n7. VERIFICANDO ACCESO REMOTO..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"7. ACCESO REMOTO" | Out-File -FilePath $rutaReporte -Append
"=================" | Out-File -FilePath $rutaReporte -Append

$rdp = Get-Service -Name "TermService"
$resultado = "Servicio RDP: $($rdp.Status) - $($rdp.StartType)"
Write-Host $resultado -ForegroundColor Yellow
$resultado | Out-File -FilePath $rutaReporte -Append

$ruta = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
$config = Get-ItemProperty -Path $ruta -ErrorAction SilentlyContinue
if ($config) {
    $resultado = "RDP Denegado: $($config.fDenyTSConnections)"
    Write-Host $resultado
    $resultado | Out-File -FilePath $rutaReporte -Append
}

# 8. CONTROL DE DISPOSITIVOS
Write-Host "`n8. VERIFICANDO CONTROL DE DISPOSITIVOS..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"8. CONTROL DE DISPOSITIVOS" | Out-File -FilePath $rutaReporte -Append
"=========================" | Out-File -FilePath $rutaReporte -Append

$pnp = Get-Service -Name "PlugPlay"
$resultado = "Plug and Play: $($pnp.Status) - $($pnp.StartType)"
Write-Host $resultado -ForegroundColor Yellow
$resultado | Out-File -FilePath $rutaReporte -Append

# 9. POWERSHELL
Write-Host "`n9. VERIFICANDO POWERSHELL..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"9. POWERSHELL" | Out-File -FilePath $rutaReporte -Append
"=============" | Out-File -FilePath $rutaReporte -Append

$executionPolicy = Get-ExecutionPolicy
$resultado = "Execution Policy: $executionPolicy"
Write-Host $resultado -ForegroundColor Yellow
$resultado | Out-File -FilePath $rutaReporte -Append

# 10. INFORMACIÓN DEL SISTEMA
Write-Host "`n10. INFORMACIÓN DEL SISTEMA..." -ForegroundColor Cyan
"" | Out-File -FilePath $rutaReporte -Append
"10. INFORMACIÓN DEL SISTEMA" | Out-File -FilePath $rutaReporte -Append
"==========================" | Out-File -FilePath $rutaReporte -Append

$os = Get-WmiObject -Class Win32_OperatingSystem
$info = @(
    "Sistema Operativo: $($os.Caption)",
    "Versión: $($os.Version)",
    "Arquitectura: $($os.OSArchitecture)",
    "Último arranque: $($os.LastBootUpTime)"
)

foreach ($linea in $info) {
    Write-Host $linea -ForegroundColor Yellow
    $linea | Out-File -FilePath $rutaReporte -Append
}

# RESUMEN FINAL
Write-Host "`n=== RESUMEN ===" -ForegroundColor Green
Write-Host "Reporte guardado en: $rutaReporte" -ForegroundColor Yellow
Write-Host "Puedes abrir el archivo para transcribir la información" -ForegroundColor Yellow

"" | Out-File -FilePath $rutaReporte -Append
"=== FIN DEL REPORTE ===" | Out-File -FilePath $rutaReporte -Append
"Generado el: $(Get-Date)" | Out-File -FilePath $rutaReporte -Append

Write-Host "`nPresiona cualquier tecla para abrir el reporte..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Abrir el reporte
Start-Process notepad $rutaReporte