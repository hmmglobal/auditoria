# Script para Subir Proyecto a GitHub - CN-CERT Bastionado
# Autor: Equipo de Seguridad
# Versión: 1.0

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$true)]
    [string]$RepositoryName,
    
    [Parameter(Mandatory=$false)]
    [string]$Description = "Herramientas y documentación para bastionado de sistemas según estándares CN-CERT",
    
    [switch]$Public,
    [switch]$Force
)

Write-Host "=== SUBIR PROYECTO A GITHUB - CN-CERT BASTIONADO ===" -ForegroundColor Green
Write-Host ""

# Verificar que Git esté instalado
Write-Host "🔍 Verificando Git..." -ForegroundColor Cyan
try {
    $gitVersion = git --version
    Write-Host "✅ Git instalado: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Git no está instalado." -ForegroundColor Red
    Write-Host "   Descarga Git desde: https://git-scm.com/" -ForegroundColor Yellow
    exit 1
}

# Verificar que estamos en el directorio correcto
Write-Host "📁 Verificando directorio actual..." -ForegroundColor Cyan
$currentDir = Get-Location
Write-Host "   Directorio actual: $currentDir" -ForegroundColor White

# Verificar que existe el README.md
if (-not (Test-Path "README.md")) {
    Write-Host "❌ Error: README.md no encontrado en el directorio actual." -ForegroundColor Red
    Write-Host "   Asegúrate de estar en el directorio raíz del proyecto." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Estructura del proyecto verificada" -ForegroundColor Green
Write-Host ""

# Verificar si ya es un repositorio Git
Write-Host "🔍 Verificando estado del repositorio..." -ForegroundColor Cyan
if (Test-Path ".git") {
    Write-Host "✅ Ya es un repositorio Git" -ForegroundColor Green
    
    # Verificar si ya tiene un remote
    $remotes = git remote -v
    if ($remotes) {
        Write-Host "⚠️  El repositorio ya tiene remotes configurados:" -ForegroundColor Yellow
        Write-Host $remotes -ForegroundColor White
        
        if (-not $Force) {
            Write-Host "❌ Usa -Force para sobrescribir la configuración existente" -ForegroundColor Red
            exit 1
        } else {
            Write-Host "🔄 Sobrescribiendo configuración existente..." -ForegroundColor Yellow
            git remote remove origin 2>$null
        }
    }
} else {
    Write-Host "🔄 Inicializando repositorio Git..." -ForegroundColor Cyan
    git init
    Write-Host "✅ Repositorio Git inicializado" -ForegroundColor Green
}

# Configurar usuario Git si no está configurado
Write-Host "👤 Configurando usuario Git..." -ForegroundColor Cyan
$userName = git config --global user.name
$userEmail = git config --global user.email

if (-not $userName) {
    Write-Host "⚠️  Usuario Git no configurado. Configurando..." -ForegroundColor Yellow
    $inputName = Read-Host "Ingresa tu nombre completo"
    git config --global user.name $inputName
}

if (-not $userEmail) {
    Write-Host "⚠️  Email Git no configurado. Configurando..." -ForegroundColor Yellow
    $inputEmail = Read-Host "Ingresa tu email"
    git config --global user.email $inputEmail
}

Write-Host "✅ Usuario Git configurado" -ForegroundColor Green
Write-Host ""

# Crear repositorio en GitHub usando GitHub CLI o instrucciones manuales
Write-Host "🌐 Creando repositorio en GitHub..." -ForegroundColor Cyan

# Verificar si GitHub CLI está instalado
try {
    $ghVersion = gh --version
    Write-Host "✅ GitHub CLI instalado: $ghVersion" -ForegroundColor Green
    
    # Verificar si está autenticado
    $authStatus = gh auth status 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ GitHub CLI autenticado" -ForegroundColor Green
        
        # Crear repositorio
        $visibility = if ($Public) { "public" } else { "private" }
        Write-Host "🔄 Creando repositorio '$RepositoryName' ($visibility)..." -ForegroundColor Cyan
        
        $createResult = gh repo create $RepositoryName --description $Description --$visibility --source=. --remote=origin --push 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Repositorio creado exitosamente en GitHub" -ForegroundColor Green
            $repoUrl = "https://github.com/$GitHubUsername/$RepositoryName"
            Write-Host "🔗 URL del repositorio: $repoUrl" -ForegroundColor Green
        } else {
            Write-Host "❌ Error creando repositorio: $createResult" -ForegroundColor Red
            Write-Host "🔄 Continuando con configuración manual..." -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠️  GitHub CLI no autenticado. Configurando..." -ForegroundColor Yellow
        Write-Host "   Ejecuta: gh auth login" -ForegroundColor White
        Write-Host "🔄 Continuando con configuración manual..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  GitHub CLI no instalado. Usando configuración manual..." -ForegroundColor Yellow
}

# Si no se pudo crear automáticamente, dar instrucciones manuales
if (-not $repoUrl) {
    Write-Host ""
    Write-Host "📋 INSTRUCCIONES MANUALES PARA CREAR REPOSITORIO:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Ve a https://github.com/new" -ForegroundColor White
    Write-Host "2. Nombre del repositorio: $RepositoryName" -ForegroundColor White
    Write-Host "3. Descripción: $Description" -ForegroundColor White
    Write-Host "4. Visibilidad: $(if ($Public) { 'Público' } else { 'Privado' })" -ForegroundColor White
    Write-Host "5. NO inicialices con README (ya tenemos uno)" -ForegroundColor White
    Write-Host "6. Haz clic en 'Create repository'" -ForegroundColor White
    Write-Host ""
    
    $continue = Read-Host "¿Ya creaste el repositorio? (s/n)"
    if ($continue -ne "s" -and $continue -ne "S") {
        Write-Host "❌ Operación cancelada" -ForegroundColor Red
        exit 1
    }
    
    $repoUrl = "https://github.com/$GitHubUsername/$RepositoryName"
}

# Configurar remote
Write-Host "🔗 Configurando remote..." -ForegroundColor Cyan
git remote add origin $repoUrl
Write-Host "✅ Remote configurado: $repoUrl" -ForegroundColor Green

# Agregar todos los archivos
Write-Host "📁 Agregando archivos al repositorio..." -ForegroundColor Cyan
git add .

# Verificar qué archivos se van a subir
Write-Host "📋 Archivos que se van a subir:" -ForegroundColor Cyan
git status --porcelain | ForEach-Object {
    $status = $_.Substring(0, 2)
    $file = $_.Substring(3)
    Write-Host "   $status $file" -ForegroundColor White
}

Write-Host ""

# Confirmar antes de hacer commit
$confirm = Read-Host "¿Continuar con el commit y push? (s/n)"
if ($confirm -ne "s" -and $confirm -ne "S") {
    Write-Host "❌ Operación cancelada" -ForegroundColor Red
    exit 1
}

# Hacer commit inicial
Write-Host "💾 Haciendo commit inicial..." -ForegroundColor Cyan
$commitMessage = @"
Initial commit: CN-CERT Bastionado tools and documentation

- Scripts de automatizacion para recoleccion de evidencias
- Guias de bastionado para Windows 10/11
- Checklists especificos para auditorias CN-CERT
- Documentacion y procedimientos operativos
- Scripts de instalacion y configuracion rapida

Herramientas desarrolladas para facilitar el proceso de auditoria
y bastionado de sistemas segun estandares CN-CERT.
"@

git commit -m $commitMessage

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Commit realizado exitosamente" -ForegroundColor Green
} else {
    Write-Host "❌ Error al hacer commit" -ForegroundColor Red
    exit 1
}

