#!/bin/bash

# Script de Recolección de Evidencias de Seguridad Linux - CN-CERT
# Autor: Equipo de Seguridad
# Versión: 1.0
# Fecha: $(date +%Y-%m-%d)

# Configuración
OUTPUT_PATH=""
SYSTEM_NAME=""
AUDITOR_NAME=""
INCLUDE_LOGS=false
INCLUDE_SCREENSHOTS=false
VERBOSE=false

# Función de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -o, --output PATH     Directorio de salida (requerido)"
    echo "  -s, --system NAME     Nombre del sistema (requerido)"
    echo "  -a, --auditor NAME    Nombre del auditor (requerido)"
    echo "  -l, --logs            Incluir logs del sistema"
    echo "  -c, --screenshots     Incluir capturas de pantalla"
    echo "  -v, --verbose         Modo verbose"
    echo "  -h, --help            Mostrar esta ayuda"
    echo ""
    echo "Ejemplo:"
    echo "  $0 -o /tmp/evidencias -s servidor-web -a 'Juan Pérez' -l -c"
}

# Función para escribir logs
write_log() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_message="[$timestamp] [$level] $message"
    
    echo "$log_message"
    echo "$log_message" >> "$BASE_PATH/audit-log.txt"
}

# Función para ejecutar comando y guardar resultado
execute_and_save() {
    local command="$1"
    local filename="$2"
    local description="$3"
    
    write_log "Ejecutando: $description"
    
    local output_file="$REPORTS_PATH/$filename.txt"
    
    cat > "$output_file" << EOF
=== $description ===
Comando: $command
Fecha: $(date '+%Y-%m-%d %H:%M:%S')
Sistema: $SYSTEM_NAME
Auditor: $AUDITOR_NAME

RESULTADO:
EOF
    
    if eval "$command" >> "$output_file" 2>&1; then
        write_log "Resultado guardado: $filename.txt"
    else
        write_log "Error ejecutando $description" "ERROR"
    fi
    
    echo "" >> "$output_file"
    echo "=== FIN DE $description ===" >> "$output_file"
}

# Función para capturar pantalla
capture_screenshot() {
    local filename="$1"
    
    if command -v gnome-screenshot >/dev/null 2>&1; then
        gnome-screenshot -f "$SCREENSHOTS_PATH/$filename.png" 2>/dev/null
        write_log "Captura de pantalla guardada: $filename.png"
    elif command -v import >/dev/null 2>&1; then
        import -window root "$SCREENSHOTS_PATH/$filename.png" 2>/dev/null
        write_log "Captura de pantalla guardada: $filename.png"
    else
        write_log "No se encontró herramienta para capturar pantalla" "WARNING"
    fi
}

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        -s|--system)
            SYSTEM_NAME="$2"
            shift 2
            ;;
        -a|--auditor)
            AUDITOR_NAME="$2"
            shift 2
            ;;
        -l|--logs)
            INCLUDE_LOGS=true
            shift
            ;;
        -c|--screenshots)
            INCLUDE_SCREENSHOTS=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Opción desconocida $1"
            show_help
            exit 1
            ;;
    esac
done

# Validar parámetros requeridos
if [[ -z "$OUTPUT_PATH" || -z "$SYSTEM_NAME" || -z "$AUDITOR_NAME" ]]; then
    echo "Error: Faltan parámetros requeridos"
    show_help
    exit 1
fi

# Configuración inicial
DATE=$(date +%Y-%m-%d)
BASE_PATH="$OUTPUT_PATH/evidencias-$SYSTEM_NAME-$DATE"
SCREENSHOTS_PATH="$BASE_PATH/capturas-pantalla"
REPORTS_PATH="$BASE_PATH/reportes"
LOGS_PATH="$BASE_PATH/logs"

# Crear directorios
mkdir -p "$BASE_PATH" "$SCREENSHOTS_PATH" "$REPORTS_PATH" "$LOGS_PATH"

