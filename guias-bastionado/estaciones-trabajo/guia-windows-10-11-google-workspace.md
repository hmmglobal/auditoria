# Guía de Bastionado Windows 10/11 con Google Workspace

## Introducción

Esta guía te permitirá implementar el checklist de seguridad para estaciones de trabajo Windows 10/11 utilizando Google Workspace como plataforma de administración central. Cada sección del checklist original se mapea con las configuraciones correspondientes en Google Workspace.

## Preparación Inicial

### 1. Acceso a Google Workspace Admin Console
- URL: https://admin.google.com
- Requisitos: Cuenta de administrador de Google Workspace
- Navegador: Chrome recomendado

### 2. Herramientas Necesarias
- Google Workspace Admin Console
- Google Chrome Enterprise (para políticas avanzadas)
- Google Workspace Security Center
- Google Drive (para almacenar evidencias)

## Implementación del Checklist

## 1. Configuración de Sistema Operativo

### 1.1 Políticas de Contraseñas

**En Google Workspace Admin Console:**
1. Ir a **Seguridad** > **Configuración de seguridad**
2. Configurar **Políticas de contraseñas**:
   - Longitud mínima: 12 caracteres
   - Requerir mayúsculas y minúsculas
   - Requerir números
   - Requerir símbolos
   - Historial: 24 contraseñas
   - Expiración: 90 días

**Evidencia a guardar:**
- Captura de pantalla de la configuración de políticas de contraseñas
- Reporte exportado de políticas de seguridad
- Comando ejecutado: `net accounts` (en la estación de trabajo)

**Ubicación de evidencia:** Google Drive > Evidencias > Políticas_Contraseñas

### 1.2 Configuración de Usuarios

**En Google Workspace Admin Console:**
1. Ir a **Usuarios** > **Configuración de usuarios**
2. Configurar:
   - Deshabilitar cuentas de invitado
   - Configurar timeouts de sesión
   - Habilitar auditoría de eventos
   - Configurar políticas de inactividad

**Evidencia a guardar:**
- Captura de pantalla de configuración de usuarios
- Lista de usuarios activos/inactivos
- Comando ejecutado: `wmic useraccount get name,disabled`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_Usuarios

### 1.3 Configuración de Servicios

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de dispositivos**
2. Configurar políticas de servicios:
   - Deshabilitar Telnet, TFTP, SNMP
   - Configurar Windows Update automático
   - Habilitar Windows Defender
   - Configurar Firewall

**Evidencia a guardar:**
- Captura de pantalla de configuración de servicios
- Reporte de estado de servicios
- Comando ejecutado: `sc query [servicename]`

**Ubicación de evidencia:** Google Drive > Evidencias > Servicios_Sistema

### 1.4 Configuración de Red

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de red**
2. Configurar:
   - Políticas de firewall
   - Configuración de DNS seguro
   - Deshabilitar NetBIOS sobre TCP/IP
   - Configurar proxy corporativo

**Evidencia a guardar:**
- Captura de pantalla de configuración de red
- Configuración de firewall exportada
- Comando ejecutado: `netsh advfirewall show allprofiles`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_Red

## 2. Configuraciones de Seguridad

### 2.1 Windows Defender

**En Google Workspace Admin Console:**
1. Ir a **Seguridad** > **Endpoint Management**
2. Configurar Windows Defender:
   - Protección en tiempo real
   - Protección basada en la nube
   - Control de acceso a carpetas
   - Escaneo automático

**Evidencia a guardar:**
- Captura de pantalla de configuración de Windows Defender
- Estado de protección exportado
- Comando ejecutado: `Get-MpComputerStatus`

**Ubicación de evidencia:** Google Drive > Evidencias > Windows_Defender

### 2.2 BitLocker

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de seguridad**
2. Configurar BitLocker:
   - Habilitar cifrado de disco completo
   - Configurar TPM + PIN
   - Configurar recuperación de claves
   - Backup de claves en Google Workspace

**Evidencia a guardar:**
- Captura de pantalla de configuración de BitLocker
- Estado de cifrado exportado
- Comando ejecutado: `manage-bde -status`

**Ubicación de evidencia:** Google Drive > Evidencias > BitLocker

### 2.3 Windows Hello

**En Google Workspace Admin Console:**
1. Ir a **Seguridad** > **Autenticación**
2. Configurar Windows Hello:
   - Habilitar autenticación biométrica
   - Configurar PIN complejo
   - Windows Hello for Business
   - Integración con Google Workspace

**Evidencia a guardar:**
- Captura de pantalla de configuración de Windows Hello
- Estado de TPM exportado
- Comando ejecutado: `Get-WmiObject -Class Win32_TPM`

