# Checklist de Seguridad CCN-STIC 599B23 para Windows 10/11 con Google Workspace

## Información General
- **Estándar**: CCN-STIC 599B23
- **Versión**: Cliente Independiente (Estandar)
- **Fecha**: $(Get-Date -Format "yyyy-MM-dd")
- **Auditor**: [Nombre del Auditor]
- **Equipo**: [Nombre/IP del Equipo]

---

## 1. PREPARACIÓN Y EJECUCIÓN DE SCRIPTS CCN-STIC

### 1.1 Preparación del Entorno
- [ ] Crear directorio `C:\Scripts\ESTANDAR`
- [ ] Copiar todos los scripts CCN-STIC al directorio
- [ ] Verificar que se ejecuta como Administrador
- [ ] Hacer backup del sistema antes de ejecutar scripts

### 1.2 Ejecución de Scripts en Orden
- [ ] **Paso 1**: Ejecutar `CCN-STIC-599B23 Cliente Independiente - Paso 1 - Servicios.bat`
- [ ] **Paso 2**: Ejecutar `CCN-STIC-599B23 Cliente Independiente - Paso 2 - GPO.bat`
- [ ] **Paso 3**: Ejecutar `CCN-STIC-599B23 Cliente Independiente - Paso 3 - Firewall.bat`
- [ ] **Paso 4**: Ejecutar `CCN-STIC-599B23 Cliente Independiente - Paso 4 - Aplica plantilla y reinicia.bat`

### 1.3 Configuraciones Adicionales (Opcionales)
- [ ] Windows Defender: `CCN-STIC-599B23 Cliente Independiente - Windows Defender (Estandar).bat`
- [ ] Control de Dispositivos: `CCN-STIC-599B23 Cliente Independiente - Control Dispositivos.bat`
- [ ] Actualizaciones WU: `CCN-STIC-599B23 Cliente Independiente - Actualizaciones WU.bat`
- [ ] Acceso Remoto RDP: `CCN-STIC-599B23 Cliente Independiente - Acceso Remoto RDP (Estandar).bat`

---

## 2. POLÍTICAS DE CONTRASEÑAS (System Access)

### 2.1 Configuración de Contraseñas
- [ ] **Edad mínima de contraseña**: 2 días
- [ ] **Edad máxima de contraseña**: 60 días
- [ ] **Longitud mínima de contraseña**: 10 caracteres
- [ ] **Complejidad de contraseña**: Habilitada
- [ ] **Historial de contraseñas**: 24 contraseñas

### 2.2 Bloqueo de Cuentas
- [ ] **Número de intentos fallidos**: 5 intentos
- [ ] **Tiempo de reinicio de contador**: 15 minutos
- [ ] **Duración del bloqueo**: Permanente (hasta desbloqueo manual)
- [ ] **Bloqueo de cuenta de administrador**: Habilitado

### 2.3 Cuentas del Sistema
- [ ] **Nuevo nombre de administrador**: "aCdCmN599"
- [ ] **Nuevo nombre de invitado**: "iCnCvN599"
- [ ] **Contraseñas en texto claro**: Deshabilitado
- [ ] **Búsqueda anónima LSA**: Deshabilitado
- [ ] **Cuenta de administrador**: Deshabilitada
- [ ] **Cuenta de invitado**: Deshabilitada

**Comando de verificación**:
```powershell
secedit /export /cfg C:\temp\security_policy.inf
Get-Content C:\temp\security_policy.inf | Select-String -Pattern "MinimumPasswordAge|MaximumPasswordAge|MinimumPasswordLength|PasswordComplexity|PasswordHistorySize|LockoutBadCount"
```

---

## 3. CONFIGURACIÓN DE SERVICIOS

### 3.1 Servicios Deshabilitados (Start=4)
- [ ] BcastDVRUserService
- [ ] BluetoothUserService
- [ ] CaptureService
- [ ] cbdhsvc
- [ ] CDPUserSvc
- [ ] ConsentUxUserSvc
- [ ] DevicePickerUserSvc
- [ ] DevicesFlowUserSvc
- [ ] MessagingService
- [ ] OneSyncSvc
- [ ] PimIndexMaintenanceSvc
- [ ] PrintWorkflowUserSvc
- [ ] UnistoreSvc
- [ ] UserDataSvc
- [ ] WpnUserService

