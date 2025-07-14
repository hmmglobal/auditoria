# Guía de Firma Digital de Scripts PowerShell - CCN-STIC 599B23

## ¿Por qué Firmar Scripts Digitalmente?

### Problemas de Scripts No Firmados
- **Política de ejecución restrictiva**: PowerShell puede bloquear scripts no firmados
- **Advertencias de seguridad**: Windows muestra advertencias al ejecutar scripts no confiables
- **Auditoría**: Difícil verificar la integridad y origen de los scripts
- **Cumplimiento**: Muchas organizaciones requieren scripts firmados para cumplir estándares de seguridad

### Beneficios de la Firma Digital
- **Autenticidad**: Verifica que el script proviene de una fuente confiable
- **Integridad**: Garantiza que el script no ha sido modificado
- **Ejecución confiable**: Permite ejecutar scripts sin advertencias
- **Auditoría**: Proporciona trazabilidad de quién creó el script
- **Cumplimiento**: Cumple con estándares de seguridad empresarial

## Opciones de Firma Digital

### 1. Certificado Autofirmado (Recomendado para Entornos Internos)

**Ventajas:**
- Gratuito
- Fácil de crear
- Control total sobre el certificado
- Adecuado para entornos internos

**Desventajas:**
- No es confiable en otros equipos
- Requiere distribución del certificado
- No verificado por autoridades externas

### 2. Certificado de Autoridad de Certificación (CA) Interna

**Ventajas:**
- Confiable en toda la organización
- Control centralizado
- Integración con Active Directory
- Políticas de seguridad corporativas

**Desventajas:**
- Requiere infraestructura PKI
- Costos de mantenimiento
- Complejidad de gestión

### 3. Certificado de Autoridad de Certificación Pública

**Ventajas:**
- Confiable universalmente
- Verificado por autoridades reconocidas
- Adecuado para distribución pública
- Mayor nivel de confianza

**Desventajas:**
- Costoso (anual)
- Requiere verificación de identidad
- Proceso de solicitud complejo

## Implementación Paso a Paso

### Paso 1: Crear Certificado Autofirmado

```powershell
# Ejecutar como Administrador
.\Sign-PowerShellScripts.ps1 -CreateSelfSigned -Verbose
```

**O manualmente:**
```powershell
# Crear certificado autofirmado
$cert = New-SelfSignedCertificate -Subject "CN=CCN-STIC-Scripts-Signing" -CertStoreLocation "Cert:\CurrentUser\My" -KeyAlgorithm RSA -KeyLength 2048 -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -KeyExportPolicy Exportable -KeyUsage DigitalSignature -Type CodeSigningCert -NotAfter (Get-Date).AddYears(5)

# Verificar certificado creado
Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=CCN-STIC-Scripts-Signing" }
```

### Paso 2: Firmar Scripts

```powershell
# Firmar todos los scripts en el directorio actual
.\Sign-PowerShellScripts.ps1 -Verbose

# Firmar scripts en directorio específico
.\Sign-PowerShellScripts.ps1 -ScriptsPath "C:\Scripts\ESTANDAR" -Verbose

# Firmar script específico
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=CCN-STIC-Scripts-Signing" } | Select-Object -First 1
Set-AuthenticodeSignature -FilePath "C:\Scripts\ESTANDAR\Install-CCN-STIC-599B23.ps1" -Certificate $cert -TimestampServer "http://timestamp.digicert.com"
```

### Paso 3: Verificar Firmas

```powershell
# Verificar firma de un script
Get-AuthenticodeSignature -FilePath "C:\Scripts\ESTANDAR\Install-CCN-STIC-599B23.ps1"

# Verificar todos los scripts en un directorio
Get-ChildItem -Path "C:\Scripts\ESTANDAR" -Filter "*.ps1" | ForEach-Object { Get-AuthenticodeSignature -FilePath $_.FullName }
```

### Paso 4: Configurar Política de Ejecución

```powershell
# Configurar política para permitir scripts firmados
.\Configure-PowerShellExecutionPolicy.ps1 -ExecutionPolicy RemoteSigned -Force -Verbose

# O manualmente
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

## Configuración de Políticas de Ejecución

### Niveles de Política de Ejecución

| Política | Descripción | Uso Recomendado |
|----------|-------------|-----------------|
| **Restricted** | No permite ejecución de scripts | Entornos de alta seguridad |
| **AllSigned** | Solo scripts firmados por confiables | Entornos corporativos |
| **RemoteSigned** | Scripts locales sin firma, remotos firmados | Desarrollo y administración |
| **Unrestricted** | Permite todos los scripts | Solo para pruebas |
| **Bypass** | Sin restricciones | No recomendado |

### Configuración Recomendada para CCN-STIC

```powershell
# Configuración recomendada
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Para scripts CCN-STIC específicos (temporal)
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force
.\Install-CCN-STIC-599B23.ps1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
```

## Distribución de Certificados

### Para Entornos de Un Solo Equipo

```powershell
# Exportar certificado autofirmado
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=CCN-STIC-Scripts-Signing" } | Select-Object -First 1
Export-PfxCertificate -Cert $cert -FilePath "C:\Scripts\ESTANDAR\CCN-STIC-Signing-Cert.pfx" -Password (ConvertTo-SecureString -String "TuContraseña" -AsPlainText -Force)

# Importar en otro equipo
Import-PfxCertificate -FilePath "C:\Scripts\ESTANDAR\CCN-STIC-Signing-Cert.pfx" -CertStoreLocation "Cert:\CurrentUser\My" -Password (ConvertTo-SecureString -String "TuContraseña" -AsPlainText -Force)
```

### Para Entornos Corporativos

```powershell
# Instalar certificado en la tienda de confianza
Import-Certificate -FilePath "C:\Scripts\ESTANDAR\CCN-STIC-Signing-Cert.cer" -CertStoreLocation "Cert:\LocalMachine\Root"

