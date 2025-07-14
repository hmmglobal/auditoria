@echo off
cls
@echo ------------------------------------------------------------------
@echo                 CCN-STIC-599B23  -    Paso 3
@echo ------------------------------------------------------------------
@echo.
@echo  Este script aplica una directiva de firewall.
@echo.
@echo  Antes de ejecutar este script asegurese que los ficheros
@echo  y scripts se encuentran en el directorio "C:\Scripts\ESTANDAR".
@echo.
@echo ------------------------------------------------------------------

pause

c:
cd "c:\Scripts\ESTANDAR"
@echo on
netsh advfirewall import "CCN-STIC-599B23 Incremental Clientes Independientes (Estandar).wfw"
@echo off


@echo.
@echo ------------------------------------------------------------------
@echo      CCN-STIC-599B23  -  Paso 3  :     EJECUCION FINALIZADA 
@echo ------------------------------------------------------------------
pause
cls
