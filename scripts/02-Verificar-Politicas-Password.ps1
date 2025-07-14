# Script 2: Verificar Políticas de Contraseñas
Write-Host "=== VERIFICACIÓN DE POLÍTICAS DE CONTRASEÑAS ===" -ForegroundColor Green
Write-Host ""

$politicas = net accounts

Write-Host "POLÍTICAS ACTUALES:" -ForegroundColor Yellow
Write-Host $politicas

Write-Host ""
Write-Host "VERIFICAR EN REGISTRO:" -ForegroundColor Yellow
$ruta = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
$valor = Get-ItemProperty -Path $ruta -Name "DisablePasswordChange" -ErrorAction SilentlyContinue
Write-Host "DisablePasswordChange: $($valor.DisablePasswordChange)"

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 