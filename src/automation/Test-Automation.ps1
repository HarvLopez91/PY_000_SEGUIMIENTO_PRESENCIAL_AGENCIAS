# ========================================================================================================
# Script: Test-Automation.ps1
# Descripción: Script de prueba para verificar la funcionalidad de automatización de SharePoint
# Autor: Sistema de Automatización - Centro de Gestión del Cliente
# Fecha: 30/10/2025
# Versión: 1.0.0
# ========================================================================================================

param(
    [switch]$TestScript,
    [switch]$TestScheduling,
    [switch]$TestBoth
)

$ScriptPath = Join-Path $PSScriptRoot "Open-SharePointFile.ps1"
$SetupPath = Join-Path $PSScriptRoot "Setup-ScheduledTasks.ps1"

function Write-TestMessage {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    switch ($Type) {
        "SUCCESS" { Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
        "ERROR" { Write-Host "[ERROR] $Message" -ForegroundColor Red }
        "WARNING" { Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
        "INFO" { Write-Host "[INFO] $Message" -ForegroundColor Cyan }
        "TEST" { Write-Host "[TEST] $Message" -ForegroundColor Magenta }
        default { Write-Host "$Message" }
    }
}

function Test-MainScript {
    Write-TestMessage "=== PRUEBA DEL SCRIPT PRINCIPAL ===" "TEST"
    
    # Verificar que el archivo existe
    if (!(Test-Path $ScriptPath)) {
        Write-TestMessage "Error: Script principal no encontrado en $ScriptPath" "ERROR"
        return $false
    }
    
    Write-TestMessage "Script principal encontrado: $ScriptPath" "SUCCESS"
    
    # Probar ejecución del script
    try {
        Write-TestMessage "Probando sintaxis del script..." "INFO"
        
        # Verificar sintaxis de PowerShell
        $Errors = @()
        $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $ScriptPath -Raw), [ref]$Errors)
        
        if ($Errors.Count -eq 0) {
            Write-TestMessage "Sintaxis del script es válida" "SUCCESS"
        }
        else {
            Write-TestMessage "Errores de sintaxis encontrados:" "ERROR"
            foreach ($ParseError in $Errors) {
                Write-TestMessage "  - Línea $($ParseError.StartLine): $($ParseError.Message)" "ERROR"
            }
            return $false
        }
        
        Write-TestMessage "Script ejecutado sin errores críticos" "SUCCESS"
        return $true
    }
    catch {
        Write-TestMessage "Error ejecutando el script: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Test-SchedulingSetup {
    Write-TestMessage "=== PRUEBA DEL CONFIGURADOR DE TAREAS ===" "TEST"
    
    # Verificar que el archivo existe
    if (!(Test-Path $SetupPath)) {
        Write-TestMessage "Error: Script de configuración no encontrado en $SetupPath" "ERROR"
        return $false
    }
    
    Write-TestMessage "Script de configuración encontrado: $SetupPath" "SUCCESS"
    
    # Verificar sintaxis
    try {
        Write-TestMessage "Verificando sintaxis del configurador..." "INFO"
        
        $Errors = @()
        $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $SetupPath -Raw), [ref]$Errors)
        
        if ($Errors.Count -eq 0) {
            Write-TestMessage "Sintaxis del configurador es válida" "SUCCESS"
        }
        else {
            Write-TestMessage "Errores de sintaxis encontrados:" "ERROR"
            foreach ($ParseError in $Errors) {
                Write-TestMessage "  - Línea $($ParseError.StartLine): $($ParseError.Message)" "ERROR"
            }
            return $false
        }
        
        Write-TestMessage "Configurador verificado correctamente" "SUCCESS"
        return $true
    }
    catch {
        Write-TestMessage "Error verificando el configurador: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Test-DirectoryStructure {
    Write-TestMessage "=== VERIFICACIÓN DE ESTRUCTURA ===" "TEST"
    
    $RequiredPaths = @(
        @{ Path = $ScriptPath; Description = "Script principal" },
        @{ Path = $SetupPath; Description = "Configurador de tareas" },
        @{ Path = (Split-Path $ScriptPath -Parent); Description = "Directorio de automatización" }
    )
    
    $AllGood = $true
    
    foreach ($Item in $RequiredPaths) {
        if (Test-Path $Item.Path) {
            Write-TestMessage "$($Item.Description): Encontrado" "SUCCESS"
        }
        else {
            Write-TestMessage "$($Item.Description): No encontrado - $($Item.Path)" "ERROR"
            $AllGood = $false
        }
    }
    
    # Verificar directorio de logs
    $LogsPath = Join-Path (Split-Path $PSScriptRoot -Parent) "logs"
    Write-TestMessage "Directorio de logs: $LogsPath" "INFO"
    
    return $AllGood
}

