@echo off
echo === VERIFICACION DE SEGURIDAD ===

echo 2.1 WINDOWS DEFENDER:
echo ---------------------
powershell -Command "Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, CloudProtectionEnabled, BehaviorMonitorEnabled, OnAccessProtectionEnabled, IoavProtectionEnabled" 2>nul
if %errorlevel% equ 0 (
    echo    ✓ Windows Defender configurado
) else (
    echo    ⚠ Verificar Windows Defender manualmente
)

echo.
echo 2.2 BITLOCKER:
echo --------------
manage-bde -status 2>nul | find "Protection On"
if %errorlevel% equ 0 (
    echo    ✓ BitLocker habilitado
) else (
    echo    ⚠ BitLocker no habilitado
)

echo.
echo 2.3 WINDOWS HELLO:
echo ------------------
powershell -Command "Get-WmiObject -Class Win32_TPM | Select-Object IsEnabled, IsActivated" 2>nul
if %errorlevel% equ 0 (
    echo    ✓ TPM disponible
) else (
    echo    ⚠ TPM no disponible
)

echo.
echo 2.4 POLITICAS DE APLICACIONES:
echo ------------------------------
powershell -Command "Get-AppLockerPolicy -Effective" 2>nul
if %errorlevel% equ 0 (
    echo    ✓ AppLocker configurado
) else (
    echo    ⚠ AppLocker no configurado
)

echo.
echo === CONFIGURACIONES EN GOOGLE WORKSPACE ===
echo - Windows Defender: Seguridad > Endpoint Management
echo - BitLocker: Dispositivos > Configuración de seguridad
echo - Windows Hello: Seguridad > Autenticación
echo - Políticas de Apps: Dispositivos > Políticas de aplicaciones

echo === FIN ===
pause 