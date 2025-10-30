# Documentación Técnica - Dashboard BI Seguimiento Presencial Agencias

## Descripción General

Dashboard de Business Intelligence desarrollado en Power BI para el seguimiento y análisis de interacciones presenciales en agencias de La Ascensión S.A. Forma parte del Centro de Gestión del Cliente y proporciona métricas clave sobre atención presencial, cancelaciones y rendimiento de agencias.

## Arquitectura del Sistema

### Componentes Principales

1. **Fuentes de Datos**
   - Base de datos transaccional de atención al cliente
   - Sistema de gestión de agencias
   - Registro de cancelaciones
   - Datos de rendimiento operativo

2. **Capa de ETL**
   - Scripts de extracción de datos
   - Transformaciones y limpieza
   - Carga incremental y completa

3. **Modelo de Datos**
   - Modelo estrella optimizado para análisis
   - Tablas de hechos y dimensiones
   - Relaciones y cardinalidades

4. **Capa de Presentación**
   - Dashboard interactivo en Power BI
   - Visualizaciones dinámicas
   - Filtros y segmentadores

## Modelo de Datos

### Tablas de Hechos

#### FactInteraccionesPresenciales
- **ID_Interaccion** (PK): Identificador único de la interacción
- **ID_Fecha** (FK): Referencia a DimFecha
- **ID_Agencia** (FK): Referencia a DimAgencia
- **ID_Cliente** (FK): Referencia a DimCliente
- **ID_TipoServicio** (FK): Referencia a DimTipoServicio
- **ID_Asesor** (FK): Referencia a DimAsesor
- **HoraInicio**: Hora de inicio de la atención
- **HoraFin**: Hora de finalización
- **DuracionMinutos**: Duración en minutos
- **EstadoInteraccion**: Estado (Completada, Cancelada, En Proceso)
- **CalificacionServicio**: Calificación del 1 al 5
- **TiempoCola**: Tiempo de espera en minutos

#### FactCancelaciones
- **ID_Cancelacion** (PK): Identificador único
- **ID_Fecha** (FK): Fecha de la cancelación
- **ID_Agencia** (FK): Agencia donde ocurrió
- **ID_Cliente** (FK): Cliente que canceló
- **MotivoCancelacion**: Razón de la cancelación
- **TiempoEsperaAntesCancelacion**: Tiempo en cola antes de cancelar

### Tablas de Dimensiones

#### DimFecha
- **ID_Fecha** (PK)
- **Fecha**: Fecha completa
- **Anio**: Año
- **Mes**: Mes
- **NombreMes**: Nombre del mes
- **Trimestre**: Trimestre
- **Semana**: Número de semana
- **DiaSemana**: Día de la semana
- **NombreDia**: Nombre del día
- **EsFinDeSemana**: Indicador booleano
- **EsFeriado**: Indicador booleano

#### DimAgencia
- **ID_Agencia** (PK)
- **CodigoAgencia**: Código único de agencia
- **NombreAgencia**: Nombre de la agencia
- **Region**: Región geográfica
- **Zona**: Zona
- **Ciudad**: Ciudad
- **Direccion**: Dirección completa
- **CapacidadAtencion**: Capacidad máxima
- **NumeroVentanillas**: Cantidad de ventanillas
- **FechaApertura**: Fecha de apertura
- **Estado**: Activa/Inactiva

#### DimCliente
- **ID_Cliente** (PK)
- **NumeroCliente**: Número de cliente
- **TipoCliente**: Individual/Corporativo
- **Segmento**: Segmento de cliente
- **FechaRegistro**: Fecha de registro
- **Estado**: Activo/Inactivo

#### DimTipoServicio
- **ID_TipoServicio** (PK)
- **CodigoServicio**: Código del servicio
- **NombreServicio**: Nombre descriptivo
- **Categoria**: Categoría del servicio
- **TiempoPromedioAtencion**: Tiempo promedio en minutos
- **Prioridad**: Nivel de prioridad

#### DimAsesor
- **ID_Asesor** (PK)
- **NumeroEmpleado**: Número de empleado
- **NombreCompleto**: Nombre del asesor
- **ID_Agencia** (FK): Agencia asignada
- **FechaIngreso**: Fecha de ingreso
- **Estado**: Activo/Inactivo

## Medidas DAX Principales

### KPIs de Atención

```dax
TotalInteracciones = COUNTROWS(FactInteraccionesPresenciales)

InteraccionesCompletadas = 
CALCULATE(
    COUNTROWS(FactInteraccionesPresenciales),
    FactInteraccionesPresenciales[EstadoInteraccion] = "Completada"
)

TasaCompletacion = 
DIVIDE(
    [InteraccionesCompletadas],
    [TotalInteracciones],
    0
)

PromedioTiempoAtencion = 
AVERAGE(FactInteraccionesPresenciales[DuracionMinutos])

PromedioTiempoCola = 
AVERAGE(FactInteraccionesPresenciales[TiempoCola])
```

### KPIs de Cancelaciones

```dax
TotalCancelaciones = COUNTROWS(FactCancelaciones)

TasaCancelacion = 
DIVIDE(
    [TotalCancelaciones],
    [TotalInteracciones],
    0
)

PromedioTiempoAntesCancelacion = 
AVERAGE(FactCancelaciones[TiempoEsperaAntesCancelacion])
```

### KPIs de Rendimiento

```dax
SatisfaccionPromedio = 
AVERAGE(FactInteraccionesPresenciales[CalificacionServicio])

CapacidadUtilizada = 
DIVIDE(
    [TotalInteracciones],
    SUM(DimAgencia[CapacidadAtencion]),
    0
)

InteraccionesPorAsesor = 
DIVIDE(
    [InteraccionesCompletadas],
    DISTINCTCOUNT(FactInteraccionesPresenciales[ID_Asesor]),
    0
)
```

## Requisitos Técnicos

### Software Necesario
- Power BI Desktop (versión 2023.10 o superior)
- Power BI Service (licencia Pro o Premium)
- SQL Server 2019 o superior (para fuentes de datos)
- Python 3.8+ (para scripts ETL)

### Conectividad
- Acceso a base de datos transaccional
- Conexión a red corporativa
- Credenciales de acceso con permisos de lectura

## Actualización de Datos

### Frecuencia de Actualización
- **Datos transaccionales**: Actualización cada 30 minutos
- **Datos de dimensiones**: Actualización diaria (2:00 AM)
- **Datos históricos**: Carga mensual completa

### Proceso de Actualización
1. Validación de conexión a fuentes
2. Extracción incremental de datos
3. Validación de calidad de datos
4. Transformación y limpieza
5. Carga al modelo
6. Actualización de cache
7. Publicación en servicio

## Seguridad

### Niveles de Acceso
1. **Administradores**: Acceso completo, configuración
2. **Gerentes Regionales**: Visualización de su región
3. **Gerentes de Agencia**: Datos de su agencia
4. **Analistas**: Solo lectura, sin filtros RLS

### Row-Level Security (RLS)
- Filtrado por región para gerentes regionales
- Filtrado por agencia para gerentes de agencia
- Sin restricciones para administradores

## Mantenimiento

### Tareas Periódicas
- **Diario**: Verificación de actualización de datos
- **Semanal**: Revisión de rendimiento del modelo
- **Mensual**: Optimización de medidas DAX
- **Trimestral**: Revisión de estructura del modelo

### Monitoreo
- Logs de actualización
- Tiempo de respuesta de visualizaciones
- Uso de recursos del servidor
- Errores de conexión
