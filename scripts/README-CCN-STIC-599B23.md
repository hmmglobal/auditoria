# Guía de Implementación CCN-STIC 599B23

## Descripción General

Este conjunto de scripts automatiza la implementación del estándar de seguridad **CCN-STIC 599B23** para Windows 10/11 en entornos con Google Workspace. Los scripts aplican configuraciones de seguridad específicas siguiendo las mejores prácticas del Centro Criptológico Nacional (CCN).

## Archivos Incluidos

### Scripts Principales
- `Install-CCN-STIC-599B23.ps1` - Script de instalación automatizada
- `Verify-CCN-STIC-Compliance.ps1` - Script de verificación de cumplimiento
- `Sign-PowerShellScripts.ps1` - Script para firmar digitalmente scripts
- `Configure-PowerShellExecutionPolicy.ps1` - Script para configurar políticas de ejecución

### Documentación
- `GUIA-FIRMA-DIGITAL-SCRIPTS.md` - Guía completa sobre firma digital
- `README-CCN-STIC-599B23.md` - Documentación principal

### Scripts CCN-STIC Originales
- `CCN-STIC-599B23 Cliente Independiente - Paso 1 - Servicios.bat`
- `CCN-STIC-599B23 Cliente Independiente - Paso 2 - GPO.bat`
- `CCN-STIC-599B23 Cliente Independiente - Paso 3 - Firewall.bat`
- `CCN-STIC-599B23 Cliente Independiente - Paso 4 - Aplica plantilla y reinicia.bat`

### Configuraciones Adicionales
- `CCN-STIC-599B23 Cliente Independiente - Windows Defender (Estandar).bat`
- `CCN-STIC-599B23 Cliente Independiente - Control Dispositivos.bat`
- `CCN-STIC-599B23 Cliente Independiente - Actualizaciones WU.bat`
- `CCN-STIC-599B23 Cliente Independiente - Acceso Remoto RDP (Estandar).bat`

### Archivos de Configuración
- `CCN-STIC-599B23 Incremental Servicios (Estandar).inf`
- `CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).inf`
- `CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).wfw`

## Requisitos Previos

### Permisos
- **Administrador local** en el equipo objetivo
- Acceso al Admin Console de Google Workspace (para configuraciones adicionales)

### Sistema Operativo
- Windows 10 (versión 1903 o posterior)
- Windows 11
- PowerShell 5.1 o superior

### Preparación
1. Crear directorio `C:\Scripts\ESTANDAR`
2. Copiar todos los archivos CCN-STIC al directorio
3. Verificar que todos los archivos están presentes
4. **Firmar scripts digitalmente** (recomendado)
5. **Configurar política de ejecución** de PowerShell

## Preparación y Firma Digital

### Paso 1: Firmar Scripts (Recomendado)

```powershell
# Crear certificado autofirmado y firmar scripts
.\Sign-PowerShellScripts.ps1 -CreateSelfSigned -Verbose

# O firmar scripts en directorio específico
.\Sign-PowerShellScripts.ps1 -ScriptsPath "C:\Scripts\ESTANDAR" -CreateSelfSigned -Verbose
```

### Paso 2: Configurar Política de Ejecución

```powershell
# Configurar política para permitir scripts firmados
.\Configure-PowerShellExecutionPolicy.ps1 -ExecutionPolicy RemoteSigned -Force -Verbose
```

## Instalación Automatizada

### Opción 1: Instalación Completa (Recomendada)

```powershell
# Ejecutar como Administrador
.\Install-CCN-STIC-599B23.ps1 -Verbose
```

### Opción 2: Instalación con Opciones Personalizadas

```powershell
# Instalación sin backup (solo para entornos de prueba)
.\Install-CCN-STIC-599B23.ps1 -SkipBackup -Verbose

# Instalación forzada (continúa aunque haya errores)
.\Install-CCN-STIC-599B23.ps1 -Force -Verbose

# Instalación con rutas personalizadas
.\Install-CCN-STIC-599B23.ps1 -ScriptsPath "D:\Scripts" -LogPath "D:\Logs" -Verbose
```

### Parámetros Disponibles

| Parámetro | Descripción | Valor por Defecto |
|-----------|-------------|-------------------|
| `-ScriptsPath` | Ruta a los scripts CCN-STIC | `C:\Scripts\ESTANDAR` |
| `-LogPath` | Ruta para logs y evidencias | `C:\evidencias` |
| `-SkipBackup` | Omitir creación de backup | `$false` |
| `-Force` | Continuar aunque haya errores | `$false` |
| `-Verbose` | Mostrar información detallada | `$false` |

## Verificación de Cumplimiento

### Verificación Básica

```powershell
# Verificación rápida
.\Verify-CCN-STIC-Compliance.ps1
```

### Verificación Completa con Reporte

```powershell
# Verificación con reporte detallado
.\Verify-CCN-STIC-Compliance.ps1 -GenerateReport -Verbose
```

### Verificación con Ruta Personalizada

