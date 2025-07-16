# Script para Configuración de Usuarios - Elementos no manejables en Google Workspace
# Autor: Sistema de Auditoría
# Fecha: $(Get-Date -Format "yyyy-MM-dd")
# Versión: 1.0

param(
    [switch]$Apply,
    [switch]$Verify,
    [switch]$GenerateReport,
    [string]$ReportPath = ".\evidencia\configuracion-usuarios.json"
)

# Función para escribir logs
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

# Función para verificar si se ejecuta como administrador
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Función para deshabilitar cuenta de invitado
function Disable-GuestAccount {
    Write-Log "Verificando estado de cuenta de invitado..."
    
    try {
        $guestAccount = Get-WmiObject -Class Win32_UserAccount -Filter "Name='Guest'"
        
        if ($guestAccount) {
            if ($guestAccount.Disabled -eq $true) {
                Write-Log "Cuenta de invitado ya está deshabilitada" "SUCCESS"
                return @{
                    Status = "Compliant"
                    Message = "Cuenta de invitado deshabilitada"
                    Details = "La cuenta Guest está correctamente deshabilitada"
                }
            } else {
                if ($Apply) {
                    Write-Log "Deshabilitando cuenta de invitado..."
                    $guestAccount.Disabled = $true
                    $guestAccount.Put()
                    Write-Log "Cuenta de invitado deshabilitada exitosamente" "SUCCESS"
                    return @{
                        Status = "Fixed"
                        Message = "Cuenta de invitado deshabilitada"
                        Details = "La cuenta Guest ha sido deshabilitada"
                    }
                } else {
                    Write-Log "Cuenta de invitado está habilitada - requiere acción" "WARNING"
                    return @{
                        Status = "NonCompliant"
                        Message = "Cuenta de invitado habilitada"
                        Details = "La cuenta Guest está habilitada y debe ser deshabilitada"
                    }
                }
            }
        } else {
            Write-Log "Cuenta de invitado no encontrada" "INFO"
            return @{
                Status = "Compliant"
                Message = "Cuenta de invitado no existe"
                Details = "No se encontró cuenta Guest en el sistema"
            }
        }
    }
    catch {
        Write-Log "Error al verificar cuenta de invitado: $($_.Exception.Message)" "ERROR"
        return @{
            Status = "Error"
            Message = "Error al verificar cuenta de invitado"
            Details = $_.Exception.Message
        }
    }
}

# Función para renombrar cuenta de administrador
function Rename-AdministratorAccount {
    Write-Log "Verificando cuenta de administrador..."
    
    try {
        $adminAccount = Get-WmiObject -Class Win32_UserAccount -Filter "Name='Administrator'"
        
        if ($adminAccount) {
            if ($adminAccount.Name -ne "Administrator") {
                Write-Log "Cuenta de administrador ya está renombrada como: $($adminAccount.Name)" "SUCCESS"
                return @{
                    Status = "Compliant"
                    Message = "Cuenta de administrador renombrada"
                    Details = "La cuenta Administrator ha sido renombrada a: $($adminAccount.Name)"
                }
            } else {
                if ($Apply) {
                    Write-Log "Renombrando cuenta de administrador..."
                    # Nota: En producción, se debe especificar el nuevo nombre
                    $newName = "Admin_$(Get-Random -Minimum 1000 -Maximum 9999)"
                    Write-Log "Nuevo nombre sugerido: $newName" "INFO"
                    Write-Log "IMPORTANTE: Para renombrar la cuenta, ejecute manualmente: wmic useraccount where name='Administrator' call rename name='$newName'" "WARNING"
                    return @{
                        Status = "ManualAction"
                        Message = "Renombrar cuenta de administrador manualmente"
                        Details = "Ejecute: wmic useraccount where name='Administrator' call rename name='$newName'"
                    }
                } else {
                    Write-Log "Cuenta de administrador no está renombrada - requiere acción" "WARNING"
                    return @{
                        Status = "NonCompliant"
                        Message = "Cuenta de administrador no renombrada"
                        Details = "La cuenta Administrator debe ser renombrada por seguridad"
                    }
                }
            }
        } else {
            Write-Log "Cuenta de administrador no encontrada" "INFO"
            return @{
                Status = "Compliant"
                Message = "Cuenta de administrador no existe"
                Details = "No se encontró cuenta Administrator en el sistema"
            }
        }
    }
    catch {
        Write-Log "Error al verificar cuenta de administrador: $($_.Exception.Message)" "ERROR"
        return @{
            Status = "Error"
            Message = "Error al verificar cuenta de administrador"
            Details = $_.Exception.Message
        }
    }
}

