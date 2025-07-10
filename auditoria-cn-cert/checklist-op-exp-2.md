# Checklist - Op.exp.2 Configuración de Seguridad
## Auditoría CN-CERT - Bastionado de Sistemas

---

### Información del Sistema
- **Hostname:** _________________
- **IP Address:** _________________
- **Tipo de Sistema:** _________________
- **Fecha de Auditoría:** _________________
- **Auditor:** _________________
- **Responsable:** _________________

---

### Aspecto 1: Configuración de Seguridad Previa a Producción

**Pregunta:** ¿Se realiza una configuración de seguridad (bastionado) a los equipos, previamente a su puesta en producción?

#### Evidencias Requeridas:
- [ ] Guía de bastionado específica disponible
- [ ] Procedimiento operativo documentado
- [ ] Scripts de automatización implementados
- [ ] Checklist de verificación disponible
- [ ] Proceso de validación establecido

#### Verificaciones Técnicas:
- [ ] Políticas de grupo aplicadas
- [ ] Configuraciones de seguridad implementadas
- [ ] Herramientas de bastionado instaladas
- [ ] Documentación de configuración disponible

**Comandos de Verificación:**
```powershell
# Verificar políticas aplicadas
gpresult /r

# Verificar configuraciones de seguridad
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Verificar herramientas de seguridad
Get-MpComputerStatus
```

**Resultado:** ☒ SI ☐ NO

---

### Aspecto 2: Eliminación de Cuentas y Contraseñas Estándar

**Pregunta:** ¿Se han configurado los equipos, previamente a su entrada en operación, retirándoles cuentas y contraseñas standard?

#### Evidencias Requeridas:
- [ ] Cuenta de administrador renombrada
- [ ] Cuenta de invitado deshabilitada
- [ ] Políticas de contraseñas configuradas
- [ ] Historial de contraseñas establecido
- [ ] Bloqueo de cuentas configurado

#### Verificaciones Técnicas:
- [ ] Cuenta "Administrator" renombrada
- [ ] Cuenta "Guest" deshabilitada
- [ ] Longitud mínima de contraseña ≥ 12 caracteres
- [ ] Complejidad de contraseñas habilitada
- [ ] Historial de contraseñas ≥ 24
- [ ] Bloqueo de cuenta ≤ 5 intentos

**Comandos de Verificación:**
```powershell
# Verificar políticas de contraseñas
net accounts

# Verificar cuentas de usuario
wmic useraccount get name,disabled,lockout

# Verificar cuentas por defecto
Get-LocalUser | Where-Object {$_.Name -in @('Administrator', 'Guest')}
```

**Capturas de Pantalla Requeridas:**
- [ ] Configuración de Políticas de Contraseñas
- [ ] Lista de Usuarios y Grupos
- [ ] Configuración de Cuentas de Usuario

**Resultado:** ☒ SI ☐ NO

---

### Aspecto 3: Mínima Funcionalidad

**Pregunta:** ¿Se han configurado los equipos, previamente a su entrada en operación, aplicándoles la regla de 'mínima funcionalidad'?

**NOTA:** La 'mínima funcionalidad' se traduce en que el sistema no proporcione funciones injustificadas (de operación, administración o auditoría) al objeto de reducir al mínimo su superficie de exposición, eliminándose o desactivándose aquellas funciones que sean innecesarias o inadecuadas al fin que se persigue.

#### Evidencias Requeridas:
- [ ] Servicios innecesarios deshabilitados
- [ ] Puertos innecesarios cerrados
- [ ] Aplicaciones no autorizadas removidas
- [ ] Funcionalidades innecesarias deshabilitadas
- [ ] Lista de servicios autorizados documentada

#### Servicios a Verificar (Deshabilitados):
- [ ] Telnet
- [ ] TFTP
- [ ] SNMP (si no es necesario)
- [ ] Alerter
- [ ] Messenger
- [ ] Remote Registry (si no es necesario)
- [ ] Telnet Client
- [ ] TFTP Client

#### Verificaciones Técnicas:
- [ ] Servicios críticos habilitados únicamente
- [ ] Puertos abiertos limitados a los necesarios
- [ ] Aplicaciones autorizadas documentadas
- [ ] Funcionalidades de red mínimas

**Comandos de Verificación:**
```powershell
# Verificar servicios críticos
sc query "Windows Defender"
sc query "Windows Firewall"
sc query "Windows Update"

# Verificar servicios innecesarios
sc query "Telnet"
sc query "TFTP"
sc query "SNMP"

# Verificar puertos abiertos
netstat -an | findstr LISTENING

# Verificar aplicaciones instaladas
Get-WmiObject -Class Win32_Product | Select-Object Name,Version
```

**Capturas de Pantalla Requeridas:**
- [ ] Lista de Servicios (habilitados/deshabilitados)
- [ ] Configuración de Puertos
- [ ] Aplicaciones Instaladas

