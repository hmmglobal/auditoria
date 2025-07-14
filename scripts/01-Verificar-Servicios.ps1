# Script 1: Verificar Servicios Críticos
Write-Host "=== VERIFICACIÓN DE SERVICIOS CRÍTICOS ===" -ForegroundColor Green
Write-Host ""

$servicios = @(
    "AuditService",
    "BFE",
    "MpsSvc", 
    "WdNisSvc",
    "WdFilter",
    "WinDefend",
    "wscsvc"
)

foreach ($servicio in $servicios) {
    $estado = Get-Service -Name $servicio -ErrorAction SilentlyContinue
    if ($estado) {
        Write-Host "✓ $servicio : $($estado.Status)" -ForegroundColor Green
    } else {
        Write-Host "✗ $servicio : NO ENCONTRADO" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 