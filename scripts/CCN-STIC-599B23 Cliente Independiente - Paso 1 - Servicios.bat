@echo off
cls
@echo ------------------------------------------------------------------------
@echo                        CCN-STIC-599B23 - Paso 1
@echo ------------------------------------------------------------------------
@echo.
@echo  Este script modifica la configuracion de inicio de los servicios
@echo  requeridos para la seguridad del sistema.
@echo.
@echo  Antes de ejecutar este script asegurese que los ficheros y scripts
@echo  se encuentran en el directorio "C:\Scripts\ESTANDAR".
@echo.
@echo ------------------------------------------------------------------------

pause

set Plantilla="c:\Scripts\ESTANDAR\CCN-STIC-599B23 Incremental Servicios (Estandar).inf"

@echo.
@echo Configurando servicios de Windows...
@echo on
secedit /configure /quiet /db "c:\Scripts\ESTANDAR\servicios_windows.sdb" /cfg %Plantilla% /overwrite /log "c:\Scripts\ESTANDAR\servicios_windows.log"
@echo off


@echo.
@echo Servicios de Windows configurados.
@echo.
@echo.
@echo ------------------------------------------------------------------
@echo      CCN-STIC-599B23  -  Paso 1  :     EJECUCION FINALIZADA 
@echo ------------------------------------------------------------------
pause
cls
