# ========================================================================================================
# Script: Open-SharePointFile.ps1
# Descripción: Abre automáticamente el archivo de SharePoint del seguimiento presencial de agencias
# Autor: Sistema de Automatización - Centro de Gestión del Cliente
# Fecha: 30/10/2025
# Versión: 1.0.0
# ========================================================================================================

param(
    [string]$SharePointUrl = "https://laascension-my.sharepoint.com/:x:/p/servicioalcliente/EQcuhISlUMZMi_AtJQ4kxxAB_TigXeQzjlgmV81Hm1fLCw?e=XEnUod",
    [switch]$LogToFile
)

# Configuración de logging
$LogPath = Join-Path $PSScriptRoot "..\..\logs"
$LogFile = Join-Path $LogPath "sharepoint-automation-$(Get-Date -Format 'yyyy-MM').log"

# Crear directorio de logs si no existe
if (!(Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
}

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"
    
    # Escribir a consola
    switch ($Level) {
        "ERROR" { Write-Host $LogEntry -ForegroundColor Red }
        "WARNING" { Write-Host $LogEntry -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $LogEntry -ForegroundColor Green }
        default { Write-Host $LogEntry }
    }
    
    # Escribir a archivo si está habilitado
    if ($LogToFile -or $true) {
        try {
            Add-Content -Path $LogFile -Value $LogEntry -Encoding UTF8
        }
        catch {
            Write-Host "Error escribiendo al log: $_" -ForegroundColor Red
        }
    }
}

function Test-InternetConnection {
    try {
        $ping = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
        return $ping
    }
    catch {
        return $false
    }
}

function Open-SharePointDocument {
    param([string]$Url)
    
    try {
        Write-Log "Iniciando apertura de documento de SharePoint..."
        Write-Log "URL: $Url"
        
        # Verificar conexión a internet
        if (-not (Test-InternetConnection)) {
            Write-Log "Error: No hay conexión a internet disponible" "ERROR"
            return $false
        }
        
        Write-Log "Conexión a internet verificada correctamente" "SUCCESS"
        
        # Intentar abrir con el navegador predeterminado
        Start-Process $Url
        
        Write-Log "Documento de SharePoint abierto exitosamente" "SUCCESS"
        Write-Log "Horario de apertura: $(Get-Date -Format 'dddd, dd/MM/yyyy HH:mm:ss')"
        
        return $true
    }
    catch {
        Write-Log "Error abriendo el documento: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Get-CurrentScheduleContext {
    $Now = Get-Date
    $DayOfWeek = $Now.DayOfWeek
    $Hour = $Now.Hour
    $Minute = $Now.Minute
    
    $Context = @{
        DateTime = $Now
        DayOfWeek = $DayOfWeek
        Hour = $Hour
        Minute = $Minute
        IsWeekday = $DayOfWeek -in @('Monday', 'Tuesday', 'Wednesday', 'Thursday')
        IsFriday = $DayOfWeek -eq 'Friday'
        IsWeekend = $DayOfWeek -in @('Saturday', 'Sunday')
    }
    
    return $Context
}

# ========================================================================================================
# EJECUCIÓN PRINCIPAL
# ========================================================================================================

Write-Log "========================================================================================================"
Write-Log "INICIANDO AUTOMATIZACIÓN DE APERTURA DE SHAREPOINT"
Write-Log "========================================================================================================"

# Obtener contexto del horario actual
$ScheduleContext = Get-CurrentScheduleContext

Write-Log "Contexto de ejecución:"
Write-Log "  - Fecha y hora: $($ScheduleContext.DateTime.ToString('dddd, dd/MM/yyyy HH:mm:ss'))"
Write-Log "  - Día de la semana: $($ScheduleContext.DayOfWeek)"
Write-Log "  - Es día laborable (L-J): $($ScheduleContext.IsWeekday)"
Write-Log "  - Es viernes: $($ScheduleContext.IsFriday)"
Write-Log "  - Es fin de semana: $($ScheduleContext.IsWeekend)"

# Validar si debe ejecutarse según el horario programado
$ShouldExecute = $false
$ExecutionReason = ""

if ($ScheduleContext.IsWeekend) {
    $ExecutionReason = "No se ejecuta en fines de semana"
}
elseif ($ScheduleContext.IsWeekday) {
    # Lunes a Jueves: 8:00 AM y 5:00 PM
    if (($ScheduleContext.Hour -eq 8 -and $ScheduleContext.Minute -ge 0 -and $ScheduleContext.Minute -le 5) -or
        ($ScheduleContext.Hour -eq 17 -and $ScheduleContext.Minute -ge 0 -and $ScheduleContext.Minute -le 5)) {
        $ShouldExecute = $true
        $ExecutionReason = "Horario programado para días laborables (L-J): 8:00 AM o 5:00 PM"
    }
    else {
        $ExecutionReason = "Fuera del horario programado para días laborables (8:00 AM o 5:00 PM)"
    }
}
elseif ($ScheduleContext.IsFriday) {
    # Viernes: 8:00 AM y 3:00 PM
    if (($ScheduleContext.Hour -eq 8 -and $ScheduleContext.Minute -ge 0 -and $ScheduleContext.Minute -le 5) -or
        ($ScheduleContext.Hour -eq 15 -and $ScheduleContext.Minute -ge 0 -and $ScheduleContext.Minute -le 5)) {
        $ShouldExecute = $true
        $ExecutionReason = "Horario programado para viernes: 8:00 AM o 3:00 PM"
    }
    else {
        $ExecutionReason = "Fuera del horario programado para viernes (8:00 AM o 3:00 PM)"
    }
}

Write-Log "Evaluación de ejecución: $ExecutionReason"

if ($ShouldExecute) {
    Write-Log "EJECUTANDO: Abriendo documento de SharePoint..." "SUCCESS"
    $Result = Open-SharePointDocument -Url $SharePointUrl
    
    if ($Result) {
        Write-Log "OPERACIÓN COMPLETADA EXITOSAMENTE" "SUCCESS"
        exit 0
    }
    else {
        Write-Log "OPERACIÓN FALLÓ" "ERROR"
        exit 1
    }
}
else {
    Write-Log "OMITIENDO EJECUCIÓN: $ExecutionReason" "WARNING"
    exit 0
}

Write-Log "========================================================================================================"
Write-Log "FIN DE LA AUTOMATIZACIÓN"
Write-Log "========================================================================================================"