# 🤖 Sistema de Automatización de SharePoint

## 📋 Descripción

Sistema completo para automatizar la apertura del archivo de seguimiento presencial de agencias en SharePoint según horarios programados específicos.

## 🎯 Horarios Programados

- **Lunes a Jueves**: 8:00 AM y 5:00 PM
- **Viernes**: 8:00 AM y 3:00 PM

## 📁 Archivos del Sistema

```
src/automation/
├── Open-SharePoint-Simple.ps1          # Script principal (versión simple)
├── Setup-ScheduledTasks-Simple.ps1     # Configurador de tareas (versión simple)
├── Instalar-Automatizacion.ps1         # Instalador automático
├── Test-Automation.ps1                 # Script de pruebas
├── Open-SharePointFile.ps1             # Script principal (versión completa)
├── Setup-ScheduledTasks.ps1            # Configurador de tareas (versión completa)
└── README-FINAL.md                     # Este documento
```

## 🚀 Instalación Rápida

### Opción 1: Instalador Automático (Recomendado)

1. **Ejecutar el instalador**
   ```powershell
   .\Instalar-Automatizacion.ps1
   ```

2. **Seguir las instrucciones en pantalla**
   - El script detectará si necesita permisos de administrador
   - Intentará abrir PowerShell como administrador automáticamente
   - Complete la instalación en la ventana de administrador

### Opción 2: Instalación Manual

1. **Abrir PowerShell como Administrador**
   - Buscar "PowerShell" en el menú inicio
   - Clic derecho > "Ejecutar como administrador"

2. **Navegar al directorio**
   ```powershell
   cd "c:\Users\eclavijo\OneDrive - La Ascensión S.A\BI - BI\08.  CENTRO DE GESTIÓN DEL CLIENTE\DESARROLLO\PBI_000_SEGUIMIENTO_PRESENCIAL_AGENCIAS\src\automation"
   ```

3. **Instalar las tareas programadas**
   ```powershell
   .\Setup-ScheduledTasks-Simple.ps1 -Install
   ```

## 📊 Verificación y Monitoreo

### Verificar Estado de las Tareas

```powershell
# Ejecutar como administrador
.\Setup-ScheduledTasks-Simple.ps1 -Status
```

### Prueba Manual

```powershell
# Probar la apertura manual (no requiere admin)
.\Open-SharePoint-Simple.ps1
```

### Ver Logs

Los logs se guardan automáticamente en:
```
../../logs/sharepoint-automation-YYYY-MM.log
```

Para ver los logs más recientes:
```powershell
Get-Content "..\..\logs\sharepoint-automation-$(Get-Date -Format 'yyyy-MM').log" | Select-Object -Last 20
```

## 🔧 Comandos Útiles

### Gestión de Tareas Programadas

```powershell
# Instalar todas las tareas
.\Setup-ScheduledTasks-Simple.ps1 -Install

# Ver estado de las tareas
.\Setup-ScheduledTasks-Simple.ps1 -Status

# Desinstalar todas las tareas
.\Setup-ScheduledTasks-Simple.ps1 -Uninstall
```

### Pruebas del Sistema

```powershell
# Ejecutar todas las pruebas
.\Test-Automation.ps1

# Probar solo el script principal
.\Test-Automation.ps1 -TestScript

# Probar solo la configuración
.\Test-Automation.ps1 -TestScheduling
```

## 📋 Tareas Creadas en el Sistema

1. **SharePoint_SEGUIMIENTO_PRESENCIAL_Weekdays_Morning**
   - Lunes a Jueves a las 8:00 AM

2. **SharePoint_SEGUIMIENTO_PRESENCIAL_Weekdays_Evening**
   - Lunes a Jueves a las 5:00 PM

3. **SharePoint_SEGUIMIENTO_PRESENCIAL_Friday_Morning**
   - Viernes a las 8:00 AM

4. **SharePoint_SEGUIMIENTO_PRESENCIAL_Friday_Afternoon**
   - Viernes a las 3:00 PM

## 🔍 Solución de Problemas

### Problema: "Se requieren permisos de administrador"
**Solución**: Ejecutar PowerShell como administrador

