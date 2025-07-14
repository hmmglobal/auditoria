# Script para Recolección Automática de Evidencia - Checklist Windows 10/11
# Integración con Google Workspace
# Autor: Sistema de Auditoría de Seguridad
# Versión: 1.0

param(
    [string]$EvidencePath = "C:\Evidencias",
    [string]$GoogleDrivePath = "$env:USERPROFILE\Google Drive\Evidencias",
    [switch]$GenerateReport,
    [switch]$UploadToDrive
)

# Configuración de colores para output
$Host.UI.RawUI.ForegroundColor = "Green"
Write-Host "=== SCRIPT DE RECOLECCIÓN DE EVIDENCIA - GOOGLE WORKSPACE ===" -ForegroundColor Cyan
Write-Host "Iniciando recolección de evidencia del sistema..." -ForegroundColor Yellow

# Función para crear directorios
function Create-EvidenceFolders {
    param([string]$BasePath)
    
    $folders = @(
        "Políticas_Contraseñas",
        "Configuracion_Usuarios", 
        "Servicios_Sistema",
        "Configuracion_Red",
        "Windows_Defender",
        "BitLocker",
        "Windows_Hello",
        "Politicas_Aplicaciones",
        "Microsoft_Edge",
        "Configuracion_Proxy",
        "Office_365",
        "Aplicaciones_Terceros",
        "Auditoria_Eventos",
        "Configuracion_Logs",
        "Windows_Backup",
        "OneDrive_Configuracion",
        "Windows_Update",
        "Mantenimiento_Sistema",
        "Configuracion_Dominio",
        "Configuracion_VPN",
        "Configuracion_Perifericos",
        "Configuracion_Energia",
        "Reporte_Cumplimiento",
        "Excepciones_Documentadas"
    )

    foreach ($folder in $folders) {
        $fullPath = Join-Path $BasePath $folder
        if (!(Test-Path $fullPath)) {
            New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
            Write-Host "✓ Creado directorio: $folder" -ForegroundColor Green
        }
    }
}

# Función para capturar pantalla
function Capture-Screenshot {
    param([string]$Path, [string]$Name)
    
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $screen.Size)
        
        $filename = Join-Path $Path "$Name-$(Get-Date -Format 'yyyyMMdd-HHmmss').png"
        $bitmap.Save($filename, [System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose()
        $bitmap.Dispose()
        
        Write-Host "✓ Captura de pantalla guardada: $Name" -ForegroundColor Green
        return $filename
    }
    catch {
        Write-Host "✗ Error al capturar pantalla: $Name" -ForegroundColor Red
        return $null
    }
}

# Función para recolectar información del sistema
function Get-SystemInfo {
    Write-Host "Recolectando información del sistema..." -ForegroundColor Yellow
    
    $systemInfo = @{
        Hostname = $env:COMPUTERNAME
        IPAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "169.254.*" -and $_.IPAddress -notlike "127.*"}).IPAddress[0]
        Username = $env:USERNAME
        Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        WindowsVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
        BuildNumber = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuildNumber
    }
    
    $systemInfo | ConvertTo-Json | Out-File (Join-Path $EvidencePath "info_sistema.json")
    Write-Host "✓ Información del sistema recolectada" -ForegroundColor Green
    return $systemInfo
}

# Función para recolectar evidencia de políticas de contraseñas
function Get-PasswordPolicyEvidence {
    Write-Host "Recolectando evidencia de políticas de contraseñas..." -ForegroundColor Yellow
    
    $passwordPath = Join-Path $EvidencePath "Políticas_Contraseñas"
    
    # Comando net accounts
    net accounts > (Join-Path $passwordPath "net_accounts.txt")
    
    # Políticas de contraseñas desde registro
    $passwordPolicies = @{
        MinLength = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -ErrorAction SilentlyContinue).MinPasswordLength
        Complexity = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -ErrorAction SilentlyContinue).PasswordComplexity
        History = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -ErrorAction SilentlyContinue).PasswordHistory
    }
    
    $passwordPolicies | ConvertTo-Json | Out-File (Join-Path $passwordPath "password_policies.json")
    
    # Captura de pantalla
    Capture-Screenshot -Path $passwordPath -Name "Politicas_Contraseñas"
    
    Write-Host "✓ Evidencia de políticas de contraseñas recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de usuarios
