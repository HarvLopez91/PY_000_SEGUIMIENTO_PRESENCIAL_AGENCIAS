# Guía de Despliegue - Dashboard Seguimiento Presencial Agencias

## Índice
1. [Requisitos Previos](#requisitos-previos)
2. [Instalación de Componentes](#instalación-de-componentes)
3. [Configuración de Base de Datos](#configuración-de-base-de-datos)
4. [Configuración de Power BI](#configuración-de-power-bi)
5. [Despliegue en Power BI Service](#despliegue-en-power-bi-service)
6. [Configuración de Seguridad](#configuración-de-seguridad)
7. [Configuración de Actualizaciones](#configuración-de-actualizaciones)
8. [Validación Post-Despliegue](#validación-post-despliegue)
9. [Troubleshooting](#troubleshooting)

---

## Requisitos Previos

### Hardware
- **Servidor de Base de Datos**:
  - CPU: 8 cores mínimo
  - RAM: 32 GB mínimo
  - Disco: 500 GB SSD (para datos y logs)
  - Red: 1 Gbps

- **Gateway de Datos** (si aplica):
  - CPU: 4 cores
  - RAM: 8 GB
  - Sistema Operativo: Windows Server 2016 o superior

### Software Requerido
- SQL Server 2019 o superior (Enterprise/Standard)
- Power BI Desktop (última versión estable)
- Power BI Service (licencia Pro o Premium)
- Python 3.8+ (para scripts ETL)
- On-Premises Data Gateway (para conexión a datos locales)

### Accesos y Permisos
- [ ] Cuenta de servicio para ETL con permisos de lectura en BD transaccional
- [ ] Cuenta de servicio con permisos de escritura en BD dimensional
- [ ] Cuenta de Power BI Pro o acceso a capacidad Premium
- [ ] Acceso administrativo a Power BI Service workspace
- [ ] Credenciales de Active Directory para RLS

---

## Instalación de Componentes

### Paso 1: Preparar Servidor de Base de Datos

```bash
# 1.1. Validar instalación de SQL Server
sqlcmd -S localhost -Q "SELECT @@VERSION"

# 1.2. Verificar servicios de SQL Server
Get-Service -Name MSSQLSERVER
Get-Service -Name SQLSERVERAGENT
```

### Paso 2: Instalar Python y Dependencias

```bash
# 2.1. Validar versión de Python
python --version

# 2.2. Crear entorno virtual
python -m venv venv_etl

# 2.3. Activar entorno virtual
# Windows:
venv_etl\Scripts\activate
# Linux/Mac:
source venv_etl/bin/activate

# 2.4. Instalar dependencias
pip install pandas==1.5.3
pip install pyodbc==4.0.39
pip install sqlalchemy==2.0.15
pip install python-dotenv==1.0.0

# 2.5. Guardar dependencias
pip freeze > requirements.txt
```

### Paso 3: Instalar Power BI Desktop

```powershell
# Descargar desde https://powerbi.microsoft.com/desktop/
# Instalar versión más reciente
# Verificar instalación
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    Where-Object {$_.DisplayName -like "*Power BI*"}
```

### Paso 4: Instalar y Configurar Gateway

```powershell
# 4.1. Descargar On-Premises Data Gateway
# https://powerbi.microsoft.com/gateway/

# 4.2. Ejecutar instalador
Start-Process "GatewayInstall.exe"

# 4.3. Registrar gateway con cuenta de Power BI
# Seguir asistente de configuración

# 4.4. Validar que el gateway esté en línea
# Verificar en Power BI Service > Settings > Manage gateways
```

---

## Configuración de Base de Datos

### Paso 1: Crear Base de Datos Dimensional

```sql
-- 1.1. Conectar a SQL Server
-- USE master;

-- 1.2. Crear base de datos
CREATE DATABASE DW_Seguimiento_Presencial
ON PRIMARY 
(
    NAME = N'DW_Seguimiento_Presencial_Data',
    FILENAME = N'D:\SQLData\DW_Seguimiento_Presencial.mdf',
    SIZE = 1GB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 512MB
)
LOG ON 
(
    NAME = N'DW_Seguimiento_Presencial_Log',
    FILENAME = N'D:\SQLLogs\DW_Seguimiento_Presencial_log.ldf',
    SIZE = 512MB,
    MAXSIZE = 10GB,
    FILEGROWTH = 256MB
);
GO

-- 1.3. Configurar opciones de base de datos
ALTER DATABASE DW_Seguimiento_Presencial 
SET RECOVERY SIMPLE;

ALTER DATABASE DW_Seguimiento_Presencial 
SET AUTO_UPDATE_STATISTICS ON;

ALTER DATABASE DW_Seguimiento_Presencial 
SET AUTO_CREATE_STATISTICS ON;
GO
```

### Paso 2: Ejecutar Scripts de Creación de Tablas

```bash
# 2.1. Ejecutar script de esquema
sqlcmd -S localhost -d DW_Seguimiento_Presencial -i data/schema.sql -o schema_output.log

# 2.2. Verificar creación exitosa
sqlcmd -S localhost -d DW_Seguimiento_Presencial -Q "SELECT name FROM sys.tables ORDER BY name"
```

### Paso 3: Crear Usuarios y Roles de Seguridad

```sql
-- 3.1. Crear login para servicio ETL
CREATE LOGIN etl_service 
WITH PASSWORD = 'P@ssw0rd_ComplexoSeguro!',
     DEFAULT_DATABASE = DW_Seguimiento_Presencial,
     CHECK_POLICY = ON;

-- 3.2. Crear usuario en la base de datos
USE DW_Seguimiento_Presencial;
CREATE USER etl_service FOR LOGIN etl_service;

-- 3.3. Asignar rol ETL
ALTER ROLE rol_ETL_Dashboard ADD MEMBER etl_service;

-- 3.4. Crear login para Power BI
CREATE LOGIN powerbi_service 
WITH PASSWORD = 'P@ssw0rd_PowerBI_Seguro!',
     DEFAULT_DATABASE = DW_Seguimiento_Presencial,
     CHECK_POLICY = ON;

-- 3.5. Crear usuario para Power BI
CREATE USER powerbi_service FOR LOGIN powerbi_service;

-- 3.6. Asignar rol de lectura
ALTER ROLE rol_LecturaDashboard ADD MEMBER powerbi_service;
GO
```

### Paso 4: Cargar Dimensión de Fechas

```sql
-- 4.1. Popular DimFecha (2020-2029)
EXEC sp_PopularDimFecha 
    @FechaInicio = '2020-01-01',
    @FechaFin = '2029-12-31';

-- 4.2. Marcar feriados nacionales
UPDATE DimFecha 
SET EsFeriado = 1, 
    NombreFeriado = 'Año Nuevo'
WHERE Mes = 1 AND DiaSemana = 1;

-- Agregar más feriados según calendario nacional
-- ...

-- 4.3. Validar carga
SELECT 
    COUNT(*) AS TotalDias,
    MIN(Fecha) AS PrimeraFecha,
    MAX(Fecha) AS UltimaFecha,
    SUM(CAST(EsFeriado AS INT)) AS TotalFeriados
FROM DimFecha;
```

### Paso 5: Crear Índices Adicionales de Rendimiento

```sql
-- 5.1. Índices columnstore para tablas de hechos grandes
CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_FactInteracciones
ON FactInteraccionesPresenciales (
    ID_Fecha, ID_Agencia, ID_Cliente, ID_TipoServicio, 
    DuracionMinutos, CalificacionServicio, TiempoCola
);

-- 5.2. Estadísticas
CREATE STATISTICS STAT_FactInteracciones_Fecha 
ON FactInteraccionesPresenciales(ID_Fecha);

CREATE STATISTICS STAT_FactInteracciones_Agencia 
ON FactInteraccionesPresenciales(ID_Agencia);
```

---

## Configuración de Power BI

### Paso 1: Crear Archivo Power BI Desktop (.pbix)

```
1. Abrir Power BI Desktop
2. Ir a File > New
3. Guardar como: "Dashboard_Seguimiento_Presencial_v1.0.pbix"
```

### Paso 2: Conectar a Fuente de Datos

```
1. Home > Get Data > SQL Server

2. Configurar conexión:
   - Server: sql-server-produccion.laascension.local
   - Database: DW_Seguimiento_Presencial
   - Data Connectivity mode: Import (recomendado para este caso)
   
3. Autenticación:
   - Usar: Windows Authentication o Database credentials
   - Username: powerbi_service
   - Password: [contraseña configurada]

4. Seleccionar tablas:
   - [x] DimFecha
   - [x] DimAgencia
   - [x] DimCliente
   - [x] DimTipoServicio
   - [x] DimAsesor
   - [x] FactInteraccionesPresenciales
   - [x] FactCancelaciones

5. Load > Transform Data (para limpiar si es necesario) > Close & Apply
```

### Paso 3: Configurar Relaciones del Modelo

```
1. Ir a Model view
2. Verificar/crear relaciones:

   FactInteraccionesPresenciales[ID_Fecha] ----* DimFecha[ID_Fecha]
   FactInteraccionesPresenciales[ID_Agencia] --* DimAgencia[ID_Agencia]
   FactInteraccionesPresenciales[ID_Cliente] --* DimCliente[ID_Cliente]
   FactInteraccionesPresenciales[ID_TipoServicio] --* DimTipoServicio[ID_TipoServicio]
   FactInteraccionesPresenciales[ID_Asesor] --* DimAsesor[ID_Asesor]
   
   FactCancelaciones[ID_Fecha] ----* DimFecha[ID_Fecha]
   FactCancelaciones[ID_Agencia] --* DimAgencia[ID_Agencia]
   FactCancelaciones[ID_Cliente] --* DimCliente[ID_Cliente]
   
   DimAsesor[ID_Agencia] ----* DimAgencia[ID_Agencia]

3. Configurar todas como:
   - Cardinality: Many to One (*)
   - Cross filter direction: Single
   - Make this relationship active: Yes
```

### Paso 4: Crear Medidas DAX

```
1. Home > New Measure

2. Copiar y pegar medidas del archivo: dax/measures.dax

3. Organizar medidas en carpetas de visualización:
   - KPIs Principales
   - Tiempos
   - Satisfacción
   - Productividad
   - Comparativas
   - Indicadores Visuales

4. Validar que no hay errores de sintaxis
```

### Paso 5: Crear Jerarquías

```
1. En Model view, crear jerarquías:

   DimFecha:
   - Jerarquía Temporal: Anio > Semestre > Trimestre > Mes > Fecha
   
   DimAgencia:
   - Jerarquía Geográfica: Region > Zona > Provincia > Canton > Agencia
   
   DimTipoServicio:
   - Jerarquía Servicio: Categoria > SubCategoria > NombreServicio
```

### Paso 6: Diseñar Páginas y Visualizaciones

```
1. Crear 6 páginas según especificaciones en visualizations/VISUALIZATION_SPECS.md

2. Configurar cada página:
   - Agregar visualizaciones según specs
   - Aplicar formato corporativo
   - Configurar interactividad
   - Crear tooltips personalizados

3. Crear bookmarks para vistas predefinidas

4. Configurar botones de navegación
```

### Paso 7: Configurar Row-Level Security

```
1. Modeling > Manage Roles

2. Crear roles según powerbi/config.py:

   Role: Gerente_Regional
   Table: DimAgencia
   Filter: [Region] = USERNAME()
   
   Role: Gerente_Agencia
   Table: DimAgencia
   Filter: [CodigoAgencia] = USERNAME()

3. Validar roles:
   - Modeling > View as Roles
   - Seleccionar rol y usuario de prueba
   - Verificar filtrado correcto
```

### Paso 8: Optimizar Rendimiento

```
1. Eliminar columnas no utilizadas de tablas

2. Cambiar tipos de datos para optimizar:
   - IDs: Whole Number
   - Fechas: Date
   - Textos cortos: Text (reducir ancho si es posible)

3. Deshabilitar carga de tablas no usadas

4. Configurar agregaciones si es necesario:
   - Para FactInteracciones si > 50M registros

5. Performance Analyzer:
   - View > Performance Analyzer
   - Start Recording
   - Interactuar con dashboard
   - Stop Recording
   - Analizar y optimizar visuales lentos
```

---

## Despliegue en Power BI Service

### Paso 1: Crear Workspace

```
1. Iniciar sesión en app.powerbi.com

2. Workspaces > Create a workspace

3. Configurar:
   - Name: "Centro Gestion Cliente - Seguimiento Presencial"
   - Description: "Dashboard BI para análisis de interacciones presenciales"
   - Advanced:
     - Workspace mode: Premium capacity (si disponible)
     - License: Pro or Premium Per User
     - Sensitivity: Confidential

4. Create
```

### Paso 2: Publicar Dashboard

```
1. En Power BI Desktop:
   - File > Publish > Publish to Power BI
   - Select workspace: "Centro Gestion Cliente - Seguimiento Presencial"
   - Publish

2. Esperar confirmación de publicación

3. Validar en Power BI Service:
   - Navegar al workspace
   - Verificar que aparece el .pbix
   - Abrir y verificar visualizaciones
```

### Paso 3: Configurar Gateway de Datos

```
1. En Power BI Service:
   - Settings > Manage gateways
   - Seleccionar gateway instalado previamente

2. Agregar fuente de datos:
   - Gateway cluster name: [nombre del gateway]
   - Data Source Name: DW_Seguimiento_Presencial
   - Data Source Type: SQL Server
   - Server: sql-server-produccion.laascension.local
   - Database: DW_Seguimiento_Presencial
   - Authentication: Windows o Database
   - Username/Password: powerbi_service credentials

3. Add

4. Test connection > Success
```

### Paso 4: Configurar Dataset

```
1. En workspace, ir a dataset:
   - Dashboard_Seguimiento_Presencial
   - Settings (⚙️)

2. Gateway connection:
   - [x] Use an On-premises or VNet data gateway
   - Gateway: [seleccionar gateway configurado]
   - Data source: DW_Seguimiento_Presencial

3. Data source credentials:
   - Edit credentials
   - Authentication: Windows o OAuth2
   - Configurar credenciales
   - Sign in

4. Scheduled refresh:
   - [x] Keep your data up to date
   - Refresh frequency: Every 30 minutes (o según config)
   - Time zone: (GMT-06:00) Central America
   - Add time: 00:00, 00:30, 01:00... (según horarios en config)

5. Apply
```

### Paso 5: Configurar Seguridad RLS en Service

```
1. Dataset > More options (...) > Security

2. Mapear usuarios a roles:
   
   Rol: Gerente_Regional
   - Agregar usuarios por correo o grupo de AD
   - Ejemplo: region.norte@laascension.com
   
   Rol: Gerente_Agencia
   - Agregar gerentes individuales
   - Ejemplo: gerente.ag001@laascension.com

3. Save

4. Test:
   - View as role > Gerente_Regional
   - Verificar filtrado correcto de datos
```

### Paso 6: Crear App de Power BI

```
1. En workspace:
   - Create app

2. Setup:
   - Name: "Seguimiento Presencial Agencias"
   - Description: [copiar de documentación]
   - App logo: Subir logo de La Ascensión
   - App theme color: #003366 (azul corporativo)

3. Content:
   - Seleccionar dashboard y reportes a incluir
   - Ordenar páginas
   - Ocultar páginas no relevantes para usuarios finales

4. Access:
   - Specific individuals or groups
   - Agregar grupos de AD:
     - GG_BI_Seguimiento_Presencial_Users
     - GG_BI_Seguimiento_Presencial_Admins
   
   - Permissions:
     - [x] Allow users to share this app
     - [x] Allow users to build content with the app's datasets
     - [ ] Allow users to copy reports (restringido)

5. Publish app

6. Copiar link de la app y distribuir a usuarios
```

---

## Configuración de Seguridad

### Paso 1: Configurar Azure AD Integration

```powershell
# Verificar que Power BI esté integrado con Azure AD
# Admin Portal > Tenant settings > Azure Active Directory

# Habilitar:
- Azure Active Directory Single Sign-On (SSO)
- Embed content in apps
- Users can see Power BI items in Microsoft 365
```

### Paso 2: Configurar Sensitivity Labels

```
1. Admin portal > Tenant settings > Information protection

2. Aplicar etiquetas a workspace y contenido:
   - Workspace: Confidential - Internal
   - Dataset: Confidential - Restricted
   - Reports: General - Internal

3. Configurar políticas DLP si aplica
```

### Paso 3: Auditoría y Monitoreo

```
1. Admin portal > Audit logs
   - Habilitar logging
   - Configurar retención: 90 días

2. Monitorear actividades:
   - ViewReport
   - ExportReport
   - DownloadReport
   - ViewDashboard

3. Configurar alertas para actividades sospechosas
```

---

## Configuración de Actualizaciones

### Paso 1: Configurar ETL Programado

```bash
# En servidor donde corre ETL

# 1.1. Crear archivo de configuración
cat > /etc/etl/config.env << EOF
SOURCE_SERVER=sql-transaccional.laascension.local
SOURCE_DB=DB_Transaccional
TARGET_SERVER=sql-server-produccion.laascension.local
TARGET_DB=DW_Seguimiento_Presencial
ETL_USER=etl_service
ETL_PASSWORD=[password_encriptado]
EOF

# 1.2. Crear script de ejecución
cat > /usr/local/bin/run_etl_dashboard.sh << 'EOF'
#!/bin/bash
cd /opt/etl/seguimiento_presencial
source venv_etl/bin/activate
python scripts/etl_dashboard.py
EOF

chmod +x /usr/local/bin/run_etl_dashboard.sh

# 1.3. Configurar cron job (cada 30 minutos)
crontab -e
# Agregar:
*/30 * * * * /usr/local/bin/run_etl_dashboard.sh >> /var/log/etl_dashboard.log 2>&1
```

### Paso 2: Configurar Monitoreo de ETL

```python
# Crear script de monitoreo
# /opt/etl/seguimiento_presencial/scripts/monitor_etl.py

import smtplib
from email.mime.text import MIMEText
from datetime import datetime, timedelta
import sqlite3

def check_etl_health():
    # Verificar última ejecución exitosa
    # Enviar alerta si han pasado más de 2 horas sin actualización
    pass

def send_alert(message):
    # Enviar email a equipo de BI
    pass

if __name__ == "__main__":
    check_etl_health()
```

---

## Validación Post-Despliegue

### Checklist de Validación

```
□ Base de datos creada y accesible
□ Todas las tablas creadas correctamente
□ Datos de prueba cargados (si aplica)
□ Relaciones del modelo configuradas
□ Medidas DAX funcionando sin errores
□ RLS configurado y probado
□ Dashboard publicado en Power BI Service
□ Gateway conectado y funcionando
□ Scheduled refresh configurado y ejecutándose
□ App creada y compartida con usuarios piloto
□ Permisos y seguridad validados
□ Performance aceptable (< 5 seg por visual)
□ Documentación entregada a usuarios
□ Capacitación realizada
□ Proceso ETL ejecutándose correctamente
□ Monitoreo y alertas configurados
```

### Test de Usuarios Piloto

```
1. Seleccionar 5-10 usuarios piloto de diferentes roles:
   - 1 Gerente Regional
   - 2 Gerentes de Agencia
   - 2 Analistas

2. Proveer acceso de prueba durante 1 semana

3. Recopilar feedback:
   - Funcionalidad
   - Rendimiento
   - Usabilidad
   - Sugerencias de mejora

4. Ajustar según feedback

5. Aprobar go-live
```

---

## Troubleshooting

### Problema: Error al conectar a base de datos

**Síntomas**: "Unable to connect to data source"

**Solución**:
```
1. Verificar conectividad de red:
   Test-NetConnection -ComputerName sql-server-produccion.laascension.local -Port 1433

2. Verificar credenciales:
   sqlcmd -S sql-server-produccion.laascension.local -U powerbi_service -P [password]

3. Verificar firewall:
   - Puerto 1433 abierto
   - Regla de entrada permitida

4. Verificar que el servicio SQL Server esté corriendo
```

### Problema: Actualización programada falla

**Síntomas**: "Scheduled refresh failed"

**Solución**:
```
1. Revisar logs de actualización en Power BI Service

2. Verificar que el gateway esté en línea

3. Probar conexión manualmente desde gateway:
   sqlcmd -S [server] -U [user] -P [password]

4. Revisar credenciales de fuente de datos

5. Verificar timeouts (aumentar si es necesario)

6. Revisar si hay bloqueos en la BD durante actualización
```

### Problema: RLS no filtra correctamente

**Síntomas**: Usuario ve datos de otras regiones/agencias

**Solución**:
```
1. Verificar expresión DAX en rol:
   - Revisar sintaxis
   - Probar con USERNAME() y USERPRINCIPALNAME()

2. Verificar mapeo usuario-rol en Security

3. Usar "View as role" para testear

4. Verificar que relaciones estén configuradas correctamente

5. Verificar que usuario esté mapeado a región/agencia en DimAgencia
```

### Problema: Performance lento

**Síntomas**: Visualizaciones tardan > 10 segundos en cargar

**Solución**:
```
1. Usar Performance Analyzer para identificar visuales lentos

2. Optimizar medidas DAX:
   - Evitar CALCULATE innecesarios
   - Usar variables VAR
   - Evitar iteradores si es posible

3. Reducir cardinalidad de tablas

4. Considerar agregaciones

5. Revisar índices en base de datos

6. Considerar cambiar de Import a DirectQuery o viceversa

7. Limitar rangos de fecha por defecto
```

### Problema: Datos desactualizados

**Síntomas**: Dashboard muestra datos antiguos

**Solución**:
```
1. Verificar última actualización en dataset settings

2. Revisar scheduled refresh logs

3. Verificar que ETL esté corriendo:
   - Revisar logs de ETL
   - Verificar cron job activo
   - Revisar errores en proceso ETL

4. Forzar refresh manual para validar

5. Verificar zona horaria en configuración
```

---

## Mantenimiento Continuo

### Tareas Diarias
- [ ] Verificar ejecución de ETL
- [ ] Revisar logs de errores
- [ ] Monitorear tiempo de actualización

### Tareas Semanales
- [ ] Revisar performance de dashboard
- [ ] Analizar queries lentas
- [ ] Revisar uso y adoption

### Tareas Mensuales
- [ ] Optimizar índices de BD
- [ ] Archivar datos antiguos (> 24 meses)
- [ ] Actualizar documentación
- [ ] Revisar feedback de usuarios

### Tareas Trimestrales
- [ ] Revisar y optimizar modelo de datos
- [ ] Evaluar nuevos requerimientos
- [ ] Capacitación a nuevos usuarios
- [ ] Auditoría de seguridad

---

## Contacto Soporte

**Equipo de BI**: bi@laascension.com
**On-call**: +XXX-XXX-XXXX
**Portal de tickets**: https://soporte.laascension.com

---

*Fin de Guía de Despliegue*
*Versión: 1.0*
*Fecha: 2023-10-30*
