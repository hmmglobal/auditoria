# Script 5: Verificar Auditoría
Write-Host "=== VERIFICACIÓN DE AUDITORÍA ===" -ForegroundColor Green
Write-Host ""

Write-Host "POLÍTICAS DE AUDITORÍA:" -ForegroundColor Yellow
$audit = auditpol /get /category:*
Write-Host $audit

Write-Host ""
Write-Host "VERIFICAR REGISTRO DE AUDITORÍA:" -ForegroundColor Yellow
$ruta = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valor = Get-ItemProperty -Path $ruta -Name "AuditBaseObjects" -ErrorAction SilentlyContinue
Write-Host "AuditBaseObjects: $($valor.AuditBaseObjects)"

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 