# Hacer push al repositorio
Write-Host "🚀 Subiendo al repositorio..." -ForegroundColor Cyan
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Push realizado exitosamente" -ForegroundColor Green
} else {
    # Intentar con master si main falla
    Write-Host "🔄 Intentando con rama 'master'..." -ForegroundColor Yellow
    git push -u origin master
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Push realizado exitosamente en rama 'master'" -ForegroundColor Green
    } else {
        Write-Host "❌ Error al hacer push" -ForegroundColor Red
        Write-Host "   Verifica tu conexión a internet y permisos del repositorio" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "=== PROYECTO SUBIDO EXITOSAMENTE ===" -ForegroundColor Green
Write-Host "🎉 ¡Tu proyecto está ahora disponible en GitHub!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 URL del repositorio: $repoUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "📥 Para descargar en otra PC:" -ForegroundColor Yellow
Write-Host "   git clone $repoUrl" -ForegroundColor White
Write-Host "   cd $RepositoryName" -ForegroundColor White
Write-Host "   .\install.ps1" -ForegroundColor White
Write-Host ""
Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
Write-Host "   1. Verifica que todo se subió correctamente" -ForegroundColor White
Write-Host "   2. Configura GitHub Pages si quieres documentación web" -ForegroundColor White
Write-Host "   3. Invita colaboradores si es necesario" -ForegroundColor White
Write-Host "   4. Configura GitHub Actions para CI/CD" -ForegroundColor White
Write-Host ""
Write-Host "✅ ¡Listo para usar en cualquier PC!" -ForegroundColor Green 