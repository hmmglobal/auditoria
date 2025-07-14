# Script 8: Verificar Control de Dispositivos
Write-Host "=== VERIFICACIÓN DE CONTROL DE DISPOSITIVOS ===" -ForegroundColor Green
Write-Host ""

Write-Host "POLÍTICAS DE INSTALACIÓN DE DISPOSITIVOS:" -ForegroundColor Yellow
$ruta = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
$restricciones = Get-ItemProperty -Path $ruta -ErrorAction SilentlyContinue
if ($restricciones) {
    Write-Host "DenyUnspecified: $($restricciones.DenyUnspecified)"
    Write-Host "DenyUnspecifiedClass: $($restricciones.DenyUnspecifiedClass)"
}

Write-Host ""
Write-Host "SERVICIO PLUG AND PLAY:" -ForegroundColor Yellow
$pnp = Get-Service -Name "PlugPlay"
Write-Host "Estado: $($pnp.Status)"
Write-Host "Tipo de inicio: $($pnp.StartType)"

Write-Host ""
Write-Host "DISPOSITIVOS USB CONECTADOS:" -ForegroundColor Yellow
$usb = Get-PnpDevice | Where-Object {$_.Class -eq "USB"} | Select-Object -First 5 FriendlyName, Status
foreach ($dispositivo in $usb) {
    Write-Host "$($dispositivo.FriendlyName) - $($dispositivo.Status)"
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 