# Función para habilitar auditoría de eventos
function Enable-EventAuditing {
    Write-Log "Verificando configuración de auditoría de eventos..."
    
    try {
        $auditPolicy = auditpol /get /category:* | Out-String
        
        # Verificar si la auditoría está habilitada para eventos críticos
        $logonAudit = auditpol /get /subcategory:"Logon" | Select-String "Success|Failure"
        $logoffAudit = auditpol /get /subcategory:"Logoff" | Select-String "Success|Failure"
        $accountManagement = auditpol /get /subcategory:"User Account Management" | Select-String "Success|Failure"
        
        $auditEnabled = $false
        if ($logonAudit -and $logoffAudit -and $accountManagement) {
            $auditEnabled = $true
        }
        
        if ($auditEnabled) {
            Write-Log "Auditoría de eventos ya está habilitada" "SUCCESS"
            return @{
                Status = "Compliant"
                Message = "Auditoría de eventos habilitada"
                Details = "Los eventos de logon, logoff y gestión de cuentas están siendo auditados"
            }
        } else {
            if ($Apply) {
                Write-Log "Habilitando auditoría de eventos..."
                
                # Configurar auditoría para eventos críticos
                auditpol /set /subcategory:"Logon" /success:enable /failure:enable
                auditpol /set /subcategory:"Logoff" /success:enable /failure:enable
                auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
                auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
                auditpol /set /subcategory:"Directory Service Access" /success:enable /failure:enable
                
                Write-Log "Auditoría de eventos habilitada exitosamente" "SUCCESS"
                return @{
                    Status = "Fixed"
                    Message = "Auditoría de eventos habilitada"
                    Details = "Se han habilitado las auditorías para eventos críticos de seguridad"
                }
            } else {
                Write-Log "Auditoría de eventos no está habilitada - requiere acción" "WARNING"
                return @{
                    Status = "NonCompliant"
                    Message = "Auditoría de eventos no habilitada"
                    Details = "Los eventos críticos de seguridad no están siendo auditados"
                }
            }
        }
    }
    catch {
        Write-Log "Error al verificar auditoría de eventos: $($_.Exception.Message)" "ERROR"
        return @{
            Status = "Error"
            Message = "Error al verificar auditoría de eventos"
            Details = $_.Exception.Message
        }
    }
}

# Función principal
function Main {
    Write-Log "=== SCRIPT DE CONFIGURACIÓN DE USUARIOS ===" "INFO"
    Write-Log "Iniciando verificación de configuración de usuarios..." "INFO"
    
    # Verificar privilegios de administrador
    if (-not (Test-Administrator)) {
        Write-Log "ERROR: Este script requiere privilegios de administrador" "ERROR"
        Write-Log "Ejecute PowerShell como administrador y vuelva a intentar" "ERROR"
        exit 1
    }
    
    $results = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        ComputerName = $env:COMPUTERNAME
        UserName = $env:USERNAME
        Checks = @()
    }
    
    # Ejecutar verificaciones
    Write-Log "Ejecutando verificaciones de configuración de usuarios..." "INFO"
    
    # 1. Verificar cuenta de invitado
    $guestResult = Disable-GuestAccount
    $results.Checks += @{
        Check = "Cuenta de invitado deshabilitada"
        Result = $guestResult
    }
    
    # 2. Verificar cuenta de administrador
    $adminResult = Rename-AdministratorAccount
    $results.Checks += @{
        Check = "Cuenta de administrador renombrada"
        Result = $adminResult
    }
    
    # 3. Verificar auditoría de eventos
    $auditResult = Enable-EventAuditing
    $results.Checks += @{
        Check = "Auditoría de eventos habilitada"
        Result = $auditResult
    }
    
    # Generar reporte si se solicita
    if ($GenerateReport) {
        Write-Log "Generando reporte en: $ReportPath" "INFO"
        
        # Crear directorio si no existe
        $reportDir = Split-Path $ReportPath -Parent
        if (-not (Test-Path $reportDir)) {
            New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
        }
        
        $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $ReportPath -Encoding UTF8
        Write-Log "Reporte generado exitosamente" "SUCCESS"
    }
    
    # Mostrar resumen
    Write-Log "=== RESUMEN DE VERIFICACIONES ===" "INFO"
    $compliant = ($results.Checks | Where-Object { $_.Result.Status -eq "Compliant" }).Count
    $nonCompliant = ($results.Checks | Where-Object { $_.Result.Status -eq "NonCompliant" }).Count
    $fixed = ($results.Checks | Where-Object { $_.Result.Status -eq "Fixed" }).Count
    $errors = ($results.Checks | Where-Object { $_.Result.Status -eq "Error" }).Count
    
    Write-Log "Controles cumplidos: $compliant" "INFO"
    Write-Log "Controles no cumplidos: $nonCompliant" "INFO"
    Write-Log "Controles corregidos: $fixed" "INFO"
    Write-Log "Errores: $errors" "INFO"
    
    Write-Log "=== FIN DEL SCRIPT ===" "INFO"
    
    return $results
}

# Ejecutar función principal
Main 