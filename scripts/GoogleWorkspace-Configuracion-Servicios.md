# Configuración de Servicios - Google Workspace

## Elementos manejados en Google Workspace

### ✅ Windows Update configurado como automático
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Configuración de dispositivos > Actualizaciones

**Configuración recomendada:**
- Modo de actualización: Automático
- Horario de instalación: 03:00 AM
- Reinicio automático: Habilitado
- Notificaciones: Configuradas

**Pasos de configuración:**
1. Ir a Admin Console
2. Navegar a Dispositivos > Configuración de dispositivos
3. Buscar "Actualizaciones"
4. Configurar políticas de Windows Update
5. Aplicar a todos los dispositivos

### ✅ Windows Defender habilitado
**Ubicación en Google Workspace:**
- Admin Console > Seguridad > Endpoint Management > Windows Defender

**Configuración recomendada:**
- Protección en tiempo real: Habilitada
- Protección basada en la nube: Habilitada
- Envío automático de muestras: Habilitado
- Protección contra ransomware: Habilitada
- Control de acceso a carpetas: Habilitado

**Pasos de configuración:**
1. Ir a Admin Console
2. Navegar a Seguridad > Endpoint Management
3. Buscar "Windows Defender"
4. Configurar políticas de protección
5. Aplicar a todos los dispositivos

### ✅ Firewall de Windows habilitado
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Configuración de red > Firewall

**Configuración recomendada:**
- Firewall habilitado: Sí
- Bloquear conexiones entrantes: Sí
- Notificar cuando se bloquea: Sí
- Permitir aplicaciones específicas: Configurar lista

**Pasos de configuración:**
1. Ir a Admin Console
2. Navegar a Dispositivos > Configuración de red
3. Buscar "Firewall"
4. Configurar reglas de firewall
5. Aplicar a todos los dispositivos

## Elementos que requieren scripts de Windows

### ❌ Telnet deshabilitado
**Razón:** Servicio local de Windows que no se puede manejar desde Google Workspace
**Script:** `03-Configuracion-Servicios.bat`

### ❌ TFTP deshabilitado
**Razón:** Servicio local de Windows que no se puede manejar desde Google Workspace
**Script:** `03-Configuracion-Servicios.bat`

### ❌ SNMP deshabilitado
**Razón:** Servicio local de Windows que no se puede manejar desde Google Workspace
**Script:** `03-Configuracion-Servicios.bat`

### ❌ Alerter deshabilitado
**Razón:** Servicio local de Windows que no se puede manejar desde Google Workspace
**Script:** `03-Configuracion-Servicios.bat`

### ❌ Messenger deshabilitado
**Razón:** Servicio local de Windows que no se puede manejar desde Google Workspace
**Script:** `03-Configuracion-Servicios.bat`

## Comandos de verificación

### Para Google Workspace:
```bash
# Verificar políticas de actualización
gcloud admin-sdk directory devices list --query="osVersion=Windows"

# Verificar configuración de seguridad
gcloud admin-sdk directory devices list --query="securityStatus=COMPLIANT"
```

### Para Windows (script):
```cmd
# Verificar estado de servicios
sc query TlntSvr
sc query tftpd
sc query SNMP
sc query Alerter
sc query Messenger
sc query wuauserv
sc query WinDefend
sc query MpsSvc
```

## Evidencias requeridas

### Google Workspace:
- Capturas de pantalla de políticas de actualización
- Capturas de pantalla de configuración de Windows Defender
- Capturas de pantalla de reglas de firewall
- Reportes de cumplimiento de dispositivos

### Windows:
- Reporte de estado de servicios
- Capturas de pantalla de servicios.msc
- Logs de eventos de servicios

## Notas importantes

1. **Servicios locales:** Los servicios como Telnet, TFTP, SNMP, Alerter y Messenger deben configurarse individualmente en cada dispositivo
2. **Políticas centralizadas:** Windows Update, Windows Defender y Firewall pueden configurarse globalmente desde Google Workspace
3. **Verificación:** Siempre verificar que los servicios estén en el estado correcto después de aplicar configuraciones
4. **Compatibilidad:** Algunos servicios pueden ser necesarios para aplicaciones específicas

## Próximos pasos

1. Configurar políticas de Windows Update en Google Workspace
2. Configurar políticas de Windows Defender en Google Workspace
3. Configurar reglas de firewall en Google Workspace
4. Ejecutar script de Windows en cada dispositivo
5. Verificar que todos los servicios estén configurados correctamente
6. Documentar evidencias en Google Drive 