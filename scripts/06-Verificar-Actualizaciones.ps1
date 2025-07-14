# Script 6: Verificar Actualizaciones
Write-Host "=== VERIFICACIÓN DE ACTUALIZACIONES ===" -ForegroundColor Green
Write-Host ""

Write-Host "SERVICIO WINDOWS UPDATE:" -ForegroundColor Yellow
$wu = Get-Service -Name "wuauserv"
Write-Host "Estado: $($wu.Status)"
Write-Host "Tipo de inicio: $($wu.StartType)"

Write-Host ""
Write-Host "POLÍTICAS DE ACTUALIZACIÓN:" -ForegroundColor Yellow
$ruta = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$politicas = Get-ItemProperty -Path $ruta -ErrorAction SilentlyContinue
if ($politicas) {
    Write-Host "NoAutoUpdate: $($politicas.NoAutoUpdate)"
    Write-Host "AUOptions: $($politicas.AUOptions)"
    Write-Host "ScheduledInstallDay: $($politicas.ScheduledInstallDay)"
    Write-Host "ScheduledInstallTime: $($politicas.ScheduledInstallTime)"
} else {
    Write-Host "No se encontraron políticas específicas"
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 