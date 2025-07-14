@echo off
cls
@echo ------------------------------------------------------------------
@echo                 CCN-STIC-599B23  -    Paso 4
@echo ------------------------------------------------------------------
@echo.
@echo  Este script aplica la plantilla de seguridad y a continuacion
@echo  reinicia el sistema.
@echo.
@echo  Antes de ejecutar este script asegurese que los ficheros y
@echo  scripts se encuentran en el directorio "C:\Scripts\ESTANDAR".
@echo.
@echo ------------------------------------------------------------------

pause

set Plantilla_CCN_STIC_599B23="c:\Scripts\ESTANDAR\CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).inf"

@echo.
@echo Aplicando plantilla de seguridad...
@echo on
secedit /configure /quiet /db "c:\Scripts\ESTANDAR\CCN-STIC-599B23 Cliente Independiente.sdb" /cfg %Plantilla_CCN_STIC_599B23% /overwrite /log "c:\Scripts\ESTANDAR\CCN-STIC-599B23 Cliente Independiente.log"
@echo off


@echo.
@echo Plantilla de seguridad aplicada.
@echo A continuacion se reiniciara el sistema.
@echo.
pause


@echo on
shutdown /r /t 15 /c "El sistema se reiniciara en 15 segundos"
@echo off

@echo.
@echo ------------------------------------------------------------------
@echo      CCN-STIC-599B23  -  Paso 4  :     EJECUCION FINALIZADA 
@echo ------------------------------------------------------------------
pause
cls