```powershell
# Verificación con ruta personalizada
.\Verify-CCN-STIC-Compliance.ps1 -OutputPath "D:\Evidencias" -GenerateReport
```

## Instalación Manual (Paso a Paso)

Si prefieres ejecutar los scripts manualmente, sigue este orden:

### 1. Preparación
```powershell
# Crear directorios necesarios
New-Item -ItemType Directory -Path "C:\Scripts\ESTANDAR" -Force
New-Item -ItemType Directory -Path "C:\evidencias" -Force

# Copiar archivos CCN-STIC al directorio
Copy-Item "*.bat" -Destination "C:\Scripts\ESTANDAR\"
Copy-Item "*.inf" -Destination "C:\Scripts\ESTANDAR\"
Copy-Item "*.wfw" -Destination "C:\Scripts\ESTANDAR\"
```

### 2. Ejecución Manual de Scripts

```cmd
# Ejecutar como Administrador en CMD
cd C:\Scripts\ESTANDAR

# Paso 1: Configuración de Servicios
CCN-STIC-599B23 Cliente Independiente - Paso 1 - Servicios.bat

# Paso 2: Configuración de GPO
CCN-STIC-599B23 Cliente Independiente - Paso 2 - GPO.bat

# Paso 3: Configuración de Firewall
CCN-STIC-599B23 Cliente Independiente - Paso 3 - Firewall.bat

# Paso 4: Aplicar plantilla final
CCN-STIC-599B23 Cliente Independiente - Paso 4 - Aplica plantilla y reinicia.bat
```

### 3. Configuraciones Adicionales (Opcionales)

```cmd
# Windows Defender
CCN-STIC-599B23 Cliente Independiente - Windows Defender (Estandar).bat

# Control de Dispositivos
CCN-STIC-599B23 Cliente Independiente - Control Dispositivos.bat

# Actualizaciones de Windows
CCN-STIC-599B23 Cliente Independiente - Actualizaciones WU.bat

# Acceso Remoto RDP
CCN-STIC-599B23 Cliente Independiente - Acceso Remoto RDP (Estandar).bat
```

## Configuraciones Aplicadas

### Políticas de Contraseñas
- **Longitud mínima**: 10 caracteres
- **Complejidad**: Habilitada
- **Historial**: 24 contraseñas
- **Edad mínima**: 2 días
- **Edad máxima**: 60 días
- **Bloqueo**: 5 intentos fallidos
- **Duración de bloqueo**: Permanente

### Servicios Deshabilitados
- BcastDVRUserService
- BluetoothUserService
- CaptureService
- cbdhsvc
- CDPUserSvc
- ConsentUxUserSvc
- DevicePickerUserSvc
- DevicesFlowUserSvc
- MessagingService
- OneSyncSvc
- PimIndexMaintenanceSvc
- PrintWorkflowUserSvc
- UnistoreSvc
- UserDataSvc
- WpnUserService

### Servicios Manuales
- AarSvc
- CredentialEnrollmentManagerUserSvc
- DeviceAssociationBrokerSvc
- UdkUserSvc
- NPSMSvc
- P9RdrService
- PenService
- webthreatdefusersvc

### Configuración de Auditoría
- **Eventos del sistema**: Éxito y fracaso
- **Eventos de inicio de sesión**: Éxito y fracaso
- **Acceso a objetos**: Éxito y fracaso
- **Uso de privilegios**: Éxito y fracaso
- **Cambios de directiva**: Éxito y fracaso
- **Administración de cuentas**: Éxito y fracaso
- **Seguimiento de procesos**: Sin auditoría
- **Acceso al directorio**: Éxito y fracaso
- **Inicio de sesión de cuenta**: Éxito y fracaso

### Windows Defender
- **Protección en tiempo real**: Habilitada
- **Protección contra PUA**: Habilitada
- **Monitoreo de comportamiento**: Habilitado
- **Protección IOAV**: Habilitada
- **Protección de red**: Habilitada
- **Actualizaciones automáticas**: Habilitadas

### Configuración de Registro
- **RestrictAnonymous**: 1 (Habilitado)
- **NoLMHash**: 1 (Habilitado)
- **LimitBlankPasswordUse**: 1 (Habilitado)
- **ForceGuest**: 0 (Deshabilitado)
- **EveryoneIncludesAnonymous**: 0 (Deshabilitado)
- **DisableDomainCreds**: 1 (Habilitado)
- **CrashOnAuditFail**: 1 (Habilitado)

## Verificación Post-Instalación

### Comandos de Verificación Rápida

```powershell
# Verificar políticas de contraseñas
net accounts

# Verificar servicios críticos
Get-Service | Where-Object {$_.Name -in @("BcastDVRUserService","BluetoothUserService","CaptureService")} | Select-Object Name, StartType, Status

# Verificar configuración de auditoría
auditpol /get /category:*

# Verificar Windows Defender
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, BehaviorMonitorEnabled, IOAVProtectionEnabled

# Verificar configuración de registro
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" | Select-Object RestrictAnonymous, NoLMHash, LimitBlankPasswordUse
```

### Verificación Completa

