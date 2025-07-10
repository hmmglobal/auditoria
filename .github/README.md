# 🛡️ CN-CERT Bastionado - Documentación y Herramientas

## 📋 Descripción

Este repositorio contiene documentación, checklists y herramientas para implementar el bastionado de sistemas según los estándares CN-CERT (Centro Criptológico Nacional - STIC), específicamente para la auditoría **Op.exp.2 - Configuración de Seguridad**.

## 🎯 Objetivo

Proporcionar una estructura completa y herramientas de automatización para:
- ✅ Implementar bastionado de sistemas Windows
- ✅ Cumplir con estándares CN-CERT
- ✅ Generar evidencias de auditoría
- ✅ Automatizar verificaciones de seguridad

## 📁 Estructura del Proyecto

```
├── 📖 README.md                           # Este archivo
├── 📋 guias-bastionado/                   # Guías de bastionado
│   ├── guia-general-bastionado.md
│   └── estaciones-trabajo/
│       └── guia-windows-10-11.md
├── ✅ checklists/                         # Listas de comprobación
│   └── checklist-windows-estaciones-trabajo.md
├── 🔧 scripts/                           # Scripts de automatización
│   ├── Get-SecurityEvidence.ps1
│   ├── Get-LinuxSecurityEvidence.sh
│   └── Get-CNCertEvidence.ps1
├── 📊 evidencias/                        # Plantillas de evidencias
│   └── plantilla-evidencia-auditoria.md
├── 📋 auditoria-cn-cert/                 # Documentación específica CN-CERT
│   ├── op-exp-2-configuracion-seguridad.md
│   └── checklist-op-exp-2.md
├── 📋 procedimientos/                    # Procedimientos operativos
│   └── procedimiento-auditoria-cn-cert.md
└── 📄 RESUMEN-EJECUTIVO-CN-CERT.md      # Resumen ejecutivo
```

## 🚀 Uso Rápido

### **Requisitos Previos**
- Windows 10/11
- PowerShell 5.1 o superior
- Permisos de administrador

### **Instalación**
```powershell
# Clonar el repositorio
git clone https://github.com/tu-usuario/cn-cert-bastionado.git
cd cn-cert-bastionado

# Configurar PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### **Ejecutar Auditoría Básica**
```powershell
# Navegar a scripts
cd scripts

# Ejecutar recolección de evidencias
.\Get-SecurityEvidence.ps1 -OutputPath "C:\evidencias" -SystemName "PC-001" -AuditorName "Tu Nombre" -IncludeScreenshots
```

## 📋 Aspectos Cubiertos (Op.exp.2 CN-CERT)

### **1. Configuración de Seguridad Previa a Producción**
- ✅ Guías de bastionado documentadas
- ✅ Procedimientos operativos establecidos
- ✅ Scripts de automatización disponibles

### **2. Eliminación de Cuentas y Contraseñas Estándar**
- ✅ Políticas de contraseñas configuradas
- ✅ Cuentas por defecto eliminadas
- ✅ Configuración de complejidad implementada

### **3. Mínima Funcionalidad**
- ✅ Servicios innecesarios deshabilitados
- ✅ Puertos innecesarios cerrados
- ✅ Aplicaciones no autorizadas removidas

### **4. Seguridad por Defecto**
- ✅ Windows Defender habilitado
- ✅ Firewall de Windows configurado
- ✅ UAC habilitado
- ✅ SmartScreen activado

### **5. Gestión de Máquinas Virtuales**
- ✅ Procedimientos específicos para VMs
- ✅ Configuración de máquina anfitriona
- ✅ Gestión de parches para VMs

## 🔧 Scripts Disponibles

### **Get-SecurityEvidence.ps1**
Script principal para recolección de evidencias en Windows.

**Parámetros:**
- `-OutputPath`: Directorio de salida
- `-SystemName`: Nombre del sistema
- `-AuditorName`: Nombre del auditor
- `-IncludeScreenshots`: Incluir capturas de pantalla
- `-IncludeLogs`: Incluir logs del sistema

### **Get-LinuxSecurityEvidence.sh**
Script para recolección de evidencias en sistemas Linux.

### **Get-CNCertEvidence.ps1**
Script específico para auditorías CN-CERT.

## 📊 Checklists Disponibles

### **checklist-windows-estaciones-trabajo.md**
Checklist completo para estaciones de trabajo Windows 10/11 con:
- ✅ 10 secciones principales de verificación
- ✅ Comandos de verificación específicos
- ✅ Espacios para evidencias
- ✅ Sección de observaciones del auditor

### **checklist-op-exp-2.md**
Checklist específico para auditoría CN-CERT Op.exp.2.

## 📖 Guías Disponibles

### **guia-general-bastionado.md**
Guía general que establece principios y mejores prácticas para el bastionado.

### **guia-windows-10-11.md**
Guía específica para estaciones de trabajo Windows 10/11.

## 🔒 Seguridad

### **⚠️ Importante**
- Este repositorio contiene **documentación y herramientas de ejemplo**
- **NO incluye** scripts oficiales de CN-CERT (por restricciones de copyright)
- **NO incluye** el PDF oficial de CN-CERT
- Para auditorías reales, descarga la documentación oficial desde CN-CERT

### **📋 Para Auditorías Reales**
1. Descarga la documentación oficial de CN-CERT
2. Obtén los scripts oficiales desde CN-CERT
3. Adapta esta documentación a los estándares oficiales
4. Valida con tu auditor CN-CERT

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## ⚠️ Descargo de Responsabilidad

Este repositorio es proporcionado "tal como está" sin garantías. Es responsabilidad del usuario:
- Verificar la compatibilidad con sus sistemas
- Validar con auditores oficiales
- Obtener documentación oficial de CN-CERT
- Cumplir con todas las regulaciones aplicables

## 📞 Contacto

- **Issues**: Usa la sección de Issues de GitHub
- **Discusiones**: Usa la sección de Discussions de GitHub
- **Wiki**: Consulta la Wiki del proyecto para más información

## 🙏 Agradecimientos

- CN-CERT por los estándares de seguridad
- Comunidad de seguridad por las mejores prácticas
- Contribuidores del proyecto

---

**⭐ Si este proyecto te es útil, por favor dale una estrella en GitHub!** 