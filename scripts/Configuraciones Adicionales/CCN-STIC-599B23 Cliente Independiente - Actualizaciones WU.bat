@echo off
cls
@echo ------------------------------------------------------------------------
@echo         CCN-STIC-599B23 Cliente Independiente - Actualizaciones
@echo ------------------------------------------------------------------------
@echo.
@echo  Este script modifica la configuracion de inicio de los servicios
@echo  requeridos para el uso de Windows Update y habilita las
@echo  configuraciones necesarias en las Plantillas Administrativas.
@echo.
@echo  Antes de ejecutar este script asegurese que los ficheros y scripts
@echo  se encuentran en el directorio 
@echo  "C:\Scripts\ESTANDAR\Configuraciones Adicionales".
@echo.
@echo ------------------------------------------------------------------------

pause

set Plantilla="c:\Scripts\ESTANDAR\Configuraciones Adicionales\CCN-STIC-599B23 Incremental Actualizaciones WU.inf"

@echo.
@echo Configurando servicios de Windows...
@echo on
secedit /configure /quiet /db "c:\Scripts\ESTANDAR\Configuraciones Adicionales\servicios_actualizaciones.sdb" /cfg %Plantilla% /overwrite /log "c:\Scripts\ESTANDAR\Configuraciones Adicionales\servicios_actualizaciones.log"
@echo.
@echo Servicios de Windows configurados.
@echo off

c:
cd "c:\Scripts\ESTANDAR\Configuraciones Adicionales"

@echo.
@echo Configurando Plantillas Administrativas...
@echo on
regedit.exe /s CCN-STIC-599B23_Actualizaciones_WU.reg
@echo off

@echo.
@echo Plantillas Administrativas configuradas.
@echo.
@echo.
@echo ---------------------------------------------------------------------------------------
@echo     CCN-STIC-599B23 Cliente Independiente - Actualizaciones : EJECUCION FINALIZADA 
@echo ---------------------------------------------------------------------------------------
pause
cls
