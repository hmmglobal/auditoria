# Script para Firmar Digitalmente Scripts de PowerShell
# Autor: Sistema de Auditoría
# Fecha: $(Get-Date -Format "yyyy-MM-dd")
# Versión: 1.0

param(
    [string]$ScriptsPath = ".",
    [string]$CertificatePath = "",
    [string]$CertificatePassword = "",
    [switch]$CreateSelfSigned,
    [switch]$Verbose
)

# Función para escribir logs
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
}

# Función para crear certificado autofirmado
function New-SelfSignedCertificate {
    Write-Log "Creando certificado autofirmado para firmar scripts..."
    
    try {
        $cert = New-SelfSignedCertificate -Subject "CN=CCN-STIC-Scripts-Signing" -CertStoreLocation "Cert:\CurrentUser\My" -KeyAlgorithm RSA -KeyLength 2048 -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -KeyExportPolicy Exportable -KeyUsage DigitalSignature -Type CodeSigningCert -NotAfter (Get-Date).AddYears(5)
        
        Write-Log "Certificado autofirmado creado exitosamente"
        Write-Log "Thumbprint: $($cert.Thumbprint)"
        Write-Log "Válido hasta: $($cert.NotAfter)"
        
        return $cert
    }
    catch {
        Write-Log "Error al crear certificado autofirmado: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Función para importar certificado desde archivo
function Import-CertificateFromFile {
    param([string]$CertificatePath, [string]$Password)
    
    Write-Log "Importando certificado desde: $CertificatePath"
    
    try {
        if ($Password) {
            $cert = Import-PfxCertificate -FilePath $CertificatePath -CertStoreLocation "Cert:\CurrentUser\My" -Password (ConvertTo-SecureString -String $Password -AsPlainText -Force)
        } else {
            $cert = Import-PfxCertificate -FilePath $CertificatePath -CertStoreLocation "Cert:\CurrentUser\My"
        }
        
        Write-Log "Certificado importado exitosamente"
        Write-Log "Thumbprint: $($cert.Thumbprint)"
        
        return $cert
    }
    catch {
        Write-Log "Error al importar certificado: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Función para obtener certificado de la tienda
function Get-CodeSigningCertificate {
    Write-Log "Buscando certificados de firma de código disponibles..."
    
    try {
        $certs = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.EnhancedKeyUsageList -and $_.EnhancedKeyUsageList.FriendlyName -contains "Code Signing" }
        
        if ($certs.Count -eq 0) {
            Write-Log "No se encontraron certificados de firma de código" "WARNING"
            return $null
        }
        
        Write-Log "Certificados de firma de código encontrados:"
        foreach ($cert in $certs) {
            Write-Log "  - $($cert.Subject) (Thumbprint: $($cert.Thumbprint))"
        }
        
        # Seleccionar el primer certificado disponible
        $selectedCert = $certs[0]
        Write-Log "Usando certificado: $($selectedCert.Subject)"
        
        return $selectedCert
    }
    catch {
        Write-Log "Error al buscar certificados: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Función para firmar script
function Sign-PowerShellScript {
    param([string]$ScriptPath, [System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate)
    
    Write-Log "Firmando script: $ScriptPath"
    
    try {
        $result = Set-AuthenticodeSignature -FilePath $ScriptPath -Certificate $Certificate -TimestampServer "http://timestamp.digicert.com"
        
        if ($result.Status -eq "Valid") {
            Write-Log "Script firmado exitosamente: $ScriptPath" "SUCCESS"
            return $true
        } else {
            Write-Log "Error al firmar script: $($result.StatusMessage)" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Error al firmar script $ScriptPath : $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función para verificar firma de script
function Test-ScriptSignature {
    param([string]$ScriptPath)
    
    try {
        $signature = Get-AuthenticodeSignature -FilePath $ScriptPath
        
        switch ($signature.Status) {
            "Valid" { 
                Write-Log "✅ Firma válida: $ScriptPath" "SUCCESS"
                return $true 
            }
            "NotSigned" { 
                Write-Log "❌ Script no firmado: $ScriptPath" "WARNING"
                return $false 
            }
            "HashMismatch" { 
                Write-Log "❌ Hash no coincide: $ScriptPath" "ERROR"
                return $false 
            }
            "NotTrusted" { 
                Write-Log "⚠️ Firma no confiable: $ScriptPath" "WARNING"
                return $false 
            }
            default { 
                Write-Log "❓ Estado desconocido ($($signature.Status)): $ScriptPath" "WARNING"
                return $false 
            }
        }
    }
    catch {
        Write-Log "Error al verificar firma de $ScriptPath : $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Función principal
function Main {
    Write-Log "Iniciando proceso de firma digital de scripts..."
    
    # Obtener certificado
    $certificate = $null
    
    if ($CreateSelfSigned) {
        $certificate = New-SelfSignedCertificate
    } elseif ($CertificatePath -and (Test-Path $CertificatePath)) {
        $certificate = Import-CertificateFromFile -CertificatePath $CertificatePath -Password $CertificatePassword
    } else {
        $certificate = Get-CodeSigningCertificate
    }
    
    if (!$certificate) {
        Write-Log "No se pudo obtener certificado para firma" "ERROR"
        Write-Log "Opciones disponibles:" "INFO"
        Write-Log "1. Usar -CreateSelfSigned para crear certificado autofirmado" "INFO"
        Write-Log "2. Usar -CertificatePath para importar certificado existente" "INFO"
        Write-Log "3. Instalar certificado de firma de código en la tienda personal" "INFO"
        return $false
    }
    
    # Buscar scripts de PowerShell
    $scripts = Get-ChildItem -Path $ScriptsPath -Filter "*.ps1" -Recurse
    
    if ($scripts.Count -eq 0) {
        Write-Log "No se encontraron scripts .ps1 en: $ScriptsPath" "WARNING"
        return $false
    }
    
    Write-Log "Encontrados $($scripts.Count) scripts para firmar"
    
    $signedCount = 0
    $failedCount = 0
    
    foreach ($script in $scripts) {
        # Verificar si ya está firmado
        $currentSignature = Get-AuthenticodeSignature -FilePath $script.FullName
        
        if ($currentSignature.Status -eq "Valid") {
            Write-Log "Script ya firmado: $($script.Name)" "INFO"
            $signedCount++
        } else {
            # Firmar script
            if (Sign-PowerShellScript -ScriptPath $script.FullName -Certificate $certificate) {
                $signedCount++
            } else {
                $failedCount++
            }
        }
    }
    
    # Mostrar resumen
    Write-Log "=== RESUMEN DE FIRMA ==="
    Write-Log "Scripts firmados exitosamente: $signedCount"
    Write-Log "Scripts con errores: $failedCount"
    Write-Log "Total de scripts procesados: $($scripts.Count)"
    
    # Verificar firmas
    Write-Log "`n=== VERIFICACIÓN DE FIRMAS ==="
    $validSignatures = 0
    
    foreach ($script in $scripts) {
        if (Test-ScriptSignature -ScriptPath $script.FullName) {
            $validSignatures++
        }
    }
    
    Write-Log "Firmas válidas: $validSignatures de $($scripts.Count)"
    
    if ($validSignatures -eq $scripts.Count) {
        Write-Log "✅ Todos los scripts están correctamente firmados" "SUCCESS"
    } else {
        Write-Log "⚠️ Algunos scripts no tienen firma válida" "WARNING"
    }
    
    return $true
}

# Ejecutar función principal
Main 