# Procedimiento Operativo - Auditoría de Bastionado CN-CERT

## Objetivo
Establecer el procedimiento estándar para realizar auditorías de bastionado de sistemas informáticos en cumplimiento con los estándares CN-CERT.

## Alcance
Este procedimiento aplica a todas las auditorías de bastionado realizadas en la organización, independientemente del tipo de sistema o plataforma.

## Responsabilidades

### Auditor Principal
- Coordinar la auditoría completa
- Validar evidencias recolectadas
- Emitir certificados de cumplimiento
- Documentar excepciones y observaciones

### Administrador de Sistemas
- Proporcionar acceso a los sistemas
- Asistir en la recolección de evidencias
- Implementar correcciones identificadas
- Mantener documentación actualizada

### Equipo de Seguridad
- Revisar y aprobar procedimientos
- Validar controles de seguridad
- Coordinar con auditores externos
- Mantener estándares actualizados

## Fases del Procedimiento

### Fase 1: Planificación y Preparación

#### 1.1 Identificación de Sistemas
- [ ] Inventariar sistemas a auditar
- [ ] Categorizar por tipo y criticidad
- [ ] Definir alcance de la auditoría
- [ ] Establecer cronograma

#### 1.2 Preparación de Herramientas
- [ ] Verificar disponibilidad de scripts
- [ ] Preparar checklists específicos
- [ ] Configurar herramientas de captura
- [ ] Validar permisos de acceso

#### 1.3 Notificación y Coordinación
- [ ] Notificar a administradores de sistemas
- [ ] Coordinar horarios de auditoría
- [ ] Preparar credenciales de acceso
- [ ] Establecer canales de comunicación

### Fase 2: Ejecución de la Auditoría

#### 2.1 Auditoría de Estaciones de Trabajo Windows

**Paso 1: Preparación**
```powershell
# Ejecutar script de recolección
.\Get-SecurityEvidence.ps1 -OutputPath "C:\evidencias" -SystemName "PC-001" -AuditorName "Juan Pérez" -IncludeLogs -IncludeScreenshots
```

**Paso 2: Verificación Manual**
- [ ] Verificar configuración de Windows Defender
- [ ] Validar estado de BitLocker
- [ ] Comprobar configuración de firewall
- [ ] Revisar políticas de contraseñas
- [ ] Validar configuración de usuarios

**Paso 3: Documentación**
- [ ] Completar checklist específico
- [ ] Capturar pantallas de configuración
- [ ] Documentar excepciones encontradas
- [ ] Generar reporte de hallazgos

#### 2.2 Auditoría de Servidores Linux

**Paso 1: Preparación**
```bash
# Ejecutar script de recolección
./Get-LinuxSecurityEvidence.sh -o /tmp/evidencias -s "servidor-web" -a "Juan Pérez" -l -c
```

**Paso 2: Verificación Manual**
- [ ] Verificar configuración de SSH
- [ ] Validar reglas de firewall
- [ ] Comprobar políticas de usuarios
- [ ] Revisar configuración de logs
- [ ] Validar servicios activos

**Paso 3: Documentación**
- [ ] Completar checklist específico
- [ ] Capturar configuraciones críticas
- [ ] Documentar excepciones encontradas
- [ ] Generar reporte de hallazgos

#### 2.3 Auditoría de Dispositivos de Red

**Paso 1: Acceso y Configuración**
- [ ] Obtener acceso administrativo
- [ ] Exportar configuración actual
- [ ] Verificar políticas de seguridad
- [ ] Validar reglas de firewall

**Paso 2: Verificación de Controles**
- [ ] Revisar configuración de acceso
- [ ] Validar políticas de contraseñas
- [ ] Comprobar configuración de logs
- [ ] Verificar actualizaciones de firmware

**Paso 3: Documentación**
- [ ] Completar checklist específico
- [ ] Capturar configuraciones
- [ ] Documentar excepciones
- [ ] Generar reporte

### Fase 3: Análisis y Validación

#### 3.1 Revisión de Evidencias
- [ ] Validar completitud de evidencias
- [ ] Verificar calidad de capturas
- [ ] Revisar reportes generados
- [ ] Validar logs recolectados

#### 3.2 Análisis de Cumplimiento
- [ ] Comparar con estándares CN-CERT
- [ ] Identificar desviaciones
- [ ] Evaluar riesgos asociados
- [ ] Priorizar correcciones

