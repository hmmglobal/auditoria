# Script de Auditoria de Dispositivos USB
# Autor: Equipo de Seguridad
# Version: 1.0

param(
    [Parameter(Mandatory=$true)]
    [string]$OutputPath,
    
    [Parameter(Mandatory=$true)]
    [string]$SystemName,
    
    [Parameter(Mandatory=$true)]
    [string]$AuditorName,
    
    [switch]$EscanearUSB
)

# Configuracion inicial
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Crear directorios de salida
$ReportsPath = Join-Path $OutputPath "reportes"
$LogsPath = Join-Path $OutputPath "logs"

New-Item -ItemType Directory -Path $ReportsPath -Force | Out-Null
New-Item -ItemType Directory -Path $LogsPath -Force | Out-Null

# Funcion para escribir logs
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    $logFile = Join-Path $LogsPath "auditoria-usb-log.txt"
    
    Write-Host $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

Write-Host "=== AUDITORIA DE DISPOSITIVOS USB ===" -ForegroundColor Green
Write-Host "Sistema: $SystemName" -ForegroundColor Yellow
Write-Host "Auditor: $AuditorName" -ForegroundColor Yellow
Write-Host ""

# 1. Habilitar registro de eventos USB
Write-Host "1. Configurando registro de eventos USB..." -ForegroundColor Cyan
Write-Log "Iniciando configuracion de registro de eventos USB"

try {
    $eventosusb = Get-WinEvent -ListLog 'Microsoft-Windows-DriverFrameworks-UserMode/Operational' -ErrorAction SilentlyContinue
    if ($eventosusb) {
        $eventosusb.IsEnabled = $true
        $eventosusb.SaveChanges()
        Write-Log "Registro de eventos USB habilitado exitosamente"
        Write-Host "   ✅ Registro de eventos USB habilitado" -ForegroundColor Green
    } else {
        Write-Log "No se pudo acceder al registro de eventos USB"
        Write-Host "   ⚠️  No se pudo acceder al registro de eventos USB" -ForegroundColor Yellow
    }
} catch {
    Write-Log "Error habilitando registro de eventos USB: $($_.Exception.Message)" "ERROR"
    Write-Host "   ❌ Error habilitando registro de eventos USB" -ForegroundColor Red
}

# 2. Detectar dispositivos USB
Write-Host "2. Detectando dispositivos USB..." -ForegroundColor Cyan
Write-Log "Iniciando deteccion de dispositivos USB"

$dispositivosUSB = @()
$unidadesUSB = @()

try {
    # Detectar dispositivos USB
    $dispositivosUSB = Get-WmiObject Win32_USBHub | Select-Object Name, DeviceID, Status, Description
    Write-Log "Dispositivos USB detectados: $($dispositivosUSB.Count)"
    
    # Detectar unidades USB
    $unidadesUSB = gwmi win32_diskdrive | Where-Object {$_.interfacetype -eq "USB"} | ForEach-Object {
        gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition" | ForEach-Object {
            gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition" | ForEach-Object {$_.deviceid}
        }
    }
    Write-Log "Unidades USB detectadas: $($unidadesUSB.Count)"
    
    Write-Host "   ✅ Dispositivos USB detectados: $($dispositivosUSB.Count)" -ForegroundColor Green
    Write-Host "   ✅ Unidades USB detectadas: $($unidadesUSB.Count)" -ForegroundColor Green
    
} catch {
    Write-Log "Error detectando dispositivos USB: $($_.Exception.Message)" "ERROR"
    Write-Host "   ❌ Error detectando dispositivos USB" -ForegroundColor Red
}

# 3. Obtener eventos USB recientes
Write-Host "3. Obteniendo eventos USB recientes..." -ForegroundColor Cyan
Write-Log "Obteniendo eventos USB recientes"

$eventosUSB = @()
try {
    $eventosUSB = Get-WinEvent -LogName 'Microsoft-Windows-DriverFrameworks-UserMode/Operational' -MaxEvents 20 -ErrorAction SilentlyContinue
    Write-Log "Eventos USB obtenidos: $($eventosUSB.Count)"
    Write-Host "   ✅ Eventos USB obtenidos: $($eventosUSB.Count)" -ForegroundColor Green
} catch {
    Write-Log "No se pudieron obtener eventos USB: $($_.Exception.Message)" "WARNING"
    Write-Host "   ⚠️  No se pudieron obtener eventos USB" -ForegroundColor Yellow
}

# 4. Generar reporte completo
Write-Host "4. Generando reporte de auditoria USB..." -ForegroundColor Cyan
Write-Log "Generando reporte de auditoria USB"

