@echo off
chcp 65001 >nul
echo ========================================
echo VERIFICACION DE CONFIGURACIONES DE DISPOSITIVOS
echo ========================================
echo.

echo [INFO] Iniciando verificacion de dispositivos...
echo [INFO] Fecha: %date% %time%
echo.

REM Crear directorio para resultados si no existe
if not exist "evidencia\dispositivos" mkdir "evidencia\dispositivos"

echo ========================================
echo 9.1 PERIFERICOS
echo ========================================
echo.

echo [VERIFICANDO] Dispositivos Plug and Play...
powershell -Command "Get-PnpDevice | Export-Csv -Path 'evidencia\dispositivos\dispositivos_pnp.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de dispositivos PnP generada
) else (
    echo [ERROR] No se pudo generar la lista de dispositivos PnP
)

echo.
echo [VERIFICANDO] Dispositivos USB conectados...
powershell -Command "Get-PnpDevice | Where-Object {$_.Class -eq 'USB'} | Export-Csv -Path 'evidencia\dispositivos\dispositivos_usb.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de dispositivos USB generada
) else (
    echo [ERROR] No se pudo generar la lista de dispositivos USB
)

echo.
echo [VERIFICANDO] Dispositivos de almacenamiento...
powershell -Command "Get-PnpDevice | Where-Object {$_.Class -eq 'DiskDrive'} | Export-Csv -Path 'evidencia\dispositivos\dispositivos_almacenamiento.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de dispositivos de almacenamiento generada
) else (
    echo [ERROR] No se pudo generar la lista de dispositivos de almacenamiento
)

echo.
echo [VERIFICANDO] Impresoras instaladas...
powershell -Command "Get-Printer | Export-Csv -Path 'evidencia\dispositivos\impresoras.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de impresoras generada
) else (
    echo [ERROR] No se pudo generar la lista de impresoras
)

echo.
echo [VERIFICANDO] Dispositivos de audio...
powershell -Command "Get-PnpDevice | Where-Object {$_.Class -eq 'Media'} | Export-Csv -Path 'evidencia\dispositivos\dispositivos_audio.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de dispositivos de audio generada
) else (
    echo [ERROR] No se pudo generar la lista de dispositivos de audio
)

echo.
echo [VERIFICANDO] Dispositivos de red...
powershell -Command "Get-PnpDevice | Where-Object {$_.Class -eq 'Net'} | Export-Csv -Path 'evidencia\dispositivos\dispositivos_red.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de dispositivos de red generada
) else (
    echo [ERROR] No se pudo generar la lista de dispositivos de red
)

echo.
echo [VERIFICANDO] Dispositivos de entrada (teclado, mouse)...
powershell -Command "Get-PnpDevice | Where-Object {$_.Class -eq 'Keyboard' -or $_.Class -eq 'Mouse'} | Export-Csv -Path 'evidencia\dispositivos\dispositivos_entrada.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de dispositivos de entrada generada
) else (
    echo [ERROR] No se pudo generar la lista de dispositivos de entrada
)

echo.
echo [VERIFICANDO] Dispositivos de almacenamiento USB...
powershell -Command "Get-WmiObject -Class Win32_DiskDrive | Where-Object {$_.InterfaceType -eq 'USB'} | Export-Csv -Path 'evidencia\dispositivos\almacenamiento_usb.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de almacenamiento USB generada
) else (
    echo [ERROR] No se pudo generar la lista de almacenamiento USB
)

echo.
echo [VERIFICANDO] Dispositivos de almacenamiento removible...
powershell -Command "Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 2} | Export-Csv -Path 'evidencia\dispositivos\almacenamiento_removible.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de almacenamiento removible generada
) else (
    echo [ERROR] No se pudo generar la lista de almacenamiento removible
)

echo.
echo ========================================
echo 9.2 CONFIGURACIONES DE ENERGIA (Google Workspace)
echo ========================================
echo.

echo [VERIFICANDO] Esquemas de energia disponibles...
powercfg /list > "evidencia\dispositivos\esquemas_energia.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de esquemas de energia generada
) else (
    echo [ERROR] No se pudo generar la lista de esquemas de energia
)

echo.
echo [VERIFICANDO] Esquema de energia activo...
powercfg /getactivescheme > "evidencia\dispositivos\esquema_activo.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Esquema activo verificado
) else (
    echo [ERROR] No se pudo verificar el esquema activo
)