### Problema: "No se puede ejecutar el script"
**Solución**: Cambiar política de ejecución
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Problema: Las tareas no se ejecutan
**Solución**: Verificar en el Programador de Tareas de Windows
1. Abrir "Programador de tareas" desde el menú inicio
2. Buscar las tareas que empiecen con "SharePoint_SEGUIMIENTO_PRESENCIAL"
3. Verificar que estén habilitadas y con horarios correctos

### Problema: No abre el navegador
**Verificar**:
- Conexión a internet
- Acceso a SharePoint
- Navegador predeterminado configurado

## 📝 Logs de Ejemplo

```
[2025-10-30 08:00:02] [INFO] INICIANDO AUTOMATIZACION DE APERTURA DE SHAREPOINT
[2025-10-30 08:00:02] [INFO] Contexto de ejecucion:
[2025-10-30 08:00:02] [INFO]   - Fecha y hora: miércoles, 30/10/2025 08:00:02
[2025-10-30 08:00:02] [INFO]   - Dia de la semana: Wednesday
[2025-10-30 08:00:02] [SUCCESS] Horario programado para dias laborables (L-J): 8:00 AM o 5:00 PM
[2025-10-30 08:00:02] [SUCCESS] EJECUTANDO: Abriendo documento de SharePoint...
[2025-10-30 08:00:02] [SUCCESS] Conexion a internet verificada correctamente
[2025-10-30 08:00:03] [SUCCESS] Documento de SharePoint abierto exitosamente
[2025-10-30 08:00:03] [SUCCESS] OPERACION COMPLETADA EXITOSAMENTE
```

## 🎛️ Personalización Avanzada

### Cambiar Horarios

Editar el archivo `Setup-ScheduledTasks-Simple.ps1` en la sección de configuración:

```powershell
$TasksConfiguration = @(
    @{
        Name = "$TaskNamePrefix`_Weekdays_Morning"
        Time = "08:30"  # Cambiar a 8:30 AM
        # ...
    }
    # ...
)
```

### Cambiar URL de SharePoint

Editar el archivo `Open-SharePoint-Simple.ps1`:

```powershell
param(
    [string]$SharePointUrl = "https://nueva-url-aqui"
)
```

## 📞 Soporte

### Información del Sistema

- **Proyecto**: Seguimiento Presencial Agencias
- **Departamento**: Centro de Gestión del Cliente
- **Empresa**: La Ascensión S.A.

### Pasos para Reportar Problemas

1. **Recopilar información**:
   - Ejecutar: `.\Test-Automation.ps1`
   - Revisar logs más recientes
   - Verificar estado de tareas

2. **Documentar el problema**:
   - Descripción del error
   - Pasos para reproducir
   - Capturas de pantalla si es necesario
   - Logs relevantes

3. **Contactar soporte técnico** con la información recopilada

---

## 🔄 Mantenimiento

### Recomendaciones Mensuales

1. **Verificar funcionamiento**:
   ```powershell
   .\Setup-ScheduledTasks-Simple.ps1 -Status
   ```

2. **Limpiar logs antiguos** (opcional):
   ```powershell
   # Eliminar logs de más de 3 meses
   Get-ChildItem "..\..\logs\*.log" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddMonths(-3)} | Remove-Item
   ```

3. **Probar ejecución manual**:
   ```powershell
   .\Open-SharePoint-Simple.ps1
   ```

### Actualizaciones del Sistema

Si necesita actualizar el sistema:

1. **Hacer backup** de la configuración actual
2. **Desinstalar** tareas existentes
3. **Actualizar** archivos de script
4. **Reinstalar** tareas programadas
5. **Verificar** funcionamiento

```powershell
# Proceso completo de actualización
.\Setup-ScheduledTasks-Simple.ps1 -Uninstall
# ... copiar nuevos archivos ...
.\Setup-ScheduledTasks-Simple.ps1 -Install
.\Test-Automation.ps1
```

---

**Nota**: Este sistema fue desarrollado específicamente para el proyecto de Seguimiento Presencial de Agencias de La Ascensión S.A. y forma parte del Centro de Gestión del Cliente.