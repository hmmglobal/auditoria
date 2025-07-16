@echo off
echo === CONFIGURACION DE USUARIOS ===

echo 1. Deshabilitando cuenta de invitado...
net user Guest /active:no
echo    ✓ Cuenta de invitado deshabilitada

echo 2. Verificando cuenta de administrador...
wmic useraccount where name='Administrator' get name
echo    ⚠ Si aparece 'Administrator', renombrar manualmente

echo 3. Configurando auditoria de eventos...
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
auditpol /set /subcategory:"Logoff" /success:enable /failure:enable
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
echo    ✓ Auditoria de eventos configurada

echo === FIN ===
pause 