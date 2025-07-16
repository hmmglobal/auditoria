# Configuraciones de Aplicaciones - Google Workspace

## 4.1 Office 365 - NO APLICA

### ❌ No se usa Office 365 en esta organización
**Motivo:** La organización no utiliza Office 365
**Alternativa:** Usar Google Workspace (Gmail, Google Drive, Google Docs, etc.)

## 4.2 Aplicaciones de Terceros

### ✅ Configuraciones que se manejan en Google Workspace
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Políticas de aplicaciones > Aplicaciones de terceros

### Configuraciones disponibles:
- **Lista de aplicaciones autorizadas verificada**
- **Configuración según políticas de seguridad**
- **Políticas de instalación/desinstalación**
- **Restricciones de aplicaciones**

### Configuraciones específicas:
1. **Lista de aplicaciones autorizadas:**
   - Definir aplicaciones permitidas
   - Configurar aplicaciones bloqueadas
   - Establecer políticas de instalación

2. **Configuración según políticas de seguridad:**
   - Restricciones de ejecución
   - Políticas de permisos
   - Configuración de seguridad por aplicación

3. **Políticas de instalación:**
   - Permitir/denegar instalación de aplicaciones
   - Configurar fuentes de instalación permitidas
   - Establecer requisitos de aprobación

4. **Restricciones de aplicaciones:**
   - Bloquear aplicaciones específicas
   - Configurar políticas de ejecución
   - Establecer restricciones por categoría

### Pasos de configuración:
1. Ir a Admin Console
2. Navegar a Dispositivos > Políticas de aplicaciones
3. Buscar "Aplicaciones de terceros"
4. Configurar lista de aplicaciones autorizadas
5. Configurar políticas de seguridad
6. Aplicar a todos los dispositivos

## Elementos que requieren scripts de Windows

### ❌ Aplicaciones actualizadas
**Razón:** Verificación local que requiere análisis de cada dispositivo
**Script:** `07-Verificacion-Aplicaciones.bat`

### ❌ Integridad de instaladores validada
**Razón:** Verificación local que requiere análisis de cada dispositivo
**Script:** `07-Verificacion-Aplicaciones.bat`

## Comandos de verificación

### Para Google Workspace:
```bash
# Verificar políticas de aplicaciones
gcloud admin-sdk directory devices list --query="appPolicy=COMPLIANT"

# Verificar aplicaciones autorizadas
gcloud admin-sdk directory devices list --query="authorizedApps=ENABLED"
```

### Para Windows (verificación local):
```cmd
# Lista de aplicaciones instaladas
powershell -Command "Get-WmiObject -Class Win32_Product | Select-Object Name,Version"

# Verificar integridad del sistema
sfc /scannow

# Aplicaciones en ejecución
tasklist /v
```

## Evidencias requeridas

### Google Workspace:
- Capturas de pantalla de políticas de aplicaciones
- Lista de aplicaciones autorizadas documentada
- Reportes de cumplimiento de aplicaciones
- Políticas de seguridad documentadas

### Windows:
- Lista de aplicaciones instaladas (archivos generados)
- Reportes de verificación de integridad
- Capturas de pantalla de aplicaciones no autorizadas
- Logs de eventos relacionados con aplicaciones

## Notas importantes

1. **Office 365:** No aplica - usar Google Workspace como alternativa
2. **Configuración centralizada:** Las políticas de aplicaciones se manejan desde Google Workspace
3. **Verificación local:** Los scripts generan listas para análisis manual
4. **Integridad:** Verificar que no hay aplicaciones maliciosas o no autorizadas
5. **Actualizaciones:** Mantener aplicaciones actualizadas según políticas de la organización

## Próximos pasos

1. Configurar lista de aplicaciones autorizadas en Google Workspace
2. Configurar políticas de seguridad de aplicaciones en Google Workspace
3. Ejecutar scripts de verificación en cada dispositivo
4. Analizar listas de aplicaciones generadas
5. Identificar aplicaciones no autorizadas
6. Documentar excepciones y justificaciones
7. Configurar alertas de cumplimiento en Google Workspace
8. Revisar regularmente las políticas de aplicaciones 