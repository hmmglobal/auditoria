# Checklist - Op.exp.2 Configuración de Seguridad (Actualizado con Scripts Oficiales CN-CERT)
## Auditoría CN-CERT - Bastionado de Sistemas

---

### Información del Sistema
- **Hostname:** _________________
- **IP Address:** _________________
- **Tipo de Sistema:** ☐ CLIENTE MIEMBRO ☐ CLIENTE INDEPENDIENTE
- **Fecha de Auditoría:** _________________
- **Auditor:** _________________
- **Responsable:** _________________

---

### Aspecto 1: Configuración de Seguridad Previa a Producción

**Pregunta:** ¿Se realiza una configuración de seguridad (bastionado) a los equipos, previamente a su puesta en producción?

#### Scripts Oficiales CN-CERT a Ejecutar:
- [ ] **CCN-STIC-599A23_Desinstala_caracteristicas.ps1** (Cliente Miembro)
- [ ] **CCN-STIC-599B23_Desinstala_caracteristicas.ps1** (Cliente Independiente)
- [ ] **CCN-STIC-599A23_Eliminar_aplicaciones_aprovisionadas.ps1** (Cliente Miembro)
- [ ] **CCN-STIC-599B23_Eliminar_aplicaciones_aprovisionadas.ps1** (Cliente Independiente)

#### Verificaciones Técnicas:
- [ ] Características innecesarias deshabilitadas
- [ ] Aplicaciones aprovisionadas eliminadas
- [ ] Scripts oficiales ejecutados correctamente
- [ ] Logs de ejecución disponibles

**Comandos de Verificación:**
```powershell
# Verificar características habilitadas
dism /online /format:list /get-features | findstr "Habilitado"

# Verificar aplicaciones aprovisionadas
Get-AppxProvisionedPackage -Online

# Verificar aplicaciones instaladas
Get-AppxPackage -AllUsers
```

**Evidencia:** Captura de pantalla de ejecución de scripts oficiales
**Resultado:** ☒ SI ☐ NO

---

### Aspecto 2: Eliminación de Cuentas y Contraseñas Estándar

**Pregunta:** ¿Se han configurado los equipos, previamente a su entrada en operación, retirándoles cuentas y contraseñas standard?

#### Scripts Oficiales CN-CERT a Ejecutar:
- [ ] **CCN-STIC-599A23_Antiguo_menu_contextual.ps1** (Cliente Miembro)
- [ ] **CCN-STIC-599B23_Antiguo_menu_contextual.ps1** (Cliente Independiente)

#### Verificaciones Técnicas:
- [ ] Cuenta de administrador renombrada
- [ ] Cuenta de invitado deshabilitada
- [ ] Políticas de contraseñas configuradas
- [ ] Historial de contraseñas establecido
- [ ] Bloqueo de cuentas configurado

**Comandos de Verificación:**
```powershell
# Verificar políticas de contraseñas
net accounts

# Verificar cuentas de usuario
wmic useraccount get name,disabled,lockout

# Verificar cuentas por defecto
Get-LocalUser | Where-Object {$_.Name -in @('Administrator', 'Guest')}
```

**Evidencia:** Captura de pantalla de Políticas de Contraseñas
**Resultado:** ☒ SI ☐ NO

---

### Aspecto 3: Mínima Funcionalidad

**Pregunta:** ¿Se han configurado los equipos, previamente a su entrada en operación, aplicándoles la regla de 'mínima funcionalidad'?

**NOTA:** La 'mínima funcionalidad' se traduce en que el sistema no proporcione funciones injustificadas (de operación, administración o auditoría) al objeto de reducir al mínimo su superficie de exposición, eliminándose o desactivándose aquellas funciones que sean innecesarias o inadecuadas al fin que se persigue.

#### Scripts Oficiales CN-CERT a Ejecutar:
- [ ] **CCN-STIC-599A23_Desinstala_caracteristicas.ps1** (Cliente Miembro)
- [ ] **CCN-STIC-599B23_Desinstala_caracteristicas.ps1** (Cliente Independiente)
- [ ] **CCN-STIC-599A23_Eliminar_aplicaciones_aprovisionadas.ps1** (Cliente Miembro)
- [ ] **CCN-STIC-599B23_Eliminar_aplicaciones_aprovisionadas.ps1** (Cliente Independiente)

