# Configuración de Dispositivos en Google Workspace

## Descripción General

Las configuraciones de dispositivos para estaciones de trabajo Windows se gestionan a través de Google Workspace, proporcionando control centralizado sobre periféricos y configuraciones de energía.

## 9.1 Periféricos

### Configuración en Google Workspace

#### 1. Acceso a la Consola de Administración
- Ir a [admin.google.com](https://admin.google.com)
- Iniciar sesión con cuenta de administrador
- Navegar a **Dispositivos** > **Configuración de dispositivos**

#### 2. Control de Acceso a USB

**Ubicación:** Dispositivos > Configuración de dispositivos > Periféricos > Control USB

**Configuraciones a aplicar:**

##### Políticas de Acceso USB
- **Dispositivos de almacenamiento USB:** Permitir solo dispositivos autorizados
- **Dispositivos de entrada USB:** Permitir teclado, mouse y dispositivos de entrada estándar
- **Dispositivos de audio USB:** Permitir auriculares y micrófonos autorizados
- **Dispositivos de imagen USB:** Permitir cámaras web autorizadas
- **Otros dispositivos USB:** Bloquear dispositivos no autorizados

##### Lista de Dispositivos Autorizados
- **Almacenamiento:** Solo dispositivos corporativos con cifrado
- **Entrada:** Teclados y mouse estándar
- **Audio:** Auriculares y micrófonos corporativos
- **Imagen:** Cámaras web autorizadas

#### 3. Configuración de Impresoras

**Ubicación:** Dispositivos > Configuración de dispositivos > Periféricos > Impresoras

**Configuraciones a aplicar:**

##### Impresoras Seguras
- **Impresoras de red:** Solo impresoras corporativas autorizadas
- **Impresoras locales:** Bloquear instalación de impresoras locales
- **Impresoras USB:** Permitir solo impresoras autorizadas
- **Configuración de seguridad:** Habilitar autenticación de impresoras

##### Políticas de Impresión
- **Impresión segura:** Requerir autenticación para impresión
- **Cola de impresión:** Configurar retención de trabajos de impresión
- **Auditoría:** Habilitar registro de actividades de impresión

#### 4. Cifrado de Dispositivos Móviles

**Ubicación:** Dispositivos > Configuración de seguridad > Cifrado

**Configuraciones a aplicar:**

##### BitLocker para Dispositivos Móviles
- **Cifrado automático:** Habilitar cifrado automático de discos
- **TPM requerido:** Requerir TPM para cifrado
- **PIN de arranque:** Configurar PIN de arranque
- **Recuperación:** Configurar claves de recuperación

##### Cifrado de Dispositivos Removibles
- **USB:** Cifrar automáticamente dispositivos USB
- **Tarjetas SD:** Cifrar tarjetas de memoria
- **Discos externos:** Cifrar discos duros externos

## 9.2 Configuraciones de Energía

### Configuración en Google Workspace

#### 1. Configuración de Esquemas de Energía

**Ubicación:** Dispositivos > Configuración de dispositivos > Energía

**Configuraciones a aplicar:**

##### Esquema de Energía Corporativo
- **Nombre:** "Esquema Corporativo Seguro"
- **Descripción:** Configuración optimizada para seguridad y productividad
- **Aplicación:** Forzar aplicación a todos los dispositivos

##### Configuración de Suspensión
- **Suspensión en AC:** 15 minutos de inactividad
- **Suspensión en batería:** 10 minutos de inactividad
- **Suspensión híbrida:** Habilitada
- **Hibernación:** Habilitada después de 30 minutos

##### Configuración de Pantalla
- **Apagado de pantalla en AC:** 10 minutos
- **Apagado de pantalla en batería:** 5 minutos
- **Brillo automático:** Habilitado
- **Adaptive brightness:** Habilitado

##### Configuración de Disco Duro
- **Apagado de disco en AC:** 20 minutos
- **Apagado de disco en batería:** 10 minutos
- **Optimización de disco:** Habilitada

#### 2. Configuración de Bloqueo de Pantalla

**Ubicación:** Dispositivos > Configuración de seguridad > Bloqueo de pantalla

**Configuraciones a aplicar:**

##### Timeouts de Bloqueo
- **Bloqueo automático:** 5 minutos de inactividad
- **Bloqueo manual:** Habilitado con Win+L
- **Bloqueo al cerrar tapa:** Habilitado
- **Bloqueo al suspender:** Habilitado

##### Configuración de Bloqueo
- **Pantalla de bloqueo:** Mostrar información corporativa
- **Notificaciones:** Mostrar notificaciones en pantalla de bloqueo
- **Fondo:** Usar fondo corporativo
- **Información del sistema:** Mostrar información básica del sistema

#### 3. Configuración de Botones y Tapa

**Ubicación:** Dispositivos > Configuración de dispositivos > Energía > Botones

**Configuraciones a aplicar:**

##### Acción de Botones
- **Botón de encendido:** Suspender
- **Botón de sueño:** Suspender
- **Cerrar tapa:** Suspender
- **Botón de reinicio:** Confirmar antes de reiniciar

##### Configuración de Tapa
- **Cerrar tapa en AC:** Suspender
- **Cerrar tapa en batería:** Suspender
- **Abrir tapa:** Reanudar desde suspensión

## Configuración de Políticas de Grupo

### Políticas a Aplicar

#### 1. Política de Control de Dispositivos
```json
{
  "deviceControl": {
    "usbStorage": {
      "enabled": false,
      "authorizedDevices": ["corporate-usb-1", "corporate-usb-2"]
    },
    "usbInput": {
      "enabled": true,
      "allowedDevices": ["keyboard", "mouse", "webcam"]
    },
    "printers": {
      "networkOnly": true,
      "authorizedPrinters": ["printer-1", "printer-2"]
    }
  }
}
```

#### 2. Política de Configuración de Energía
```json
{
  "powerConfiguration": {
    "scheme": {
      "name": "Corporate Secure",
      "description": "Secure corporate power scheme"
    },
    "sleep": {
      "acTimeout": 900,
      "batteryTimeout": 600,
      "hybridSleep": true
    },
    "display": {
      "acTimeout": 600,
      "batteryTimeout": 300,
      "adaptiveBrightness": true
    },
    "lock": {
      "timeout": 300,
      "manualLock": true,
      "lidLock": true
    }
  }
}
```

## Verificación y Monitoreo

### 1. Reportes de Dispositivos

**Ubicación:** Dispositivos > Reportes > Dispositivos

**Reportes disponibles:**
- Dispositivos conectados por tipo
- Dispositivos USB autorizados/no autorizados
- Impresoras instaladas y configuradas
- Estado de cifrado de dispositivos
- Configuraciones de energía aplicadas

### 2. Dashboard de Monitoreo

**Ubicación:** Dispositivos > Dashboard

**Métricas a monitorear:**
- Dispositivos conectados por día
- Intentos de conexión de dispositivos no autorizados
- Estado de cifrado de dispositivos
- Configuraciones de energía aplicadas
- Alertas de dispositivos

### 3. Alertas Automáticas

**Configuración de alertas:**
- **Frecuencia:** Tiempo real
- **Canal:** Email y notificaciones push
- **Eventos:** Conexión de dispositivos no autorizados, fallos de cifrado

## Comandos de Verificación Local

### Verificación de Periféricos
```powershell
# Verificar dispositivos USB conectados
Get-PnpDevice | Where-Object {$_.Class -eq "USB"}

# Verificar impresoras instaladas
Get-Printer

# Verificar dispositivos de almacenamiento
Get-PhysicalDisk
```

### Verificación de Configuración de Energía
```powershell
# Verificar esquema de energía activo
powercfg /getactivescheme

# Verificar configuración de suspensión
powercfg /query SCHEME_CURRENT SUB_SLEEP

# Verificar configuración de pantalla
powercfg /query SCHEME_CURRENT SUB_VIDEO
```

## Evidencias Requeridas

### 1. Capturas de Pantalla
- Configuración de control USB en Google Workspace
- Configuración de impresoras autorizadas
- Configuración de esquemas de energía
- Configuración de bloqueo de pantalla

### 2. Reportes Exportados
- Reporte de dispositivos conectados
- Reporte de configuraciones de energía aplicadas
- Reporte de dispositivos no autorizados
- Reporte de estado de cifrado

### 3. Archivos de Configuración
- Exportación de políticas de dispositivos
- Configuración de esquemas de energía
- Lista de dispositivos autorizados

## Notas Importantes

1. **Control Centralizado:** Todas las configuraciones de dispositivos se manejan desde Google Workspace para mantener consistencia.

2. **Seguridad:** Se implementan controles estrictos sobre dispositivos USB y periféricos para prevenir riesgos de seguridad.

3. **Energía:** Las configuraciones de energía están optimizadas para seguridad y productividad corporativa.

4. **Verificación:** Los scripts locales solo verifican el estado actual, no modifican configuraciones.

5. **Cumplimiento:** Esta configuración cumple con los requisitos de seguridad para estaciones de trabajo Windows.

## Contacto y Soporte

Para problemas con la configuración de dispositivos:
- **Soporte técnico:** [soporte@empresa.com](mailto:soporte@empresa.com)
- **Documentación:** [docs.empresa.com/dispositivos](https://docs.empresa.com/dispositivos)
- **Emergencias:** +1-800-DISPOSITIVOS

---

**Última actualización:** $(Get-Date -Format "yyyy-MM-dd")  
**Versión:** 1.0  
**Responsable:** Equipo de Infraestructura 