# 🤖 Automatización de Apertura de SharePoint

## 📖 Descripción

Este módulo automatiza la apertura del archivo de seguimiento presencial de agencias en SharePoint según horarios programados específicos. El sistema utiliza el Programador de Tareas de Windows para ejecutar scripts de PowerShell que abren automáticamente el documento en los horarios establecidos.

## 🎯 Objetivo

Automatizar la apertura del archivo de SharePoint del seguimiento presencial según el siguiente calendario:

- **Lunes a Jueves**: 8:00 AM y 5:00 PM
- **Viernes**: 8:00 AM y 3:00 PM

## 📁 Estructura de Archivos

```
src/automation/
├── Open-SharePointFile.ps1      # Script principal para abrir SharePoint
├── Setup-ScheduledTasks.ps1     # Configurador de tareas programadas
├── Test-Automation.ps1          # Script de pruebas y validación
└── README.md                    # Este documento
```

## 🚀 Instalación y Configuración

### Requisitos Previos

- Windows 10/11 o Windows Server
- PowerShell 5.1 o superior
- Permisos de administrador (solo para instalación)
- Acceso a internet para SharePoint

### Pasos de Instalación

1. **Abrir PowerShell como Administrador**
   ```powershell
   # Buscar "PowerShell" en el menú inicio
   # Clic derecho > "Ejecutar como administrador"
   ```

2. **Navegar al directorio del proyecto**
   ```powershell
   cd "c:\Users\eclavijo\OneDrive - La Ascensión S.A\BI - BI\08.  CENTRO DE GESTIÓN DEL CLIENTE\DESARROLLO\PBI_000_SEGUIMIENTO_PRESENCIAL_AGENCIAS\src\automation"
   ```

3. **Ejecutar pruebas (opcional pero recomendado)**
   ```powershell
   .\Test-Automation.ps1
   ```

4. **Instalar las tareas programadas**
   ```powershell
   .\Setup-ScheduledTasks.ps1 -Install
   ```

5. **Verificar la instalación**
   ```powershell
   .\Setup-ScheduledTasks.ps1 -Status
   ```

## 🔧 Uso y Comandos

### Comandos Principales

#### Configuración de Tareas Programadas

```powershell
# Instalar todas las tareas programadas
.\Setup-ScheduledTasks.ps1 -Install

# Ver el estado de las tareas
.\Setup-ScheduledTasks.ps1 -Status

# Desinstalar todas las tareas
.\Setup-ScheduledTasks.ps1 -Uninstall
```

#### Ejecución Manual

```powershell
# Ejecutar manualmente con logging
.\Open-SharePointFile.ps1 -LogToFile

# Ejecutar con URL personalizada
.\Open-SharePointFile.ps1 -SharePointUrl "https://..." -LogToFile
```

#### Pruebas y Validación

```powershell
# Ejecutar todas las pruebas
.\Test-Automation.ps1

# Probar solo el script principal
.\Test-Automation.ps1 -TestScript

# Probar solo la configuración de tareas
.\Test-Automation.ps1 -TestScheduling
```

### Tareas Programadas Creadas

El sistema crea las siguientes tareas en el Programador de Tareas de Windows:

1. **SharePoint_SEGUIMIENTO_PRESENCIAL_Weekdays_Morning**
   - Días: Lunes, Martes, Miércoles, Jueves
   - Hora: 8:00 AM

2. **SharePoint_SEGUIMIENTO_PRESENCIAL_Weekdays_Evening**
   - Días: Lunes, Martes, Miércoles, Jueves
   - Hora: 5:00 PM

3. **SharePoint_SEGUIMIENTO_PRESENCIAL_Friday_Morning**
   - Días: Viernes
   - Hora: 8:00 AM

4. **SharePoint_SEGUIMIENTO_PRESENCIAL_Friday_Afternoon**
   - Días: Viernes
   - Hora: 3:00 PM

## 📊 Logging y Monitoreo

### Ubicación de Logs

Los logs se almacenan en:
```
../../logs/sharepoint-automation-YYYY-MM.log
```

### Información Registrada

- Fecha y hora de ejecución
- Contexto del horario (día de la semana, hora)
- Verificación de conexión a internet
- Resultado de la apertura del documento
- Errores y advertencias

### Ejemplo de Log