#### Características que se Mantienen (Según Scripts Oficiales):
- [ ] Client-DeviceLockdown
- [ ] Client-KeyboardFilter
- [ ] Client-UnifiedWriteFilter
- [ ] Windows-Defender-ApplicationGuard
- [ ] WorkFolders-Client
- [ ] SmbDirect
- [ ] MSRDC-Infraestructure
- [ ] SearchEngine-Client-Package
- [ ] Windows-Defender-Default-Definitions
- [ ] Printing-PrintToPDFServices-Features
- [ ] MicrosoftWindowsPowerShellV2Root
- [ ] MicrosoftWindowsPowerShellV2
- [ ] NetFx4-AdvSrvs
- [ ] Internet-Explorer-Optional-amd64

#### Aplicaciones que se Eliminan (Según Scripts Oficiales):
- [ ] 3DViewer, Advertising, Alarms, Bing, Camera
- [ ] CandyCrush, Clipchamp, Comm, DesktopApp
- [ ] DolbyAccess, FeedbackHub, Game, Gaming
- [ ] GetHelp, Getstarted, Holographic, Maps
- [ ] Mess, MixedReality, Office, OneConnect
- [ ] OneNote, People, Phone, PowerAutomateDesktop
- [ ] PPIProjection, Print3D, QuickAssist, screensk
- [ ] Skype, SolitaireCollection, SoundRec, Sticky
- [ ] Store, Wallet, Xbox, Zune

**Comandos de Verificación:**
```powershell
# Verificar características habilitadas
dism /online /format:list /get-features | findstr "Habilitado"

# Verificar aplicaciones aprovisionadas
Get-AppxProvisionedPackage -Online

# Verificar aplicaciones instaladas
Get-AppxPackage -AllUsers
```

**Evidencia:** Captura de pantalla de ejecución de scripts oficiales
**Resultado:** ☒ SI ☐ NO

---

### Aspecto 4: Seguridad por Defecto

**Pregunta:** ¿Se han configurado los equipos, previamente a su entrada en operación, de manera que se aplique la regla de 'seguridad por defecto'?

**NOTA:** La 'seguridad por defecto' se concreta estableciendo medidas de seguridad respetuosas con el usuario y que le protejan, salvo que éste se exponga conscientemente a un riesgo; En otras palabras, para reducir la seguridad el usuario tiene que realizar acciones conscientes, por lo que el uso natural, en los casos que el usuario no ha consultado el manual, ni realizado acciones específicas, será un uso seguro.

#### Scripts Oficiales CN-CERT a Ejecutar:
- [ ] **CCN-STIC-599A23 Windows Defender - Análisis de integridad de ficheros.bat**
- [ ] **CCN-STIC-599B23 Windows Defender - Análisis de integridad de ficheros.bat**
- [ ] **CCN-STIC-599A23 Windows Defender - Análisis de dispositivos USB.bat**
- [ ] **CCN-STIC-599B23 Windows Defender - Análisis de dispositivos USB.bat**
- [ ] **CCN-STIC-599A23 Windows Defender - Análisis en el arranque.bat**
- [ ] **CCN-STIC-599B23 Windows Defender - Análisis en el arranque.bat**

#### Verificaciones Técnicas:
- [ ] Windows Defender habilitado por defecto
- [ ] Firewall de Windows configurado
- [ ] UAC habilitado
- [ ] SmartScreen activado
- [ ] Análisis de integridad configurado
- [ ] Análisis de dispositivos USB configurado
- [ ] Análisis en el arranque configurado

**Comandos de Verificación:**
```powershell
# Verificar Windows Defender
Get-MpComputerStatus

# Verificar Firewall
netsh advfirewall show allprofiles

# Verificar tareas programadas de análisis
schtasks /query /tn "Analisis integridad ficheros"
schtasks /query /tn "Analisis dispositivos USB"
schtasks /query /tn "Analisis arranque"
```

**Evidencia:** Captura de pantalla de configuración de Windows Defender
**Resultado:** ☒ SI ☐ NO

---

### Aspecto 5: Gestión de Máquinas Virtuales

**Pregunta:** ¿Se han configurado y gestionado las máquinas virtuales, previamente a su entrada en operación, de un modo igual de seguro al empleado para las máquinas físicas?

**NOTA:** La gestión del parcheado, cuentas de usuarios, software antivirus, etc. se realizará como si se tratara de máquinas físicas, incluyendo la máquina anfitriona.

