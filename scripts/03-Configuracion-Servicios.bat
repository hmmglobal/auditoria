@echo off
echo === CONFIGURACION DE SERVICIOS ===

echo 1. Deshabilitando Telnet...
sc config TlntSvr start= disabled 2>nul
sc stop TlntSvr 2>nul
echo    ✓ Telnet deshabilitado

echo 2. Deshabilitando TFTP...
sc config tftpd start= disabled 2>nul
sc stop tftpd 2>nul
echo    ✓ TFTP deshabilitado

echo 3. Deshabilitando SNMP...
sc config SNMP start= disabled 2>nul
sc stop SNMP 2>nul
echo    ✓ SNMP deshabilitado

echo 4. Deshabilitando Alerter...
sc config Alerter start= disabled 2>nul
sc stop Alerter 2>nul
echo    ✓ Alerter deshabilitado

echo 5. Deshabilitando Messenger...
sc config Messenger start= disabled 2>nul
sc stop Messenger 2>nul
echo    ✓ Messenger deshabilitado

echo 6. Configurando Windows Update...
sc config wuauserv start= auto 2>nul
echo    ✓ Windows Update configurado como automático

echo 7. Verificando Windows Defender...
sc query WinDefend | find "RUNNING" >nul
if %errorlevel% equ 0 (
    echo    ✓ Windows Defender está ejecutándose
) else (
    echo    ⚠ Windows Defender no está ejecutándose
)

echo 8. Verificando Firewall de Windows...
sc query MpsSvc | find "RUNNING" >nul
if %errorlevel% equ 0 (
    echo    ✓ Firewall de Windows está ejecutándose
) else (
    echo    ⚠ Firewall de Windows no está ejecutándose
)

echo === FIN ===
pause 