```
[2025-10-30 08:00:02] [INFO] ========================================================================================================
[2025-10-30 08:00:02] [INFO] INICIANDO AUTOMATIZACIÓN DE APERTURA DE SHAREPOINT
[2025-10-30 08:00:02] [INFO] ========================================================================================================
[2025-10-30 08:00:02] [INFO] Contexto de ejecución:
[2025-10-30 08:00:02] [INFO]   - Fecha y hora: miércoles, 30/10/2025 08:00:02
[2025-10-30 08:00:02] [INFO]   - Día de la semana: Wednesday
[2025-10-30 08:00:02] [INFO]   - Es día laborable (L-J): True
[2025-10-30 08:00:02] [INFO]   - Es viernes: False
[2025-10-30 08:00:02] [INFO]   - Es fin de semana: False
[2025-10-30 08:00:02] [SUCCESS] Evaluación de ejecución: Horario programado para días laborables (L-J): 8:00 AM o 5:00 PM
[2025-10-30 08:00:02] [SUCCESS] EJECUTANDO: Abriendo documento de SharePoint...
[2025-10-30 08:00:02] [INFO] Iniciando apertura de documento de SharePoint...
[2025-10-30 08:00:02] [SUCCESS] Conexión a internet verificada correctamente
[2025-10-30 08:00:03] [SUCCESS] Documento de SharePoint abierto exitosamente
[2025-10-30 08:00:03] [SUCCESS] OPERACIÓN COMPLETADA EXITOSAMENTE
```

## 🔍 Solución de Problemas

### Problemas Comunes

#### 1. Error de Permisos
**Síntoma**: "Se requieren permisos de administrador"
**Solución**: Ejecutar PowerShell como administrador

#### 2. Script no Ejecuta
**Síntoma**: "No se puede ejecutar el script"
**Solución**: 
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 3. No Abre el Navegador
**Síntoma**: El script se ejecuta pero no abre SharePoint
**Solución**: 
- Verificar conexión a internet
- Verificar que la URL sea accesible
- Comprobar el navegador predeterminado

#### 4. Tareas no se Ejecutan
**Síntoma**: Las tareas están instaladas pero no se ejecutan
**Solución**:
- Verificar que las tareas estén habilitadas en el Programador de Tareas
- Comprobar que el usuario tenga permisos de ejecución
- Verificar los triggers de tiempo

### Comandos de Diagnóstico

```powershell
# Verificar estado completo
.\Setup-ScheduledTasks.ps1 -Status

# Probar conexión y funcionamiento
.\Test-Automation.ps1

# Ejecutar manualmente para depurar
.\Open-SharePointFile.ps1 -LogToFile

# Ver logs recientes
Get-Content "..\..\logs\sharepoint-automation-$(Get-Date -Format 'yyyy-MM').log" | Select-Object -Last 20
```

## 🔧 Personalización

### Modificar Horarios

Para cambiar los horarios, edite el archivo `Setup-ScheduledTasks.ps1` en la sección `$TasksConfiguration`:

```powershell
$TasksConfiguration = @(
    @{
        Name = "$TaskNamePrefix`_Weekdays_Morning"
        Description = "Descripción personalizada"
        Days = @("Monday", "Tuesday", "Wednesday", "Thursday")
        Time = "08:00"  # Cambiar hora aquí
    },
    # ... más configuraciones
)
```

### Cambiar URL de SharePoint

Modifique el parámetro por defecto en `Open-SharePointFile.ps1`:

```powershell
param(
    [string]$SharePointUrl = "https://nueva-url-sharepoint.com",
    # ...
)
```

### Personalizar Logging

Modifique las rutas de log en `Open-SharePointFile.ps1`:

```powershell
$LogPath = Join-Path $PSScriptRoot "ruta\personalizada\logs"
```

## 📋 Mantenimiento

### Tareas de Mantenimiento Recomendadas

1. **Revisión Semanal de Logs**
   - Verificar que las ejecuciones sean exitosas
   - Identificar patrones de errores

2. **Actualización Mensual**
   - Verificar que las tareas sigan programadas
   - Probar ejecución manual

3. **Limpieza de Logs**
   - Los logs se crean mensualmente
   - Eliminar logs antiguos según política de retención

### Actualizaciones del Sistema

Cuando actualice el sistema:

1. Hacer backup de la configuración actual
2. Desinstalar tareas existentes
3. Actualizar scripts
4. Reinstalar tareas
5. Verificar funcionamiento

```powershell
# Proceso de actualización
.\Setup-ScheduledTasks.ps1 -Uninstall
# ... actualizar archivos ...
.\Setup-ScheduledTasks.ps1 -Install
.\Test-Automation.ps1
```

## 📞 Soporte

Para soporte técnico:

1. **Revisar logs**: Verificar los archivos de log para identificar errores
2. **Ejecutar pruebas**: Usar `Test-Automation.ps1` para diagnóstico
3. **Documentar el problema**: Incluir logs y pasos para reproducir
4. **Contactar al administrador del sistema**: Con la información recopilada

---

**Nota**: Este sistema está diseñado específicamente para el proyecto de Seguimiento Presencial de Agencias de La Ascensión S.A. y forma parte del Centro de Gestión del Cliente.