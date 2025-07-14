@echo off
cls
@echo ------------------------------------------------------------------------
@echo           CCN-STIC-599B23 Cliente Independiente - Acceso Remoto
@echo ------------------------------------------------------------------------
@echo.
@echo  Este script modifica la configuracion de inicio de los servicios
@echo  requeridos para el uso de Acceso Remoto o RDP y habilita las
@echo  configuraciones necesarias en las Plantillas Administrativas,
@echo  junto con las reglas del firewall pertinentes.
@echo.
@echo  Antes de ejecutar este script asegurese que los ficheros y scripts
@echo  se encuentran en el directorio 
@echo  "C:\Scripts\ESTANDAR\Configuraciones Adicionales".
@echo.
@echo ------------------------------------------------------------------------

pause

set Plantilla="c:\Scripts\ESTANDAR\Configuraciones Adicionales\CCN-STIC-599B23 Incremental Acceso Remoto RDP (Estandar).inf"

@echo.
@echo Configurando servicios de Windows...
@echo on
secedit /configure /quiet /db "c:\Scripts\ESTANDAR\Configuraciones Adicionales\servicios_acceso_remoto.sdb" /cfg %Plantilla% /overwrite /log "c:\Scripts\ESTANDAR\Configuraciones Adicionales\servicios_acceso_remoto.log"
@echo.
@echo Servicios de Windows configurados.
@echo off

c:
cd "c:\Scripts\ESTANDAR\Configuraciones Adicionales"

@echo.
@echo Configurando reglas del Firewall...
@echo on
netsh advfirewall import "CCN-STIC-599B23 Incremental Acceso Remoto RDP (Estandar).wfw"
@echo off
@echo.

@echo.
@echo Configurando Plantillas Administrativas...
@echo on
regedit.exe /s CCN-STIC-599B23_Acceso_Remoto_RDP_(Estandar).reg
@echo off

@echo.
@echo Plantillas Administrativas configuradas.
@echo.
@echo.
@echo ---------------------------------------------------------------------------------------
@echo      CCN-STIC-599B23 Cliente Independiente - Acceso Remoto : EJECUCION FINALIZADA 
@echo ---------------------------------------------------------------------------------------
pause
cls
