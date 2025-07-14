# Script 7: Verificar Acceso Remoto
Write-Host "=== VERIFICACIÓN DE ACCESO REMOTO ===" -ForegroundColor Green
Write-Host ""

Write-Host "SERVICIO RDP:" -ForegroundColor Yellow
$rdp = Get-Service -Name "TermService"
Write-Host "Estado: $($rdp.Status)"
Write-Host "Tipo de inicio: $($rdp.StartType)"

Write-Host ""
Write-Host "CONFIGURACIÓN RDP EN REGISTRO:" -ForegroundColor Yellow
$ruta = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
$config = Get-ItemProperty -Path $ruta -ErrorAction SilentlyContinue
if ($config) {
    Write-Host "fDenyTSConnections: $($config.fDenyTSConnections)"
    Write-Host "fSingleSessionPerUser: $($config.fSingleSessionPerUser)"
}

Write-Host ""
Write-Host "REGLAS DE FIREWALL RDP:" -ForegroundColor Yellow
$reglasRDP = Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*Remote Desktop*"} | Select-Object DisplayName, Enabled, Direction
foreach ($regla in $reglasRDP) {
    Write-Host "$($regla.DisplayName) - $($regla.Enabled) - $($regla.Direction)"
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 