echo "=== RECOLECCIÓN DE EVIDENCIAS DE SEGURIDAD LINUX - CN-CERT ==="
echo "Sistema: $SYSTEM_NAME"
echo "Auditor: $AUDITOR_NAME"
echo "Fecha: $DATE"
echo "Directorio de salida: $BASE_PATH"
echo ""

write_log "Iniciando recolección de evidencias de seguridad"

# 1. Información del Sistema
echo "1. Recolectando información del sistema..."
execute_and_save "uname -a" "informacion-sistema" "INFORMACIÓN DEL SISTEMA"
execute_and_save "cat /etc/os-release" "version-sistema" "VERSIÓN DEL SISTEMA"
execute_and_save "hostname" "hostname" "NOMBRE DEL HOST"
execute_and_save "whoami" "usuario-actual" "USUARIO ACTUAL"
execute_and_save "id" "informacion-usuario" "INFORMACIÓN DE USUARIO"

# 2. Configuración de Red
echo "2. Recolectando configuración de red..."
execute_and_save "ip addr show" "configuracion-red" "CONFIGURACIÓN DE RED"
execute_and_save "ip route show" "tabla-rutas" "TABLA DE RUTAS"
execute_and_save "cat /etc/resolv.conf" "configuracion-dns" "CONFIGURACIÓN DNS"
execute_and_save "ss -tuln" "puertos-abiertos" "PUERTOS ABIERTOS"
execute_and_save "netstat -tuln" "conexiones-red" "CONEXIONES DE RED"

# 3. Usuarios y Grupos
echo "3. Recolectando información de usuarios..."
execute_and_save "cat /etc/passwd" "usuarios-sistema" "USUARIOS DEL SISTEMA"
execute_and_save "cat /etc/group" "grupos-sistema" "GRUPOS DEL SISTEMA"
execute_and_save "cat /etc/shadow" "passwords-hash" "HASHES DE CONTRASEÑAS"
execute_and_save "who" "usuarios-conectados" "USUARIOS CONECTADOS"
execute_and_save "last" "historial-inicios" "HISTORIAL DE INICIOS DE SESIÓN"

# 4. Configuración de Seguridad
echo "4. Recolectando configuración de seguridad..."

# Políticas de contraseñas
execute_and_save "cat /etc/login.defs" "politicas-contrasenas" "POLÍTICAS DE CONTRASEÑAS"
execute_and_save "cat /etc/pam.d/common-password" "configuracion-pam" "CONFIGURACIÓN PAM"

# Configuración de sudo
execute_and_save "cat /etc/sudoers" "configuracion-sudo" "CONFIGURACIÓN SUDO"
execute_and_save "ls -la /etc/sudoers.d/" "archivos-sudo" "ARCHIVOS SUDO"

# Configuración de SSH
execute_and_save "cat /etc/ssh/sshd_config" "configuracion-ssh" "CONFIGURACIÓN SSH"
execute_and_save "systemctl status ssh" "estado-ssh" "ESTADO DEL SERVICIO SSH"

# 5. Servicios del Sistema
echo "5. Verificando servicios del sistema..."
execute_and_save "systemctl list-units --type=service --state=running" "servicios-activos" "SERVICIOS ACTIVOS"
execute_and_save "systemctl list-units --type=service --state=failed" "servicios-fallidos" "SERVICIOS FALLIDOS"
execute_and_save "systemctl list-units --type=service --state=enabled" "servicios-habilitados" "SERVICIOS HABILITADOS"

# 6. Configuración de Firewall
echo "6. Verificando configuración de firewall..."
if command -v ufw >/dev/null 2>&1; then
    execute_and_save "ufw status verbose" "estado-ufw" "ESTADO UFW"
    execute_and_save "ufw status numbered" "reglas-ufw" "REGLAS UFW"
elif command -v iptables >/dev/null 2>&1; then
    execute_and_save "iptables -L -v -n" "reglas-iptables" "REGLAS IPTABLES"
    execute_and_save "iptables -t nat -L -v -n" "reglas-nat" "REGLAS NAT"
fi

