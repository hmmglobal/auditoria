# Script para Configuración de Usuarios
Write-Host "=== CONFIGURACIÓN DE USUARIOS ==="

# 1. Deshabilitar cuenta de invitado
Write-Host "1. Verificando cuenta de invitado..."
$guestAccount = Get-WmiObject -Class Win32_UserAccount -Filter "Name='Guest'"
if ($guestAccount) {
    if ($guestAccount.Disabled -eq $false) {
        $guestAccount.Disabled = $true
        $guestAccount.Put()
        Write-Host "   ✓ Cuenta de invitado deshabilitada"
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
        $newName = "Admin_$(Get-Random -Minimum 1000 -Maximum 9999)"
        Write-Host "   ⚠ Ejecutar manualmente: wmic useraccount where name='Administrator' call rename name='$newName'"
    } else {
        Write-Host "   ✓ Cuenta de administrador ya renombrada como: $($adminAccount.Name)"
    }
} else {
    Write-Host "   ✓ Cuenta de administrador no existe"
}

# 3. Habilitar auditoría de eventos
Write-Host "3. Verificando auditoría de eventos..."
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
auditpol /set /subcategory:"Logoff" /success:enable /failure:enable
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
Write-Host "   ✓ Auditoría de eventos configurada"

Write-Host "=== FIN ===" 