**Ubicación de evidencia:** Google Drive > Evidencias > Windows_Hello

### 2.4 Políticas de Aplicaciones

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Políticas de aplicaciones**
2. Configurar:
   - AppLocker policies
   - SmartScreen habilitado
   - UAC configurado
   - Políticas de ejecución

**Evidencia a guardar:**
- Captura de pantalla de políticas de aplicaciones
- Configuración de AppLocker exportada
- Comando ejecutado: `Get-AppLockerPolicy -Effective`

**Ubicación de evidencia:** Google Drive > Evidencias > Politicas_Aplicaciones

## 3. Configuraciones de Navegación Web

### 3.1 Microsoft Edge

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de navegador**
2. Configurar Microsoft Edge:
   - SmartScreen habilitado
   - Protección contra phishing
   - Configuración de cookies restrictiva
   - Plugins limitados

**Evidencia a guardar:**
- Captura de pantalla de configuración de Edge
- Configuración de seguridad exportada
- Comando ejecutado: `reg query "HKCU\Software\Microsoft\Edge"`

**Ubicación de evidencia:** Google Drive > Evidencias > Microsoft_Edge

### 3.2 Configuraciones de Proxy

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de red**
2. Configurar proxy:
   - Proxy corporativo
   - Filtrado de contenido
   - Certificados SSL
   - Configuración de red

**Evidencia a guardar:**
- Captura de pantalla de configuración de proxy
- Configuración de red exportada
- Comando ejecutado: `netsh winhttp show proxy`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_Proxy

## 4. Configuraciones de Aplicaciones

### 4.1 Office 365

**En Google Workspace Admin Console:**
1. Ir a **Aplicaciones** > **Google Workspace**
2. Configurar Office 365:
   - Protección contra macros
   - Políticas de DLP
   - Cifrado de documentos
   - Autenticación multifactor

**Evidencia a guardar:**
- Captura de pantalla de configuración de Office
- Políticas de DLP exportadas
- Comando ejecutado: `Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office"`

**Ubicación de evidencia:** Google Drive > Evidencias > Office_365

### 4.2 Aplicaciones de Terceros

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Políticas de aplicaciones**
2. Configurar:
   - Lista de aplicaciones autorizadas
   - Políticas de actualización
   - Configuración de seguridad
   - Validación de integridad

**Evidencia a guardar:**
- Lista de aplicaciones instaladas
- Configuración de políticas exportada
- Comando ejecutado: `Get-WmiObject -Class Win32_Product | Select-Object Name,Version`

**Ubicación de evidencia:** Google Drive > Evidencias > Aplicaciones_Terceros

## 5. Configuraciones de Auditoría

### 5.1 Eventos de Windows

**En Google Workspace Admin Console:**
1. Ir a **Seguridad** > **Centro de seguridad**
2. Configurar auditoría:
   - Inicios de sesión (éxito/fallo)
   - Cambios de contraseña
   - Creación/modificación de usuarios
   - Acceso a archivos sensibles

**Evidencia a guardar:**
- Captura de pantalla de políticas de auditoría
- Configuración de eventos exportada
- Comando ejecutado: `auditpol /get /category:*`

**Ubicación de evidencia:** Google Drive > Evidencias > Auditoria_Eventos

### 5.2 Configuración de Logs

**En Google Workspace Admin Console:**
1. Ir a **Seguridad** > **Configuración de logs**
2. Configurar:
   - Tamaño máximo de logs (1GB)
   - Retención (90 días)
   - Envío a SIEM
   - Logs de seguridad

**Evidencia a guardar:**
- Captura de pantalla de configuración de logs
- Configuración de retención exportada
- Comando ejecutado: `wevtutil qe Security /c:10 /f:text`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_Logs

## 6. Configuraciones de Backup

### 6.1 Windows Backup

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de backup**
2. Configurar:
   - Backup automático
   - Cifrado de backups
   - Integridad de backups
   - Restauración

**Evidencia a guardar:**
- Captura de pantalla de configuración de backup
- Estado de backups exportado
- Comando ejecutado: `wbadmin get status`

**Ubicación de evidencia:** Google Drive > Evidencias > Windows_Backup

### 6.2 OneDrive for Business

**En Google Workspace Admin Console:**
1. Ir a **Aplicaciones** > **Google Drive**
2. Configurar:
   - Sincronización automática
   - Cifrado de datos
   - Retención configurada
   - Configuración de seguridad

**Evidencia a guardar:**
- Captura de pantalla de configuración de OneDrive
- Configuración de sincronización exportada
- Comando ejecutado: `Get-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive"`

