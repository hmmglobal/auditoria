# Lista de Comprobación - Estaciones de Trabajo Windows 10/11 con Google Workspace

## Información del Sistema
- **Hostname:** _________________
- **IP Address:** _________________
- **Usuario:** _________________
- **Fecha de Auditoría:** _________________
- **Auditor:** _________________
- **Versión de Windows:** _________________
- **Google Workspace Admin:** _________________

## Lectura ##

W Logrado en workspace
E manejado por eset
X No logrado
O Logrado

## 1. Configuración de Sistema Operativo

### 1.1 Políticas de Contraseñas (Aplicado via Workspace)
- [W] Longitud mínima configurada a 12 caracteres
- [W] Complejidad de contraseñas habilitada
- [W] Historial de contraseñas configurado (24)
- [W] Edad máxima de contraseña configurada (90 días)
- [W] Edad mínima de contraseña configurada (1 día)
- [W] Bloqueo de cuenta configurado (5 intentos)
- [W] Tiempo de bloqueo configurado (30 minutos)

**En Google Workspace:** Seguridad > Configuración de seguridad > Políticas de contraseñas
**Evidencia:** Google Drive > Evidencias > Políticas_Contraseñas
**Comando de verificación:** `net accounts`
**Script automático:** `Get-PasswordPolicyEvidence`

### 1.2 Configuración de Usuarios
- [O] Cuenta de invitado deshabilitada
- [O] Cuenta de administrador renombrada
- [W] Timeout de sesión configurado
- [O] Auditoría de eventos habilitada
- [W] Usuarios inactivos deshabilitados

**En Google Workspace:** Usuarios > Configuración de usuarios
**Evidencia:** Google Drive > Evidencias > Configuracion_Usuarios
**Comando de verificación:** `wmic useraccount get name,disabled`
**Script automático:** `Get-UserEvidence`

### 1.3 Configuración de Servicios
- [O] Telnet deshabilitado
- [O] TFTP deshabilitado
- [O] SNMP deshabilitado (si no es necesario)
- [O] Alerter deshabilitado
- [O] Messenger deshabilitado
- [W] Windows Update configurado como automático
- [E] Windows Defender habilitado
- [E] Firewall de Windows habilitado

**En Google Workspace:** Dispositivos > Configuración de dispositivos > Servicios
**Evidencia:** Google Drive > Evidencias > Servicios_Sistema
**Comando de verificación:** `sc query [servicename]`
**Script automático:** `Get-ServiceEvidence`

### 1.4 Configuración de Red
- [ ] Firewall de Windows habilitado
- [ ] NetBIOS sobre TCP/IP deshabilitado
- [ ] DNS seguro configurado
- [ ] IPv6 habilitado (si aplica)
- [ ] Configuración de proxy aplicada

**En Google Workspace:** Dispositivos > Configuración de red
**Evidencia:** Google Drive > Evidencias > Configuracion_Red
**Comando de verificación:** `netsh advfirewall show allprofiles`
**Script automático:** `Get-NetworkEvidence`

## 2. Configuraciones de Seguridad

### 2.1 Windows Defender
- [ ] Protección en tiempo real habilitada
- [ ] Protección basada en la nube habilitada
- [ ] Envío automático de muestras habilitado
- [ ] Protección contra ransomware habilitada
- [ ] Control de acceso a carpetas habilitado
- [ ] Definiciones de virus actualizadas
- [ ] Escaneo automático configurado

**En Google Workspace:** Seguridad > Endpoint Management > Windows Defender
**Evidencia:** Google Drive > Evidencias > Windows_Defender
**Comando de verificación:** `Get-MpComputerStatus`
**Script automático:** `Get-WindowsDefenderEvidence`

### 2.2 BitLocker
- [ ] Cifrado de disco completo habilitado
- [ ] TPM + PIN configurado
- [ ] Recuperación de claves habilitada
- [ ] Backup de claves configurado
- [ ] Estado de cifrado verificado

**En Google Workspace:** Dispositivos > Configuración de seguridad > BitLocker
**Evidencia:** Google Drive > Evidencias > BitLocker
**Comando de verificación:** `manage-bde -status`
**Script automático:** `Get-BitLockerEvidence`

### 2.3 Windows Hello
- [ ] Autenticación biométrica habilitada
- [ ] PIN complejo configurado
- [ ] Windows Hello for Business habilitado
- [ ] Configuración de seguridad verificada

**En Google Workspace:** Seguridad > Autenticación > Windows Hello
**Evidencia:** Google Drive > Evidencias > Windows_Hello
**Comando de verificación:** `Get-WmiObject -Class Win32_TPM`
**Script automático:** `Get-WindowsHelloEvidence`

