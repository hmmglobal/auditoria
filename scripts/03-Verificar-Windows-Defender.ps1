# Script 3: Verificar Windows Defender
Write-Host "=== VERIFICACIÓN DE WINDOWS DEFENDER ===" -ForegroundColor Green
Write-Host ""

Write-Host "ESTADO DE WINDOWS DEFENDER:" -ForegroundColor Yellow
$defender = Get-MpComputerStatus
Write-Host "Antivirus Enabled: $($defender.AntivirusEnabled)"
Write-Host "Real-time Protection: $($defender.RealTimeProtectionEnabled)"
Write-Host "Behavior Monitor: $($defender.BehaviorMonitorEnabled)"
Write-Host "On Access Protection: $($defender.OnAccessProtectionEnabled)"
Write-Host "IOAV Protection: $($defender.IoavProtectionEnabled)"

Write-Host ""
Write-Host "POLÍTICAS DE WINDOWS DEFENDER:" -ForegroundColor Yellow
$politicas = Get-MpPreference
Write-Host "DisableRealtimeMonitoring: $($politicas.DisableRealtimeMonitoring)"
Write-Host "DisableBehaviorMonitoring: $($politicas.DisableBehaviorMonitoring)"
Write-Host "DisableOnAccessProtection: $($politicas.DisableOnAccessProtection)"

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 