**Ubicación de evidencia:** Google Drive > Evidencias > OneDrive_Configuracion

## 7. Configuraciones de Mantenimiento

### 7.1 Windows Update

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de actualizaciones**
2. Configurar:
   - Actualizaciones automáticas
   - Horario de instalación (03:00 AM)
   - Reinicio automático
   - Notificaciones

**Evidencia a guardar:**
- Captura de pantalla de configuración de Windows Update
- Estado de actualizaciones exportado
- Comando ejecutado: `Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10`

**Ubicación de evidencia:** Google Drive > Evidencias > Windows_Update

### 7.2 Mantenimiento del Sistema

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de mantenimiento**
2. Configurar:
   - Desfragmentación automática
   - Limpieza de archivos temporales
   - Verificación de integridad
   - Mantenimiento programado

**Evidencia a guardar:**
- Captura de pantalla de configuración de mantenimiento
- Estado del sistema exportado
- Comando ejecutado: `sfc /scannow`

**Ubicación de evidencia:** Google Drive > Evidencias > Mantenimiento_Sistema

## 8. Configuraciones de Red Corporativa

### 8.1 Dominio

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de dominio**
2. Configurar:
   - Unión al dominio corporativo
   - Políticas de grupo
   - Sincronización de reloj NTP
   - Configuración de dominio

**Evidencia a guardar:**
- Captura de pantalla de información del sistema
- Configuración de dominio exportada
- Comando ejecutado: `systeminfo | findstr /C:"Domain"`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_Dominio

### 8.2 VPN

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de VPN**
2. Configurar:
   - Cliente VPN corporativo
   - Conexión automática
   - Políticas de tráfico
   - Configuración de seguridad

**Evidencia a guardar:**
- Captura de pantalla de configuración de VPN
- Configuración de conexiones exportada
- Comando ejecutado: `Get-VpnConnection`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_VPN

## 9. Configuraciones de Dispositivos

### 9.1 Periféricos

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de periféricos**
2. Configurar:
   - Control de acceso USB
   - Impresoras seguras
   - Cifrado de dispositivos móviles
   - Configuración de dispositivos

**Evidencia a guardar:**
- Captura de pantalla de administrador de dispositivos
- Lista de dispositivos exportada
- Comando ejecutado: `Get-PnpDevice`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_Perifericos

### 9.2 Configuraciones de Energía

**En Google Workspace Admin Console:**
1. Ir a **Dispositivos** > **Configuración de energía**
2. Configurar:
   - Suspensión automática
   - Bloqueo de pantalla
   - Timeouts configurados
   - Configuración de energía

**Evidencia a guardar:**
- Captura de pantalla de opciones de energía
- Configuración de energía exportada
- Comando ejecutado: `powercfg /list`

**Ubicación de evidencia:** Google Drive > Evidencias > Configuracion_Energia

## 10. Verificación Final

### 10.1 Resumen de Cumplimiento

**En Google Workspace Admin Console:**
1. Ir a **Seguridad** > **Centro de seguridad**
2. Generar reporte de cumplimiento:
   - Total de controles verificados
   - Controles cumplidos
   - Controles no cumplidos
   - Porcentaje de cumplimiento

**Evidencia a guardar:**
- Reporte de cumplimiento exportado
- Dashboard de seguridad
- Métricas de cumplimiento

**Ubicación de evidencia:** Google Drive > Evidencias > Reporte_Cumplimiento

### 10.2 Excepciones Documentadas

**En Google Workspace Admin Console:**
1. Ir a **Seguridad** > **Excepciones**
2. Documentar:
   - Limitaciones técnicas
   - Impacto en operaciones
   - Alternativas implementadas
   - Plan de remediación

**Evidencia a guardar:**
- Documento de excepciones
- Plan de remediación
- Justificaciones técnicas

**Ubicación de evidencia:** Google Drive > Evidencias > Excepciones_Documentadas

### 10.3 Evidencias Recolectadas

**Organización en Google Drive:**
```
Google Drive/
├── Evidencias/
│   ├── Políticas_Contraseñas/
│   ├── Configuracion_Usuarios/
│   ├── Servicios_Sistema/
│   ├── Configuracion_Red/
│   ├── Windows_Defender/
│   ├── BitLocker/
│   ├── Windows_Hello/
│   ├── Politicas_Aplicaciones/
│   ├── Microsoft_Edge/
│   ├── Configuracion_Proxy/
│   ├── Office_365/
│   ├── Aplicaciones_Terceros/
│   ├── Auditoria_Eventos/
│   ├── Configuracion_Logs/
│   ├── Windows_Backup/
│   ├── OneDrive_Configuracion/
│   ├── Windows_Update/
│   ├── Mantenimiento_Sistema/
│   ├── Configuracion_Dominio/
│   ├── Configuracion_VPN/
│   ├── Configuracion_Perifericos/
│   ├── Configuracion_Energia/
│   ├── Reporte_Cumplimiento/
│   └── Excepciones_Documentadas/
└── Checklist_Completado/
    └── checklist-windows-estaciones-trabajo-completado.md
```