### 2.4 Políticas de Aplicaciones
- [ ] AppLocker configurado
- [ ] SmartScreen habilitado
- [ ] UAC configurado apropiadamente
- [ ] Políticas de ejecución aplicadas

**En Google Workspace:** Dispositivos > Políticas de aplicaciones
**Evidencia:** Google Drive > Evidencias > Politicas_Aplicaciones
**Comando de verificación:** `Get-AppLockerPolicy -Effective`
**Script automático:** `Get-AppPolicyEvidence`

## 3. Configuraciones de Navegación Web

### 3.1 Microsoft Edge
- [ ] SmartScreen habilitado
- [ ] Protección contra phishing habilitada
- [ ] Configuración de cookies restrictiva
- [ ] JavaScript habilitado con restricciones
- [ ] Plugins limitados a los necesarios
- [ ] Configuración de seguridad verificada

**En Google Workspace:** Dispositivos > Configuración de navegador > Microsoft Edge
**Evidencia:** Google Drive > Evidencias > Microsoft_Edge
**Comando de verificación:** `reg query "HKCU\Software\Microsoft\Edge"`
**Script automático:** `Get-EdgeEvidence`

### 3.2 Configuraciones de Proxy
- [ ] Proxy corporativo configurado
- [ ] Filtrado de contenido habilitado
- [ ] Certificados SSL configurados
- [ ] Configuración de red verificada

**En Google Workspace:** Dispositivos > Configuración de red > Proxy
**Evidencia:** Google Drive > Evidencias > Configuracion_Proxy
**Comando de verificación:** `netsh winhttp show proxy`
**Script automático:** `Get-ProxyEvidence`

## 4. Configuraciones de Aplicaciones

### 4.1 Office 365
- [ ] Protección contra macros habilitada
- [ ] Políticas de DLP configuradas
- [ ] Cifrado de documentos habilitado
- [ ] Autenticación multifactor configurada
- [ ] Configuración de seguridad verificada

**En Google Workspace:** Aplicaciones > Google Workspace > Office 365
**Evidencia:** Google Drive > Evidencias > Office_365
**Comando de verificación:** `Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office"`
**Script automático:** `Get-OfficeEvidence`

### 4.2 Aplicaciones de Terceros
- [ ] Aplicaciones actualizadas
- [ ] Configuración según políticas de seguridad
- [ ] Integridad de instaladores validada
- [ ] Lista de aplicaciones autorizadas verificada

**En Google Workspace:** Dispositivos > Políticas de aplicaciones > Aplicaciones de terceros
**Evidencia:** Google Drive > Evidencias > Aplicaciones_Terceros
**Comando de verificación:** `Get-WmiObject -Class Win32_Product | Select-Object Name,Version`
**Script automático:** `Get-ApplicationEvidence`

## 5. Configuraciones de Auditoría

### 5.1 Eventos de Windows
- [ ] Inicios de sesión auditados (éxito/fallo)
- [ ] Cambios de contraseña auditados
- [ ] Creación/modificación de usuarios auditada
- [ ] Acceso a archivos sensibles auditado
- [ ] Cambios de configuración de seguridad auditados

**En Google Workspace:** Seguridad > Centro de seguridad > Auditoría
**Evidencia:** Google Drive > Evidencias > Auditoria_Eventos
**Comando de verificación:** `auditpol /get /category:*`
**Script automático:** `Get-AuditEvidence`

### 5.2 Configuración de Logs
- [ ] Tamaño máximo de logs configurado (1GB)
- [ ] Retención configurada (90 días)
- [ ] Envío a SIEM configurado
- [ ] Logs de seguridad verificados

**En Google Workspace:** Seguridad > Configuración de logs
**Evidencia:** Google Drive > Evidencias > Configuracion_Logs
**Comando de verificación:** `wevtutil qe Security /c:10 /f:text`
**Script automático:** `Get-LogEvidence`

## 6. Configuraciones de Backup

### 6.1 Windows Backup
- [ ] Backup automático configurado
- [ ] Backups cifrados
- [ ] Integridad de backups validada
- [ ] Restauración probada

**En Google Workspace:** Dispositivos > Configuración de backup
**Evidencia:** Google Drive > Evidencias > Windows_Backup
**Comando de verificación:** `wbadmin get status`
**Script automático:** `Get-BackupEvidence`

### 6.2 OneDrive for Business
- [ ] Sincronización automática configurada
- [ ] Datos cifrados
- [ ] Retención configurada
- [ ] Configuración verificada

**En Google Workspace:** Aplicaciones > Google Drive > OneDrive
**Evidencia:** Google Drive > Evidencias > OneDrive_Configuracion
**Comando de verificación:** `Get-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive"`
**Script automático:** `Get-OneDriveEvidence`

## 7. Configuraciones de Mantenimiento

