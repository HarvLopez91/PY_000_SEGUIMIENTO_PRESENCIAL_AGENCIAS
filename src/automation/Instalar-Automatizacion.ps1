# Script de instalacion automatica - SharePoint Automation
# Autor: Sistema de Automatizacion - Centro de Gestion del Cliente
# Fecha: 30/10/2025

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "INSTALADOR DE AUTOMATIZACION - SEGUIMIENTO PRESENCIAL AGENCIAS" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Este script instalara la automatizacion para abrir el archivo de SharePoint automaticamente." -ForegroundColor White
Write-Host ""
Write-Host "HORARIOS PROGRAMADOS:" -ForegroundColor Yellow
Write-Host "- Lunes a Jueves: 8:00 AM y 5:00 PM" -ForegroundColor White
Write-Host "- Viernes: 8:00 AM y 3:00 PM" -ForegroundColor White
Write-Host ""

# Verificar si se esta ejecutando como administrador
$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
$IsAdmin = $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "ATENCION: Este script requiere permisos de administrador." -ForegroundColor Red
    Write-Host ""
    Write-Host "Para instalar la automatizacion, siga estos pasos:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Cierre esta ventana de PowerShell" -ForegroundColor White
    Write-Host "2. Haga clic derecho en 'PowerShell' en el menu inicio" -ForegroundColor White
    Write-Host "3. Seleccione 'Ejecutar como administrador'" -ForegroundColor White
    Write-Host "4. Navegue a esta carpeta:" -ForegroundColor White
    Write-Host "   cd `"$PSScriptRoot`"" -ForegroundColor Gray
    Write-Host "5. Ejecute el comando de instalacion:" -ForegroundColor White
    Write-Host "   .\Setup-ScheduledTasks-Simple.ps1 -Install" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Presione cualquier tecla para continuar..." -ForegroundColor White
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    # Intentar abrir PowerShell como administrador automaticamente
    try {
        Write-Host "Intentando abrir PowerShell como administrador automaticamente..." -ForegroundColor Yellow
        $InstallCommand = "cd `"$PSScriptRoot`"; .\Setup-ScheduledTasks-Simple.ps1 -Install; pause"
        Start-Process PowerShell -ArgumentList "-NoExit", "-Command", $InstallCommand -Verb RunAs
        Write-Host "Se abrio una nueva ventana de PowerShell como administrador." -ForegroundColor Green
        Write-Host "Complete la instalacion en esa ventana." -ForegroundColor Green
    }
    catch {
        Write-Host "No se pudo abrir PowerShell automaticamente. Siga los pasos manuales arriba." -ForegroundColor Yellow
    }
    
    exit 1
}

# Si ya se esta ejecutando como administrador, proceder con la instalacion
Write-Host "Ejecutandose como administrador. Procediendo con la instalacion..." -ForegroundColor Green
Write-Host ""

try {
    # Verificar que los scripts necesarios existen
    $ScriptPath = Join-Path $PSScriptRoot "Open-SharePoint-Simple.ps1"
    $SetupPath = Join-Path $PSScriptRoot "Setup-ScheduledTasks-Simple.ps1"
    
    if (!(Test-Path $ScriptPath)) {
        Write-Host "Error: No se encontro Open-SharePoint-Simple.ps1" -ForegroundColor Red
        exit 1
    }
    
    if (!(Test-Path $SetupPath)) {
        Write-Host "Error: No se encontro Setup-ScheduledTasks-Simple.ps1" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Archivos verificados correctamente." -ForegroundColor Green
    Write-Host ""
    
    # Ejecutar la instalacion
    Write-Host "Iniciando instalacion de tareas programadas..." -ForegroundColor Yellow
    & $SetupPath -Install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "INSTALACION COMPLETADA EXITOSAMENTE" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "La automatizacion ha sido instalada y configurada." -ForegroundColor White
        Write-Host ""
        Write-Host "El archivo de SharePoint se abrira automaticamente en los siguientes horarios:" -ForegroundColor White
        Write-Host "- Lunes a Jueves: 8:00 AM y 5:00 PM" -ForegroundColor White
        Write-Host "- Viernes: 8:00 AM y 3:00 PM" -ForegroundColor White
        Write-Host ""
        Write-Host "Para verificar el estado de las tareas:" -ForegroundColor Yellow
        Write-Host ".\Setup-ScheduledTasks-Simple.ps1 -Status" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Para probar manualmente:" -ForegroundColor Yellow
        Write-Host ".\Open-SharePoint-Simple.ps1" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Los logs se guardaran en: ..\\..\\logs\\" -ForegroundColor Yellow
    }
    else {
        Write-Host ""
        Write-Host "Error durante la instalacion. Revise los mensajes anteriores." -ForegroundColor Red
    }
}
catch {
    Write-Host "Error inesperado durante la instalacion: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Presione cualquier tecla para salir..." -ForegroundColor White
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")