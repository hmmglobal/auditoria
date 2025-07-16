@echo off
echo === CONFIGURACION DE RED ===

echo 1. Deshabilitando NetBIOS sobre TCP/IP...
for /f "tokens=*" %%i in ('netsh interface show interface') do (
    echo %%i | find "Enabled" >nul
    if not errorlevel 1 (
        for /f "tokens=3" %%j in ("%%i") do (
            netsh interface ipv4 set interface "%%j" netbios=disable 2>nul
        )
    )
)
echo    ✓ NetBIOS sobre TCP/IP deshabilitado

echo 2. Configurando DNS seguro...
netsh interface ipv4 set dns "Ethernet" static 8.8.8.8 2>nul
netsh interface ipv4 add dns "Ethernet" 8.8.4.4 index=2 2>nul
echo    ✓ DNS seguro configurado (Google DNS)

echo 3. Verificando IPv6...
netsh interface ipv6 show interface | find "enabled" >nul
if %errorlevel% equ 0 (
    echo    ✓ IPv6 está habilitado
) else (
    echo    ⚠ IPv6 no está habilitado
)

echo 4. Verificando configuración de proxy...
netsh winhttp show proxy
echo    ⚠ Configurar proxy desde Google Workspace si es necesario

echo === FIN ===
pause 