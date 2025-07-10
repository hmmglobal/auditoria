# Op.exp.2 - Configuración de Seguridad
## Auditoría CN-CERT - Bastionado de Sistemas

---

### Información General
- **Categoría / Dimensión**: Configuración de seguridad
- **Medida aplica**: SI ☒ NO ☐
- **Medida auditada**: SI ☒ NO ☐
- **Grado de implementación**: SI ☒ EN PROCESO ☐ NO ☐
- **Medida compensatoria**: SI ☐ NO ☒
- **Medida complementaria de vigilancia**: SI ☐ NO ☒

---

### Propuesta de Evidencias

#### ☒ Evidencia de guías de bastionado, particularizadas a los equipos relevantes del sistema.

**Documentos disponibles:**
- `guias-bastionado/guia-general-bastionado.md` - Guía general de bastionado
- `guias-bastionado/estaciones-trabajo/guia-windows-10-11.md` - Guía específica para Windows 10/11
- `guias-bastionado/servidores-windows/guia-windows-server.md` - Guía para servidores Windows
- `guias-bastionado/servidores-linux/guia-linux-server.md` - Guía para servidores Linux
- `guias-bastionado/dispositivos-red/guia-firewall.md` - Guía para dispositivos de red

#### ☒ Evidencia de listas de comprobación cumplimentadas (checklist) de los equipos bastionados.

**Checklists disponibles:**
- `checklists/checklist-windows-estaciones-trabajo.md` - Checklist para estaciones Windows
- `checklists/checklist-windows-servidor.md` - Checklist para servidores Windows
- `checklists/checklist-linux-servidor.md` - Checklist para servidores Linux
- `checklists/checklist-dispositivos-red.md` - Checklist para dispositivos de red

#### ☒ Evidencias al azar, solicitadas por el auditor, para verificar que diferentes aspectos considerados en las guías de bastionado se hayan configurado en la realidad.

**Herramientas de verificación:**
- `scripts/Get-SecurityEvidence.ps1` - Script de recolección para Windows
- `scripts/Get-LinuxSecurityEvidence.sh` - Script de recolección para Linux
- `evidencias/plantilla-evidencia-auditoria.md` - Plantilla de evidencias

---

### Aspectos a Evaluar

| Aspecto | Hallazgos del auditor / referencia a las evidencias | Cumple |
|---------|-----------------------------------------------------|---------|
| **¿Se realiza una configuración de seguridad (bastionado) a los equipos, previamente a su puesta en producción?** | **SI ☒**<br><br>**Evidencias:**<br>• Guía general de bastionado implementada<br>• Procedimientos operativos documentados<br>• Scripts de automatización disponibles<br>• Checklists específicos por tipo de equipo<br><br>**Referencias:**<br>• `procedimientos/procedimiento-auditoria-cn-cert.md`<br>• `guias-bastionado/guia-general-bastionado.md` | ☒ SI<br>☐ NO |
| **¿Se han configurado los equipos, previamente a su entrada en operación, retirándoles cuentas y contraseñas standard?** | **SI ☒**<br><br>**Evidencias:**<br>• Políticas de contraseñas documentadas<br>• Procedimiento de eliminación de cuentas por defecto<br>• Configuración de complejidad de contraseñas<br>• Auditoría de cuentas de usuario<br><br>**Referencias:**<br>• Sección 1.1 de `checklists/checklist-windows-estaciones-trabajo.md`<br>• Comandos de verificación: `net accounts`, `wmic useraccount` | ☒ SI<br>☐ NO |
| **¿Se han configurado los equipos, previamente a su entrada en operación, aplicándoles la regla de 'mínima funcionalidad'?** | **SI ☒**<br><br>**Evidencias:**<br>• Lista de servicios innecesarios deshabilitados<br>• Configuración de puertos cerrados<br>• Eliminación de aplicaciones no autorizadas<br>• Configuración de AppLocker/Software Restriction Policies<br><br>**Referencias:**<br>• Sección 1.3 de `checklists/checklist-windows-estaciones-trabajo.md`<br>• Servicios deshabilitados: Telnet, TFTP, SNMP, Alerter, Messenger<br>• Comando de verificación: `sc query [servicename]` | ☒ SI<br>☐ NO |
| **¿Se han configurado los equipos, previamente a su entrada en operación, de manera que se aplique la regla de 'seguridad por defecto'?** | **SI ☒**<br><br>**Evidencias:**<br>• Windows Defender habilitado por defecto<br>• Firewall de Windows configurado<br>• UAC habilitado<br>• SmartScreen activado<br>• Configuración de seguridad automática<br><br>**Referencias:**<br>• Sección 2.1-2.4 de `checklists/checklist-windows-estaciones-trabajo.md`<br>• Configuraciones de seguridad automáticas documentadas | ☒ SI<br>☐ NO |
| **¿Se han configurado y gestionado las máquinas virtuales, previamente a su entrada en operación, de un modo igual de seguro al empleado para las máquinas físicas?** | **SI ☒**<br><br>**Evidencias:**<br>• Guías de bastionado aplicables a VMs<br>• Procedimientos de gestión de VMs documentados<br>• Configuración de máquina anfitriona<br>• Gestión de parches para VMs<br>• Antivirus en VMs configurado<br><br>**Referencias:**<br>• `guias-bastionado/virtualizacion/guia-vm-bastionado.md`<br>• Procedimientos específicos para VMs documentados | ☒ SI<br>☐ NO |

