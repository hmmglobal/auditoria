# Script de Verificación de Cumplimiento CCN-STIC 599B23
# Autor: Sistema de Auditoría
# Fecha: $(Get-Date -Format "yyyy-MM-dd")
# Versión: 1.0

param(
    [string]$OutputPath = "C:\evidencias",
    [switch]$GenerateReport,
    [switch]$Verbose
)

# Crear directorio de evidencias si no existe
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

# Función para escribir logs
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "$OutputPath\verification.log" -Value $logMessage
}

# Función para verificar políticas de contraseñas
function Test-PasswordPolicies {
    Write-Log "Verificando políticas de contraseñas..."
    
    try {
        $securityPolicy = secedit /export /cfg "$OutputPath\temp_security.inf" 2>$null
        if (Test-Path "$OutputPath\temp_security.inf") {
            $content = Get-Content "$OutputPath\temp_security.inf"
            
            $results = @{
                MinimumPasswordAge = ($content | Select-String "MinimumPasswordAge\s*=\s*(\d+)").Matches.Groups[1].Value
                MaximumPasswordAge = ($content | Select-String "MaximumPasswordAge\s*=\s*(\d+)").Matches.Groups[1].Value
                MinimumPasswordLength = ($content | Select-String "MinimumPasswordLength\s*=\s*(\d+)").Matches.Groups[1].Value
                PasswordComplexity = ($content | Select-String "PasswordComplexity\s*=\s*(\d+)").Matches.Groups[1].Value
                PasswordHistorySize = ($content | Select-String "PasswordHistorySize\s*=\s*(\d+)").Matches.Groups[1].Value
                LockoutBadCount = ($content | Select-String "LockoutBadCount\s*=\s*(\d+)").Matches.Groups[1].Value
                ResetLockoutCount = ($content | Select-String "ResetLockoutCount\s*=\s*(\d+)").Matches.Groups[1].Value
                LockoutDuration = ($content | Select-String "LockoutDuration\s*=\s*(-?\d+)").Matches.Groups[1].Value
            }
            
            # Verificar cumplimiento
            $compliance = @{
                MinimumPasswordAge = $results.MinimumPasswordAge -eq "2"
                MaximumPasswordAge = $results.MaximumPasswordAge -eq "60"
                MinimumPasswordLength = $results.MinimumPasswordLength -eq "10"
                PasswordComplexity = $results.PasswordComplexity -eq "1"
                PasswordHistorySize = $results.PasswordHistorySize -eq "24"
                LockoutBadCount = $results.LockoutBadCount -eq "5"
                ResetLockoutCount = $results.ResetLockoutCount -eq "15"
                LockoutDuration = $results.LockoutDuration -eq "-1"
            }
            
            return @{
                Results = $results
                Compliance = $compliance
                Compliant = ($compliance.Values | Where-Object { $_ -eq $false }).Count -eq 0
            }
        }
    }
    catch {
        Write-Log "Error al verificar políticas de contraseñas: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Función para verificar servicios
function Test-ServicesConfiguration {
    Write-Log "Verificando configuración de servicios..."
    
    $disabledServices = @(
        "BcastDVRUserService", "BluetoothUserService", "CaptureService", "cbdhsvc",
        "CDPUserSvc", "ConsentUxUserSvc", "DevicePickerUserSvc", "DevicesFlowUserSvc",
        "MessagingService", "OneSyncSvc", "PimIndexMaintenanceSvc", "PrintWorkflowUserSvc",
        "UnistoreSvc", "UserDataSvc", "WpnUserService"
    )
    
    $manualServices = @(
        "AarSvc", "CredentialEnrollmentManagerUserSvc", "DeviceAssociationBrokerSvc",
        "UdkUserSvc", "NPSMSvc", "P9RdrService", "PenService", "webthreatdefusersvc"
    )
    
    $results = @{
        DisabledServices = @()
        ManualServices = @()
        NonCompliantServices = @()
    }
    
    foreach ($service in $disabledServices) {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc) {
            if ($svc.StartType -eq "Disabled") {
                $results.DisabledServices += $service
            } else {
                $results.NonCompliantServices += @{
                    Service = $service
                    Expected = "Disabled"
                    Actual = $svc.StartType
                }
            }
        }
    }
    
    foreach ($service in $manualServices) {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc) {
            if ($svc.StartType -eq "Manual") {
                $results.ManualServices += $service
            } else {
                $results.NonCompliantServices += @{
                    Service = $service
                    Expected = "Manual"
                    Actual = $svc.StartType
                }
            }
        }
    }
    
    return @{
        Results = $results
        Compliant = $results.NonCompliantServices.Count -eq 0
    }
}