# 7. Procesos del Sistema
echo "7. Analizando procesos del sistema..."
execute_and_save "ps aux" "procesos-sistema" "PROCESOS DEL SISTEMA"
execute_and_save "ps -ef" "procesos-detallados" "PROCESOS DETALLADOS"
execute_and_save "top -b -n 1" "estado-sistema" "ESTADO DEL SISTEMA"

# 8. Configuración de Logs
echo "8. Verificando configuración de logs..."
execute_and_save "cat /etc/rsyslog.conf" "configuracion-rsyslog" "CONFIGURACIÓN RSYSLOG"
execute_and_save "systemctl status rsyslog" "estado-rsyslog" "ESTADO RSYSLOG"
execute_and_save "journalctl --list-boots" "boots-disponibles" "BOOTS DISPONIBLES"

# 9. Configuración de Auditoría
echo "9. Verificando configuración de auditoría..."
if command -v auditctl >/dev/null 2>&1; then
    execute_and_save "auditctl -s" "estado-audit" "ESTADO DE AUDITORÍA"
    execute_and_save "auditctl -l" "reglas-audit" "REGLAS DE AUDITORÍA"
    execute_and_save "ausearch -i" "eventos-audit" "EVENTOS DE AUDITORÍA"
fi

# 10. Configuración de Cifrado
echo "10. Verificando configuración de cifrado..."
execute_and_save "lsblk -f" "sistemas-archivos" "SISTEMAS DE ARCHIVOS"
execute_and_save "cryptsetup status" "estado-cifrado" "ESTADO DE CIFRADO"
execute_and_save "mount | grep -E '(encrypt|luks)'" "volumenes-cifrados" "VOLÚMENES CIFRADOS"

# 11. Configuración de Aplicaciones
echo "11. Verificando aplicaciones instaladas..."
if command -v dpkg >/dev/null 2>&1; then
    execute_and_save "dpkg -l" "paquetes-instalados" "PAQUETES INSTALADOS (DEBIAN)"
elif command -v rpm >/dev/null 2>&1; then
    execute_and_save "rpm -qa" "paquetes-instalados" "PAQUETES INSTALADOS (RHEL)"
fi

# 12. Configuración de Cron
echo "12. Verificando tareas programadas..."
execute_and_save "crontab -l" "cron-usuario" "CRON DEL USUARIO"
execute_and_save "cat /etc/crontab" "cron-sistema" "CRON DEL SISTEMA"
execute_and_save "ls -la /etc/cron.d/" "cron-directorio" "ARCHIVOS CRON"

# 13. Configuración de Permisos
echo "13. Verificando permisos críticos..."
execute_and_save "ls -la /etc/passwd /etc/shadow /etc/group" "permisos-criticos" "PERMISOS CRÍTICOS"
execute_and_save "find /etc -perm -4000 -type f" "archivos-suid" "ARCHIVOS SUID"
execute_and_save "find /etc -perm -2000 -type f" "archivos-sgid" "ARCHIVOS SGID"

# 14. Configuración de Kernel
echo "14. Verificando configuración del kernel..."
execute_and_save "cat /proc/version" "version-kernel" "VERSIÓN DEL KERNEL"
execute_and_save "cat /proc/cmdline" "parametros-kernel" "PARÁMETROS DEL KERNEL"
execute_and_save "sysctl -a" "parametros-sysctl" "PARÁMETROS SYSCTL"

# 15. Capturas de Pantalla (si se solicita)
if [[ "$INCLUDE_SCREENSHOTS" == true ]]; then
    echo "15. Capturando pantallas..."
    write_log "Iniciando capturas de pantalla"
    
    echo "Abra las siguientes ventanas para capturar:"
    echo "- Configuración del sistema"
    echo "- Configuración de red"
    echo "- Configuración de seguridad"
    echo "Presione Enter cuando esté listo..."
    read -r
    
    capture_screenshot "configuracion-sistema"
    sleep 2
    capture_screenshot "configuracion-red"
    sleep 2
    capture_screenshot "configuracion-seguridad"
