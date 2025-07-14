# Script 4: Verificar Firewall
Write-Host "=== VERIFICACIÓN DE FIREWALL ===" -ForegroundColor Green
Write-Host ""

Write-Host "ESTADO DEL FIREWALL:" -ForegroundColor Yellow
$firewall = Get-NetFirewallProfile
foreach ($perfil in $firewall) {
    Write-Host "$($perfil.Name): $($perfil.Enabled)"
}

Write-Host ""
Write-Host "REGLAS DE FIREWALL ACTIVAS:" -ForegroundColor Yellow
$reglas = Get-NetFirewallRule | Where-Object {$_.Enabled -eq "True"} | Select-Object -First 10 DisplayName, Direction, Action
foreach ($regla in $reglas) {
    Write-Host "$($regla.DisplayName) - $($regla.Direction) - $($regla.Action)"
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 