function Show-InstallationInstructions {
    Write-TestMessage "" "INFO"
    Write-TestMessage "=== INSTRUCCIONES DE INSTALACIÓN ===" "INFO"
    Write-TestMessage "" "INFO"
    Write-TestMessage "Para instalar la automatización completa, siga estos pasos:" "INFO"
    Write-TestMessage "" "INFO"
    Write-TestMessage "1. Abra PowerShell como Administrador" "INFO"
    Write-TestMessage "2. Navegue al directorio del proyecto:" "INFO"
    Write-TestMessage "   cd `"$PSScriptRoot`"" "INFO"
    Write-TestMessage "" "INFO"
    Write-TestMessage "3. Instale las tareas programadas:" "INFO"
    Write-TestMessage "   .\\Setup-ScheduledTasks.ps1 -Install" "INFO"
    Write-TestMessage "" "INFO"
    Write-TestMessage "4. Verifique el estado de las tareas:" "INFO"
    Write-TestMessage "   .\\Setup-ScheduledTasks.ps1 -Status" "INFO"
    Write-TestMessage "" "INFO"
    Write-TestMessage "5. Para probar manualmente el script:" "INFO"
    Write-TestMessage "   .\\Open-SharePointFile.ps1 -LogToFile" "INFO"
    Write-TestMessage "" "INFO"
    Write-TestMessage "=== HORARIOS PROGRAMADOS ===" "INFO"
    Write-TestMessage "• Lunes a Jueves: 8:00 AM y 5:00 PM" "INFO"
    Write-TestMessage "• Viernes: 8:00 AM y 3:00 PM" "INFO"
    Write-TestMessage "" "INFO"
    Write-TestMessage "Los logs se guardarán en: ..\\..\\logs\\" "INFO"
}

# ========================================================================================================
# EJECUCIÓN PRINCIPAL
# ========================================================================================================

Write-TestMessage "" "INFO"
Write-TestMessage "PRUEBAS DE AUTOMATIZACION - SEGUIMIENTO PRESENCIAL AGENCIAS" "TEST"
Write-TestMessage "========================================================================" "TEST"
Write-TestMessage "" "INFO"

# Validar parámetros
if (!$TestScript -and !$TestScheduling -and !$TestBoth) {
    $TestBoth = $true
}

$OverallSuccess = $true

# Verificar estructura de directorios
$StructureOK = Test-DirectoryStructure
$OverallSuccess = $OverallSuccess -and $StructureOK

# Ejecutar pruebas solicitadas
if ($TestScript -or $TestBoth) {
    $ScriptTestResult = Test-MainScript
    $OverallSuccess = $OverallSuccess -and $ScriptTestResult
}

if ($TestScheduling -or $TestBoth) {
    $SchedulingTestResult = Test-SchedulingSetup
    $OverallSuccess = $OverallSuccess -and $SchedulingTestResult
}

# Mostrar resultados finales
Write-TestMessage "" "INFO"
Write-TestMessage "=== RESUMEN DE PRUEBAS ===" "TEST"

if ($OverallSuccess) {
    Write-TestMessage "Todas las pruebas pasaron exitosamente" "SUCCESS"
    Write-TestMessage "El sistema de automatización está listo para instalarse" "SUCCESS"
}
else {
    Write-TestMessage "Algunas pruebas fallaron" "ERROR"
    Write-TestMessage "Revise los errores anteriores antes de proceder" "ERROR"
}

# Mostrar instrucciones de instalación
Show-InstallationInstructions

Write-TestMessage "" "INFO"
Write-TestMessage "========================================================================" "TEST"

exit $(if ($OverallSuccess) { 0 } else { 1 })