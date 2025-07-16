@echo off
echo === VERIFICACION DE NAVEGACION WEB ===

echo 3.1 MICROSOFT EDGE:
echo -------------------
echo Verificando configuraciones de Edge...

rem Verificar SmartScreen
reg query "HKCU\Software\Microsoft\Edge\SmartScreenEnabled" 2>nul
if %errorlevel% equ 0 (
    echo    ✓ SmartScreen configurado
) else (
    echo    ⚠ SmartScreen no configurado
)

rem Verificar protección contra phishing
reg query "HKCU\Software\Microsoft\Edge\PhishingProtectionEnabled" 2>nul
if %errorlevel% equ 0 (
    echo    ✓ Protección contra phishing configurada
) else (
    echo    ⚠ Protección contra phishing no configurada
)

rem Verificar configuración de cookies
reg query "HKCU\Software\Microsoft\Edge\CookiesBlockThirdParty" 2>nul
if %errorlevel% equ 0 (
    echo    ✓ Configuración de cookies configurada
) else (
    echo    ⚠ Configuración de cookies no configurada
)

rem Verificar JavaScript
reg query "HKCU\Software\Microsoft\Edge\JavaScriptEnabled" 2>nul
if %errorlevel% equ 0 (
    echo    ✓ JavaScript configurado
) else (
    echo    ⚠ JavaScript no configurado
)

echo.
echo 3.2 CONFIGURACIONES DE PROXY:
echo -----------------------------
echo Verificando configuración de proxy...

rem Verificar proxy
netsh winhttp show proxy
if %errorlevel% equ 0 (
    echo    ✓ Configuración de proxy verificada
) else (
    echo    ⚠ Configuración de proxy no encontrada
)

rem Verificar certificados SSL
echo    ⚠ Verificar certificados SSL manualmente con: certmgr.msc

echo.
echo === CONFIGURACIONES EN GOOGLE WORKSPACE ===
echo - Microsoft Edge: Dispositivos > Configuración de navegador > Microsoft Edge
echo - Proxy: Dispositivos > Configuración de red > Proxy (ya configurado en punto 1.4)

echo === FIN ===
pause 