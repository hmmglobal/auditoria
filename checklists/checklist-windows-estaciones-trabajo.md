# Lista de Comprobación - Estaciones de Trabajo Windows 10/11

## Información del Sistema
- **Hostname:** _________________
- **IP Address:** _________________
- **Usuario:** _________________
- **Fecha de Auditoría:** _________________
- **Auditor:** _________________
- **Versión de Windows:** _________________

## 1. Configuración de Sistema Operativo

### 1.1 Políticas de Contraseñas
- [ ] Longitud mínima configurada a 12 caracteres
- [ ] Complejidad de contraseñas habilitada
- [ ] Historial de contraseñas configurado (24)
- [ ] Edad máxima de contraseña configurada (90 días)
- [ ] Edad mínima de contraseña configurada (1 día)
- [ ] Bloqueo de cuenta configurado (5 intentos)
- [ ] Tiempo de bloqueo configurado (30 minutos)

**Evidencia:** Captura de pantalla de Políticas de Contraseñas
**Comando de verificación:** `net accounts`

### 1.2 Configuración de Usuarios
- [ ] Cuenta de invitado deshabilitada
- [ ] Cuenta de administrador renombrada
- [ ] Timeout de sesión configurado
- [ ] Auditoría de eventos habilitada
- [ ] Usuarios inactivos deshabilitados

**Evidencia:** Captura de pantalla de Usuarios y Grupos
**Comando de verificación:** `wmic useraccount get name,disabled`

### 1.3 Configuración de Servicios
- [ ] Telnet deshabilitado
- [ ] TFTP deshabilitado
- [ ] SNMP deshabilitado (si no es necesario)
- [ ] Alerter deshabilitado
- [ ] Messenger deshabilitado
- [ ] Windows Update configurado como automático
- [ ] Windows Defender habilitado
- [ ] Firewall de Windows habilitado

**Evidencia:** Captura de pantalla de Servicios
**Comando de verificación:** `sc query [servicename]`

### 1.4 Configuración de Red
- [ ] Firewall de Windows habilitado
- [ ] NetBIOS sobre TCP/IP deshabilitado
- [ ] DNS seguro configurado
- [ ] IPv6 habilitado (si aplica)
- [ ] Configuración de proxy aplicada

**Evidencia:** Captura de pantalla de Configuración de Red
**Comando de verificación:** `netsh advfirewall show allprofiles`

## 2. Configuraciones de Seguridad

### 2.1 Windows Defender
- [ ] Protección en tiempo real habilitada
- [ ] Protección basada en la nube habilitada
- [ ] Envío automático de muestras habilitado
- [ ] Protección contra ransomware habilitada
- [ ] Control de acceso a carpetas habilitado
- [ ] Definiciones de virus actualizadas
- [ ] Escaneo automático configurado

**Evidencia:** Captura de pantalla de Windows Defender
**Comando de verificación:** `Get-MpComputerStatus`

### 2.2 BitLocker
- [ ] Cifrado de disco completo habilitado
- [ ] TPM + PIN configurado
- [ ] Recuperación de claves habilitada
- [ ] Backup de claves configurado
- [ ] Estado de cifrado verificado

**Evidencia:** Captura de pantalla de BitLocker
**Comando de verificación:** `manage-bde -status`

### 2.3 Windows Hello
- [ ] Autenticación biométrica habilitada
- [ ] PIN complejo configurado
- [ ] Windows Hello for Business habilitado
- [ ] Configuración de seguridad verificada

**Evidencia:** Captura de pantalla de Windows Hello
**Comando de verificación:** `Get-WmiObject -Class Win32_TPM`

### 2.4 Políticas de Aplicaciones
- [ ] AppLocker configurado
- [ ] SmartScreen habilitado
- [ ] UAC configurado apropiadamente
- [ ] Políticas de ejecución aplicadas

**Evidencia:** Captura de pantalla de Políticas de Aplicaciones
**Comando de verificación:** `Get-AppLockerPolicy -Effective`

## 3. Configuraciones de Navegación Web

### 3.1 Microsoft Edge
- [ ] SmartScreen habilitado
- [ ] Protección contra phishing habilitada
- [ ] Configuración de cookies restrictiva
- [ ] JavaScript habilitado con restricciones
- [ ] Plugins limitados a los necesarios
- [ ] Configuración de seguridad verificada

**Evidencia:** Captura de pantalla de Configuración de Edge
**Comando de verificación:** `reg query "HKCU\Software\Microsoft\Edge"`

### 3.2 Configuraciones de Proxy
- [ ] Proxy corporativo configurado
- [ ] Filtrado de contenido habilitado
- [ ] Certificados SSL configurados
- [ ] Configuración de red verificada

**Evidencia:** Captura de pantalla de Configuración de Proxy
**Comando de verificación:** `netsh winhttp show proxy`

## 4. Configuraciones de Aplicaciones

### 4.1 Office 365
- [ ] Protección contra macros habilitada
- [ ] Políticas de DLP configuradas
- [ ] Cifrado de documentos habilitado
- [ ] Autenticación multifactor configurada
- [ ] Configuración de seguridad verificada

**Evidencia:** Captura de pantalla de Configuración de Office
**Comando de verificación:** `Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office"`