#### 3.3 Documentación de Hallazgos
- [ ] Registrar hallazgos críticos
- [ ] Documentar observaciones menores
- [ ] Identificar mejores prácticas
- [ ] Proponer mejoras

### Fase 4: Reporte y Certificación

#### 4.1 Generación de Reporte
- [ ] Consolidar evidencias recolectadas
- [ ] Generar reporte ejecutivo
- [ ] Incluir hallazgos y recomendaciones
- [ ] Documentar plan de acción

#### 4.2 Emisión de Certificado
- [ ] Evaluar nivel de cumplimiento
- [ ] Emitir certificado correspondiente
- [ ] Documentar excepciones aprobadas
- [ ] Establecer fecha de reauditoría

#### 4.3 Entrega de Resultados
- [ ] Presentar resultados a stakeholders
- [ ] Entregar documentación completa
- [ ] Establecer seguimiento
- [ ] Archivar evidencias

## Criterios de Evaluación

### Nivel de Cumplimiento
- **CUMPLE (100%)**: Todos los controles verificados cumplen con los estándares
- **CUMPLE CON OBSERVACIONES (80-99%)**: Cumple pero con observaciones menores
- **NO CUMPLE (<80%)**: No cumple con los estándares requeridos

### Criterios de Aprobación
- Mínimo 80% de cumplimiento general
- Todos los controles críticos implementados
- Excepciones documentadas y justificadas
- Plan de remediación establecido

## Documentación Requerida

### Para cada Sistema Auditado
1. **Ficha técnica del sistema**
2. **Checklist cumplimentado**
3. **Evidencias recolectadas**
4. **Reporte de hallazgos**
5. **Certificado de cumplimiento**

### Evidencias Mínimas
1. **Capturas de pantalla** de configuraciones críticas
2. **Reportes de configuración** generados por herramientas
3. **Logs de auditoría** del sistema
4. **Comandos ejecutados** y sus resultados

## Gestión de Excepciones

### Tipos de Excepciones
1. **Limitaciones técnicas**: Imposibilidad técnica de implementar control
2. **Impacto operacional**: Afectación significativa a operaciones
3. **Costos prohibitivos**: Costos excesivos para implementación
4. **Alternativas equivalentes**: Controles alternativos implementados

### Proceso de Aprobación
1. **Solicitud formal** de excepción
2. **Análisis de riesgo** por equipo de seguridad
3. **Aprobación** del comité correspondiente
4. **Documentación** y seguimiento

## Mantenimiento y Seguimiento

### Revisiones Periódicas
- **Revisión mensual** de sistemas críticos
- **Revisión trimestral** de todos los sistemas
- **Revisión anual** de procedimientos
- **Actualización** según nuevos estándares

### Mejora Continua
- **Análisis de tendencias** de hallazgos
- **Actualización de controles** según amenazas
- **Optimización de procedimientos**
- **Capacitación del personal**

## Herramientas y Recursos

### Scripts de Automatización
- `Get-SecurityEvidence.ps1` - Windows
- `Get-LinuxSecurityEvidence.sh` - Linux
- Scripts específicos por plataforma

### Checklists
- Checklist general de bastionado
- Checklists específicos por tipo de sistema
- Checklists de validación de evidencias

### Plantillas
- Plantilla de reporte de auditoría
- Plantilla de certificado de cumplimiento
- Plantilla de documentación de excepciones

## Contactos y Escalación

### Contactos Primarios
- **Auditor Principal**: [Nombre] - [Teléfono] - [Email]
- **Equipo de Seguridad**: [Email]
- **Administradores de Sistemas**: [Email]

### Escalación
1. **Nivel 1**: Auditor asignado
2. **Nivel 2**: Auditor principal
3. **Nivel 3**: Jefe de seguridad
4. **Nivel 4**: Director de TI

## Anexos

### Anexo A: Checklist de Preparación
- [ ] Herramientas verificadas
- [ ] Accesos configurados
- [ ] Cronograma establecido
- [ ] Stakeholders notificados

### Anexo B: Checklist de Validación
- [ ] Evidencias completas
- [ ] Reportes generados
- [ ] Excepciones documentadas
- [ ] Certificados emitidos

### Anexo C: Plantillas de Documentos
- Plantilla de reporte ejecutivo
- Plantilla de certificado
- Plantilla de excepción

---
**Versión:** 1.0  
**Fecha:** $(Get-Date -Format "yyyy-MM-dd")  
**Responsable:** Equipo de Seguridad  
**Revisión:** Trimestral 