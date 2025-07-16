@echo off
chcp 65001 >nul
echo ========================================
echo VERIFICACION DE CONFIGURACIONES DE AUDITORIA
echo ========================================
echo.

echo [INFO] Iniciando verificacion de auditoria...
echo [INFO] Fecha: %date% %time%
echo.

REM Crear directorio para resultados si no existe
if not exist "evidencia\auditoria" mkdir "evidencia\auditoria"

echo ========================================
echo 5.1 EVENTOS DE WINDOWS (No aplica - Google Workspace)
echo ========================================
echo.

echo [VERIFICANDO] Politicas de auditoria actuales...
auditpol /get /category:* > "evidencia\auditoria\politicas_auditoria.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Politicas de auditoria verificadas
) else (
    echo [ERROR] No se pudieron verificar las politicas de auditoria
)

echo.
echo [VERIFICANDO] Auditoria de inicios de sesion...
auditpol /get /subcategory:"Logon" > "evidencia\auditoria\auditoria_logon.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Auditoria de logon verificada
) else (
    echo [ERROR] No se pudo verificar la auditoria de logon
)

echo.
echo [VERIFICANDO] Auditoria de cambios de contraseña...
auditpol /get /subcategory:"Credential Validation" > "evidencia\auditoria\auditoria_credenciales.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Auditoria de credenciales verificada
) else (
    echo [ERROR] No se pudo verificar la auditoria de credenciales
)

echo.
echo [VERIFICANDO] Auditoria de gestion de usuarios...
auditpol /get /subcategory:"User Account Management" > "evidencia\auditoria\auditoria_usuarios.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Auditoria de usuarios verificada
) else (
    echo [ERROR] No se pudo verificar la auditoria de usuarios
)

echo.
echo ========================================
echo 5.2 CONFIGURACION DE LOGS (No aplica - Google Workspace)
echo ========================================
echo.

echo [VERIFICANDO] Configuracion del log de seguridad...
wevtutil gl Security > "evidencia\auditoria\config_log_seguridad.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de log de seguridad verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion del log de seguridad
)

echo.
echo [VERIFICANDO] Configuracion del log de aplicacion...
wevtutil gl Application > "evidencia\auditoria\config_log_aplicacion.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de log de aplicacion verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion del log de aplicacion
)

echo.
echo [VERIFICANDO] Configuracion del log del sistema...
wevtutil gl System > "evidencia\auditoria\config_log_sistema.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de log del sistema verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion del log del sistema
)

echo.
echo [VERIFICANDO] Lista de logs disponibles...
wevtutil el > "evidencia\auditoria\logs_disponibles.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Lista de logs obtenida
) else (
    echo [ERROR] No se pudo obtener la lista de logs
)

echo.
echo ========================================
echo VERIFICACION DE EVENTOS RECIENTES
echo ========================================
echo.

echo [VERIFICANDO] Eventos recientes de seguridad...
powershell -Command "Get-WinEvent -LogName Security -MaxEvents 10 | Format-Table TimeCreated,Id,Message -AutoSize" > "evidencia\auditoria\eventos_seguridad_recientes.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Eventos de seguridad obtenidos
) else (
    echo [ERROR] No se pudieron obtener los eventos de seguridad
)

echo.
echo [VERIFICANDO] Eventos de inicio de sesion exitosos...
powershell -Command "Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} -MaxEvents 5 | Format-Table TimeCreated,Id,Message -AutoSize" > "evidencia\auditoria\eventos_logon_exitosos.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Eventos de logon exitosos obtenidos
) else (
    echo [ERROR] No se pudieron obtener los eventos de logon exitosos
)

echo.
echo [VERIFICANDO] Eventos de inicio de sesion fallidos...
powershell -Command "Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} -MaxEvents 5 | Format-Table TimeCreated,Id,Message -AutoSize" > "evidencia\auditoria\eventos_logon_fallidos.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Eventos de logon fallidos obtenidos
) else (
    echo [ERROR] No se pudieron obtener los eventos de logon fallidos
)

echo.
echo ========================================
echo VERIFICACION DE CONFIGURACION DE AUDITORIA
echo ========================================
echo.

echo [VERIFICANDO] Configuracion de auditoria en registro...
powershell -Command "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'AuditBaseObjects' -ErrorAction SilentlyContinue" > "evidencia\auditoria\config_auditoria_registro.txt" 2>&1
if %errorlevel% equ 0 (
    echo [OK] Configuracion de auditoria en registro verificada
) else (
    echo [ERROR] No se pudo verificar la configuracion de auditoria en registro
)

echo.
echo ========================================
echo RESUMEN DE VERIFICACION
echo ========================================
echo.

echo [INFO] Archivos de evidencia generados en: evidencia\auditoria\
echo [INFO] - politicas_auditoria.txt
echo [INFO] - auditoria_logon.txt
echo [INFO] - auditoria_credenciales.txt
echo [INFO] - auditoria_usuarios.txt
echo [INFO] - config_log_seguridad.txt
echo [INFO] - config_log_aplicacion.txt
echo [INFO] - config_log_sistema.txt
echo [INFO] - logs_disponibles.txt
echo [INFO] - eventos_seguridad_recientes.txt
echo [INFO] - eventos_logon_exitosos.txt
echo [INFO] - eventos_logon_fallidos.txt
echo [INFO] - config_auditoria_registro.txt

echo.
echo [INFO] Verificacion de auditoria completada
echo [INFO] Revisar archivos de evidencia para detalles completos
echo.

echo ========================================
echo NOTA: Las configuraciones de auditoria se manejan via Google Workspace
echo ========================================
echo.

pause 