```powershell
# Ejecutar script de verificación
.\Verify-CCN-STIC-Compliance.ps1 -GenerateReport -Verbose
```

## Integración con Google Workspace

### Configuraciones Recomendadas en Google Workspace Admin

1. **Políticas de Contraseñas**:
   - Longitud mínima: 10 caracteres
   - Complejidad requerida: Habilitada
   - Historial: 24 contraseñas

2. **Políticas de Sesión**:
   - Tiempo de inactividad: 10 minutos
   - Cierre de sesión automático: Habilitado
   - Autenticación de dos factores: Habilitada

3. **Políticas de Dispositivos**:
   - Cifrado de datos: Habilitado
   - Verificación de integridad: Habilitado
   - Políticas de acceso: Configuradas

### Configuración de Organizaciones
- Crear organizaciones específicas para diferentes tipos de dispositivos
- Aplicar políticas según el nivel de seguridad requerido
- Configurar acceso condicional según las necesidades

## Solución de Problemas

### Errores Comunes

#### Error: "No se pudo crear backup"
```powershell
# Solución: Usar modo forzado
.\Install-CCN-STIC-599B23.ps1 -Force -Verbose
```

#### Error: "Faltan archivos requeridos"
```powershell
# Verificar que todos los archivos estén en C:\Scripts\ESTANDAR
Get-ChildItem "C:\Scripts\ESTANDAR" | Select-Object Name
```

#### Error: "Este script requiere permisos de administrador"
```powershell
# Ejecutar PowerShell como Administrador
Start-Process PowerShell -Verb RunAs
```

#### Error: "No se puede cargar el archivo porque la ejecución de scripts está deshabilitada"
```powershell
# Verificar política actual
Get-ExecutionPolicy

# Cambiar política temporalmente
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

# Ejecutar script
.\Install-CCN-STIC-599B23.ps1

# Restaurar política
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
```

#### Error: "El archivo no está firmado digitalmente"
```powershell
# Firmar el script
.\Sign-PowerShellScripts.ps1 -CreateSelfSigned -Verbose

# O configurar política para permitir scripts no firmados (solo para desarrollo)
.\Configure-PowerShellExecutionPolicy.ps1 -ExecutionPolicy Unrestricted -Force -Verbose
```

#### Error: "Servicios no se configuraron correctamente"
```powershell
# Verificar logs de secedit
Get-Content "C:\Scripts\ESTANDAR\servicios_windows.log"
Get-Content "C:\Scripts\ESTANDAR\gpo_windows.log"
```

### Logs y Evidencias

Los scripts generan logs detallados en:
- `C:\evidencias\installation.log` - Log de instalación
- `C:\evidencias\verification.log` - Log de verificación
- `C:\evidencias\installation_report.md` - Reporte de instalación
- `C:\evidencias\compliance_report.md` - Reporte de cumplimiento
- `C:\evidencias\compliance_results.json` - Resultados en formato JSON

### Restauración

Si necesitas restaurar la configuración anterior:

```powershell
# Restaurar desde backup (si existe)
$backupPath = Get-ChildItem "C:\evidencias\backup_*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($backupPath) {
    secedit /configure /db "$backupPath\security_backup.inf" /log "$backupPath\restore.log"
}
```

## Notas Importantes

### Antes de la Instalación
1. **Hacer backup** del sistema
2. **Probar en entorno de laboratorio** antes de aplicar en producción
3. **Verificar compatibilidad** con aplicaciones críticas
4. **Notificar a usuarios** sobre posibles cambios en el comportamiento

### Durante la Instalación
1. **No interrumpir** la ejecución de los scripts
2. **Monitorear logs** para detectar errores
3. **Verificar** que cada paso se complete correctamente

### Después de la Instalación
1. **Reiniciar** el equipo si es necesario
2. **Verificar** que las aplicaciones funcionen correctamente
3. **Documentar** cualquier problema o excepción
4. **Generar reporte** de cumplimiento

### Consideraciones de Seguridad
- Las configuraciones aplicadas son **restrictivas** y pueden afectar la funcionalidad
- **Algunos servicios** pueden ser necesarios para aplicaciones específicas
- **Verificar compatibilidad** con software antivirus de terceros
- **Monitorear** logs de auditoría para detectar problemas

## Soporte y Contacto

Para problemas técnicos o preguntas sobre la implementación:

1. **Revisar logs** en `C:\evidencias\`
2. **Verificar documentación** del estándar CCN-STIC 599B23
3. **Consultar** con el equipo de seguridad de la organización
4. **Contactar** al administrador de sistemas

## Versiones y Actualizaciones

- **Versión actual**: 1.0
- **Fecha de última actualización**: $(Get-Date -Format "yyyy-MM-dd")
- **Estándar base**: CCN-STIC 599B23
- **Compatibilidad**: Windows 10/11

---

**Nota**: Este conjunto de scripts implementa configuraciones de seguridad específicas del estándar CCN-STIC 599B23. Asegúrese de que estas configuraciones sean apropiadas para su entorno antes de aplicarlas. 