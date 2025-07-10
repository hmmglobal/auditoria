# Script para Corregir Caracteres Especiales en Scripts
# Autor: Equipo de Seguridad
# Version: 1.0

Write-Host "=== CORRIGIENDO CARACTERES ESPECIALES EN SCRIPTS ===" -ForegroundColor Green
Write-Host ""

# Definir el mapeo de caracteres especiales
$characterMap = @{
    'á' = 'a'
    'é' = 'e'
    'í' = 'i'
    'ó' = 'o'
    'ú' = 'u'
    'ñ' = 'n'
    'ü' = 'u'
    '¿' = '?'
    '¡' = '!'
}

# Función para corregir caracteres en un archivo
function Fix-SpecialCharacters {
    param(
        [string]$FilePath
    )
    
    Write-Host "Corrigiendo: $FilePath" -ForegroundColor Cyan
    
    try {
        # Leer el contenido del archivo
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        
        # Aplicar correcciones
        foreach ($special in $characterMap.Keys) {
            $normal = $characterMap[$special]
            $content = $content -replace $special, $normal
        }
        
        # Guardar el archivo corregido
        $content | Out-File -FilePath $FilePath -Encoding UTF8 -NoNewline
        
        Write-Host "  ✅ Corregido" -ForegroundColor Green
    }
    catch {
        Write-Host "  ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Corregir scripts en el directorio scripts
$scriptsPath = "scripts"
if (Test-Path $scriptsPath) {
    Write-Host "Corrigiendo scripts en: $scriptsPath" -ForegroundColor Yellow
    
    $scriptFiles = Get-ChildItem -Path $scriptsPath -Filter "*.ps1" -Recurse
    foreach ($file in $scriptFiles) {
        Fix-SpecialCharacters -FilePath $file.FullName
    }
    
    $scriptFiles = Get-ChildItem -Path $scriptsPath -Filter "*.sh" -Recurse
    foreach ($file in $scriptFiles) {
        Fix-SpecialCharacters -FilePath $file.FullName
    }
}

# Corregir archivos principales
$mainFiles = @(
    "install.ps1",
    "install-simple.ps1",
    "subir-github.ps1",
    "README.md",
    "README-GITHUB.md",
    "DESCARGA-RAPIDA.md"
)

Write-Host ""
Write-Host "Corrigiendo archivos principales:" -ForegroundColor Yellow

foreach ($file in $mainFiles) {
    if (Test-Path $file) {
        Fix-SpecialCharacters -FilePath $file
    } else {
        Write-Host "  ⚠️  No encontrado: $file" -ForegroundColor Yellow
    }
}

# Corregir archivos en subdirectorios
$subdirs = @(
    "guias-bastionado",
    "checklists",
    "procedimientos"
)

foreach ($dir in $subdirs) {
    if (Test-Path $dir) {
        Write-Host ""
        Write-Host "Corrigiendo archivos en: $dir" -ForegroundColor Yellow
        
        $files = Get-ChildItem -Path $dir -Filter "*.md" -Recurse
        foreach ($file in $files) {
            Fix-SpecialCharacters -FilePath $file.FullName
        }
    }
}

Write-Host ""
Write-Host "=== CORRECCIÓN COMPLETADA ===" -ForegroundColor Green
Write-Host "Todos los caracteres especiales han sido corregidos." -ForegroundColor Green
Write-Host ""
Write-Host "Ahora puedes ejecutar los scripts sin problemas de codificación." -ForegroundColor Cyan 