# Función para verificar configuración de auditoría
function Test-AuditConfiguration {
    Write-Log "Verificando configuración de auditoría..."
    
    try {
        $auditPolicy = auditpol /get /category:* 2>$null | Out-String
        $lines = $auditPolicy -split "`n"
        
        $results = @{}
        foreach ($line in $lines) {
            if ($line -match "(.+)\s+(Success|Failure|Success and Failure|No Auditing)") {
                $category = $matches[1].Trim()
                $setting = $matches[2].Trim()
                $results[$category] = $setting
            }
        }
        
        # Verificar configuraciones críticas
        $expectedSettings = @{
            "System Events" = "Success and Failure"
            "Logon Events" = "Success and Failure"
            "Object Access" = "Success and Failure"
            "Privilege Use" = "Success and Failure"
            "Policy Change" = "Success and Failure"
            "Account Management" = "Success and Failure"
            "Process Tracking" = "No Auditing"
            "Directory Service Access" = "Success and Failure"
            "Account Logon Events" = "Success and Failure"
        }
        
        $compliance = @{}
        foreach ($category in $expectedSettings.Keys) {
            $compliance[$category] = $results[$category] -eq $expectedSettings[$category]
        }
        
        return @{
            Results = $results
            Expected = $expectedSettings
            Compliance = $compliance
            Compliant = ($compliance.Values | Where-Object { $_ -eq $false }).Count -eq 0
        }
    }
    catch {
        Write-Log "Error al verificar configuración de auditoría: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Función para verificar Windows Defender
function Test-WindowsDefenderConfiguration {
    Write-Log "Verificando configuración de Windows Defender..."
    
    try {
        $preferences = Get-MpPreference -ErrorAction SilentlyContinue
        $status = Get-MpComputerStatus -ErrorAction SilentlyContinue
        
        if ($preferences -and $status) {
            $results = @{
                PUAProtection = $preferences.PUAProtection
                DisableAntiSpyware = $preferences.DisableAntiSpyware
                ServiceKeepAlive = $preferences.ServiceKeepAlive
                RealTimeProtectionEnabled = $status.RealTimeProtectionEnabled
                BehaviorMonitorEnabled = $status.BehaviorMonitorEnabled
                IOAVProtectionEnabled = $status.IOAVProtectionEnabled
            }
            
            $compliance = @{
                PUAProtection = $results.PUAProtection -eq $true
                DisableAntiSpyware = $results.DisableAntiSpyware -eq $false
                ServiceKeepAlive = $results.ServiceKeepAlive -eq $true
                RealTimeProtectionEnabled = $results.RealTimeProtectionEnabled -eq $true
                BehaviorMonitorEnabled = $results.BehaviorMonitorEnabled -eq $true
                IOAVProtectionEnabled = $results.IOAVProtectionEnabled -eq $true
            }
            
            return @{
                Results = $results
                Compliance = $compliance
                Compliant = ($compliance.Values | Where-Object { $_ -eq $false }).Count -eq 0
            }
        }
    }
    catch {
        Write-Log "Error al verificar Windows Defender: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Función para verificar configuración de registro
function Test-RegistryConfiguration {
    Write-Log "Verificando configuración de registro..."
    
    $registryChecks = @{
        "LSA\RestrictAnonymous" = @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Expected = 1 }
        "LSA\NoLMHash" = @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Expected = 1 }
        "LSA\LimitBlankPasswordUse" = @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Expected = 1 }
        "LSA\ForceGuest" = @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Expected = 0 }
        "LSA\EveryoneIncludesAnonymous" = @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Expected = 0 }
        "LSA\DisableDomainCreds" = @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Expected = 1 }
        "LSA\CrashOnAuditFail" = @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Expected = 1 }
    }
    
    $results = @{}
    $compliance = @{}
    
    foreach ($check in $registryChecks.GetEnumerator()) {
        try {
            $value = Get-ItemProperty -Path $check.Value.Path -Name $check.Key -ErrorAction SilentlyContinue
            if ($value) {
                $actualValue = $value.$($check.Key)
                $results[$check.Key] = $actualValue
                $compliance[$check.Key] = $actualValue -eq $check.Value.Expected
            } else {
                $results[$check.Key] = "Not Found"
                $compliance[$check.Key] = $false
            }
        }
        catch {
            $results[$check.Key] = "Error"
            $compliance[$check.Key] = $false
        }
    }
    
    return @{
        Results = $results
        Compliance = $compliance
        Compliant = ($compliance.Values | Where-Object { $_ -eq $false }).Count -eq 0
    }
}