---

### Evidencias Específicas por Aspecto

#### 1. Configuración de Seguridad Previa a Producción

**Documentos de Evidencia:**
- `procedimientos/procedimiento-auditoria-cn-cert.md` - Procedimiento completo
- `guias-bastionado/guia-general-bastionado.md` - Guía general
- Scripts de automatización disponibles

**Capturas de Pantalla Requeridas:**
- Configuración de políticas de grupo aplicadas
- Estado de servicios críticos
- Configuración de firewall

#### 2. Eliminación de Cuentas y Contraseñas Estándar

**Comandos de Verificación:**
```powershell
# Verificar políticas de contraseñas
net accounts

# Verificar cuentas de usuario
wmic useraccount get name,disabled,lockout

# Verificar cuentas por defecto
Get-LocalUser | Where-Object {$_.Name -in @('Administrator', 'Guest')}
```

**Evidencias Documentales:**
- Lista de cuentas estándar eliminadas
- Políticas de contraseñas aplicadas
- Configuración de complejidad

#### 3. Mínima Funcionalidad

**Servicios Deshabilitados:**
- Telnet
- TFTP
- SNMP (si no es necesario)
- Alerter
- Messenger

**Configuraciones Aplicadas:**
- Puertos innecesarios cerrados
- Aplicaciones no autorizadas removidas
- Funcionalidades innecesarias deshabilitadas

**Comandos de Verificación:**
```powershell
# Verificar servicios
sc query "Telnet"
sc query "TFTP"
sc query "SNMP"

# Verificar puertos abiertos
netstat -an | findstr LISTENING
```

#### 4. Seguridad por Defecto

**Configuraciones Automáticas:**
- Windows Defender habilitado
- Firewall de Windows activo
- UAC configurado
- SmartScreen activado
- Actualizaciones automáticas

**Evidencias:**
- Capturas de configuración de seguridad
- Reportes de estado de protección
- Configuraciones de políticas aplicadas

#### 5. Gestión de Máquinas Virtuales

**Procedimientos Específicos:**
- Bastionado de máquina anfitriona
- Configuración de seguridad en VMs
- Gestión de parches para VMs
- Antivirus en entorno virtual

**Evidencias:**
- Configuración de hipervisor
- Estado de seguridad de VMs
- Procedimientos de gestión documentados

---

### Resumen de Cumplimiento

| Aspecto | Estado | Evidencias Disponibles |
|---------|--------|------------------------|
| Configuración previa a producción | ☒ CUMPLE | Guías, procedimientos, scripts |
| Eliminación de cuentas estándar | ☒ CUMPLE | Políticas, comandos de verificación |
| Mínima funcionalidad | ☒ CUMPLE | Lista de servicios, configuraciones |
| Seguridad por defecto | ☒ CUMPLE | Configuraciones automáticas |
| Gestión de VMs | ☒ CUMPLE | Procedimientos específicos |

**Resultado General: CUMPLE (100%)**

---

### Observaciones del Auditor

**Observaciones generales:**
- Todas las guías de bastionado están documentadas y disponibles
- Los procedimientos operativos están implementados
- Las herramientas de automatización facilitan la verificación
- Los checklists cubren todos los aspectos requeridos

**Recomendaciones:**
- Mantener actualizadas las guías según nuevas amenazas
- Revisar periódicamente las configuraciones
- Documentar cualquier cambio en los procedimientos

**Plan de acción:**
- Revisión trimestral de configuraciones
- Actualización anual de guías
- Capacitación continua del personal

---

### Firma y Aprobación

**Auditor:** _________________ **Fecha:** _________________
**Responsable del Sistema:** _________________ **Fecha:** _________________
**Aprobado por:** _________________ **Fecha:** _________________

---
**Versión del Documento:** 1.0  
**Fecha de Creación:** $(Get-Date -Format "yyyy-MM-dd")  
**Próxima Revisión:** $(Get-Date).AddMonths(3).ToString("yyyy-MM-dd") 