### 3.2 Servicios Manuales (Start=3)
- [ ] AarSvc
- [ ] CredentialEnrollmentManagerUserSvc
- [ ] DeviceAssociationBrokerSvc
- [ ] UdkUserSvc
- [ ] NPSMSvc
- [ ] P9RdrService
- [ ] PenService
- [ ] webthreatdefusersvc

**Comando de verificación**:
```powershell
Get-Service | Where-Object {$_.Name -in @("BcastDVRUserService","BluetoothUserService","CaptureService","cbdhsvc","CDPUserSvc")} | Select-Object Name, StartType, Status
```

---

## 4. CONFIGURACIÓN DE AUDITORÍA

### 4.1 Configuración de Logs
- [ ] **Tamaño máximo del log del sistema**: 32768 KB
- [ ] **Tamaño máximo del log de seguridad**: 16384 KB
- [ ] **Tamaño máximo del log de aplicaciones**: 32768 KB
- [ ] **Acceso de invitado restringido**: Habilitado

### 4.2 Políticas de Auditoría
- [ ] **Eventos del sistema**: Auditoría de éxito y fracaso
- [ ] **Eventos de inicio de sesión**: Auditoría de éxito y fracaso
- [ ] **Acceso a objetos**: Auditoría de éxito y fracaso
- [ ] **Uso de privilegios**: Auditoría de éxito y fracaso
- [ ] **Cambios de directiva**: Auditoría de éxito y fracaso
- [ ] **Administración de cuentas**: Auditoría de éxito y fracaso
- [ ] **Seguimiento de procesos**: Sin auditoría
- [ ] **Acceso al directorio**: Auditoría de éxito y fracaso
- [ ] **Inicio de sesión de cuenta**: Auditoría de éxito y fracaso

**Comando de verificación**:
```powershell
auditpol /get /category:*
```

---

## 5. SEGURIDAD DE ARCHIVOS Y PERMISOS

### 5.1 Archivos del Sistema Protegidos
- [ ] clip.exe - Solo Administradores y Sistema
- [ ] ChatApis.dll - Solo Administradores
- [ ] cacls.exe - Solo Administradores y Sistema
- [ ] regedit.exe - Solo Administradores y Sistema
- [ ] ftp.exe - Solo Administradores y Sistema
- [ ] icacls.exe - Solo Administradores y Sistema
- [ ] nbtstat.exe - Solo Administradores y Sistema
- [ ] SecEdit.exe - Solo Administradores y Sistema
- [ ] TRACERT.EXE - Solo Administradores y Sistema

### 5.2 Directorios Protegidos
- [ ] %SystemRoot%\security - Solo Administradores y Sistema
- [ ] %SystemRoot%\Registration - Restringido
- [ ] %SystemDrive%\Users\Default - Restringido
- [ ] %SystemDrive%\Users\Public - Restringido
- [ ] %SystemRoot%\Logs - Restringido
- [ ] %SystemRoot%\system32\winevt\Logs - Restringido

**Comando de verificación**:
```powershell
icacls "C:\Windows\System32\clip.exe"
icacls "C:\Windows\System32\regedit.exe"
```

---

## 6. PRIVILEGIOS DEL SISTEMA

### 6.1 Privilegios Restringidos
- [ ] **SeTakeOwnershipPrivilege**: Solo Administradores
- [ ] **SeNetworkLogonRight**: Usuarios y Administradores
- [ ] **SeImpersonatePrivilege**: Servicios del sistema, servicio de red, servicio local, Administradores
- [ ] **SeRestorePrivilege**: Operadores de copia de seguridad y Administradores
- [ ] **SeManageVolumePrivilege**: Solo Administradores
- [ ] **SeUndockPrivilege**: Solo Administradores
- [ ] **SeChangeNotifyPrivilege**: Usuarios autenticados, servicios del sistema, servicio de red, Administradores
- [ ] **SeDelegateSessionUserImpersonatePrivilege**: Solo Administradores
- [ ] **SeSystemEnvironmentPrivilege**: Solo Administradores
- [ ] **SeBackupPrivilege**: Operadores de copia de seguridad y Administradores
- [ ] **SeSystemProfilePrivilege**: Solo Administradores
- [ ] **SeProfileSingleProcessPrivilege**: Solo Administradores
- [ ] **SeAuditPrivilege**: Servicios del sistema y servicio de red
- [ ] **SeRemoteShutdownPrivilege**: Solo Administradores
- [ ] **SeSecurityPrivilege**: Solo Administradores

