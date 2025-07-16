# Configuraciones de Seguridad - Google Workspace

## 2.1 Windows Defender

### ✅ Todas las configuraciones se manejan en Google Workspace
**Ubicación en Google Workspace:**
- Admin Console > Seguridad > Endpoint Management > Windows Defender

### Configuraciones disponibles:
- **Protección en tiempo real habilitada**
- **Protección basada en la nube habilitada**
- **Envío automático de muestras habilitado**
- **Protección contra ransomware habilitada**
- **Control de acceso a carpetas habilitado**
- **Definiciones de virus actualizadas**
- **Escaneo automático configurado**

### Pasos de configuración:
1. Ir a Admin Console
2. Navegar a Seguridad > Endpoint Management
3. Buscar "Windows Defender"
4. Configurar todas las protecciones
5. Aplicar a todos los dispositivos

## 2.2 BitLocker

### ✅ Todas las configuraciones se manejan en Google Workspace
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Configuración de seguridad > BitLocker

### Configuraciones disponibles:
- **Cifrado de disco completo habilitado**
- **TPM + PIN configurado**
- **Recuperación de claves habilitada**
- **Backup de claves configurado**
- **Estado de cifrado verificado**

### Pasos de configuración:
1. Ir a Admin Console
2. Navegar a Dispositivos > Configuración de seguridad
3. Buscar "BitLocker"
4. Configurar cifrado y recuperación
5. Aplicar a todos los dispositivos

## 2.3 Windows Hello

### ✅ Todas las configuraciones se manejan en Google Workspace
**Ubicación en Google Workspace:**
- Admin Console > Seguridad > Autenticación > Windows Hello

### Configuraciones disponibles:
- **Autenticación biométrica habilitada**
- **PIN complejo configurado**
- **Windows Hello for Business habilitado**
- **Configuración de seguridad verificada**

### Pasos de configuración:
1. Ir a Admin Console
2. Navegar a Seguridad > Autenticación
3. Buscar "Windows Hello"
4. Configurar autenticación biométrica y PIN
5. Aplicar a todos los dispositivos

## 2.4 Políticas de Aplicaciones

### ✅ Todas las configuraciones se manejan en Google Workspace
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Políticas de aplicaciones

### Configuraciones disponibles:
- **AppLocker configurado**
- **SmartScreen habilitado**
- **UAC configurado apropiadamente**
- **Políticas de ejecución aplicadas**

### Pasos de configuración:
1. Ir a Admin Console
2. Navegar a Dispositivos > Políticas de aplicaciones
3. Configurar AppLocker, SmartScreen, UAC
4. Aplicar a todos los dispositivos

## Comandos de verificación

### Para Google Workspace:
```bash
# Verificar políticas de seguridad
gcloud admin-sdk directory devices list --query="securityStatus=COMPLIANT"

# Verificar configuración de Windows Defender
gcloud admin-sdk directory devices list --query="defenderStatus=ENABLED"

# Verificar configuración de BitLocker
gcloud admin-sdk directory devices list --query="bitlockerStatus=ENCRYPTED"
```

### Para Windows (verificación local):
```cmd
# Windows Defender
powershell -Command "Get-MpComputerStatus"

# BitLocker
manage-bde -status

# Windows Hello
powershell -Command "Get-WmiObject -Class Win32_TPM"

# Políticas de aplicaciones
powershell -Command "Get-AppLockerPolicy -Effective"
```

## Evidencias requeridas

### Google Workspace:
- Capturas de pantalla de políticas de Windows Defender
- Capturas de pantalla de configuración de BitLocker
- Capturas de pantalla de configuración de Windows Hello
- Capturas de pantalla de políticas de aplicaciones
- Reportes de cumplimiento de seguridad

### Windows:
- Reportes de verificación local
- Capturas de pantalla de estado de servicios
- Logs de eventos de seguridad

## Notas importantes

1. **Configuración centralizada:** Todas las configuraciones de seguridad se manejan desde Google Workspace
2. **Verificación local:** Los scripts solo verifican el estado actual
3. **Cumplimiento:** Google Workspace proporciona reportes de cumplimiento automáticos
4. **Actualizaciones:** Las políticas se aplican automáticamente a todos los dispositivos
5. **Monitoreo:** Google Workspace permite monitorear el estado de seguridad en tiempo real

## Próximos pasos

1. Configurar todas las políticas de seguridad en Google Workspace
2. Ejecutar scripts de verificación en cada dispositivo
3. Verificar que las políticas se hayan aplicado correctamente
4. Documentar evidencias en Google Drive
5. Configurar alertas de cumplimiento en Google Workspace
6. Revisar reportes de seguridad regularmente 