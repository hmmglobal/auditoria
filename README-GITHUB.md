# 🛡️ CN-CERT Bastionado - Herramientas y Documentación

## 📥 Descarga Rápida

### **Para Usar en tu PC:**

```powershell
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/cn-cert-bastionado.git
cd cn-cert-bastionado

# 2. Configurar PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 3. Ejecutar auditoría básica
cd scripts
.\Get-SecurityEvidence.ps1 -OutputPath "C:\evidencias" -SystemName "PC-001" -AuditorName "Tu Nombre" -IncludeScreenshots
```

## 🎯 ¿Qué Incluye?

### **Scripts de Automatización:**
- ✅ `Get-SecurityEvidence.ps1` - Recolección completa de evidencias
- ✅ `Get-LinuxSecurityEvidence.sh` - Para sistemas Linux
- ✅ `Get-CNCertEvidence.ps1` - Específico para CN-CERT

### **Documentación:**
- ✅ Guías de bastionado
- ✅ Checklists específicos
- ✅ Plantillas de evidencias
- ✅ Procedimientos operativos

### **Checklists:**
- ✅ Checklist para Windows 10/11
- ✅ Checklist específico CN-CERT Op.exp.2
- ✅ Plantillas de auditoría

## 🚀 Uso Inmediato

### **Ejecutar Auditoría Completa:**
```powershell
# Navegar a scripts
cd scripts

# Ejecutar con todas las opciones
.\Get-SecurityEvidence.ps1 -OutputPath "C:\evidencias" -SystemName "PC-001" -AuditorName "Juan Pérez" -IncludeScreenshots -IncludeLogs
```

### **Ejecutar Solo Verificación:**
```powershell
# Solo verificar sin capturas
.\Get-SecurityEvidence.ps1 -OutputPath "C:\evidencias" -SystemName "PC-001" -AuditorName "Juan Pérez"
```

## 📋 Evidencias Generadas

El script generará automáticamente:
- 📸 Capturas de pantalla de configuraciones
- 📊 Reportes de configuración
- 📋 Logs del sistema
- 📄 Resumen de auditoría
- 📦 Archivo ZIP con todas las evidencias

## ⚠️ Importante

- **Este repositorio NO incluye** scripts oficiales de CN-CERT
- **Para auditorías reales** descarga la documentación oficial desde CN-CERT
- **Los scripts son seguros** y solo recolectan información de configuración

## 📞 Soporte

- **Issues**: Reporta problemas en GitHub
- **Wiki**: Consulta la documentación detallada
- **Discussions**: Preguntas y debates

---

**⭐ ¡Dale una estrella si te es útil!** 