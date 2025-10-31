# Script para abrir SharePoint automaticamente
# Autor: Sistema de Automatizacion - Centro de Gestion del Cliente
# Fecha: 30/10/2025

param(
    [string]$SharePointUrl = "https://laascension-my.sharepoint.com/:x:/p/servicioalcliente/EQcuhISlUMZMi_AtJQ4kxxAB_TigXeQzjlgmV81Hm1fLCw?e=XEnUod"
)

# Configuracion de logging
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
    Write-Host $LogEntry
    
    # Escribir a archivo
    try {
        Add-Content -Path $LogFile -Value $LogEntry -Encoding UTF8
    }
    catch {
        Write-Host "Error escribiendo al log: $_"
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
        
        # Verificar conexion a internet
        if (-not (Test-InternetConnection)) {
            Write-Log "Error: No hay conexion a internet disponible" "ERROR"
            return $false
        }
        
        Write-Log "Conexion a internet verificada correctamente" "SUCCESS"
        
        # Abrir con el navegador predeterminado
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

# EJECUCION PRINCIPAL
Write-Log "========================================================================"
Write-Log "INICIANDO AUTOMATIZACION DE APERTURA DE SHAREPOINT"
Write-Log "========================================================================"

# Obtener contexto del horario actual
$ScheduleContext = Get-CurrentScheduleContext

Write-Log "Contexto de ejecucion:"
Write-Log "  - Fecha y hora: $($ScheduleContext.DateTime.ToString('dddd, dd/MM/yyyy HH:mm:ss'))"
Write-Log "  - Dia de la semana: $($ScheduleContext.DayOfWeek)"
Write-Log "  - Es dia laborable (L-J): $($ScheduleContext.IsWeekday)"
Write-Log "  - Es viernes: $($ScheduleContext.IsFriday)"
Write-Log "  - Es fin de semana: $($ScheduleContext.IsWeekend)"

# Validar si debe ejecutarse segun el horario programado
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
        $ExecutionReason = "Horario programado para dias laborables (L-J): 8:00 AM o 5:00 PM"
    }
    else {
        $ExecutionReason = "Fuera del horario programado para dias laborables (8:00 AM o 5:00 PM)"
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

Write-Log "Evaluacion de ejecucion: $ExecutionReason"

if ($ShouldExecute) {
    Write-Log "EJECUTANDO: Abriendo documento de SharePoint..." "SUCCESS"
    $Result = Open-SharePointDocument -Url $SharePointUrl
    
    if ($Result) {
        Write-Log "OPERACION COMPLETADA EXITOSAMENTE" "SUCCESS"
        exit 0
    }
    else {
        Write-Log "OPERACION FALLO" "ERROR"
        exit 1
    }
}
else {
    Write-Log "OMITIENDO EJECUCION: $ExecutionReason" "WARNING"
    exit 0
}

Write-Log "========================================================================"
Write-Log "FIN DE LA AUTOMATIZACION"
Write-Log "========================================================================"