# Función para generar reporte
function Generate-ComplianceReport {
    param($Results)
    
    $report = @"
# Reporte de Cumplimiento CCN-STIC 599B23
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Equipo: $env:COMPUTERNAME
Usuario: $env:USERNAME

## Resumen de Cumplimiento

"@
    
    $overallCompliant = $true
    
    foreach ($category in $Results.Keys) {
        $result = $Results[$category]
        if ($result.Compliant -eq $false) {
            $overallCompliant = $false
        }
        
        $status = if ($result.Compliant) { "✅ CUMPLE" } else { "❌ NO CUMPLE" }
        $report += "`n### $category : $status`n"
        
        if ($result.Results) {
            $report += "`n**Detalles:**`n"
            foreach ($item in $result.Results.GetEnumerator()) {
                $report += "- $($item.Key): $($item.Value)`n"
            }
        }
        
        if ($result.Compliance) {
            $report += "`n**Cumplimiento:**`n"
            foreach ($item in $result.Compliance.GetEnumerator()) {
                $status = if ($item.Value) { "✅" } else { "❌" }
                $report += "- $($item.Key): $status`n"
            }
        }
    }
    
    $overallStatus = if ($overallCompliant) { "✅ CUMPLE" } else { "❌ NO CUMPLE" }
    $report += "`n## Estado General: $overallStatus`n"
    
    return $report
}

# Función principal
function Main {
    Write-Log "Iniciando verificación de cumplimiento CCN-STIC 599B23..."
    
    $allResults = @{}
    
    # Verificar políticas de contraseñas
    $passwordResults = Test-PasswordPolicies
    if ($passwordResults) {
        $allResults["Políticas de Contraseñas"] = $passwordResults
    }
    
    # Verificar servicios
    $serviceResults = Test-ServicesConfiguration
    if ($serviceResults) {
        $allResults["Configuración de Servicios"] = $serviceResults
    }
    
    # Verificar auditoría
    $auditResults = Test-AuditConfiguration
    if ($auditResults) {
        $allResults["Configuración de Auditoría"] = $auditResults
    }
    
    # Verificar Windows Defender
    $defenderResults = Test-WindowsDefenderConfiguration
    if ($defenderResults) {
        $allResults["Windows Defender"] = $defenderResults
    }
    
    # Verificar registro
    $registryResults = Test-RegistryConfiguration
    if ($registryResults) {
        $allResults["Configuración de Registro"] = $registryResults
    }
    
    # Exportar resultados a JSON
    $allResults | ConvertTo-Json -Depth 10 | Out-File "$OutputPath\compliance_results.json" -Encoding UTF8
    
    # Generar reporte si se solicita
    if ($GenerateReport) {
        $report = Generate-ComplianceReport -Results $allResults
        $report | Out-File "$OutputPath\compliance_report.md" -Encoding UTF8
        Write-Log "Reporte generado en: $OutputPath\compliance_report.md"
    }
    
    # Mostrar resumen
    Write-Log "Verificación completada. Resultados guardados en: $OutputPath"
    
    $compliantCount = ($allResults.Values | Where-Object { $_.Compliant -eq $true }).Count
    $totalCount = $allResults.Count
    
    Write-Log "Resumen: $compliantCount de $totalCount categorías cumplen con el estándar"
    
    if ($Verbose) {
        foreach ($category in $allResults.Keys) {
            $status = if ($allResults[$category].Compliant) { "CUMPLE" } else { "NO CUMPLE" }
            Write-Log "$category : $status"
        }
    }
    
    return $allResults
}

# Ejecutar función principal
Main 