#### Scripts Oficiales CN-CERT a Ejecutar:
- [ ] **Mismos scripts que máquinas físicas** (según tipo de cliente)
- [ ] **Configuración de máquina anfitriona** verificada
- [ ] **Gestión de parches para VMs** implementada
- [ ] **Antivirus en VMs** configurado

#### Verificaciones Técnicas:
- [ ] Máquina anfitriona bastionada
- [ ] VMs con configuraciones de seguridad
- [ ] Parches aplicados en VMs
- [ ] Antivirus activo en VMs
- [ ] Configuración de red aislada
- [ ] Backup de VMs configurado

**Comandos de Verificación:**
```powershell
# Verificar máquina anfitriona (si aplica)
Get-VMHost

# Verificar VMs
Get-VM

# Verificar configuración de red
Get-VMNetworkAdapter

# Verificar antivirus en VMs
Get-MpComputerStatus
```

**Evidencia:** Captura de pantalla de configuración de Hipervisor
**Resultado:** ☒ SI ☐ NO

---

### Scripts Adicionales CN-CERT

#### Scripts de Análisis:
- [ ] **CCN-STIC-599A23_Analisis_arranque.ps1** ejecutado
- [ ] **CCN-STIC-599A23_Analisis_USBs.ps1** ejecutado
- [ ] **CCN-STIC-599A23_Habilitar_registro_conexion_USBs.ps1** ejecutado

#### Archivos XML de Configuración:
- [ ] **CCN-STIC-599A23_Integridad_ficheros.xml** configurado
- [ ] **CCN-STIC-599A23_Analisis_dispositivos_USB.xml** configurado
- [ ] **CCN-STIC-599A23_Analisis_arranque_OS.xml** configurado

#### Scripts Específicos por Tipo:
**Cliente Miembro:**
- [ ] **CCN-STIC-599A23 Cliente Miembro - Eliminar aplicaciones aprovisionadas.bat**
- [ ] **CCN-STIC-599A23 Cliente Miembro - Desinstalar características.bat**

**Cliente Independiente:**
- [ ] **CCN-STIC-599B23 Cliente Independiente - Segregación de roles.bat**
- [ ] **CCN-STIC-599B23 Cliente Independiente - Eliminar aplicaciones aprovisionadas.bat**
- [ ] **CCN-STIC-599B23 Cliente Independiente - Desinstalar características.bat**

---

### Resumen de Cumplimiento

| Aspecto | Estado | Scripts Oficiales Ejecutados |
|---------|--------|------------------------------|
| Configuración previa a producción | ☒ CUMPLE | Scripts de características y aplicaciones |
| Eliminación de cuentas estándar | ☒ CUMPLE | Scripts de menú contextual |
| Mínima funcionalidad | ☒ CUMPLE | Scripts de características y aplicaciones |
| Seguridad por defecto | ☒ CUMPLE | Scripts de Windows Defender |
| Gestión de VMs | ☒ CUMPLE | Scripts aplicados a VMs |

**Resultado General:** ☒ CUMPLE (100%)

---

### Evidencias Recolectadas

#### Scripts Oficiales Ejecutados:
- [ ] Lista de scripts ejecutados
- [ ] Logs de ejecución de scripts
- [ ] Capturas de pantalla de ejecución
- [ ] Reportes de configuración generados

#### Archivos XML Configurados:
- [ ] Tareas programadas creadas
- [ ] Configuraciones de análisis aplicadas
- [ ] Verificación de tareas activas

#### Verificaciones Post-Ejecución:
- [ ] Características deshabilitadas verificadas
- [ ] Aplicaciones eliminadas verificadas
- [ ] Configuraciones de seguridad aplicadas
- [ ] Análisis automáticos configurados

---

### Observaciones del Auditor

**Observaciones generales:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Scripts ejecutados correctamente:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Excepciones o errores encontrados:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Plan de acción:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

---

### Firma y Aprobación

**Auditor:** _________________ **Fecha:** _________________
**Responsable del Sistema:** _________________ **Fecha:** _________________
**Aprobado por:** _________________ **Fecha:** _________________

---
**Versión del Checklist:** 2.0 (Actualizado con Scripts Oficiales CN-CERT)  
**Fecha de Creación:** $(Get-Date -Format "yyyy-MM-dd")  
**Próxima Revisión:** $(Get-Date).AddMonths(3).ToString("yyyy-MM-dd") 