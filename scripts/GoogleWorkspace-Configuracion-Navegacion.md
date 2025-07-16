# Configuraciones de Navegación Web - Google Workspace

## 3.1 Microsoft Edge

### ✅ Todas las configuraciones se manejan en Google Workspace
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Configuración de navegador > Microsoft Edge

### Configuraciones disponibles:
- **SmartScreen habilitado**
- **Protección contra phishing habilitada**
- **Configuración de cookies restrictiva**
- **JavaScript habilitado con restricciones**
- **Plugins limitados a los necesarios**
- **Configuración de seguridad verificada**

### Configuraciones específicas:
1. **SmartScreen:**
   - Habilitar SmartScreen para aplicaciones y archivos
   - Habilitar SmartScreen para sitios web
   - Configurar nivel de protección

2. **Protección contra phishing:**
   - Habilitar protección contra sitios web maliciosos
   - Configurar alertas de seguridad
   - Habilitar protección contra descargas

3. **Cookies:**
   - Bloquear cookies de terceros
   - Configurar políticas de cookies
   - Habilitar limpieza automática

4. **JavaScript:**
   - Habilitar JavaScript con restricciones
   - Configurar sitios permitidos
   - Habilitar protección contra scripts maliciosos

5. **Plugins:**
   - Limitar plugins a los necesarios
   - Configurar lista de plugins permitidos
   - Habilitar actualizaciones automáticas

### Pasos de configuración:
1. Ir a Admin Console
2. Navegar a Dispositivos > Configuración de navegador
3. Buscar "Microsoft Edge"
4. Configurar todas las opciones de seguridad
5. Aplicar a todos los dispositivos

## 3.2 Configuraciones de Proxy

### ✅ Todas las configuraciones se manejan en Google Workspace
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Configuración de red > Proxy

### Configuraciones disponibles:
- **Proxy corporativo configurado** (ya configurado en punto 1.4)
- **Filtrado de contenido habilitado**
- **Certificados SSL configurados**
- **Configuración de red verificada**

### Configuraciones específicas:
1. **Proxy corporativo:**
   - Configurar servidor proxy
   - Configurar puerto
   - Configurar excepciones

2. **Filtrado de contenido:**
   - Habilitar filtrado de contenido web
   - Configurar categorías bloqueadas
   - Configurar sitios permitidos

3. **Certificados SSL:**
   - Configurar certificados corporativos
   - Habilitar inspección SSL
   - Configurar certificados raíz

### Pasos de configuración:
1. Ir a Admin Console
2. Navegar a Dispositivos > Configuración de red
3. Buscar "Proxy"
4. Configurar proxy y filtrado
5. Aplicar a todos los dispositivos

## Comandos de verificación

### Para Google Workspace:
```bash
# Verificar políticas de navegador
gcloud admin-sdk directory devices list --query="browserConfig=COMPLIANT"

# Verificar configuración de proxy
gcloud admin-sdk directory devices list --query="proxyConfig=ENABLED"
```

### Para Windows (verificación local):
```cmd
# Microsoft Edge
reg query "HKCU\Software\Microsoft\Edge\SmartScreenEnabled"
reg query "HKCU\Software\Microsoft\Edge\PhishingProtectionEnabled"

# Proxy
netsh winhttp show proxy
```

## Evidencias requeridas

### Google Workspace:
- Capturas de pantalla de políticas de Microsoft Edge
- Capturas de pantalla de configuración de proxy
- Reportes de cumplimiento de navegador
- Políticas de navegación documentadas

### Windows:
- Reportes de verificación local
- Capturas de pantalla de configuraciones del registro
- Verificación manual de Microsoft Edge

## Notas importantes

1. **Configuración centralizada:** Todas las configuraciones de navegación se manejan desde Google Workspace
2. **Verificación local:** Los scripts solo verifican que las políticas se hayan aplicado
3. **Microsoft Edge:** Las políticas se aplican automáticamente a todos los dispositivos
4. **Proxy:** La configuración de proxy se hereda del punto 1.4
5. **Certificados:** Los certificados SSL pueden requerir configuración manual adicional

## Próximos pasos

1. Configurar políticas de Microsoft Edge en Google Workspace
2. Configurar proxy y filtrado en Google Workspace
3. Ejecutar scripts de verificación en cada dispositivo
4. Verificar que las políticas se hayan aplicado correctamente
5. Documentar configuraciones en Google Drive
6. Probar navegación en sitios de prueba
7. Configurar alertas de cumplimiento en Google Workspace 