### 6.2 Derechos Denegados
- [ ] **SeDenyRemoteInteractiveLogonRight**: Todos los usuarios
- [ ] **SeDenyInteractiveLogonRight**: Usuarios invitados y usuarios anónimos
- [ ] **SeDenyBatchLogonRight**: Usuarios invitados y usuarios anónimos
- [ ] **SeDenyServiceLogonRight**: Usuarios invitados y usuarios anónimos
- [ ] **SeDenyNetworkLogonRight**: Usuarios invitados y usuarios anónimos

**Comando de verificación**:
```powershell
secedit /export /cfg C:\temp\privileges.inf
Get-Content C:\temp\privileges.inf | Select-String -Pattern "SeTakeOwnershipPrivilege|SeNetworkLogonRight|SeImpersonatePrivilege"
```

---

## 7. CONFIGURACIÓN DE REGISTRO

### 7.1 Configuración de LSA
- [ ] **LDAPServerIntegrity**: 2 (Requerir firma)
- [ ] **LdapEnforceChannelBinding**: 2 (Requerido)
- [ ] **VulnerableChannelAllowList**: Vacío
- [ ] **SignSecureChannel**: 1 (Habilitado)
- [ ] **SealSecureChannel**: 1 (Habilitado)
- [ ] **RestrictNTLMInDomain**: 1 (Habilitado)
- [ ] **RequireStrongKey**: 1 (Habilitado)
- [ ] **RequireSignOrSeal**: 1 (Habilitado)
- [ ] **AuditNTLMInDomain**: 7 (Auditoría completa)
- [ ] **LDAPClientIntegrity**: 1 (Habilitado)

### 7.2 Configuración de Red
- [ ] **RequireSecuritySignature**: 1 (Habilitado)
- [ ] **EnableSecuritySignature**: 1 (Habilitado)
- [ ] **EnablePlainTextPassword**: 0 (Deshabilitado)
- [ ] **SmbServerNameHardeningLevel**: 2 (Máximo)
- [ ] **RestrictNullSessAccess**: 1 (Habilitado)
- [ ] **NullSessionShares**: Vacío
- [ ] **NullSessionPipes**: Vacío

### 7.3 Configuración de Sesión
- [ ] **ProtectionMode**: 1 (Habilitado)
- [ ] **ClearPageFileAtShutdown**: 1 (Habilitado)
- [ ] **AddPrinterDrivers**: 1 (Habilitado)
- [ ] **UseMachineId**: 1 (Habilitado)
- [ ] **RestrictAnonymousSAM**: 1 (Habilitado)
- [ ] **RestrictAnonymous**: 1 (Habilitado)
- [ ] **AllowOnlineID**: 0 (Deshabilitado)
- [ ] **NoLMHash**: 1 (Habilitado)
- [ ] **LimitBlankPasswordUse**: 1 (Habilitado)
- [ ] **ForceGuest**: 0 (Deshabilitado)
- [ ] **EveryoneIncludesAnonymous**: 0 (Deshabilitado)
- [ ] **DisableDomainCreds**: 1 (Habilitado)
- [ ] **CrashOnAuditFail**: 1 (Habilitado)

**Comando de verificación**:
```powershell
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" | Select-Object LDAPServerIntegrity, LdapEnforceChannelBinding
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" | Select-Object RestrictAnonymous, NoLMHash, LimitBlankPasswordUse
```

---

## 8. CONFIGURACIÓN DE WINDOWS DEFENDER

### 8.1 Configuración General
- [ ] **PUAProtection**: 1 (Habilitado)
- [ ] **DisableAntiSpyware**: 0 (Habilitado)
- [ ] **DisableRoutinelyTakingAction**: 0 (Habilitado)
- [ ] **ServiceKeepAlive**: 1 (Habilitado)
- [ ] **RandomizeScheduleTaskTimes**: 0 (Deshabilitado)

### 8.2 Actualizaciones de Firmas
- [ ] **DisableScanOnUpdate**: 0 (Habilitado)
- [ ] **UpdateOnStartUp**: 1 (Habilitado)
- [ ] **ASSignatureDue**: 7 días
- [ ] **AVSignatureDue**: 7 días
- [ ] **SignatureUpdateCatchupInterval**: 1 día
- [ ] **SignatureUpdateInterval**: 24 horas

