# Guía de Bastionado - Estaciones de Trabajo Windows 10/11

## Objetivo
Esta guía establece los controles de seguridad específicos para el bastionado de estaciones de trabajo Windows 10/11 en cumplimiento con los estándares CN-CERT.

## Alcance
Aplica a todas las estaciones de trabajo Windows 10 y Windows 11 de la organización.

## Configuraciones de Sistema Operativo

### 1. Políticas de Contraseñas
```
Configuración GPO requerida:
- Longitud mínima: 12 caracteres
- Complejidad: Habilitada
- Historial: 24 contraseñas
- Edad máxima: 90 días
- Edad mínima: 1 día
- Bloqueo de cuenta: 5 intentos fallidos
- Tiempo de bloqueo: 30 minutos
```

### 2. Configuración de Usuarios
- **Deshabilitar cuentas de invitado**
- **Renombrar cuenta de administrador**
- **Configurar timeouts de sesión**
- **Habilitar auditoría de eventos**

### 3. Configuración de Servicios
**Servicios a deshabilitar:**
- Telnet
- TFTP
- SNMP (si no es necesario)
- Alerter
- Messenger

**Servicios a configurar:**
- Windows Update: Automático
- Windows Defender: Habilitado
- Firewall de Windows: Habilitado

### 4. Configuración de Red
- **Configurar firewall de Windows**
- **Deshabilitar NetBIOS sobre TCP/IP**
- **Configurar DNS seguro**
- **Habilitar IPv6 (si aplica)**

## Configuraciones de Seguridad

### 1. Windows Defender
```
Configuraciones requeridas:
- Protección en tiempo real: Habilitada
- Protección basada en la nube: Habilitada
- Envío automático de muestras: Habilitado
- Protección contra ransomware: Habilitada
- Control de acceso a carpetas: Habilitado
```

### 2. BitLocker
- **Habilitar cifrado de disco completo**
- **Configurar TPM + PIN**
- **Habilitar recuperación de claves**
- **Configurar backup de claves**

### 3. Windows Hello
- **Habilitar autenticación biométrica**
- **Configurar PIN complejo**
- **Habilitar Windows Hello for Business**

### 4. Políticas de Aplicaciones
- **Configurar AppLocker**
- **Habilitar SmartScreen**
- **Configurar control de cuentas de usuario (UAC)**

## Configuraciones de Navegación Web

### 1. Microsoft Edge
```
Configuraciones de seguridad:
- SmartScreen: Habilitado
- Protección contra phishing: Habilitada
- Configuración de cookies: Restrictiva
- JavaScript: Habilitado (con restricciones)
- Plugins: Solo los necesarios
```

### 2. Configuraciones de Proxy
- **Configurar proxy corporativo**
- **Habilitar filtrado de contenido**
- **Configurar certificados SSL**

## Configuraciones de Aplicaciones

### 1. Office 365
- **Habilitar protección contra macros**
- **Configurar políticas de DLP**
- **Habilitar cifrado de documentos**
- **Configurar autenticación multifactor**

### 2. Aplicaciones de Terceros
- **Mantener actualizadas**
- **Configurar según políticas de seguridad**
- **Validar integridad de instaladores**

## Configuraciones de Auditoría

### 1. Eventos de Windows
```
Eventos a auditar:
- Inicios de sesión (éxito/fallo)
- Cambios de contraseña
- Creación/modificación de usuarios
- Acceso a archivos sensibles
- Cambios de configuración de seguridad
```

### 2. Configuración de Logs
- **Tamaño máximo de logs: 1GB**
- **Retención: 90 días**
- **Configurar envío a SIEM**

## Configuraciones de Backup

### 1. Windows Backup
- **Configurar backup automático**
- **Cifrar backups**
- **Validar integridad de backups**
- **Probar restauración**

### 2. OneDrive for Business
- **Sincronización automática**
- **Cifrado de datos**
- **Configurar retención**

## Configuraciones de Mantenimiento

### 1. Windows Update
```
Configuración requerida:
- Actualizaciones automáticas: Habilitadas
- Horario de instalación: 03:00 AM
- Reinicio automático: Habilitado
- Notificaciones: Configuradas
```

### 2. Mantenimiento del Sistema
- **Desfragmentación automática**
- **Limpieza de archivos temporales**
- **Verificación de integridad del sistema**

## Configuraciones de Red Corporativa

### 1. Dominio
- **Unirse al dominio corporativo**
- **Configurar políticas de grupo**
- **Sincronizar reloj con servidor NTP**

### 2. VPN
- **Configurar cliente VPN corporativo**
- **Habilitar conexión automática**
- **Configurar políticas de tráfico**

## Configuraciones de Dispositivos

### 1. Periféricos
- **Controlar acceso a USB**
- **Configurar impresoras seguras**
- **Habilitar cifrado de dispositivos móviles**

### 2. Configuraciones de Energía
- **Configurar suspensión automática**
- **Habilitar bloqueo de pantalla**
- **Configurar timeouts**

## Verificación y Validación

### 1. Herramientas de Verificación
- **Microsoft Security Compliance Toolkit**
- **PowerShell Scripts de auditoría**
- **Herramientas de análisis de vulnerabilidades**

### 2. Pruebas de Configuración
- **Verificar políticas aplicadas**
- **Probar controles de seguridad**
- **Validar configuraciones de red**

## Documentación de Evidencias

### 1. Capturas de Pantalla Requeridas
- Configuración de Windows Defender
- Configuración de BitLocker
- Configuración de firewall
- Configuración de usuarios
- Configuración de servicios

### 2. Reportes Requeridos
- Reporte de configuración de seguridad
- Reporte de usuarios y grupos
- Reporte de servicios habilitados/deshabilitados
- Reporte de políticas aplicadas

### 3. Logs Requeridos
- Logs de eventos de seguridad
- Logs de configuración
- Logs de auditoría

## Procedimientos de Emergencia

### 1. Acceso de Emergencia
- **Procedimiento de acceso administrativo**
- **Credenciales de emergencia**
- **Contactos de soporte**

### 2. Recuperación de Sistema
- **Procedimiento de restauración**
- **Puntos de restauración**
- **Backup de configuración**

## Mantenimiento Continuo

### 1. Revisiones Periódicas
- **Revisión mensual de configuraciones**
- **Actualización de políticas**
- **Validación de controles**

### 2. Actualizaciones
- **Parches de seguridad**
- **Actualizaciones de aplicaciones**
- **Revisión de configuraciones**

---
**Versión:** 1.0  
**Fecha:** $(Get-Date -Format "yyyy-MM-dd")  
**Responsable:** Equipo de Seguridad  
**Revisión:** Trimestral 