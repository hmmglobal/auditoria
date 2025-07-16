# Script para Configuración de Usuarios - Elementos no manejables en Google Workspace
# Configura: Cuenta de invitado, Cuenta de administrador, Auditoría de eventos

param(
    [switch]$Apply
)

# Verificar privilegios de administrador
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Este script requiere privilegios de administrador"
    exit 1
}

Write-Host "=== CONFIGURACIÓN DE USUARIOS ==="

# 1. Deshabilitar cuenta de invitado
Write-Host "1. Verificando cuenta de invitado..."
$guestAccount = Get-WmiObject -Class Win32_UserAccount -Filter "Name='Guest'"
if ($guestAccount) {
    if ($guestAccount.Disabled -eq $false) {
        if ($Apply) {
            $guestAccount.Disabled = $true
            $guestAccount.Put()
            Write-Host "   ✓ Cuenta de invitado deshabilitada"
        } else {
            Write-Host "   ⚠ Cuenta de invitado habilitada - ejecutar con -Apply para deshabilitar"
        }
    } else {
        Write-Host "   ✓ Cuenta de invitado ya está deshabilitada"
    }
} else {
    Write-Host "   ✓ Cuenta de invitado no existe"
}

# 2. Renombrar cuenta de administrador
Write-Host "2. Verificando cuenta de administrador..."
$adminAccount = Get-WmiObject -Class Win32_UserAccount -Filter "Name='Administrator'"
if ($adminAccount) {
    if ($adminAccount.Name -eq "Administrator") {
        if ($Apply) {
            $newName = "Admin_$(Get-Random -Minimum 1000 -Maximum 9999)"
            Write-Host "   ⚠ Ejecutar manualmente: wmic useraccount where name='Administrator' call rename name='$newName'"
        } else {
            Write-Host "   ⚠ Cuenta de administrador no renombrada - ejecutar con -Apply para ver comando"
        }
    } else {
        Write-Host "   ✓ Cuenta de administrador ya renombrada como: $($adminAccount.Name)"
    }
} else {
    Write-Host "   ✓ Cuenta de administrador no existe"
}

# 3. Habilitar auditoría de eventos
Write-Host "3. Verificando auditoría de eventos..."
$logonAudit = auditpol /get /subcategory:"Logon" | Select-String "Success|Failure"
$logoffAudit = auditpol /get /subcategory:"Logoff" | Select-String "Success|Failure"
$accountManagement = auditpol /get /subcategory:"User Account Management" | Select-String "Success|Failure"

if ($logonAudit -and $logoffAudit -and $accountManagement) {
    Write-Host "   ✓ Auditoría de eventos ya está habilitada"
} else {
    if ($Apply) {
        auditpol /set /subcategory:"Logon" /success:enable /failure:enable
        auditpol /set /subcategory:"Logoff" /success:enable /failure:enable
        auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
        auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
        Write-Host "   ✓ Auditoría de eventos habilitada"
    } else {
        Write-Host "   ⚠ Auditoría de eventos no habilitada - ejecutar con -Apply para habilitar"
    }
}

Write-Host "=== FIN ===" 