### 4.2 Aplicaciones de Terceros
- [ ] Aplicaciones actualizadas
- [ ] Configuración según políticas de seguridad
- [ ] Integridad de instaladores validada
- [ ] Lista de aplicaciones autorizadas verificada

**Evidencia:** Lista de aplicaciones instaladas
**Comando de verificación:** `Get-WmiObject -Class Win32_Product | Select-Object Name,Version`

## 5. Configuraciones de Auditoría

### 5.1 Eventos de Windows
- [ ] Inicios de sesión auditados (éxito/fallo)
- [ ] Cambios de contraseña auditados
- [ ] Creación/modificación de usuarios auditada
- [ ] Acceso a archivos sensibles auditado
- [ ] Cambios de configuración de seguridad auditados

**Evidencia:** Captura de pantalla de Políticas de Auditoría
**Comando de verificación:** `auditpol /get /category:*`

### 5.2 Configuración de Logs
- [ ] Tamaño máximo de logs configurado (1GB)
- [ ] Retención configurada (90 días)
- [ ] Envío a SIEM configurado
- [ ] Logs de seguridad verificados

**Evidencia:** Captura de pantalla de Configuración de Logs
**Comando de verificación:** `wevtutil qe Security /c:10 /f:text`

## 6. Configuraciones de Backup

### 6.1 Windows Backup
- [ ] Backup automático configurado
- [ ] Backups cifrados
- [ ] Integridad de backups validada
- [ ] Restauración probada

**Evidencia:** Captura de pantalla de Configuración de Backup
**Comando de verificación:** `wbadmin get status`

### 6.2 OneDrive for Business
- [ ] Sincronización automática configurada
- [ ] Datos cifrados
- [ ] Retención configurada
- [ ] Configuración verificada

**Evidencia:** Captura de pantalla de OneDrive
**Comando de verificación:** `Get-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive"`

## 7. Configuraciones de Mantenimiento

### 7.1 Windows Update
- [ ] Actualizaciones automáticas habilitadas
- [ ] Horario de instalación configurado (03:00 AM)
- [ ] Reinicio automático habilitado
- [ ] Notificaciones configuradas
- [ ] Última actualización verificada

**Evidencia:** Captura de pantalla de Windows Update
**Comando de verificación:** `Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10`

### 7.2 Mantenimiento del Sistema
- [ ] Desfragmentación automática configurada
- [ ] Limpieza de archivos temporales configurada
- [ ] Integridad del sistema verificada
- [ ] Mantenimiento programado

**Evidencia:** Captura de pantalla de Mantenimiento
**Comando de verificación:** `sfc /scannow`

## 8. Configuraciones de Red Corporativa

### 8.1 Dominio
- [ ] Sistema unido al dominio corporativo
- [ ] Políticas de grupo aplicadas
- [ ] Reloj sincronizado con servidor NTP
- [ ] Configuración de dominio verificada

**Evidencia:** Captura de pantalla de Información del Sistema
**Comando de verificación:** `systeminfo | findstr /C:"Domain"`

### 8.2 VPN
- [ ] Cliente VPN corporativo configurado
- [ ] Conexión automática habilitada
- [ ] Políticas de tráfico configuradas
- [ ] Configuración de VPN verificada

**Evidencia:** Captura de pantalla de Configuración de VPN
**Comando de verificación:** `Get-VpnConnection`

## 9. Configuraciones de Dispositivos

### 9.1 Periféricos
- [ ] Acceso a USB controlado
- [ ] Impresoras seguras configuradas
- [ ] Cifrado de dispositivos móviles habilitado
- [ ] Configuración de dispositivos verificada

**Evidencia:** Captura de pantalla de Administrador de Dispositivos
**Comando de verificación:** `Get-PnpDevice`

### 9.2 Configuraciones de Energía
- [ ] Suspensión automática configurada
- [ ] Bloqueo de pantalla habilitado
- [ ] Timeouts configurados
- [ ] Configuración de energía verificada

**Evidencia:** Captura de pantalla de Opciones de Energía
**Comando de verificación:** `powercfg /list`

## 10. Verificación Final

### 10.1 Resumen de Cumplimiento
- [ ] Total de controles verificados: _____ / _____
- [ ] Controles cumplidos: _____ / _____
- [ ] Controles no cumplidos: _____ / _____
- [ ] Porcentaje de cumplimiento: _____%

### 10.2 Excepciones Documentadas
- [ ] Limitaciones técnicas documentadas
- [ ] Impacto en operaciones justificado
- [ ] Alternativas equivalentes implementadas
- [ ] Plan de remediación establecido

### 10.3 Evidencias Recolectadas
- [ ] Capturas de pantalla completas
- [ ] Reportes de configuración
- [ ] Logs de auditoría
- [ ] Documentación de excepciones

## Observaciones del Auditor

**Observaciones generales:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Recomendaciones:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Plan de acción:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

## Firma y Aprobación

**Auditor:** _________________ **Fecha:** _________________
**Responsable del Sistema:** _________________ **Fecha:** _________________
**Aprobado por:** _________________ **Fecha:** _________________

---
**Versión del Checklist:** 1.0  
**Fecha de Creación:** $(Get-Date -Format "yyyy-MM-dd")  
**Próxima Revisión:** $(Get-Date).AddMonths(3).ToString("yyyy-MM-dd") 