### 8.3 Configuración de Escaneo
- [ ] **DisableHeuristics**: 0 (Habilitado)
- [ ] **CheckForSignaturesBeforeRunningScan**: 1 (Habilitado)
- [ ] **ScheduleDay**: 1 (Domingo)
- [ ] **QuickScanInterval**: 24 horas
- [ ] **ScanParameters**: 2 (Escaneo completo)
- [ ] **ScheduleQuickScanTime**: 60 minutos
- [ ] **ScheduleTime**: 120 minutos
- [ ] **DisableScanningMappedNetworkDrivesForFullScan**: 0 (Habilitado)
- [ ] **DisableArchiveScanning**: 0 (Habilitado)
- [ ] **DisablePackedExeScanning**: 0 (Habilitado)
- [ ] **DisableRemovableDriveScanning**: 0 (Habilitado)
- [ ] **AllowPause**: 0 (Deshabilitado)

### 8.4 Protección en Tiempo Real
- [ ] **DisableScanOnRealtimeEnable**: 0 (Habilitado)
- [ ] **DisableScriptScanning**: 0 (Habilitado)
- [ ] **DisableRawWriteNotification**: 0 (Habilitado)
- [ ] **DisableBehaviorMonitoring**: 0 (Habilitado)
- [ ] **DisableRealtimeMonitoring**: 0 (Habilitado)
- [ ] **DisableIOAVProtection**: 0 (Habilitado)
- [ ] **DisableOnAccessProtection**: 0 (Habilitado)

### 8.5 Protección de Red
- [ ] **EnableNetworkProtection**: 1 (Habilitado)
- [ ] **DisableProtocolRecognition**: 0 (Habilitado)
- [ ] **DisableDatagramProcessing**: 1 (Deshabilitado)
- [ ] **DisableSignatureRetirement**: 0 (Habilitado)

**Comando de verificación**:
```powershell
Get-MpPreference | Select-Object PUAProtection, DisableAntiSpyware, ServiceKeepAlive
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, BehaviorMonitorEnabled, IOAVProtectionEnabled
```

---

## 9. CONFIGURACIÓN DE GOOGLE WORKSPACE

### 9.1 Políticas de Contraseñas (Google Workspace Admin)
- [ ] **Longitud mínima de contraseña**: 10 caracteres
- [ ] **Complejidad requerida**: Habilitada
- [ ] **Historial de contraseñas**: 24 contraseñas
- [ ] **Edad mínima de contraseña**: 2 días
- [ ] **Edad máxima de contraseña**: 60 días

### 9.2 Políticas de Sesión
- [ ] **Tiempo de inactividad**: 10 minutos
- [ ] **Cierre de sesión automático**: Habilitado
- [ ] **Requerir autenticación de dos factores**: Habilitado

### 9.3 Políticas de Dispositivos
- [ ] **Cifrado de datos**: Habilitado
- [ ] **Verificación de integridad**: Habilitado
- [ ] **Políticas de acceso**: Configuradas
- [ ] **Organización de dispositivos**: Configurada

**Comando de verificación**:
```powershell
# Verificar configuración de Google Workspace
# Nota: Requiere acceso al Admin Console de Google Workspace
```

---

## 10. CONFIGURACIÓN DE FIREWALL

### 10.1 Perfiles de Firewall
- [ ] **Perfil de dominio**: Configurado
- [ ] **Perfil privado**: Configurado
- [ ] **Perfil público**: Configurado

### 10.2 Reglas de Firewall
- [ ] **Reglas de entrada**: Restringidas
- [ ] **Reglas de salida**: Configuradas
- [ ] **Reglas de conexión**: Configuradas

**Comando de verificación**:
```powershell
Get-NetFirewallProfile | Select-Object Name, Enabled, LogFileName
Get-NetFirewallRule | Where-Object {$_.Enabled -eq "True"} | Select-Object DisplayName, Direction, Action
```

---

## 11. CONFIGURACIÓN DE ACTUALIZACIONES

### 11.1 Windows Update
- [ ] **Actualizaciones automáticas**: Habilitadas
- [ ] **Notificaciones de actualizaciones**: Configuradas
- [ ] **Reinicio automático**: Configurado
- [ ] **Actualizaciones de definiciones**: Automáticas