### 7.1 Windows Update
- [ ] Actualizaciones automáticas habilitadas
- [ ] Horario de instalación configurado (03:00 AM)
- [ ] Reinicio automático habilitado
- [ ] Notificaciones configuradas
- [ ] Última actualización verificada

**En Google Workspace:** Dispositivos > Configuración de actualizaciones
**Evidencia:** Google Drive > Evidencias > Windows_Update
**Comando de verificación:** `Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10`
**Script automático:** `Get-WindowsUpdateEvidence`

### 7.2 Mantenimiento del Sistema
- [ ] Desfragmentación automática configurada
- [ ] Limpieza de archivos temporales configurada
- [ ] Integridad del sistema verificada
- [ ] Mantenimiento programado

**En Google Workspace:** Dispositivos > Configuración de mantenimiento
**Evidencia:** Google Drive > Evidencias > Mantenimiento_Sistema
**Comando de verificación:** `sfc /scannow`
**Script automático:** `Get-MaintenanceEvidence`

## 8. Configuraciones de Red Corporativa

### 8.1 Dominio
- [ ] Sistema unido al dominio corporativo
- [ ] Políticas de grupo aplicadas
- [ ] Reloj sincronizado con servidor NTP
- [ ] Configuración de dominio verificada

**En Google Workspace:** Dispositivos > Configuración de dominio
**Evidencia:** Google Drive > Evidencias > Configuracion_Dominio
**Comando de verificación:** `systeminfo | findstr /C:"Domain"`
**Script automático:** `Get-DomainEvidence`

### 8.2 VPN
- [ ] Cliente VPN corporativo configurado
- [ ] Conexión automática habilitada
- [ ] Políticas de tráfico configuradas
- [ ] Configuración de VPN verificada

**En Google Workspace:** Dispositivos > Configuración de VPN
**Evidencia:** Google Drive > Evidencias > Configuracion_VPN
**Comando de verificación:** `Get-VpnConnection`
**Script automático:** `Get-VPNEvidence`

## 9. Configuraciones de Dispositivos

### 9.1 Periféricos
- [ ] Acceso a USB controlado
- [ ] Impresoras seguras configuradas
- [ ] Cifrado de dispositivos móviles habilitado
- [ ] Configuración de dispositivos verificada

**En Google Workspace:** Dispositivos > Configuración de periféricos
**Evidencia:** Google Drive > Evidencias > Configuracion_Perifericos
**Comando de verificación:** `Get-PnpDevice`
**Script automático:** `Get-PeripheralEvidence`

### 9.2 Configuraciones de Energía
- [ ] Suspensión automática configurada
- [ ] Bloqueo de pantalla habilitado
- [ ] Timeouts configurados
- [ ] Configuración de energía verificada

**En Google Workspace:** Dispositivos > Configuración de energía
**Evidencia:** Google Drive > Evidencias > Configuracion_Energia
**Comando de verificación:** `powercfg /list`
**Script automático:** `Get-PowerEvidence`

## 10. Verificación Final

### 10.1 Resumen de Cumplimiento
- [ ] Total de controles verificados: _____ / _____
- [ ] Controles cumplidos: _____ / _____
- [ ] Controles no cumplidos: _____ / _____
- [ ] Porcentaje de cumplimiento: _____%

**Script automático:** `Generate-ComplianceReport`

### 10.2 Excepciones Documentadas
- [ ] Limitaciones técnicas documentadas
- [ ] Impacto en operaciones justificado
- [ ] Alternativas equivalentes implementadas
- [ ] Plan de remediación establecido

**Evidencia:** Google Drive > Evidencias > Excepciones_Documentadas

### 10.3 Evidencias Recolectadas
- [ ] Capturas de pantalla completas
- [ ] Reportes de configuración
- [ ] Logs de auditoría
- [ ] Documentación de excepciones

**Script automático:** `Copy-ToGoogleDrive`

## Proceso de Ejecución Automatizada

### Paso 1: Preparación
```powershell
# Descargar y ejecutar script de recolección
.\Get-GoogleWorkspaceEvidence.ps1 -GenerateReport -UploadToDrive
```

### Paso 2: Verificación Manual
1. Revisar cada carpeta de evidencia en Google Drive
2. Verificar cumplimiento de cada control
3. Marcar controles cumplidos/no cumplidos
4. Documentar excepciones

### Paso 3: Generación de Reporte Final
```powershell
# Generar reporte de cumplimiento
.\Generate-FinalReport.ps1 -SystemInfo $systemInfo -ComplianceData $complianceData
```

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
**Versión del Checklist:** 2.0 (Google Workspace Integration)  
**Fecha de Creación:** $(Get-Date -Format "yyyy-MM-dd")  
**Próxima Revisión:** $(Get-Date).AddMonths(3).ToString("yyyy-MM-dd") 