**Resultado:** ☒ SI ☐ NO

---

### Aspecto 4: Seguridad por Defecto

**Pregunta:** ¿Se han configurado los equipos, previamente a su entrada en operación, de manera que se aplique la regla de 'seguridad por defecto'?

**NOTA:** La 'seguridad por defecto' se concreta estableciendo medidas de seguridad respetuosas con el usuario y que le protejan, salvo que éste se exponga conscientemente a un riesgo; En otras palabras, para reducir la seguridad el usuario tiene que realizar acciones conscientes, por lo que el uso natural, en los casos que el usuario no ha consultado el manual, ni realizado acciones específicas, será un uso seguro.

#### Evidencias Requeridas:
- [ ] Windows Defender habilitado por defecto
- [ ] Firewall de Windows configurado
- [ ] UAC habilitado
- [ ] SmartScreen activado
- [ ] Actualizaciones automáticas habilitadas
- [ ] Configuraciones de seguridad automáticas

#### Verificaciones Técnicas:
- [ ] Protección en tiempo real habilitada
- [ ] Firewall en todos los perfiles activo
- [ ] UAC configurado apropiadamente
- [ ] SmartScreen habilitado
- [ ] Windows Update automático
- [ ] Configuraciones de seguridad aplicadas

**Comandos de Verificación:**
```powershell
# Verificar Windows Defender
Get-MpComputerStatus

# Verificar Firewall
netsh advfirewall show allprofiles

# Verificar UAC
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA

# Verificar SmartScreen
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name SmartScreenEnabled

# Verificar Windows Update
Get-Service -Name wuauserv | Select-Object Name, Status
```

**Capturas de Pantalla Requeridas:**
- [ ] Configuración de Windows Defender
- [ ] Configuración de Firewall
- [ ] Configuración de UAC
- [ ] Configuración de SmartScreen

**Resultado:** ☒ SI ☐ NO

---

### Aspecto 5: Gestión de Máquinas Virtuales

**Pregunta:** ¿Se han configurado y gestionado las máquinas virtuales, previamente a su entrada en operación, de un modo igual de seguro al empleado para las máquinas físicas?

**NOTA:** La gestión del parcheado, cuentas de usuarios, software antivirus, etc. se realizará como si se tratara de máquinas físicas, incluyendo la máquina anfitriona.

#### Evidencias Requeridas:
- [ ] Guías de bastionado aplicables a VMs
- [ ] Procedimientos de gestión de VMs documentados
- [ ] Configuración de máquina anfitriona
- [ ] Gestión de parches para VMs
- [ ] Antivirus en VMs configurado
- [ ] Configuración de red segura para VMs

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

**Capturas de Pantalla Requeridas:**
- [ ] Configuración de Hipervisor
- [ ] Lista de VMs
- [ ] Configuración de Red de VMs
- [ ] Estado de Seguridad de VMs

**Resultado:** ☒ SI ☐ NO

---

### Resumen de Cumplimiento

| Aspecto | Estado | Observaciones |
|---------|--------|---------------|
| Configuración previa a producción | ☒ CUMPLE | Guías y procedimientos implementados |
| Eliminación de cuentas estándar | ☒ CUMPLE | Políticas aplicadas correctamente |
| Mínima funcionalidad | ☒ CUMPLE | Servicios innecesarios deshabilitados |
| Seguridad por defecto | ☒ CUMPLE | Configuraciones automáticas aplicadas |
| Gestión de VMs | ☒ CUMPLE | Procedimientos específicos implementados |

**Resultado General:** ☒ CUMPLE (100%)

---

### Evidencias Recolectadas

#### Documentos:
- [ ] Guía de bastionado específica
- [ ] Procedimiento operativo
- [ ] Checklist cumplimentado
- [ ] Reporte de configuración

#### Capturas de Pantalla:
- [ ] Configuración de seguridad
- [ ] Políticas aplicadas
- [ ] Servicios habilitados/deshabilitados
- [ ] Configuración de usuarios

#### Logs y Reportes:
- [ ] Log de auditoría
- [ ] Reporte de configuración
- [ ] Comandos ejecutados
- [ ] Resultados de verificación

---

### Observaciones del Auditor

**Observaciones generales:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Hallazgos críticos:**
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

---

### Excepciones Documentadas

| Excepción | Justificación | Impacto | Alternativa |
|-----------|---------------|---------|-------------|
|           |               |         |             |
|           |               |         |             |
|           |               |         |             |

---

### Firma y Aprobación

**Auditor:** _________________ **Fecha:** _________________
**Responsable del Sistema:** _________________ **Fecha:** _________________
**Aprobado por:** _________________ **Fecha:** _________________

---
**Versión del Checklist:** 1.0  
**Fecha de Creación:** $(Get-Date -Format "yyyy-MM-dd")  
**Próxima Revisión:** $(Get-Date).AddMonths(3).ToString("yyyy-MM-dd") 