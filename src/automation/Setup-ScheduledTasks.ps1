# ========================================================================================================
# Script: Setup-ScheduledTasks.ps1
# Descripción: Configura las tareas programadas para la apertura automática del archivo de SharePoint
# Autor: Sistema de Automatización - Centro de Gestión del Cliente
# Fecha: 30/10/2025
# Versión: 1.0.0
# ========================================================================================================

#Requires -RunAsAdministrator

param(
    [switch]$Install,
    [switch]$Uninstall,
    [switch]$Status,
    [string]$TaskNamePrefix = "SharePoint_SEGUIMIENTO_PRESENCIAL"
)

# Configuración de tareas
$ScriptPath = Join-Path $PSScriptRoot "Open-SharePointFile.ps1"
$TasksConfiguration = @(
    @{
        Name = "$TaskNamePrefix`_Weekdays_Morning"
        Description = "Abre el archivo de SharePoint de seguimiento presencial - Lunes a Jueves 8:00 AM"
        Days = @("Monday", "Tuesday", "Wednesday", "Thursday")
        Time = "08:00"
    },
    @{
        Name = "$TaskNamePrefix`_Weekdays_Evening"
        Description = "Abre el archivo de SharePoint de seguimiento presencial - Lunes a Jueves 5:00 PM"
        Days = @("Monday", "Tuesday", "Wednesday", "Thursday")
        Time = "17:00"
    },
    @{
        Name = "$TaskNamePrefix`_Friday_Morning"
        Description = "Abre el archivo de SharePoint de seguimiento presencial - Viernes 8:00 AM"
        Days = @("Friday")
        Time = "08:00"
    },
    @{
        Name = "$TaskNamePrefix`_Friday_Afternoon"
        Description = "Abre el archivo de SharePoint de seguimiento presencial - Viernes 3:00 PM"
        Days = @("Friday")
        Time = "15:00"
    }
)

function Write-StatusMessage {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    switch ($Type) {
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor Green }
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor Red }
        "WARNING" { Write-Host "⚠️  $Message" -ForegroundColor Yellow }
        "INFO" { Write-Host "ℹ️  $Message" -ForegroundColor Cyan }
        default { Write-Host "$Message" }
    }
}

function Test-Prerequisites {
    Write-StatusMessage "Verificando prerrequisitos..." "INFO"
    
    # Verificar si el script existe
    if (!(Test-Path $ScriptPath)) {
        Write-StatusMessage "Error: No se encontró el script principal en: $ScriptPath" "ERROR"
        return $false
    }
    
    # Verificar permisos de administrador
    $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
    $IsAdmin = $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (!$IsAdmin) {
        Write-StatusMessage "Error: Se requieren permisos de administrador para configurar tareas programadas" "ERROR"
        return $false
    }
    
    Write-StatusMessage "Prerrequisitos verificados correctamente" "SUCCESS"
    return $true
}

