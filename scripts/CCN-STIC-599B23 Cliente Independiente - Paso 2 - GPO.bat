@echo off
cls
@echo ---------------------------------------------------------------------
@echo                 CCN-STIC-599B23  -    Paso 2
@echo ---------------------------------------------------------------------
@echo.
@echo  Este script aplica los valores de las plantillas administrativas
@echo  a la configuracion de equipo.
@echo.
@echo  Antes de ejecutar este script asegurese que el directorio
@echo  GroupPolicy se encuentra en el directorio "C:\Scripts\ESTANDAR".
@echo.
@echo  NOTA: el directorio GroupPolicy tiene el atributo Oculto y
@echo  es posible que tenga que cambiar las opciones de carpeta del
@echo  explorador para ver la carpeta
@echo.
@echo ---------------------------------------------------------------------

pause

"%systemroot%\system32\xcopy" /E /H /R /I /Y "c:\Scripts\ESTANDAR\GroupPolicy\*.*" "%systemroot%\system32\GroupPolicy"

rem cd %windir%\system32
rem attrib -h GroupPolicy
rem rd /q /s GroupPolicy
rem attrib -h "c:\Scripts\ESTANDAR\GroupPolicy"
rem move /y "c:\Scripts\ESTANDAR\GroupPolicy" "%Windir%\system32"
rem attrib +h "%Windir%\system32\GroupPolicy"

@echo off
gpupdate /force
@echo off

@echo.
@echo ------------------------------------------------------------------
@echo       CCN-STIC-599B23  -  Paso 2  :     EJECUCION FINALIZADA 
@echo ------------------------------------------------------------------
pause
cls
