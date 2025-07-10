# 🤝 Guía de Contribución

¡Gracias por tu interés en contribuir al proyecto CN-CERT Bastionado!

## 📋 Cómo Contribuir

### **1. Reportar Issues**

Si encuentras un bug o tienes una sugerencia:

1. **Busca si ya existe** un issue similar
2. **Crea un nuevo issue** con:
   - Título descriptivo
   - Descripción detallada del problema
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Información del sistema (Windows version, PowerShell version)

### **2. Proponer Mejoras**

Para nuevas funcionalidades:

1. **Crea un issue** con la etiqueta `enhancement`
2. **Describe la funcionalidad** que propones
3. **Explica el beneficio** para la comunidad
4. **Espera feedback** antes de implementar

### **3. Contribuir Código**

#### **Fork y Clone**
```bash
# Fork el repositorio en GitHub
# Luego clona tu fork
git clone https://github.com/tu-usuario/cn-cert-bastionado.git
cd cn-cert-bastionado

# Agrega el repositorio original como upstream
git remote add upstream https://github.com/original/cn-cert-bastionado.git
```

#### **Crear una Rama**
```bash
# Crea una rama para tu feature
git checkout -b feature/nueva-funcionalidad

# O para un bug fix
git checkout -b fix/nombre-del-bug
```

#### **Desarrollar**
- **Sigue las convenciones** de código existentes
- **Documenta** tu código
- **Prueba** tu funcionalidad
- **Mantén** la compatibilidad con CN-CERT

#### **Commit y Push**
```bash
# Agrega tus cambios
git add .

# Commit con mensaje descriptivo
git commit -m "feat: agregar nueva funcionalidad de verificación"

# Push a tu fork
git push origin feature/nueva-funcionalidad
```

#### **Crear Pull Request**
1. Ve a tu fork en GitHub
2. Crea un Pull Request
3. **Describe** los cambios realizados
4. **Menciona** el issue relacionado
5. **Espera** la revisión

## 📝 Convenciones de Código

### **PowerShell**
```powershell
# Usar camelCase para variables
$systemName = "PC-001"

# Usar Verb-Noun para funciones
function Get-SecurityEvidence {
    param(
        [Parameter(Mandatory=$true)]
        [string]$OutputPath
    )
    # Código aquí
}

# Comentarios descriptivos
# Verificar estado de Windows Defender
$defenderStatus = Get-MpComputerStatus
```

### **Markdown**
```markdown
# Títulos principales
## Subtítulos
### Sub-subtítulos

# Listas
- ✅ Elemento completado
- ⏳ Elemento pendiente
- ❌ Elemento con error

# Código
```powershell
Get-Command -Name "Get-*"
```
```

### **Mensajes de Commit**
```
feat: nueva funcionalidad
fix: corrección de bug
docs: actualización de documentación
style: cambios de formato
refactor: refactorización de código
test: agregar o modificar tests
chore: tareas de mantenimiento
```

## 🧪 Testing

### **Antes de Contribuir**
1. **Prueba** tu código en diferentes versiones de Windows
2. **Verifica** que no rompe funcionalidades existentes
3. **Documenta** los casos de prueba

### **Entorno de Prueba**
- Windows 10 (versión 1909 o superior)
- Windows 11
- PowerShell 5.1 o superior
- Permisos de administrador

## 📚 Documentación

### **Actualizar Documentación**
- **README.md**: Para cambios importantes
- **Guías**: Para nuevas funcionalidades
- **Checklists**: Para nuevos controles
- **Comentarios**: En el código

### **Formato de Documentación**
- Usar Markdown
- Incluir ejemplos de uso
- Mantener consistencia con el estilo existente
- Agregar capturas de pantalla cuando sea necesario

## 🔒 Seguridad

### **Directrices Importantes**
- **NO incluir** información sensible
- **NO incluir** credenciales o claves
- **NO incluir** datos de producción
- **Verificar** que el código es seguro

### **Revisión de Seguridad**
- Todo el código será revisado por seguridad
- Los scripts deben ser seguros para ejecutar
- No debe exponer información del sistema

## 🏷️ Etiquetas de Issues

- `bug`: Error o problema
- `enhancement`: Nueva funcionalidad
- `documentation`: Mejoras en documentación
- `help wanted`: Necesita ayuda
- `good first issue`: Bueno para principiantes
- `security`: Problemas de seguridad
- `windows`: Específico de Windows
- `linux`: Específico de Linux

## 📞 Comunicación

### **Canal de Comunicación**
- **Issues**: Para reportar problemas
- **Discussions**: Para preguntas y debates
- **Pull Requests**: Para código

### **Código de Conducta**
- Sé respetuoso con otros contribuidores
- Mantén un ambiente inclusivo
- Ayuda a otros cuando puedas
- Acepta críticas constructivas

## 🎯 Áreas de Contribución

### **Prioridad Alta**
- Mejoras en scripts de automatización
- Nuevos checklists para diferentes sistemas
- Corrección de bugs en scripts existentes
- Mejoras en documentación

### **Prioridad Media**
- Nuevas guías de bastionado
- Mejoras en plantillas de evidencias
- Optimización de scripts
- Traducciones

### **Prioridad Baja**
- Mejoras cosméticas
- Refactorización de código
- Nuevas características experimentales

## 🙏 Reconocimiento

Todas las contribuciones serán reconocidas en:
- **README.md**: Lista de contribuidores
- **Releases**: Notas de la versión
- **Documentación**: Créditos donde corresponda

---

**¡Gracias por contribuir a hacer la seguridad más accesible para todos!** 