$USBReport = @"
=== AUDITORIA DE DISPOSITIVOS USB ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

=== CONFIGURACION ===
Registro de eventos USB habilitado: $(if ($eventosusb -and $eventosusb.IsEnabled) { "SI" } else { "NO" })

=== DISPOSITIVOS USB CONECTADOS ===
Total de dispositivos: $($dispositivosUSB.Count)

$(if ($dispositivosUSB) {
    $dispositivosUSB | ForEach-Object {
        "- Nombre: $($_.Name)"
        "  ID: $($_.DeviceID)"
        "  Estado: $($_.Status)"
        "  Descripcion: $($_.Description)"
        ""
    }
} else {
    "No se detectaron dispositivos USB"
})

=== UNIDADES USB DETECTADAS ===
Total de unidades: $($unidadesUSB.Count)

$(if ($unidadesUSB) {
    $unidadesUSB | ForEach-Object { "- Unidad: $_" }
} else {
    "No se detectaron unidades USB"
})

=== EVENTOS USB RECIENTES ===
Total de eventos: $($eventosUSB.Count)

$(if ($eventosUSB) {
    $eventosUSB | Select-Object TimeCreated, Id, Message | Format-Table -AutoSize | Out-String
} else {
    "No se encontraron eventos USB recientes"
})

=== RECOMENDACIONES DE SEGURIDAD ===
1. Verificar que el registro de eventos USB esté habilitado
2. Revisar dispositivos USB conectados regularmente
3. Escanear unidades USB con antivirus antes de usar
4. Implementar políticas de control de dispositivos USB
5. Monitorear eventos USB para detectar actividad sospechosa

=== FIN DE AUDITORIA DE DISPOSITIVOS USB ===
"@

$USBReport | Out-File -FilePath (Join-Path $ReportsPath "auditoria-usb-completa.txt") -Encoding UTF8
Write-Log "Reporte de auditoria USB generado exitosamente"

# 5. Escanear unidades USB (si se solicita)
if ($EscanearUSB -and $unidadesUSB) {
    Write-Host "5. Escaneando unidades USB con Windows Defender..." -ForegroundColor Cyan
    Write-Log "Iniciando escaneo de unidades USB"
    
    foreach ($unidad in $unidadesUSB) {
        $letra = $unidad + "\"
        Write-Host "   Escaneando unidad $letra..." -ForegroundColor Yellow
        Write-Log "Iniciando escaneo de unidad $letra"
        
        try {
            $scanResult = & 'C:\Program Files\Windows Defender\MpCmdRun.exe' -Scan -ScanType 3 -File $letra 2>&1
            $scanReport = @"
=== ESCANEO WINDOWS DEFENDER - UNIDAD $letra ===
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Sistema: $SystemName
Auditor: $AuditorName

RESULTADO DEL ESCANEO:
$scanResult

=== FIN DE ESCANEO - UNIDAD $letra ===
"@
            $scanReport | Out-File -FilePath (Join-Path $ReportsPath "escaneo-usb-$($unidad.Replace(':','')).txt") -Encoding UTF8
            Write-Log "Escaneo completado para unidad $letra"
            Write-Host "   ✅ Escaneo completado para unidad $letra" -ForegroundColor Green
        } catch {
            Write-Log "Error escaneando unidad $letra : $($_.Exception.Message)" "ERROR"
            Write-Host "   ❌ Error escaneando unidad $letra" -ForegroundColor Red
        }
    }
} elseif ($EscanearUSB) {
    Write-Host "5. No hay unidades USB para escanear" -ForegroundColor Yellow
    Write-Log "No se encontraron unidades USB para escanear"
}

# Finalizacion
Write-Host ""
Write-Host "=== AUDITORIA USB COMPLETADA ===" -ForegroundColor Green
Write-Host "Reporte guardado en: $(Join-Path $ReportsPath "auditoria-usb-completa.txt")" -ForegroundColor Yellow
Write-Log "Auditoria de dispositivos USB completada exitosamente"

# Estadisticas finales
Write-Host ""
Write-Host "Estadisticas:" -ForegroundColor Cyan
Write-Host "- Dispositivos USB: $($dispositivosUSB.Count)" -ForegroundColor White
Write-Host "- Unidades USB: $($unidadesUSB.Count)" -ForegroundColor White
Write-Host "- Eventos USB: $($eventosUSB.Count)" -ForegroundColor White
if ($EscanearUSB) {
    Write-Host "- Unidades escaneadas: $($unidadesUSB.Count)" -ForegroundColor White
} 