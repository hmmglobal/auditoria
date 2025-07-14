# Script para Generar Reporte Final de Cumplimiento
# Integración con Google Workspace
# Autor: Sistema de Auditoría de Seguridad
# Versión: 1.0

param(
    [string]$EvidencePath = "C:\Evidencias",
    [string]$GoogleDrivePath = "$env:USERPROFILE\Google Drive\Evidencias",
    [string]$OutputPath = "C:\Reportes",
    [string]$AuditorName = "",
    [string]$SystemOwner = "",
    [switch]$IncludeScreenshots,
    [switch]$UploadToDrive
)

# Configuración de colores para output
$Host.UI.RawUI.ForegroundColor = "Green"
Write-Host "=== GENERADOR DE REPORTE FINAL DE CUMPLIMIENTO ===" -ForegroundColor Cyan

# Función para leer información del sistema
function Get-SystemInfoFromEvidence {
    $systemInfoPath = Join-Path $EvidencePath "info_sistema.json"
    if (Test-Path $systemInfoPath) {
        return Get-Content $systemInfoPath | ConvertFrom-Json
    }
    else {
        return @{
            Hostname = $env:COMPUTERNAME
            IPAddress = "No disponible"
            Username = $env:USERNAME
            Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            WindowsVersion = "No disponible"
            BuildNumber = "No disponible"
        }
    }
}

# Función para analizar evidencia recolectada
function Analyze-Evidence {
    param([string]$EvidencePath)
    
    $analysis = @{
        TotalControls = 50
        CompletedControls = 0
        MissingControls = 0
        EvidenceCollected = @()
        MissingEvidence = @()
    }
    
    # Verificar carpetas de evidencia
    $expectedFolders = @(
        "Políticas_Contraseñas",
        "Configuracion_Usuarios",
        "Servicios_Sistema",
        "Configuracion_Red",
        "Windows_Defender",
        "BitLocker",
        "Windows_Hello",
        "Politicas_Aplicaciones",
        "Microsoft_Edge",
        "Configuracion_Proxy",
        "Office_365",
        "Aplicaciones_Terceros",
        "Auditoria_Eventos",
        "Configuracion_Logs",
        "Windows_Backup",
        "OneDrive_Configuracion",
        "Windows_Update",
        "Mantenimiento_Sistema",
        "Configuracion_Dominio",
        "Configuracion_VPN",
        "Configuracion_Perifericos",
        "Configuracion_Energia",
        "Reporte_Cumplimiento",
        "Excepciones_Documentadas"
    )
    
    foreach ($folder in $expectedFolders) {
        $folderPath = Join-Path $EvidencePath $folder
        if (Test-Path $folderPath) {
            $files = Get-ChildItem -Path $folderPath -File
            if ($files.Count -gt 0) {
                $analysis.CompletedControls++
                $analysis.EvidenceCollected += $folder
            }
            else {
                $analysis.MissingEvidence += $folder
            }
        }
        else {
            $analysis.MissingEvidence += $folder
        }
    }
    
    $analysis.MissingControls = $analysis.TotalControls - $analysis.CompletedControls
    return $analysis
}