# O usar GPO para distribuir automáticamente
# (Requiere configuración en Active Directory)
```

## Verificación y Auditoría

### Comandos de Verificación

```powershell
# Verificar estado de firma
Get-AuthenticodeSignature -FilePath "script.ps1"

# Verificar certificado
Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=CCN-STIC-Scripts-Signing" }

# Verificar política de ejecución
Get-ExecutionPolicy -List

# Verificar scripts no firmados
Get-ChildItem -Path "C:\Scripts\ESTANDAR" -Filter "*.ps1" | ForEach-Object { 
    $sig = Get-AuthenticodeSignature -FilePath $_.FullName
    if ($sig.Status -ne "Valid") {
        Write-Host "Script no firmado: $($_.Name)"
    }
}
```

### Script de Verificación Automatizada

```powershell
# Ejecutar verificación completa
.\Verify-CCN-STIC-Compliance.ps1 -GenerateReport -Verbose
```

## Solución de Problemas

### Error: "No se puede cargar el archivo porque la ejecución de scripts está deshabilitada"

**Solución:**
```powershell
# Verificar política actual
Get-ExecutionPolicy

# Cambiar política temporalmente
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

# Ejecutar script
.\Install-CCN-STIC-599B23.ps1

# Restaurar política
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
```

### Error: "El archivo no está firmado digitalmente"

**Solución:**
```powershell
# Firmar el script
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=CCN-STIC-Scripts-Signing" } | Select-Object -First 1
Set-AuthenticodeSignature -FilePath "script.ps1" -Certificate $cert
```

### Error: "El certificado no es confiable"

**Solución:**
```powershell
# Instalar certificado en tienda de confianza
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=CCN-STIC-Scripts-Signing" } | Select-Object -First 1
Export-Certificate -Cert $cert -FilePath "cert.cer"
Import-Certificate -FilePath "cert.cer" -CertStoreLocation "Cert:\LocalMachine\Root"
```

### Error: "El certificado ha expirado"

**Solución:**
```powershell
# Crear nuevo certificado
Remove-Item -Path "Cert:\CurrentUser\My\ThumbprintDelCertificado" -Force
$cert = New-SelfSignedCertificate -Subject "CN=CCN-STIC-Scripts-Signing" -CertStoreLocation "Cert:\CurrentUser\My" -KeyAlgorithm RSA -KeyLength 2048 -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -KeyExportPolicy Exportable -KeyUsage DigitalSignature -Type CodeSigningCert -NotAfter (Get-Date).AddYears(5)

# Volver a firmar scripts
Get-ChildItem -Path "C:\Scripts\ESTANDAR" -Filter "*.ps1" | ForEach-Object {
    Set-AuthenticodeSignature -FilePath $_.FullName -Certificate $cert
}
```

## Mejores Prácticas

### Seguridad
1. **Usar certificados con clave privada protegida**
2. **Renovar certificados antes de que expiren**
3. **Mantener lista de certificados revocados**
4. **Verificar firmas antes de ejecutar scripts**
5. **Usar políticas de ejecución restrictivas**

### Gestión
1. **Documentar todos los certificados utilizados**
2. **Mantener backup de certificados**
3. **Establecer proceso de renovación**
4. **Auditar uso de certificados regularmente**
5. **Capacitar usuarios sobre verificación de firmas**

### Automatización
1. **Firmar scripts automáticamente al crear**
2. **Verificar firmas en despliegues**
3. **Monitorear expiración de certificados**
4. **Generar reportes de cumplimiento**
5. **Integrar con sistemas de gestión de configuración**

## Integración con CCN-STIC 599B23

### Requisitos del Estándar
- **Verificación de integridad** de scripts de seguridad
- **Autenticación** de origen de configuraciones
- **Auditoría** de cambios en configuraciones
- **Trazabilidad** de modificaciones

### Implementación
1. **Firmar todos los scripts CCN-STIC**
2. **Verificar firmas antes de ejecutar**
3. **Documentar certificados utilizados**
4. **Incluir verificación en checklist de cumplimiento**
5. **Generar evidencias de firma**

### Comandos Específicos para CCN-STIC

```powershell
# Firmar scripts CCN-STIC
.\Sign-PowerShellScripts.ps1 -ScriptsPath "C:\Scripts\ESTANDAR" -CreateSelfSigned -Verbose

# Verificar scripts CCN-STIC
Get-ChildItem -Path "C:\Scripts\ESTANDAR" -Filter "*.ps1" | ForEach-Object {
    $sig = Get-AuthenticodeSignature -FilePath $_.FullName
    Write-Host "$($_.Name): $($sig.Status)"
}

# Configurar política para CCN-STIC
.\Configure-PowerShellExecutionPolicy.ps1 -ExecutionPolicy RemoteSigned -Force -Verbose
```

## Conclusión

La firma digital de scripts es **esencial** para:
- **Cumplir estándares de seguridad** como CCN-STIC 599B23
- **Garantizar integridad** de configuraciones críticas
- **Facilitar auditorías** y verificaciones
- **Mejorar confiabilidad** en entornos empresariales

**Recomendación**: Implementar firma digital desde el inicio del proyecto CCN-STIC para evitar problemas de ejecución y cumplimiento.

---

**Nota**: Esta guía se centra en certificados autofirmados para entornos internos. Para entornos de producción o distribución pública, considere usar certificados de autoridades de certificación reconocidas. 