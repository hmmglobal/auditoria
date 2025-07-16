# Configuración de Red - Google Workspace

## Elementos manejados en Google Workspace

### ✅ Firewall de Windows habilitado
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Configuración de red > Firewall

**Configuración recomendada:**
- Firewall habilitado: Sí
- Bloquear conexiones entrantes: Sí
- Notificar cuando se bloquea: Sí
- Permitir aplicaciones específicas: Configurar lista
- Reglas personalizadas: Según políticas de la organización

**Pasos de configuración:**
1. Ir a Admin Console
2. Navegar a Dispositivos > Configuración de red
3. Buscar "Firewall"
4. Configurar reglas de firewall
5. Aplicar a todos los dispositivos

### ✅ Configuración de proxy aplicada
**Ubicación en Google Workspace:**
- Admin Console > Dispositivos > Configuración de red > Proxy

**Configuración recomendada:**
- Servidor proxy: [Configurar según organización]
- Puerto: [Configurar según organización]
- Excepciones: Configurar según políticas
- Autenticación: Si es requerida
- Filtrado de contenido: Habilitado

**Pasos de configuración:**
1. Ir a Admin Console
2. Navegar a Dispositivos > Configuración de red
3. Buscar "Proxy"
4. Configurar servidor y puerto
5. Configurar excepciones y filtros
6. Aplicar a todos los dispositivos

## Elementos que requieren scripts de Windows

### ❌ NetBIOS sobre TCP/IP deshabilitado
**Razón:** Configuración de red local que no se puede manejar desde Google Workspace
**Script:** `04-Configuracion-Red.bat`

### ❌ DNS seguro configurado
**Razón:** Configuración de red local que no se puede manejar desde Google Workspace
**Script:** `04-Configuracion-Red.bat`

### ❌ IPv6 habilitado (si aplica)
**Razón:** Configuración de red local que no se puede manejar desde Google Workspace
**Script:** `04-Configuracion-Red.bat`

## Comandos de verificación

### Para Google Workspace:
```bash
# Verificar políticas de red
gcloud admin-sdk directory devices list --query="networkConfig=COMPLIANT"

# Verificar configuración de proxy
gcloud admin-sdk directory devices list --query="proxyConfig=ENABLED"
```

### Para Windows (script):
```cmd
# Verificar configuración de red
netsh interface ipv4 show config
netsh interface ipv6 show interface
netsh winhttp show proxy
ipconfig /all
```

## Evidencias requeridas

### Google Workspace:
- Capturas de pantalla de reglas de firewall
- Capturas de pantalla de configuración de proxy
- Reportes de cumplimiento de red
- Políticas de red documentadas

### Windows:
- Reporte de configuración de red
- Capturas de pantalla de ipconfig
- Verificación de conectividad
- Logs de eventos de red

## Notas importantes

1. **Configuraciones locales:** NetBIOS, DNS e IPv6 deben configurarse individualmente en cada dispositivo
2. **Políticas centralizadas:** Firewall y proxy pueden configurarse globalmente desde Google Workspace
3. **Compatibilidad:** Verificar que las configuraciones no afecten aplicaciones críticas
4. **DNS seguro:** Usar servidores DNS confiables como Google DNS (8.8.8.8, 8.8.4.4)
5. **NetBIOS:** Deshabilitar para mejorar seguridad, pero verificar compatibilidad con aplicaciones legacy

## Próximos pasos

1. Configurar reglas de firewall en Google Workspace
2. Configurar proxy corporativo en Google Workspace
3. Ejecutar script de Windows en cada dispositivo
4. Verificar conectividad y funcionalidad
5. Documentar configuraciones en Google Drive
6. Probar aplicaciones críticas después de los cambios 