### 11.2 Google Workspace Updates
- [ ] **Actualizaciones de Chrome**: Automáticas
- [ ] **Actualizaciones de aplicaciones**: Configuradas
- [ ] **Políticas de actualización**: Aplicadas

**Comando de verificación**:
```powershell
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" | Select-Object NoAutoUpdate, AUOptions, ScheduledInstallDay, ScheduledInstallTime
```

---

## 12. CONFIGURACIÓN DE ACCESO REMOTO

### 12.1 Remote Desktop (RDP)
- [ ] **RDP habilitado**: Solo si es necesario
- [ ] **Autenticación de nivel de red**: Habilitada
- [ ] **Conexiones de red**: Restringidas
- [ ] **Cifrado**: Configurado

### 12.2 Acceso Remoto Alternativo
- [ ] **VPN**: Configurado si es necesario
- [ ] **Acceso web**: Configurado
- [ ] **Autenticación multifactor**: Habilitada

**Comando de verificación**:
```powershell
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" | Select-Object fDenyTSConnections
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | Select-Object SecurityLayer, UserAuthentication
```

---

## 13. CONFIGURACIÓN DE CONTROL DE DISPOSITIVOS

### 13.1 Dispositivos USB
- [ ] **Almacenamiento USB**: Restringido
- [ ] **Dispositivos de entrada**: Configurados
- [ ] **Dispositivos de red**: Restringidos

### 13.2 Dispositivos de Almacenamiento
- [ ] **Discos duros externos**: Restringidos
- [ ] **Tarjetas de memoria**: Restringidas
- [ ] **Dispositivos de copia de seguridad**: Configurados

**Comando de verificación**:
```powershell
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" | Select-Object Start
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices" | Select-Object Deny_All
```

---

## 14. VERIFICACIÓN FINAL Y EVIDENCIAS

### 14.1 Verificación de Configuración
- [ ] Ejecutar script de verificación completo
- [ ] Revisar logs de aplicación de políticas
- [ ] Verificar que no hay errores en la aplicación
- [ ] Confirmar que todos los servicios están en el estado correcto

### 14.2 Recolección de Evidencias
- [ ] Exportar configuración de seguridad actual
- [ ] Capturar pantallas de configuración crítica
- [ ] Generar reporte de cumplimiento
- [ ] Documentar cualquier desviación o excepción

**Comandos de verificación final**:
```powershell
# Exportar configuración completa
secedit /export /cfg C:\evidencias\configuracion_final.inf

# Verificar servicios críticos
Get-Service | Where-Object {$_.StartType -eq "Disabled"} | Select-Object Name, Status

# Verificar políticas de contraseñas
net accounts

# Verificar configuración de auditoría
auditpol /get /category:*

# Generar reporte de cumplimiento
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory
```

---

## 15. DOCUMENTACIÓN Y REPORTES

### 15.1 Documentación Requerida
- [ ] Checklist completado y firmado
- [ ] Evidencias de configuración
- [ ] Logs de aplicación de políticas
- [ ] Reporte de cumplimiento
- [ ] Documentación de excepciones

### 15.2 Archivos de Evidencia
- [ ] `configuracion_final.inf`
- [ ] `servicios_windows.log`
- [ ] `gpo_windows.log`
- [ ] `firewall_windows.log`
- [ ] Capturas de pantalla de configuración
- [ ] Reporte de cumplimiento final

---

## NOTAS IMPORTANTES

1. **Orden de ejecución**: Los scripts CCN-STIC deben ejecutarse en el orden especificado (Paso 1, 2, 3, 4)
2. **Permisos**: Todos los scripts requieren ejecución como Administrador
3. **Backup**: Siempre hacer backup del sistema antes de aplicar configuraciones
4. **Pruebas**: Probar en un entorno de laboratorio antes de aplicar en producción
5. **Documentación**: Mantener registro detallado de todas las configuraciones aplicadas
6. **Verificación**: Confirmar que las configuraciones se aplicaron correctamente
7. **Excepciones**: Documentar cualquier configuración que no se pueda aplicar y su justificación

---

## FIRMAS

**Auditor**: _________________  **Fecha**: _________________

**Administrador del Sistema**: _________________  **Fecha**: _________________

**Revisor**: _________________  **Fecha**: _________________

---

*Este checklist está basado en el estándar CCN-STIC 599B23 para clientes independientes y ha sido adaptado para entornos con Google Workspace.* 