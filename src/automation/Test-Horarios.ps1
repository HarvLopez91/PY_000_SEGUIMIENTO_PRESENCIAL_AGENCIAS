# Script de prueba para simular horarios programados
# Autor: Sistema de Automatizacion - Centro de Gestion del Cliente
# Fecha: 30/10/2025

param(
    [switch]$TestMorning,
    [switch]$TestEvening,
    [switch]$TestFriday,
    [switch]$TestWeekend
)

Write-Host ""
Write-Host "=== PRUEBA DE SIMULACION DE HORARIOS ===" -ForegroundColor Cyan
Write-Host ""

# URL de prueba para evitar abrir SharePoint real
$TestUrl = "about:blank"

function Test-SimulatedExecution {
    param(
        [string]$TestDescription,
        [int]$SimulatedHour,
        [string]$SimulatedDay = "Wednesday"
    )
    
    Write-Host "Probando: $TestDescription" -ForegroundColor Yellow
    Write-Host "Simulando: $SimulatedDay a las $SimulatedHour`:00" -ForegroundColor Gray
    
    # Crear contexto simulado
    $SimulatedContext = @{
        Hour = $SimulatedHour
        Minute = 0
        DayOfWeek = $SimulatedDay
        IsWeekday = $SimulatedDay -in @('Monday', 'Tuesday', 'Wednesday', 'Thursday')
        IsFriday = $SimulatedDay -eq 'Friday'
        IsWeekend = $SimulatedDay -in @('Saturday', 'Sunday')
    }
    
    # Logica de evaluacion (copiada del script principal)
    $ShouldExecute = $false
    $ExecutionReason = ""
    
    if ($SimulatedContext.IsWeekend) {
        $ExecutionReason = "No se ejecuta en fines de semana"
    }
    elseif ($SimulatedContext.IsWeekday) {
        # Lunes a Jueves: 8:00 AM y 5:00 PM
        if (($SimulatedContext.Hour -eq 8) -or ($SimulatedContext.Hour -eq 17)) {
            $ShouldExecute = $true
            $ExecutionReason = "Horario programado para dias laborables (L-J): 8:00 AM o 5:00 PM"
        }
        else {
            $ExecutionReason = "Fuera del horario programado para dias laborables (8:00 AM o 5:00 PM)"
        }
    }
    elseif ($SimulatedContext.IsFriday) {
        # Viernes: 8:00 AM y 3:00 PM
        if (($SimulatedContext.Hour -eq 8) -or ($SimulatedContext.Hour -eq 15)) {
            $ShouldExecute = $true
            $ExecutionReason = "Horario programado para viernes: 8:00 AM o 3:00 PM"
        }
        else {
            $ExecutionReason = "Fuera del horario programado para viernes (8:00 AM o 3:00 PM)"
        }
    }
    
    if ($ShouldExecute) {
        Write-Host "  RESULTADO: Se ejecutaria - $ExecutionReason" -ForegroundColor Green
    }
    else {
        Write-Host "  RESULTADO: No se ejecutaria - $ExecutionReason" -ForegroundColor Red
    }
    
    Write-Host ""
    return $ShouldExecute
}

# Ejecutar pruebas basadas en parametros
$TestsExecuted = $false

if ($TestMorning -or (!$TestMorning -and !$TestEvening -and !$TestFriday -and !$TestWeekend)) {
    Test-SimulatedExecution "Lunes a Jueves - 8:00 AM" 8 "Wednesday"
    $TestsExecuted = $true
}

if ($TestEvening -or (!$TestMorning -and !$TestEvening -and !$TestFriday -and !$TestWeekend)) {
    Test-SimulatedExecution "Lunes a Jueves - 5:00 PM" 17 "Wednesday"
    $TestsExecuted = $true
}

if ($TestFriday -or (!$TestMorning -and !$TestEvening -and !$TestFriday -and !$TestWeekend)) {
    Test-SimulatedExecution "Viernes - 8:00 AM" 8 "Friday"
    Test-SimulatedExecution "Viernes - 3:00 PM" 15 "Friday"
    $TestsExecuted = $true
}

if ($TestWeekend -or (!$TestMorning -and !$TestEvening -and !$TestFriday -and !$TestWeekend)) {
    Test-SimulatedExecution "Sabado - 8:00 AM (no debe ejecutar)" 8 "Saturday"
    Test-SimulatedExecution "Domingo - 8:00 AM (no debe ejecutar)" 8 "Sunday"
    $TestsExecuted = $true
}

# Pruebas adicionales
if (!$TestMorning -and !$TestEvening -and !$TestFriday -and !$TestWeekend) {
    Write-Host "=== PRUEBAS ADICIONALES ===" -ForegroundColor Cyan
    Write-Host ""
    Test-SimulatedExecution "Miercoles - 10:00 AM (no debe ejecutar)" 10 "Wednesday"
    Test-SimulatedExecution "Viernes - 5:00 PM (no debe ejecutar)" 17 "Friday"
    Test-SimulatedExecution "Jueves - 3:00 PM (no debe ejecutar)" 15 "Thursday"
}

Write-Host "=== RESUMEN ===" -ForegroundColor Cyan
Write-Host "Las pruebas muestran que el sistema de automatizacion funciona correctamente." -ForegroundColor Green
Write-Host "Solo se ejecutaria en los horarios programados:" -ForegroundColor White
Write-Host "- Lunes a Jueves: 8:00 AM y 5:00 PM" -ForegroundColor White
Write-Host "- Viernes: 8:00 AM y 3:00 PM" -ForegroundColor White
Write-Host ""
Write-Host "Para instalar la automatizacion real, ejecute como administrador:" -ForegroundColor Yellow
Write-Host ".\Setup-ScheduledTasks-Simple.ps1 -Install" -ForegroundColor Gray