# Función para generar reporte HTML
function Generate-HTMLReport {
    param(
        [object]$SystemInfo,
        [object]$Analysis,
        [string]$OutputPath
    )
    
    $compliancePercentage = [math]::Round(($Analysis.CompletedControls / $Analysis.TotalControls) * 100, 2)
    
    $htmlReport = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Cumplimiento - Windows 10/11</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; border-bottom: 2px solid #0078d4; padding-bottom: 20px; margin-bottom: 30px; }
        .system-info { background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .compliance-summary { background-color: #e8f5e8; padding: 20px; border-radius: 5px; margin-bottom: 30px; }
        .evidence-section { margin-bottom: 30px; }
        .evidence-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px; }
        .evidence-item { background-color: #f8f9fa; padding: 15px; border-radius: 5px; border-left: 4px solid #0078d4; }
        .missing-item { border-left-color: #dc3545; background-color: #fff5f5; }
        .progress-bar { width: 100%; height: 30px; background-color: #e9ecef; border-radius: 15px; overflow: hidden; margin: 10px 0; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #28a745, #20c997); transition: width 0.3s ease; }
        .footer { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #dee2e6; color: #6c757d; }
        .status-completed { color: #28a745; font-weight: bold; }
        .status-missing { color: #dc3545; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #dee2e6; }
        th { background-color: #0078d4; color: white; }
        tr:nth-child(even) { background-color: #f8f9fa; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Reporte de Cumplimiento - Estación de Trabajo Windows 10/11</h1>
            <h2>Integración con Google Workspace</h2>
            <p>Fecha de generación: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")</p>
        </div>

        <div class="system-info">
            <h3>Información del Sistema</h3>
            <table>
                <tr><td><strong>Hostname:</strong></td><td>$($SystemInfo.Hostname)</td></tr>
                <tr><td><strong>Dirección IP:</strong></td><td>$($SystemInfo.IPAddress)</td></tr>
                <tr><td><strong>Usuario:</strong></td><td>$($SystemInfo.Username)</td></tr>
                <tr><td><strong>Versión de Windows:</strong></td><td>$($SystemInfo.WindowsVersion) Build $($SystemInfo.BuildNumber)</td></tr>
                <tr><td><strong>Fecha de Auditoría:</strong></td><td>$($SystemInfo.Date)</td></tr>
            </table>
        </div>

        <div class="compliance-summary">
            <h3>Resumen de Cumplimiento</h3>
            <div class="progress-bar">
                <div class="progress-fill" style="width: $compliancePercentage%"></div>
            </div>
            <p><strong>Porcentaje de cumplimiento:</strong> <span class="status-completed">$compliancePercentage%</span></p>
            <table>
                <tr><td><strong>Total de controles:</strong></td><td>$($Analysis.TotalControls)</td></tr>
                <tr><td><strong>Controles cumplidos:</strong></td><td class="status-completed">$($Analysis.CompletedControls)</td></tr>
                <tr><td><strong>Controles faltantes:</strong></td><td class="status-missing">$($Analysis.MissingControls)</td></tr>
            </table>
        </div>

        <div class="evidence-section">
            <h3>Evidencia Recolectada</h3>
            <div class="evidence-grid">
"@

    foreach ($evidence in $Analysis.EvidenceCollected) {
        $htmlReport += @"
                <div class="evidence-item">
                    <h4>✓ $evidence</h4>
                    <p>Evidencia disponible en Google Drive</p>
                </div>
"@
    }

    foreach ($missing in $Analysis.MissingEvidence) {
        $htmlReport += @"
                <div class="evidence-item missing-item">
                    <h4>✗ $missing</h4>
                    <p>Evidencia no recolectada</p>
                </div>
"@
    }

    $htmlReport += @"
            </div>
        </div>

        <div class="evidence-section">
            <h3>Detalles de Evidencia</h3>
            <table>
                <thead>
                    <tr>
                        <th>Categoría</th>
                        <th>Estado</th>
                        <th>Archivos</th>
                        <th>Última Modificación</th>
                    </tr>
                </thead>
                <tbody>
"@

    foreach ($evidence in $Analysis.EvidenceCollected) {
        $folderPath = Join-Path $EvidencePath $evidence
        $files = Get-ChildItem -Path $folderPath -File
        $lastModified = $files | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty LastWriteTime
        
        $htmlReport += @"
                    <tr>
                        <td>$evidence</td>
                        <td class="status-completed">Completado</td>
                        <td>$($files.Count) archivos</td>
                        <td>$($lastModified.ToString('dd/MM/yyyy HH:mm'))</td>
                    </tr>
"@
    }

    foreach ($missing in $Analysis.MissingEvidence) {
        $htmlReport += @"
                    <tr>
                        <td>$missing</td>
                        <td class="status-missing">Pendiente</td>
                        <td>0 archivos</td>
                        <td>N/A</td>
                    </tr>
"@
    }

    $htmlReport += @"
                </tbody>
            </table>
        </div>

        <div class="evidence-section">
            <h3>Recomendaciones</h3>
            <ul>
                <li>Revisar controles faltantes y recolectar evidencia correspondiente</li>
                <li>Verificar configuración en Google Workspace Admin Console</li>
                <li>Documentar excepciones técnicas si aplica</li>
                <li>Establecer plan de remediación para controles no cumplidos</li>
                <li>Programar auditoría de seguimiento en 3 meses</li>
            </ul>
        </div>

        <div class="footer">
            <p><strong>Auditor:</strong> $AuditorName | <strong>Responsable del Sistema:</strong> $SystemOwner</p>
            <p>Reporte generado automáticamente por el Sistema de Auditoría de Seguridad</p>
            <p>Versión del script: 1.0 | Integración con Google Workspace</p>
        </div>
    </div>
</body>
</html>
"@

    $htmlPath = Join-Path $OutputPath "reporte_cumplimiento_final.html"
    $htmlReport | Out-File -FilePath $htmlPath -Encoding UTF8
    
    Write-Host "✓ Reporte HTML generado: $htmlPath" -ForegroundColor Green
    return $htmlPath
}

# Función para generar reporte PDF (requiere wkhtmltopdf)
function Generate-PDFReport {
    param(
        [string]$HtmlPath,
        [string]$OutputPath
    )
    
    $pdfPath = Join-Path $OutputPath "reporte_cumplimiento_final.pdf"
    
    # Verificar si wkhtmltopdf está disponible
    $wkhtmltopdf = Get-Command wkhtmltopdf -ErrorAction SilentlyContinue
    if ($wkhtmltopdf) {
        try {
            & wkhtmltopdf --page-size A4 --margin-top 20mm --margin-bottom 20mm --margin-left 20mm --margin-right 20mm $HtmlPath $pdfPath
            Write-Host "✓ Reporte PDF generado: $pdfPath" -ForegroundColor Green
            return $pdfPath
        }
        catch {
            Write-Host "⚠ Error al generar PDF: $($_.Exception.Message)" -ForegroundColor Yellow
            return $null
        }
    }
    else {
        Write-Host "⚠ wkhtmltopdf no encontrado. Solo se generó reporte HTML." -ForegroundColor Yellow
        return $null
    }
}

# Función para generar reporte de texto
function Generate-TextReport {
    param(
        [object]$SystemInfo,
        [object]$Analysis,
        [string]$OutputPath
    )
    
    $compliancePercentage = [math]::Round(($Analysis.CompletedControls / $Analysis.TotalControls) * 100, 2)
    
    $textReport = @"
REPORTE DE CUMPLIMIENTO - ESTACIÓN DE TRABAJO WINDOWS 10/11
Integración con Google Workspace
===============================================================

FECHA DE GENERACIÓN: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")

INFORMACIÓN DEL SISTEMA:
- Hostname: $($SystemInfo.Hostname)
- Dirección IP: $($SystemInfo.IPAddress)
- Usuario: $($SystemInfo.Username)
- Versión de Windows: $($SystemInfo.WindowsVersion) Build $($SystemInfo.BuildNumber)
- Fecha de Auditoría: $($SystemInfo.Date)

RESUMEN DE CUMPLIMIENTO:
- Total de controles: $($Analysis.TotalControls)
- Controles cumplidos: $($Analysis.CompletedControls)
- Controles faltantes: $($Analysis.MissingControls)
- Porcentaje de cumplimiento: $compliancePercentage%

EVIDENCIA RECOLECTADA:
"@

    foreach ($evidence in $Analysis.EvidenceCollected) {
        $textReport += "✓ $evidence`n"
    }

    $textReport += @"

EVIDENCIA FALTANTE:
"@

    foreach ($missing in $Analysis.MissingEvidence) {
        $textReport += "✗ $missing`n"
    }

    $textReport += @"

DETALLES DE EVIDENCIA:
"@

    foreach ($evidence in $Analysis.EvidenceCollected) {
        $folderPath = Join-Path $EvidencePath $evidence
        $files = Get-ChildItem -Path $folderPath -File
        $lastModified = $files | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty LastWriteTime
        
        $textReport += "- $evidence`: $($files.Count) archivos (Última modificación: $($lastModified.ToString('dd/MM/yyyy HH:mm')))`n"
    }

    $textReport += @"

RECOMENDACIONES:
1. Revisar controles faltantes y recolectar evidencia correspondiente
2. Verificar configuración en Google Workspace Admin Console
3. Documentar excepciones técnicas si aplica
4. Establecer plan de remediación para controles no cumplidos
5. Programar auditoría de seguimiento en 3 meses

FIRMAS:
Auditor: $AuditorName
Responsable del Sistema: $SystemOwner
Fecha: $(Get-Date -Format "dd/MM/yyyy")

---
Reporte generado automáticamente por el Sistema de Auditoría de Seguridad
Versión del script: 1.0 | Integración con Google Workspace
"@

    $textPath = Join-Path $OutputPath "reporte_cumplimiento_final.txt"
    $textReport | Out-File -FilePath $textPath -Encoding UTF8
    
    Write-Host "✓ Reporte de texto generado: $textPath" -ForegroundColor Green
    return $textPath
}

# Función para copiar reportes a Google Drive
function Copy-ReportsToGoogleDrive {
    param([string]$OutputPath, [string]$GoogleDrivePath)
    
    if ($UploadToDrive -and (Test-Path $GoogleDrivePath)) {
        Write-Host "Copiando reportes a Google Drive..." -ForegroundColor Yellow
        
        $reportsFolder = Join-Path $GoogleDrivePath "Reportes_Finales"
        if (!(Test-Path $reportsFolder)) {
            New-Item -Path $reportsFolder -ItemType Directory -Force | Out-Null
        }
        
        try {
            Copy-Item -Path "$OutputPath\*" -Destination $reportsFolder -Force
            Write-Host "✓ Reportes copiados a Google Drive: $reportsFolder" -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Error al copiar reportes a Google Drive: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Función principal
function Main {
    # Crear directorio de salida
    if (!(Test-Path $OutputPath)) {
        New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
    }
    
    Write-Host "Analizando evidencia recolectada..." -ForegroundColor Yellow
    
    # Obtener información del sistema
    $systemInfo = Get-SystemInfoFromEvidence
    
    # Analizar evidencia
    $analysis = Analyze-Evidence -EvidencePath $EvidencePath
    
    Write-Host "Generando reportes..." -ForegroundColor Yellow
    
    # Generar reportes
    $htmlPath = Generate-HTMLReport -SystemInfo $systemInfo -Analysis $analysis -OutputPath $OutputPath
    $textPath = Generate-TextReport -SystemInfo $systemInfo -Analysis $analysis -OutputPath $OutputPath
    $pdfPath = Generate-PDFReport -HtmlPath $htmlPath -OutputPath $OutputPath
    
    # Copiar a Google Drive si se solicita
    Copy-ReportsToGoogleDrive -OutputPath $OutputPath -GoogleDrivePath $GoogleDrivePath
    
    Write-Host "`n=== REPORTES GENERADOS ===" -ForegroundColor Cyan
    Write-Host "HTML: $htmlPath" -ForegroundColor Green
    Write-Host "Texto: $textPath" -ForegroundColor Green
    if ($pdfPath) {
        Write-Host "PDF: $pdfPath" -ForegroundColor Green
    }
    
    Write-Host "`nResumen de cumplimiento:" -ForegroundColor Yellow
    Write-Host "- Total de controles: $($analysis.TotalControls)" -ForegroundColor White
    Write-Host "- Controles cumplidos: $($analysis.CompletedControls)" -ForegroundColor Green
    Write-Host "- Controles faltantes: $($analysis.MissingControls)" -ForegroundColor Red
    Write-Host "- Porcentaje de cumplimiento: $([math]::Round(($analysis.CompletedControls / $analysis.TotalControls) * 100, 2))%" -ForegroundColor Cyan
    
    if ($analysis.MissingEvidence.Count -gt 0) {
        Write-Host "`nEvidencia faltante:" -ForegroundColor Yellow
        foreach ($missing in $analysis.MissingEvidence) {
            Write-Host "- $missing" -ForegroundColor Red
        }
    }
}

# Ejecutar función principal
Main 