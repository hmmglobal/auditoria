@echo off
echo === CONFIGURACION DE USUARIOS ===

echo 1. Deshabilitando cuenta de invitado...
net user Guest /active:no 2>nul
if %errorlevel% equ 0 (
    echo    ✓ Cuenta de invitado deshabilitada
) else (
    echo    ✓ Cuenta de invitado no existe o ya está deshabilitada
)

echo 2. Verificando cuenta de administrador...
wmic useraccount where name='Administrator' get name 2>nul | find "Administrator" >nul
if %errorlevel% equ 0 (
    echo    ⚠ Cuenta Administrator encontrada - renombrar manualmente
) else (
    echo    ✓ Cuenta Administrator no encontrada o ya renombrada
)

echo 3. Configurando auditoria de eventos...
echo    ⚠ Configurar manualmente en Políticas de Grupo Local
echo    - Inicios de sesión (éxito/fallo)
echo    - Cierres de sesión (éxito/fallo)
echo    - Gestión de cuentas de usuario (éxito/fallo)

echo === FIN ===
pause 