fi

# 16. Logs del Sistema (si se solicita)
if [[ "$INCLUDE_LOGS" == true ]]; then
    echo "16. Exportando logs del sistema..."
    write_log "Iniciando exportación de logs"
    
    # Logs del sistema
    cp /var/log/syslog "$LOGS_PATH/syslog-$DATE.log" 2>/dev/null || \
    cp /var/log/messages "$LOGS_PATH/messages-$DATE.log" 2>/dev/null
    
    # Logs de autenticación
    cp /var/log/auth.log "$LOGS_PATH/auth-$DATE.log" 2>/dev/null || \
    cp /var/log/secure "$LOGS_PATH/secure-$DATE.log" 2>/dev/null
    
    # Logs de auditoría
    if command -v ausearch >/dev/null 2>&1; then
        ausearch -i > "$LOGS_PATH/audit-$DATE.log" 2>/dev/null
    fi
    
    # Logs del journal
    journalctl --since "7 days ago" > "$LOGS_PATH/journal-$DATE.log" 2>/dev/null
    
    write_log "Logs exportados al directorio $LOGS_PATH"
fi

# 17. Generar reporte resumen
echo "17. Generando reporte resumen..."
cat > "$BASE_PATH/reporte-resumen.txt" << EOF
=== REPORTE RESUMEN DE AUDITORÍA LINUX ===
Fecha: $(date '+%Y-%m-%d %H:%M:%S')
Sistema: $SYSTEM_NAME
Auditor: $AUDITOR_NAME

INFORMACIÓN DEL SISTEMA:
- Hostname: $(hostname)
- Usuario: $(whoami)
- Distribución: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
- Kernel: $(uname -r)
- Arquitectura: $(uname -m)

ARCHIVOS GENERADOS:
$(ls "$REPORTS_PATH" | sed 's/^/- /')

CAPTURAS DE PANTALLA:
$(if [[ "$INCLUDE_SCREENSHOTS" == true ]]; then ls "$SCREENSHOTS_PATH" | sed 's/^/- /'; else echo "- No solicitadas"; fi)

LOGS EXPORTADOS:
$(if [[ "$INCLUDE_LOGS" == true ]]; then ls "$LOGS_PATH" | sed 's/^/- /'; else echo "- No solicitados"; fi)

SERVICIOS CRÍTICOS:
- SSH: $(systemctl is-active ssh 2>/dev/null || echo "No disponible")
- Firewall: $(if command -v ufw >/dev/null 2>&1; then ufw status | head -1; else echo "No UFW"; fi)
- Logs: $(systemctl is-active rsyslog 2>/dev/null || echo "No disponible")

USUARIOS ACTIVOS:
- Total usuarios: $(cat /etc/passwd | wc -l)
- Usuarios conectados: $(who | wc -l)

SISTEMAS DE ARCHIVOS:
$(df -h | head -1)
$(df -h | grep -E '(encrypt|luks)' || echo "No se encontraron volúmenes cifrados")

=== FIN DEL REPORTE RESUMEN ===
EOF

# 18. Crear archivo tar.gz con todas las evidencias
echo "18. Creando archivo comprimido con evidencias..."
tar -czf "$BASE_PATH.tar.gz" -C "$OUTPUT_PATH" "evidencias-$SYSTEM_NAME-$DATE"
write_log "Archivo comprimido creado: $BASE_PATH.tar.gz"

# Finalización
echo ""
echo "=== RECOLECCIÓN COMPLETADA ==="
echo "Directorio de evidencias: $BASE_PATH"
echo "Archivo comprimido: $BASE_PATH.tar.gz"
echo "Log de auditoría: $BASE_PATH/audit-log.txt"

write_log "Recolección de evidencias completada exitosamente"

# Mostrar estadísticas finales
TOTAL_FILES=$(find "$BASE_PATH" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$BASE_PATH" | cut -f1)
echo "Total de archivos generados: $TOTAL_FILES"
echo "Tamaño total: $TOTAL_SIZE" 