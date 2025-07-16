@echo off
echo === VERIFICACION DE APLICACIONES DE TERCEROS ===

echo 4.2 APLICACIONES DE TERCEROS:
echo -----------------------------

echo Verificando aplicaciones instaladas...
powershell -Command "Get-WmiObject -Class Win32_Product | Select-Object Name,Version | Sort-Object Name" > aplicaciones_instaladas.txt
if %errorlevel% equ 0 (
    echo    ✓ Lista de aplicaciones generada en: aplicaciones_instaladas.txt
) else (
    echo    ⚠ Error al generar lista de aplicaciones
)

echo.
echo Verificando aplicaciones del sistema...
powershell -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion | Sort-Object DisplayName" > aplicaciones_sistema.txt
if %errorlevel% equ 0 (
    echo    ✓ Lista de aplicaciones del sistema generada en: aplicaciones_sistema.txt
) else (
    echo    ⚠ Error al generar lista de aplicaciones del sistema
)

echo.
echo Verificando aplicaciones de usuario...
powershell -Command "Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion | Sort-Object DisplayName" > aplicaciones_usuario.txt
if %errorlevel% equ 0 (
    echo    ✓ Lista de aplicaciones de usuario generada en: aplicaciones_usuario.txt
) else (
    echo    ⚠ Error al generar lista de aplicaciones de usuario
)

echo.
echo Verificando integridad del sistema...
sfc /scannow
if %errorlevel% equ 0 (
    echo    ✓ Verificación de integridad del sistema completada
) else (
    echo    ⚠ Error en verificación de integridad del sistema
)

echo.
echo === CONFIGURACIONES EN GOOGLE WORKSPACE ===
echo - Lista de aplicaciones autorizadas: Dispositivos > Políticas de aplicaciones > Aplicaciones de terceros
echo - Configuración de seguridad: Dispositivos > Políticas de aplicaciones

echo === FIN ===
echo.
echo Archivos generados:
echo - aplicaciones_instaladas.txt
echo - aplicaciones_sistema.txt  
echo - aplicaciones_usuario.txt
pause 