## Proceso de Implementación Paso a Paso

### Fase 1: Preparación (Día 1)
1. **Configurar estructura en Google Drive**
   - Crear carpetas de evidencia
   - Configurar permisos de acceso
   - Preparar plantillas de documentación

2. **Configurar Google Workspace Admin Console**
   - Verificar permisos de administrador
   - Configurar políticas base
   - Preparar herramientas de auditoría

### Fase 2: Implementación Base (Días 2-3)
1. **Configuraciones de Sistema Operativo**
   - Políticas de contraseñas
   - Configuración de usuarios
   - Servicios del sistema
   - Configuración de red

2. **Configuraciones de Seguridad**
   - Windows Defender
   - BitLocker
   - Windows Hello
   - Políticas de aplicaciones

### Fase 3: Configuraciones Específicas (Días 4-5)
1. **Navegación Web y Aplicaciones**
   - Microsoft Edge
   - Configuración de proxy
   - Office 365
   - Aplicaciones de terceros

2. **Auditoría y Backup**
   - Eventos de Windows
   - Configuración de logs
   - Windows Backup
   - OneDrive for Business

### Fase 4: Configuraciones Avanzadas (Días 6-7)
1. **Mantenimiento y Red**
   - Windows Update
   - Mantenimiento del sistema
   - Configuración de dominio
   - VPN

2. **Dispositivos y Energía**
   - Periféricos
   - Configuraciones de energía

### Fase 5: Verificación y Documentación (Día 8)
1. **Verificación Final**
   - Resumen de cumplimiento
   - Documentación de excepciones
   - Recolección de evidencias

2. **Generación de Reporte**
   - Checklist completado
   - Evidencias organizadas
   - Reporte ejecutivo

## Herramientas de Automatización

### Scripts de PowerShell para Evidencia

```powershell
# Script para recolectar evidencia automáticamente
# Guardar como: Get-GoogleWorkspaceEvidence.ps1

param(
    [string]$EvidencePath = "C:\Evidencias",
    [string]$GoogleDrivePath = "C:\GoogleDrive\Evidencias"
)

# Crear estructura de carpetas
$folders = @(
    "Políticas_Contraseñas",
    "Configuracion_Usuarios",
    "Servicios_Sistema",
    "Configuracion_Red",
    "Windows_Defender",
    "BitLocker",
    "Windows_Hello",
    "Politicas_Aplicaciones",
    "Microsoft_Edge",
    "Configuracion_Proxy",
    "Office_365",
    "Aplicaciones_Terceros",
    "Auditoria_Eventos",
    "Configuracion_Logs",
    "Windows_Backup",
    "OneDrive_Configuracion",
    "Windows_Update",
    "Mantenimiento_Sistema",
    "Configuracion_Dominio",
    "Configuracion_VPN",
    "Configuracion_Perifericos",
    "Configuracion_Energia",
    "Reporte_Cumplimiento",
    "Excepciones_Documentadas"
)

foreach ($folder in $folders) {
    New-Item -Path "$EvidencePath\$folder" -ItemType Directory -Force
    New-Item -Path "$GoogleDrivePath\$folder" -ItemType Directory -Force
}

# Recolectar evidencia automáticamente
Write-Host "Recolectando evidencia del sistema..." -ForegroundColor Green

# Políticas de contraseñas
net accounts > "$EvidencePath\Políticas_Contraseñas\net_accounts.txt"

# Usuarios
wmic useraccount get name,disabled > "$EvidencePath\Configuracion_Usuarios\usuarios.txt"

# Servicios
Get-Service | Where-Object {$_.Name -match "telnet|tftp|snmp"} | Export-Csv "$EvidencePath\Servicios_Sistema\servicios_criticos.csv"

# Windows Defender
Get-MpComputerStatus | Export-Clixml "$EvidencePath\Windows_Defender\defender_status.xml"

# BitLocker
manage-bde -status > "$EvidencePath\BitLocker\bitlocker_status.txt"

# Windows Update
Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10 | Export-Csv "$EvidencePath\Windows_Update\ultimas_actualizaciones.csv"

Write-Host "Evidencia recolectada en: $EvidencePath" -ForegroundColor Green
Write-Host "Copiando a Google Drive: $GoogleDrivePath" -ForegroundColor Green

# Copiar a Google Drive
Copy-Item -Path "$EvidencePath\*" -Destination "$GoogleDrivePath" -Recurse -Force

Write-Host "Proceso completado." -ForegroundColor Green
```