function Get-UserEvidence {
    Write-Host "Recolectando evidencia de configuración de usuarios..." -ForegroundColor Yellow
    
    $userPath = Join-Path $EvidencePath "Configuracion_Usuarios"
    
    # Lista de usuarios
    wmic useraccount get name,disabled > (Join-Path $userPath "usuarios.txt")
    
    # Usuarios detallados
    Get-WmiObject -Class Win32_UserAccount | Select-Object Name, Disabled, AccountType, SID | Export-Csv (Join-Path $userPath "usuarios_detallado.csv") -NoTypeInformation
    
    # Cuentas de invitado
    Get-WmiObject -Class Win32_UserAccount | Where-Object {$_.Name -like "*guest*" -or $_.Name -like "*invitado*"} | Export-Csv (Join-Path $userPath "cuentas_invitado.csv") -NoTypeInformation
    
    # Captura de pantalla
    Capture-Screenshot -Path $userPath -Name "Configuracion_Usuarios"
    
    Write-Host "✓ Evidencia de usuarios recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de servicios
function Get-ServiceEvidence {
    Write-Host "Recolectando evidencia de servicios del sistema..." -ForegroundColor Yellow
    
    $servicePath = Join-Path $EvidencePath "Servicios_Sistema"
    
    # Servicios críticos
    $criticalServices = @("telnet", "tftp", "snmp", "alerter", "messenger")
    $serviceStatus = @()
    
    foreach ($service in $criticalServices) {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc) {
            $serviceStatus += [PSCustomObject]@{
                ServiceName = $service
                Status = $svc.Status
                StartType = $svc.StartType
            }
        }
    }
    
    $serviceStatus | Export-Csv (Join-Path $servicePath "servicios_criticos.csv") -NoTypeInformation
    
    # Todos los servicios
    Get-Service | Select-Object Name, Status, StartType | Export-Csv (Join-Path $servicePath "todos_servicios.csv") -NoTypeInformation
    
    # Captura de pantalla
    Capture-Screenshot -Path $servicePath -Name "Servicios_Sistema"
    
    Write-Host "✓ Evidencia de servicios recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de Windows Defender
function Get-WindowsDefenderEvidence {
    Write-Host "Recolectando evidencia de Windows Defender..." -ForegroundColor Yellow
    
    $defenderPath = Join-Path $EvidencePath "Windows_Defender"
    
    # Estado de Windows Defender
    Get-MpComputerStatus | Export-Clixml (Join-Path $defenderPath "defender_status.xml")
    Get-MpComputerStatus | ConvertTo-Json | Out-File (Join-Path $defenderPath "defender_status.json")
    
    # Configuración de Windows Defender
    Get-MpPreference | Export-Clixml (Join-Path $defenderPath "defender_preferences.xml")
    
    # Captura de pantalla
    Capture-Screenshot -Path $defenderPath -Name "Windows_Defender"
    
    Write-Host "✓ Evidencia de Windows Defender recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de BitLocker
function Get-BitLockerEvidence {
    Write-Host "Recolectando evidencia de BitLocker..." -ForegroundColor Yellow
    
    $bitlockerPath = Join-Path $EvidencePath "BitLocker"
    
    # Estado de BitLocker
    manage-bde -status > (Join-Path $bitlockerPath "bitlocker_status.txt")
    
    # Información de TPM
    Get-WmiObject -Class Win32_TPM | Export-Clixml (Join-Path $bitlockerPath "tpm_info.xml")
    
    # Captura de pantalla
    Capture-Screenshot -Path $bitlockerPath -Name "BitLocker"
    
    Write-Host "✓ Evidencia de BitLocker recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de Windows Update
function Get-WindowsUpdateEvidence {
    Write-Host "Recolectando evidencia de Windows Update..." -ForegroundColor Yellow
    
    $updatePath = Join-Path $EvidencePath "Windows_Update"
    
    # Últimas actualizaciones
    Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 20 | Export-Csv (Join-Path $updatePath "ultimas_actualizaciones.csv") -NoTypeInformation
    
    # Configuración de Windows Update
    Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" | ConvertTo-Json | Out-File (Join-Path $updatePath "update_config.json")
    
    # Captura de pantalla
    Capture-Screenshot -Path $updatePath -Name "Windows_Update"
    
    Write-Host "✓ Evidencia de Windows Update recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de red
function Get-NetworkEvidence {
    Write-Host "Recolectando evidencia de configuración de red..." -ForegroundColor Yellow
    
    $networkPath = Join-Path $EvidencePath "Configuracion_Red"
    
    # Configuración de firewall
    netsh advfirewall show allprofiles > (Join-Path $networkPath "firewall_profiles.txt")
    
    # Configuración de red
    Get-NetAdapter | Export-Csv (Join-Path $networkPath "adaptadores_red.csv") -NoTypeInformation
    
    # Configuración IP
    Get-NetIPAddress | Export-Csv (Join-Path $networkPath "configuracion_ip.csv") -NoTypeInformation
    
    # Configuración DNS
    Get-DnsClientServerAddress | Export-Csv (Join-Path $networkPath "configuracion_dns.csv") -NoTypeInformation
    
    # Captura de pantalla
    Capture-Screenshot -Path $networkPath -Name "Configuracion_Red"
    
    Write-Host "✓ Evidencia de red recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de aplicaciones
function Get-ApplicationEvidence {
    Write-Host "Recolectando evidencia de aplicaciones..." -ForegroundColor Yellow
    
    $appPath = Join-Path $EvidencePath "Aplicaciones_Terceros"
    
    # Aplicaciones instaladas
    Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor, InstallDate | Export-Csv (Join-Path $appPath "aplicaciones_instaladas.csv") -NoTypeInformation
    
    # Aplicaciones de Office
    Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Office" -ErrorAction SilentlyContinue | ConvertTo-Json | Out-File (Join-Path $appPath "office_config.json")
    
    # Captura de pantalla
    Capture-Screenshot -Path $appPath -Name "Aplicaciones_Terceros"
    
    Write-Host "✓ Evidencia de aplicaciones recolectada" -ForegroundColor Green
}

# Función para recolectar evidencia de auditoría
function Get-AuditEvidence {
    Write-Host "Recolectando evidencia de auditoría..." -ForegroundColor Yellow
    
    $auditPath = Join-Path $EvidencePath "Auditoria_Eventos"
    
    # Políticas de auditoría
    auditpol /get /category:* > (Join-Path $auditPath "politicas_auditoria.txt")
    
    # Últimos eventos de seguridad
    Get-WinEvent -LogName Security -MaxEvents 100 | Export-Clixml (Join-Path $auditPath "eventos_seguridad.xml")
    
    # Configuración de logs
    Get-WinEvent -ListLog Security | Export-Clixml (Join-Path $auditPath "configuracion_logs.xml")
    
    # Captura de pantalla
    Capture-Screenshot -Path $auditPath -Name "Auditoria_Eventos"
    
    Write-Host "✓ Evidencia de auditoría recolectada" -ForegroundColor Green
}

# Función para generar reporte de cumplimiento
function Generate-ComplianceReport {
    Write-Host "Generando reporte de cumplimiento..." -ForegroundColor Yellow
    
    $reportPath = Join-Path $EvidencePath "Reporte_Cumplimiento"
    $systemInfo = Get-Content (Join-Path $EvidencePath "info_sistema.json") | ConvertFrom-Json
    
    $report = @"
# Reporte de Cumplimiento - Checklist Windows 10/11
## Información del Sistema
- **Hostname:** $($systemInfo.Hostname)
- **IP Address:** $($systemInfo.IPAddress)
- **Usuario:** $($systemInfo.Username)
- **Fecha de Auditoría:** $($systemInfo.Date)
- **Versión de Windows:** $($systemInfo.WindowsVersion) Build $($systemInfo.BuildNumber)

## Resumen de Evidencias Recolectadas
- [x] Información del Sistema
- [x] Políticas de Contraseñas
- [x] Configuración de Usuarios
- [x] Servicios del Sistema
- [x] Windows Defender
- [x] BitLocker
- [x] Windows Update
- [x] Configuración de Red
- [x] Aplicaciones de Terceros
- [x] Auditoría de Eventos

## Ubicación de Evidencias
Todas las evidencias se encuentran en: $EvidencePath

## Próximos Pasos
1. Revisar cada carpeta de evidencia
2. Verificar cumplimiento de cada control
3. Documentar excepciones
4. Generar reporte final de cumplimiento

---
**Generado automáticamente el:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

    $report | Out-File (Join-Path $reportPath "reporte_cumplimiento.md")
    
    Write-Host "✓ Reporte de cumplimiento generado" -ForegroundColor Green
}

# Función para copiar a Google Drive
function Copy-ToGoogleDrive {
    if ($UploadToDrive -and (Test-Path $GoogleDrivePath)) {
        Write-Host "Copiando evidencias a Google Drive..." -ForegroundColor Yellow
        
        try {
            Copy-Item -Path "$EvidencePath\*" -Destination $GoogleDrivePath -Recurse -Force
            Write-Host "✓ Evidencias copiadas a Google Drive" -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Error al copiar a Google Drive: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    elseif ($UploadToDrive) {
        Write-Host "⚠ Google Drive no encontrado en: $GoogleDrivePath" -ForegroundColor Yellow
        Write-Host "   Las evidencias se guardaron en: $EvidencePath" -ForegroundColor Yellow
    }
}

# Función principal
function Main {
    # Crear directorios de evidencia
    Create-EvidenceFolders -BasePath $EvidencePath
    
    # Recolectar información del sistema
    $systemInfo = Get-SystemInfo
    
    # Recolectar evidencia por categorías
    Get-PasswordPolicyEvidence
    Get-UserEvidence
    Get-ServiceEvidence
    Get-WindowsDefenderEvidence
    Get-BitLockerEvidence
    Get-WindowsUpdateEvidence
    Get-NetworkEvidence
    Get-ApplicationEvidence
    Get-AuditEvidence
    
    # Generar reporte si se solicita
    if ($GenerateReport) {
        Generate-ComplianceReport
    }
    
    # Copiar a Google Drive si se solicita
    Copy-ToGoogleDrive
    
    Write-Host "`n=== RECOLECCIÓN COMPLETADA ===" -ForegroundColor Cyan
    Write-Host "Evidencias guardadas en: $EvidencePath" -ForegroundColor Green
    Write-Host "Total de archivos recolectados: $(Get-ChildItem -Path $EvidencePath -Recurse -File | Measure-Object | Select-Object -ExpandProperty Count)" -ForegroundColor Green
    
    if ($UploadToDrive -and (Test-Path $GoogleDrivePath)) {
        Write-Host "Evidencias también disponibles en: $GoogleDrivePath" -ForegroundColor Green
    }
}

# Ejecutar función principal
Main 