function Install-ScheduledTasks {
    Write-StatusMessage "=== INSTALANDO TAREAS PROGRAMADAS ===" "INFO"
    
    if (!(Test-Prerequisites)) {
        return $false
    }
    
    $SuccessCount = 0
    $ErrorCount = 0
    
    foreach ($TaskConfig in $TasksConfiguration) {
        try {
            Write-StatusMessage "Configurando tarea: $($TaskConfig.Name)" "INFO"
            
            # Eliminar tarea existente si existe
            $ExistingTask = Get-ScheduledTask -TaskName $TaskConfig.Name -ErrorAction SilentlyContinue
            if ($ExistingTask) {
                Write-StatusMessage "  Eliminando tarea existente..." "WARNING"
                Unregister-ScheduledTask -TaskName $TaskConfig.Name -Confirm:$false
            }
            
            # Crear acción de la tarea
            $Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`" -LogToFile"
            
            # Crear triggers para cada día especificado
            $Triggers = @()
            foreach ($Day in $TaskConfig.Days) {
                $Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $Day -At $TaskConfig.Time
                $Triggers += $Trigger
            }
            
            # Configurar configuración de la tarea
            $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
            
            # Configurar principal (ejecutar como usuario actual)
            $Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
            
            # Registrar la tarea
            $Task = New-ScheduledTask -Action $Action -Trigger $Triggers -Settings $Settings -Principal $Principal -Description $TaskConfig.Description
            Register-ScheduledTask -TaskName $TaskConfig.Name -InputObject $Task | Out-Null
            
            Write-StatusMessage "  ✅ Tarea '$($TaskConfig.Name)' creada exitosamente" "SUCCESS"
            Write-StatusMessage "     Días: $($TaskConfig.Days -join ', ')" "INFO"
            Write-StatusMessage "     Hora: $($TaskConfig.Time)" "INFO"
            
            $SuccessCount++
        }
        catch {
            Write-StatusMessage "  ❌ Error creando tarea '$($TaskConfig.Name)': $($_.Exception.Message)" "ERROR"
            $ErrorCount++
        }
    }
    
    Write-StatusMessage "" "INFO"
    Write-StatusMessage "=== RESUMEN DE INSTALACIÓN ===" "INFO"
    Write-StatusMessage "Tareas creadas exitosamente: $SuccessCount" "SUCCESS"
    Write-StatusMessage "Errores encontrados: $ErrorCount" $(if ($ErrorCount -gt 0) { "ERROR" } else { "INFO" })
    
    if ($SuccessCount -gt 0) {
        Write-StatusMessage "" "INFO"
        Write-StatusMessage "🎯 HORARIOS CONFIGURADOS:" "INFO"
        Write-StatusMessage "   • Lunes a Jueves: 8:00 AM y 5:00 PM" "INFO"
        Write-StatusMessage "   • Viernes: 8:00 AM y 3:00 PM" "INFO"
        Write-StatusMessage "" "INFO"
        Write-StatusMessage "Para ver el estado de las tareas, ejecute:" "INFO"
        Write-StatusMessage "   .\Setup-ScheduledTasks.ps1 -Status" "INFO"
    }
    
    return ($ErrorCount -eq 0)
}

function Uninstall-ScheduledTasks {
    Write-StatusMessage "=== DESINSTALANDO TAREAS PROGRAMADAS ===" "WARNING"
    
    $RemovedCount = 0
    $ErrorCount = 0
    
    foreach ($TaskConfig in $TasksConfiguration) {
        try {
            $ExistingTask = Get-ScheduledTask -TaskName $TaskConfig.Name -ErrorAction SilentlyContinue
            if ($ExistingTask) {
                Unregister-ScheduledTask -TaskName $TaskConfig.Name -Confirm:$false
                Write-StatusMessage "Tarea '$($TaskConfig.Name)' eliminada" "SUCCESS"
                $RemovedCount++
            }
            else {
                Write-StatusMessage "Tarea '$($TaskConfig.Name)' no encontrada" "WARNING"
            }
        }
        catch {
            Write-StatusMessage "Error eliminando tarea '$($TaskConfig.Name)': $($_.Exception.Message)" "ERROR"
            $ErrorCount++
        }
    }
    
    Write-StatusMessage "" "INFO"
    Write-StatusMessage "=== RESUMEN DE DESINSTALACIÓN ===" "INFO"
    Write-StatusMessage "Tareas eliminadas: $RemovedCount" "SUCCESS"
    Write-StatusMessage "Errores: $ErrorCount" $(if ($ErrorCount -gt 0) { "ERROR" } else { "INFO" })
}

function Show-TasksStatus {
    Write-StatusMessage "=== ESTADO DE TAREAS PROGRAMADAS ===" "INFO"
    Write-StatusMessage "" "INFO"
    
    $AllTasksExist = $true
    
    foreach ($TaskConfig in $TasksConfiguration) {
        $Task = Get-ScheduledTask -TaskName $TaskConfig.Name -ErrorAction SilentlyContinue
        
        if ($Task) {
            $State = $Task.State
            $LastRunTime = (Get-ScheduledTaskInfo -TaskName $TaskConfig.Name).LastRunTime
            $NextRunTime = (Get-ScheduledTaskInfo -TaskName $TaskConfig.Name).NextRunTime
            
            Write-StatusMessage "📋 $($TaskConfig.Name)" "INFO"
            Write-StatusMessage "   Estado: $State" $(if ($State -eq "Ready") { "SUCCESS" } else { "WARNING" })
            Write-StatusMessage "   Días: $($TaskConfig.Days -join ', ')" "INFO"
            Write-StatusMessage "   Hora: $($TaskConfig.Time)" "INFO"
            
            if ($LastRunTime) {
                Write-StatusMessage "   Última ejecución: $($LastRunTime.ToString('dd/MM/yyyy HH:mm:ss'))" "INFO"
            }
            else {
                Write-StatusMessage "   Última ejecución: Nunca" "WARNING"
            }
            
            if ($NextRunTime) {
                Write-StatusMessage "   Próxima ejecución: $($NextRunTime.ToString('dd/MM/yyyy HH:mm:ss'))" "INFO"
            }
            
            Write-StatusMessage "" "INFO"
        }
        else {
            Write-StatusMessage "❌ $($TaskConfig.Name): NO ENCONTRADA" "ERROR"
            $AllTasksExist = $false
        }
    }
    
    if ($AllTasksExist) {
        Write-StatusMessage "✅ Todas las tareas están configuradas correctamente" "SUCCESS"
    }
    else {
        Write-StatusMessage "⚠️  Algunas tareas no están configuradas. Ejecute con -Install para crearlas." "WARNING"
    }
    
    # Mostrar información del script principal
    Write-StatusMessage "" "INFO"
    Write-StatusMessage "📄 Información del script principal:" "INFO"
    Write-StatusMessage "   Ruta: $ScriptPath" "INFO"
    Write-StatusMessage "   Existe: $(if (Test-Path $ScriptPath) { 'Sí' } else { 'No' })" $(if (Test-Path $ScriptPath) { "SUCCESS" } else { "ERROR" })
}

# ========================================================================================================
# EJECUCIÓN PRINCIPAL
# ========================================================================================================

Write-StatusMessage "" "INFO"
Write-StatusMessage "========================================================================================================" "INFO"
Write-StatusMessage "CONFIGURADOR DE TAREAS PROGRAMADAS - SEGUIMIENTO PRESENCIAL AGENCIAS" "INFO"
Write-StatusMessage "========================================================================================================" "INFO"
Write-StatusMessage "" "INFO"

# Validar parámetros
$ParametersProvided = @($Install, $Uninstall, $Status) | Where-Object { $_ -eq $true }

if ($ParametersProvided.Count -eq 0) {
    Write-StatusMessage "❓ Debe especificar una acción:" "WARNING"
    Write-StatusMessage "" "INFO"
    Write-StatusMessage "   -Install    : Instalar/crear las tareas programadas" "INFO"
    Write-StatusMessage "   -Uninstall  : Desinstalar/eliminar las tareas programadas" "INFO"
    Write-StatusMessage "   -Status     : Mostrar el estado actual de las tareas" "INFO"
    Write-StatusMessage "" "INFO"
    Write-StatusMessage "Ejemplos:" "INFO"
    Write-StatusMessage "   .\Setup-ScheduledTasks.ps1 -Install" "INFO"
    Write-StatusMessage "   .\Setup-ScheduledTasks.ps1 -Status" "INFO"
    Write-StatusMessage "   .\Setup-ScheduledTasks.ps1 -Uninstall" "INFO"
    exit 1
}

if ($ParametersProvided.Count -gt 1) {
    Write-StatusMessage "❌ Error: Solo puede especificar una acción a la vez" "ERROR"
    exit 1
}

# Ejecutar la acción solicitada
try {
    if ($Install) {
        $Result = Install-ScheduledTasks
        exit $(if ($Result) { 0 } else { 1 })
    }
    elseif ($Uninstall) {
        Uninstall-ScheduledTasks
        exit 0
    }
    elseif ($Status) {
        Show-TasksStatus
        exit 0
    }
}
catch {
    Write-StatusMessage "Error inesperado: $($_.Exception.Message)" "ERROR"
    exit 1
}

Write-StatusMessage "" "INFO"
Write-StatusMessage "========================================================================================================" "INFO"