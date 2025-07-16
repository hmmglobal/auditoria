# Configuración de Auditoría en Google Workspace

## Descripción General

Las configuraciones de auditoría para estaciones de trabajo Windows se gestionan principalmente a través de Google Workspace, ya que proporciona un control centralizado y reportes consolidados de eventos de seguridad.

## 5.1 Eventos de Windows

### Configuración en Google Workspace

#### 1. Acceso a la Consola de Administración
- Ir a [admin.google.com](https://admin.google.com)
- Iniciar sesión con cuenta de administrador
- Navegar a **Seguridad** > **Centro de seguridad**

#### 2. Configuración de Auditoría de Eventos

**Ubicación:** Seguridad > Centro de seguridad > Auditoría

**Configuraciones a aplicar:**

##### Auditoría de Inicios de Sesión
- **Evento ID 4624:** Inicios de sesión exitosos
- **Evento ID 4625:** Inicios de sesión fallidos
- **Configuración:** Habilitar auditoría de éxito y fallo
- **Retención:** 90 días mínimo

##### Auditoría de Cambios de Contraseña
- **Evento ID 4723:** Cambios de contraseña
- **Evento ID 4724:** Restablecimiento de contraseña
- **Configuración:** Habilitar auditoría de éxito

##### Auditoría de Gestión de Usuarios
- **Evento ID 4720:** Creación de cuenta de usuario
- **Evento ID 4722:** Habilitación de cuenta de usuario
- **Evento ID 4725:** Deshabilitación de cuenta de usuario
- **Evento ID 4726:** Eliminación de cuenta de usuario
- **Configuración:** Habilitar auditoría de éxito y fallo

##### Auditoría de Acceso a Archivos Sensibles
- **Evento ID 4663:** Acceso a objeto
- **Evento ID 4660:** Eliminación de objeto
- **Configuración:** Habilitar auditoría de éxito y fallo para archivos críticos

##### Auditoría de Cambios de Configuración
- **Evento ID 4719:** Cambios en política de auditoría del sistema
- **Evento ID 4738:** Cambios en política de contraseñas
- **Configuración:** Habilitar auditoría de éxito y fallo

#### 3. Configuración de Alertas

**Ubicación:** Seguridad > Centro de seguridad > Alertas

**Alertas a configurar:**
- Múltiples intentos de inicio de sesión fallidos
- Creación de cuentas de usuario no autorizadas
- Cambios en políticas de seguridad
- Acceso a archivos sensibles fuera de horario

## 5.2 Configuración de Logs

### Configuración en Google Workspace

#### 1. Configuración de Retención de Logs

**Ubicación:** Seguridad > Centro de seguridad > Configuración de logs

**Configuraciones:**
- **Tamaño máximo de logs:** 1GB por log
- **Retención:** 90 días mínimo
- **Compresión:** Habilitada después de 7 días
- **Archivado:** Automático a Google Cloud Storage

#### 2. Configuración de Envío a SIEM

**Ubicación:** Seguridad > Centro de seguridad > Integraciones

**Configuraciones:**
- **SIEM habilitado:** Sí
- **Formato de envío:** JSON
- **Frecuencia:** Tiempo real
- **Filtros:** Todos los eventos de seguridad

#### 3. Configuración de Logs Específicos

##### Log de Seguridad
- **Tamaño máximo:** 1GB
- **Retención:** 90 días
- **Eventos críticos:** Retención extendida a 1 año

##### Log de Aplicación
- **Tamaño máximo:** 512MB
- **Retención:** 30 días
- **Filtros:** Solo eventos de aplicaciones críticas

##### Log del Sistema
- **Tamaño máximo:** 1GB
- **Retención:** 60 días
- **Eventos de error:** Retención extendida a 90 días

## Configuración de Políticas de Grupo

### Políticas a Aplicar

#### 1. Política de Auditoría Base
```json
{
  "auditPolicy": {
    "logonEvents": {
      "success": true,
      "failure": true
    },
    "credentialValidation": {
      "success": true,
      "failure": true
    },
    "userAccountManagement": {
      "success": true,
      "failure": true
    },
    "fileSystem": {
      "success": false,
      "failure": true
    },
    "securityStateChange": {
      "success": true,
      "failure": true
    }
  }
}
```

#### 2. Política de Configuración de Logs
```json
{
  "logConfiguration": {
    "securityLog": {
      "maxSize": "1073741824",
      "retention": "7776000",
      "compression": true
    },
    "applicationLog": {
      "maxSize": "536870912",
      "retention": "2592000",
      "compression": true
    },
    "systemLog": {
      "maxSize": "1073741824",
      "retention": "5184000",
      "compression": true
    }
  }
}
```

## Verificación y Monitoreo

### 1. Reportes de Auditoría

**Ubicación:** Seguridad > Centro de seguridad > Reportes

**Reportes disponibles:**
- Actividad de inicio de sesión
- Cambios de configuración de seguridad
- Gestión de usuarios
- Acceso a archivos sensibles
- Eventos de seguridad críticos

### 2. Dashboard de Monitoreo

**Ubicación:** Seguridad > Centro de seguridad > Dashboard

**Métricas a monitorear:**
- Eventos de seguridad por día
- Intentos de inicio de sesión fallidos
- Cambios de configuración
- Alertas activas
- Estado de logs

### 3. Alertas Automáticas

**Configuración de alertas:**
- **Frecuencia:** Tiempo real
- **Canal:** Email y notificaciones push
- **Escalación:** Automática después de 1 hora sin respuesta

## Comandos de Verificación Local

### Verificación de Políticas de Auditoría
```powershell
# Verificar políticas de auditoría actuales
auditpol /get /category:*

# Verificar auditoría de inicios de sesión
auditpol /get /subcategory:"Logon"

# Verificar auditoría de cambios de contraseña
auditpol /get /subcategory:"Credential Validation"
```

### Verificación de Configuración de Logs
```powershell
# Verificar configuración del log de seguridad
wevtutil gl Security

# Verificar eventos recientes
Get-WinEvent -LogName Security -MaxEvents 10

# Verificar eventos de inicio de sesión
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} -MaxEvents 5
```

## Evidencias Requeridas

### 1. Capturas de Pantalla
- Configuración de auditoría en Google Workspace
- Políticas de retención de logs
- Configuración de alertas
- Dashboard de monitoreo

### 2. Reportes Exportados
- Reporte de políticas de auditoría
- Reporte de configuración de logs
- Reporte de eventos de seguridad (últimos 30 días)
- Reporte de alertas activas

### 3. Archivos de Configuración
- Exportación de políticas de auditoría
- Configuración de retención de logs
- Configuración de alertas

## Notas Importantes

1. **Centralización:** Todas las configuraciones de auditoría se manejan desde Google Workspace para mantener consistencia.

2. **Retención:** Los logs se retienen por 90 días mínimo, con eventos críticos retenidos por 1 año.

3. **Monitoreo:** Se configuran alertas automáticas para eventos críticos de seguridad.

4. **Verificación:** Los scripts locales solo verifican el estado actual, no modifican configuraciones.

5. **Cumplimiento:** Esta configuración cumple con los requisitos de auditoría para estaciones de trabajo Windows.

## Contacto y Soporte

Para problemas con la configuración de auditoría:
- **Soporte técnico:** [soporte@empresa.com](mailto:soporte@empresa.com)
- **Documentación:** [docs.empresa.com/auditoria](https://docs.empresa.com/auditoria)
- **Emergencias:** +1-800-AUDITORIA

---

**Última actualización:** $(Get-Date -Format "yyyy-MM-dd")  
**Versión:** 1.0  
**Responsable:** Equipo de Seguridad 