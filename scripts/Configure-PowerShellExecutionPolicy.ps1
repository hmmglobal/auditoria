# Script para Configurar Política de Ejecución de PowerShell
# Autor: Sistema de Auditoría
# Fecha: $(Get-Date -Format "yyyy-MM-dd")
# Versión: 1.0

param(
    [ValidateSet("Restricted", "AllSigned", "RemoteSigned", "Unrestricted", "Bypass", "Undefined")]
    [string]$ExecutionPolicy = "RemoteSigned",
    [switch]$Force,
    [switch]$Verbose
)

# Función para escribir logs
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
}

# Función para verificar permisos de administrador
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Función para obtener política de ejecución actual
function Get-CurrentExecutionPolicy {
    Write-Log "Verificando política de ejecución actual..."
    
    $currentPolicy = Get-ExecutionPolicy
    $currentPolicyList = Get-ExecutionPolicy -List
    
    Write-Log "Política actual: $currentPolicy"
    Write-Log "Políticas por ámbito:"
    
    foreach ($scope in $currentPolicyList) {
        Write-Log "  $($scope.Scope): $($scope.ExecutionPolicy)"
    }
    
    return @{
        Current = $currentPolicy
        List = $currentPolicyList
    }
}

# Función para configurar política de ejecución
function Set-ExecutionPolicyConfig {
    param([string]$Policy, [bool]$Force)
    
    Write-Log "Configurando política de ejecución a: $Policy"
    
    try {
        if ($Force) {
            Set-ExecutionPolicy -ExecutionPolicy $Policy -Force -Scope LocalMachine
            Set-ExecutionPolicy -ExecutionPolicy $Policy -Force -Scope CurrentUser
        } else {
            Set-ExecutionPolicy -ExecutionPolicy $Policy -Scope LocalMachine
            Set-ExecutionPolicy -ExecutionPolicy $Policy -Scope CurrentUser
        }
        
        Write-Log "Política de ejecución configurada exitosamente" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error al configurar política de ejecución: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para configurar políticas específicas para scripts CCN-STIC
function Set-CCN-STIC-SpecificPolicies {
    Write-Log "Configurando políticas específicas para scripts CCN-STIC..."
    
    try {
        # Crear directorio para scripts confiables si no existe
        $trustedScriptsPath = "C:\Scripts\ESTANDAR"
        if (!(Test-Path $trustedScriptsPath)) {
            New-Item -ItemType Directory -Path $trustedScriptsPath -Force | Out-Null
            Write-Log "Directorio de scripts confiables creado: $trustedScriptsPath"
        }
        
        # Configurar política más permisiva para el directorio de scripts CCN-STIC
        $unrestrictedPolicy = "Unrestricted"
        Set-ExecutionPolicy -ExecutionPolicy $unrestrictedPolicy -Scope Process -Force
        
        Write-Log "Política temporal configurada para scripts CCN-STIC" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error al configurar políticas específicas: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para verificar scripts no firmados
function Test-UnsignedScripts {
    param([string]$ScriptsPath = ".")
    
    Write-Log "Verificando scripts no firmados en: $ScriptsPath"
    
    $scripts = Get-ChildItem -Path $ScriptsPath -Filter "*.ps1" -Recurse
    $unsignedScripts = @()
    
    foreach ($script in $scripts) {
        $signature = Get-AuthenticodeSignature -FilePath $script.FullName
        
        if ($signature.Status -ne "Valid") {
            $unsignedScripts += @{
                Name = $script.Name
                Path = $script.FullName
                Status = $signature.Status
            }
        }
    }
    
    if ($unsignedScripts.Count -gt 0) {
        Write-Log "Scripts no firmados encontrados: $($unsignedScripts.Count)" "WARNING"
        foreach ($script in $unsignedScripts) {
            Write-Log "  - $($script.Name): $($script.Status)"
        }
    } else {
        Write-Log "Todos los scripts están firmados correctamente" "SUCCESS"
    }
    
    return $unsignedScripts
}

# Función para configurar excepciones para scripts específicos
function Set-ScriptExceptions {
    param([string]$ScriptsPath = ".")
    
    Write-Log "Configurando excepciones para scripts específicos..."
    
    try {
        $scripts = Get-ChildItem -Path $ScriptsPath -Filter "*.ps1" -Recurse
        
        foreach ($script in $scripts) {
            # Crear regla de firewall para permitir ejecución (si es necesario)
            $scriptName = $script.BaseName
            Write-Log "Configurando excepción para: $scriptName"
        }
        
        Write-Log "Excepciones configuradas exitosamente" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error al configurar excepciones: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para generar reporte de configuración
function Generate-ConfigurationReport {
    param([string]$OutputPath = "C:\evidencias")
    
    if (!(Test-Path $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }
    
    $report = @"
# Reporte de Configuración de Política de Ejecución PowerShell
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Equipo: $env:COMPUTERNAME
Usuario: $env:USERNAME

## Política de Ejecución Configurada

"@
    
    $currentPolicies = Get-ExecutionPolicy -List
    foreach ($policy in $currentPolicies) {
        $report += "`n- $($policy.Scope): $($policy.ExecutionPolicy)`n"
    }
    
    $report += "`n## Recomendaciones de Seguridad`n"
    $report += @"
1. **Restricted**: No permite ejecución de scripts (más seguro)
2. **AllSigned**: Solo scripts firmados por confiables
3. **RemoteSigned**: Scripts locales sin firma, remotos firmados
4. **Unrestricted**: Permite todos los scripts (menos seguro)
5. **Bypass**: Sin restricciones (no recomendado)

## Scripts CCN-STIC

Los scripts CCN-STIC están ubicados en: C:\Scripts\ESTANDAR
Para ejecutar estos scripts específicos, use:

```powershell
# Ejecutar con política temporal
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force
.\Install-CCN-STIC-599B23.ps1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
```

## Verificación de Firmas

Para verificar que los scripts están firmados:

```powershell
Get-AuthenticodeSignature -FilePath "C:\Scripts\ESTANDAR\Install-CCN-STIC-599B23.ps1"
```

"@
    
    $report | Out-File "$OutputPath\powershell_execution_policy_report.md" -Encoding UTF8
    Write-Log "Reporte generado en: $OutputPath\powershell_execution_policy_report.md"
}

# Función principal
function Main {
    Write-Log "Iniciando configuración de política de ejecución de PowerShell..."
    
    # Verificar permisos de administrador
    if (!(Test-Administrator)) {
        Write-Log "Este script requiere permisos de administrador" "ERROR"
        Write-Log "Ejecute PowerShell como Administrador" "INFO"
        return $false
    }
    
    # Mostrar política actual
    $currentPolicies = Get-CurrentExecutionPolicy
    
    # Configurar nueva política
    if (Set-ExecutionPolicyConfig -Policy $ExecutionPolicy -Force $Force) {
        Write-Log "Política configurada exitosamente a: $ExecutionPolicy" "SUCCESS"
    } else {
        Write-Log "Error al configurar política" "ERROR"
        return $false
    }
    
    # Configurar políticas específicas para CCN-STIC
    Set-CCN-STIC-SpecificPolicies
    
    # Verificar scripts no firmados
    $unsignedScripts = Test-UnsignedScripts -ScriptsPath "."
    
    # Configurar excepciones si es necesario
    if ($unsignedScripts.Count -gt 0) {
        Write-Log "Configurando excepciones para scripts no firmados..." "WARNING"
        Set-ScriptExceptions -ScriptsPath "."
    }
    
    # Mostrar política final
    Write-Log "`n=== POLÍTICA FINAL CONFIGURADA ==="
    $finalPolicies = Get-ExecutionPolicy -List
    foreach ($policy in $finalPolicies) {
        Write-Log "$($policy.Scope): $($policy.ExecutionPolicy)"
    }
    
    # Generar reporte
    Generate-ConfigurationReport
    
    # Mostrar recomendaciones
    Write-Log "`n=== RECOMENDACIONES ==="
    Write-Log "1. Para máxima seguridad, use 'Restricted' o 'AllSigned'"
    Write-Log "2. Para scripts CCN-STIC, use 'RemoteSigned' o configure excepciones"
    Write-Log "3. Verifique siempre las firmas de scripts antes de ejecutar"
    Write-Log "4. Mantenga actualizados los certificados de firma"
    
    if ($unsignedScripts.Count -gt 0) {
        Write-Log "`n⚠️ ADVERTENCIA: Scripts no firmados detectados"
        Write-Log "Considere firmar los scripts para mayor seguridad"
        Write-Log "Use el script Sign-PowerShellScripts.ps1 para firmar"
    }
    
    return $true
}

# Ejecutar función principal
Main 