# 🚀 Descarga Rápida - CN-CERT Bastionado

## 📥 **PASO 1: Descargar el Proyecto**

### **Opción A: Usando Git (Recomendado)**
```powershell
# Clonar el repositorio
git clone https://github.com/TU-USUARIO/cn-cert-bastionado.git
cd cn-cert-bastionado
```

### **Opción B: Descarga Directa**
1. Ve a: `https://github.com/TU-USUARIO/cn-cert-bastionado`
2. Haz clic en el botón verde "Code"
3. Selecciona "Download ZIP"
4. Extrae el archivo ZIP en tu PC

## ⚡ **PASO 2: Instalación Automática**

```powershell
# Ejecutar instalación automática
.\install.ps1

# O especificar directorio personalizado
.\install.ps1 -InstallPath "D:\mi-bastionado"
```

## 🎯 **PASO 3: Ejecutar Auditoría**

```powershell
# Navegar al directorio de instalación
cd C:\cn-cert-bastionado

# Ejecutar auditoría completa
.\ejecutar-auditoria.ps1 -SystemName "PC-001" -AuditorName "Tu Nombre" -IncludeScreenshots

# O ejecutar desde scripts directamente
cd scripts
.\Get-SecurityEvidence.ps1 -OutputPath "C:\evidencias" -SystemName "PC-001" -AuditorName "Tu Nombre" -IncludeScreenshots
```

## 📋 **¿Qué Incluye?**

### **Scripts Principales:**
- ✅ `Get-SecurityEvidence.ps1` - Auditoría completa
- ✅ `Get-CNCertEvidence.ps1` - Específico CN-CERT
- ✅ `Get-LinuxSecurityEvidence.sh` - Para Linux

### **Documentación:**
- ✅ Guías de bastionado Windows 10/11
- ✅ Checklists específicos
- ✅ Procedimientos operativos

### **Evidencias Generadas:**
- 📸 Capturas de pantalla automáticas
- 📊 Reportes de configuración
- 📋 Logs del sistema
- 📄 Resumen ejecutivo
- 📦 Archivo ZIP con todo

## 🔧 **Configuración Requerida**

### **PowerShell:**
```powershell
# Permitir ejecución de scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### **Permisos:**
- ⚠️ **Recomendado:** Ejecutar como Administrador
- ✅ **Mínimo:** Usuario estándar (algunas verificaciones limitadas)

## 📁 **Estructura de Directorios**

```
cn-cert-bastionado/
├── scripts/                    # Scripts de automatización
├── guias-bastionado/          # Documentación técnica
├── checklists/                # Checklists específicos
├── procedimientos/            # Procedimientos operativos
├── evidencias/                # Evidencias generadas
│   ├── capturas-pantalla/     # Screenshots automáticos
│   ├── reportes/              # Reportes de configuración
│   ├── logs/                  # Logs del sistema
│   └── checklists/            # Checklists completados
└── install.ps1                # Instalador automático
```

## 🚨 **Solución de Problemas**

### **Error: "No se puede cargar el archivo"**
```powershell
# Verificar política de ejecución
Get-ExecutionPolicy -List

# Configurar política
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### **Error: "Acceso denegado"**
- Ejecutar PowerShell como Administrador
- Verificar permisos de escritura en el directorio

### **Error: "Git no encontrado"**
- Descargar Git desde: https://git-scm.com/
- O usar descarga directa (Opción B)

## 📞 **Soporte**

- **Issues:** Reporta problemas en GitHub
- **Documentación:** Revisa README.md completo
- **Ejemplos:** Consulta la carpeta `ejemplos/`

---

**⭐ ¡Dale una estrella al repositorio si te es útil!** 