### Plantilla de Checklist Completado

```markdown
# Checklist Completado - Estación de Trabajo Windows 10/11

## Información del Sistema
- **Hostname:** [HOSTNAME]
- **IP Address:** [IP_ADDRESS]
- **Usuario:** [USERNAME]
- **Fecha de Auditoría:** [DATE]
- **Auditor:** [AUDITOR_NAME]
- **Versión de Windows:** [WINDOWS_VERSION]

## Resumen de Cumplimiento
- **Total de controles:** 50
- **Controles cumplidos:** [X]
- **Controles no cumplidos:** [Y]
- **Porcentaje de cumplimiento:** [Z]%

## Evidencias Recolectadas
- [ ] Políticas de Contraseñas: [LINK_EVIDENCIA]
- [ ] Configuración de Usuarios: [LINK_EVIDENCIA]
- [ ] Servicios del Sistema: [LINK_EVIDENCIA]
- [ ] Configuración de Red: [LINK_EVIDENCIA]
- [ ] Windows Defender: [LINK_EVIDENCIA]
- [ ] BitLocker: [LINK_EVIDENCIA]
- [ ] Windows Hello: [LINK_EVIDENCIA]
- [ ] Políticas de Aplicaciones: [LINK_EVIDENCIA]
- [ ] Microsoft Edge: [LINK_EVIDENCIA]
- [ ] Configuración de Proxy: [LINK_EVIDENCIA]
- [ ] Office 365: [LINK_EVIDENCIA]
- [ ] Aplicaciones de Terceros: [LINK_EVIDENCIA]
- [ ] Auditoría de Eventos: [LINK_EVIDENCIA]
- [ ] Configuración de Logs: [LINK_EVIDENCIA]
- [ ] Windows Backup: [LINK_EVIDENCIA]
- [ ] OneDrive: [LINK_EVIDENCIA]
- [ ] Windows Update: [LINK_EVIDENCIA]
- [ ] Mantenimiento: [LINK_EVIDENCIA]
- [ ] Configuración de Dominio: [LINK_EVIDENCIA]
- [ ] VPN: [LINK_EVIDENCIA]
- [ ] Periféricos: [LINK_EVIDENCIA]
- [ ] Configuración de Energía: [LINK_EVIDENCIA]

## Observaciones del Auditor
[OBSERVACIONES]

## Recomendaciones
[RECOMENDACIONES]

## Plan de Acción
[PLAN_ACCION]

## Firma y Aprobación
- **Auditor:** [AUDITOR_NAME] - **Fecha:** [DATE]
- **Responsable del Sistema:** [RESPONSIBLE] - **Fecha:** [DATE]
- **Aprobado por:** [APPROVER] - **Fecha:** [DATE]
```

## Consideraciones Importantes

### 1. Permisos de Google Workspace
- Asegúrate de tener permisos de administrador completo
- Configura políticas de grupo apropiadas
- Verifica que las políticas se apliquen correctamente

### 2. Sincronización de Evidencias
- Usa Google Drive File Stream para sincronización automática
- Configura permisos de acceso apropiados
- Mantén backup de evidencias en múltiples ubicaciones

### 3. Cumplimiento Normativo
- Verifica que las configuraciones cumplan con estándares de seguridad
- Documenta excepciones y justificaciones
- Mantén trazabilidad de cambios

### 4. Mantenimiento Continuo
- Programa auditorías periódicas
- Actualiza políticas según nuevas amenazas
- Mantén documentación actualizada

## Conclusión

Esta guía te proporciona un marco completo para implementar el checklist de seguridad de Windows 10/11 utilizando Google Workspace como plataforma de administración central. Siguiendo este proceso paso a paso, podrás:

1. **Implementar todas las configuraciones de seguridad** de manera sistemática
2. **Recolectar evidencia organizada** en Google Drive
3. **Mantener trazabilidad** de todos los cambios realizados
4. **Generar reportes de cumplimiento** automáticamente
5. **Facilitar auditorías futuras** con documentación completa

Recuerda adaptar las configuraciones según las políticas específicas de tu organización y mantener actualizada la documentación conforme evolucionen las amenazas y tecnologías de seguridad. 