echo.
echo [VERIFICANDO] Configuracion de energia actual...
powercfg /query > "evidencia\dispositivos\configuracion_energia.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de energia verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion de energia
)

echo.
echo [VERIFICANDO] Configuracion de suspension...
powercfg /query SCHEME_CURRENT SUB_SLEEP > "evidencia\dispositivos\configuracion_suspension.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de suspension verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion de suspension
)

echo.
echo [VERIFICANDO] Configuracion de pantalla...
powercfg /query SCHEME_CURRENT SUB_VIDEO > "evidencia\dispositivos\configuracion_pantalla.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de pantalla verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion de pantalla
)

echo.
echo [VERIFICANDO] Configuracion de disco duro...
powercfg /query SCHEME_CURRENT SUB_DISK > "evidencia\dispositivos\configuracion_disco.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de disco verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion de disco
)

echo.
echo ========================================
echo VERIFICACION DE CONFIGURACIONES DE SEGURIDAD
echo ========================================
echo.

echo [VERIFICANDO] Configuracion de BitLocker...
manage-bde -status > "evidencia\dispositivos\bitlocker_status.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Estado de BitLocker verificado
) else (
    echo [ERROR] No se pudo verificar el estado de BitLocker
)

echo.
echo [VERIFICANDO] Configuracion de TPM...
powershell -Command "Get-WmiObject -Class Win32_TPM | Export-Csv -Path 'evidencia\dispositivos\tpm_config.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de TPM verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion de TPM
)

echo.
echo [VERIFICANDO] Dispositivos con errores...
powershell -Command "Get-PnpDevice | Where-Object {$_.Status -eq 'Error'} | Export-Csv -Path 'evidencia\dispositivos\dispositivos_error.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de dispositivos con errores generada
) else (
    echo [ERROR] No se pudo generar la lista de dispositivos con errores
)

echo.
echo ========================================
echo VERIFICACION DE ALMACENAMIENTO
echo ========================================
echo.

echo [VERIFICANDO] Discos fisicos...
powershell -Command "Get-PhysicalDisk | Export-Csv -Path 'evidencia\dispositivos\discos_fisicos.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de discos fisicos generada
) else (
    echo [ERROR] No se pudo generar la lista de discos fisicos
)

echo.
echo [VERIFICANDO] Volumenes...
powershell -Command "Get-Volume | Export-Csv -Path 'evidencia\dispositivos\volumenes.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de volumenes generada
) else (
    echo [ERROR] No se pudo generar la lista de volumenes
)

echo.
echo [VERIFICANDO] Particiones...
powershell -Command "Get-Partition | Export-Csv -Path 'evidencia\dispositivos\particiones.csv' -NoTypeInformation" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de particiones generada
) else (
    echo [ERROR] No se pudo generar la lista de particiones
)

echo.
echo ========================================
echo RESUMEN DE VERIFICACION
echo ========================================
echo.

echo [INFO] Archivos de evidencia generados en: evidencia\dispositivos\
echo [INFO] - dispositivos_pnp.csv
echo [INFO] - dispositivos_usb.csv
echo [INFO] - dispositivos_almacenamiento.csv
echo [INFO] - impresoras.csv
echo [INFO] - dispositivos_audio.csv
echo [INFO] - dispositivos_red.csv
echo [INFO] - dispositivos_entrada.csv
echo [INFO] - almacenamiento_usb.csv
echo [INFO] - almacenamiento_removible.csv
echo [INFO] - esquemas_energia.txt
echo [INFO] - esquema_activo.txt
echo [INFO] - configuracion_energia.txt
echo [INFO] - configuracion_suspension.txt
echo [INFO] - configuracion_pantalla.txt
echo [INFO] - configuracion_disco.txt
echo [INFO] - bitlocker_status.txt
echo [INFO] - tpm_config.csv
echo [INFO] - dispositivos_error.csv
echo [INFO] - discos_fisicos.csv
echo [INFO] - volumenes.csv
echo [INFO] - particiones.csv

echo.
echo [INFO] Verificacion de dispositivos completada
echo [INFO] Revisar archivos de evidencia para detalles completos
echo.

echo ========================================
echo NOTA: Las configuraciones de energia se manejan via Google Workspace
echo ========================================
echo.

pause 