# Diccionario de Datos - Dashboard Seguimiento Presencial Agencias

## Tablas de Hechos

### FactInteraccionesPresenciales

Tabla que almacena todas las interacciones presenciales entre clientes y asesores en las agencias.

| Campo | Tipo de Dato | Descripción | Valores Permitidos | Ejemplo | Obligatorio |
|-------|--------------|-------------|-------------------|---------|-------------|
| ID_Interaccion | INT | Identificador único de la interacción (PK) | Numérico único | 100234 | Sí |
| ID_Fecha | INT | Clave foránea a DimFecha | Referencia válida | 20231015 | Sí |
| ID_Agencia | INT | Clave foránea a DimAgencia | Referencia válida | 45 | Sí |
| ID_Cliente | INT | Clave foránea a DimCliente | Referencia válida | 78901 | Sí |
| ID_TipoServicio | INT | Clave foránea a DimTipoServicio | Referencia válida | 12 | Sí |
| ID_Asesor | INT | Clave foránea a DimAsesor | Referencia válida | 345 | Sí |
| HoraInicio | TIME | Hora de inicio de atención | HH:MM:SS | 09:30:00 | Sí |
| HoraFin | TIME | Hora de finalización de atención | HH:MM:SS | 09:45:00 | Sí |
| DuracionMinutos | DECIMAL(10,2) | Duración de la atención en minutos | 0 - 999.99 | 15.50 | Sí |
| EstadoInteraccion | VARCHAR(20) | Estado de la interacción | Completada, Cancelada, En Proceso | Completada | Sí |
| CalificacionServicio | INT | Calificación otorgada por el cliente | 1, 2, 3, 4, 5, NULL | 4 | No |
| TiempoCola | DECIMAL(10,2) | Tiempo de espera en cola (minutos) | 0 - 999.99 | 8.25 | Sí |
| NumeroTicket | VARCHAR(20) | Número de ticket asignado | Alfanumérico | A-123-456 | Sí |
| FechaCreacion | DATETIME | Fecha y hora de creación del registro | Formato válido | 2023-10-15 09:30:00 | Sí |
| UsuarioCreacion | VARCHAR(50) | Usuario que creó el registro | Usuario válido | sistema_auto | Sí |

**Granularidad**: Una fila por cada interacción presencial completada o cancelada

**Volumen Estimado**: ~50,000 registros por mes

**Retención**: 24 meses de datos en línea, histórico en archivo

---

### FactCancelaciones

Tabla que registra todas las cancelaciones de atención (clientes que abandonan sin ser atendidos).

| Campo | Tipo de Dato | Descripción | Valores Permitidos | Ejemplo | Obligatorio |
|-------|--------------|-------------|-------------------|---------|-------------|
| ID_Cancelacion | INT | Identificador único de cancelación (PK) | Numérico único | 50123 | Sí |
| ID_Fecha | INT | Clave foránea a DimFecha | Referencia válida | 20231015 | Sí |
| ID_Agencia | INT | Clave foránea a DimAgencia | Referencia válida | 45 | Sí |
| ID_Cliente | INT | Clave foránea a DimCliente | Referencia válida | 78901 | No |
| MotivoCancelacion | VARCHAR(100) | Razón de la cancelación | Texto descriptivo | Tiempo de espera excesivo | Sí |
| TiempoEsperaAntesCancelacion | DECIMAL(10,2) | Minutos en cola antes de cancelar | 0 - 999.99 | 25.75 | Sí |
| HoraCancelacion | TIME | Hora en que se canceló | HH:MM:SS | 10:15:30 | Sí |
| NumeroTicket | VARCHAR(20) | Ticket que fue cancelado | Alfanumérico | B-789-012 | No |
| FechaCreacion | DATETIME | Fecha y hora de creación del registro | Formato válido | 2023-10-15 10:15:30 | Sí |

**Granularidad**: Una fila por cada cancelación registrada

**Volumen Estimado**: ~5,000 registros por mes

**Relación con FactInteracciones**: Son mutuamente excluyentes (un ticket es interacción O cancelación)

---

## Tablas de Dimensiones

### DimFecha

Dimensión de calendario para análisis temporal.

| Campo | Tipo de Dato | Descripción | Valores Permitidos | Ejemplo | Obligatorio |
|-------|--------------|-------------|-------------------|---------|-------------|
| ID_Fecha | INT | Identificador único (PK) formato YYYYMMDD | 20200101 - 20291231 | 20231015 | Sí |
| Fecha | DATE | Fecha completa | Fecha válida | 2023-10-15 | Sí |
| Anio | INT | Año | 2020-2029 | 2023 | Sí |
| Mes | INT | Número de mes | 1-12 | 10 | Sí |
| NombreMes | VARCHAR(20) | Nombre del mes | Enero-Diciembre | Octubre | Sí |
| Trimestre | INT | Trimestre del año | 1-4 | 4 | Sí |
| Semestre | INT | Semestre del año | 1-2 | 2 | Sí |
| Semana | INT | Semana del año | 1-53 | 41 | Sí |
| DiaSemana | INT | Día de la semana | 1-7 (1=Lunes) | 7 | Sí |
| NombreDia | VARCHAR(20) | Nombre del día | Lunes-Domingo | Domingo | Sí |
| EsFinDeSemana | BIT | Indicador de fin de semana | 0, 1 | 1 | Sí |
| EsFeriado | BIT | Indicador de feriado nacional | 0, 1 | 0 | Sí |
| NombreFeriado | VARCHAR(100) | Nombre del feriado si aplica | Texto o NULL | NULL | No |
| DiaDelAnio | INT | Día del año | 1-366 | 288 | Sí |

**Granularidad**: Una fila por día

**Rango**: 2020-01-01 a 2029-12-31 (10 años)

**Actualización**: Precargada, actualización anual

---

### DimAgencia

Dimensión de agencias físicas de atención.

| Campo | Tipo de Dato | Descripción | Valores Permitidos | Ejemplo | Obligatorio |
|-------|--------------|-------------|-------------------|---------|-------------|
| ID_Agencia | INT | Identificador único (PK) | Numérico único | 45 | Sí |
| CodigoAgencia | VARCHAR(10) | Código único de agencia | AG-XXXX | AG-0045 | Sí |
| NombreAgencia | VARCHAR(100) | Nombre de la agencia | Texto | Agencia Centro | Sí |
| Region | VARCHAR(50) | Región geográfica | Norte, Sur, Este, Oeste, Centro | Centro | Sí |
| Zona | VARCHAR(50) | Zona específica dentro de región | Texto | Zona 3 | Sí |
| Provincia | VARCHAR(50) | Provincia | Texto válido | San José | Sí |
| Canton | VARCHAR(50) | Cantón | Texto válido | Central | Sí |
| Distrito | VARCHAR(50) | Distrito | Texto válido | Carmen | Sí |
| Direccion | VARCHAR(200) | Dirección completa | Texto | Av. Central, Calle 5 | Sí |
| CodigoPostal | VARCHAR(10) | Código postal | Numérico | 10101 | No |
| Telefono | VARCHAR(20) | Teléfono de contacto | Formato telefónico | +506-2222-3333 | No |
| Email | VARCHAR(100) | Correo electrónico | Email válido | centro@laascension.com | No |
| CapacidadAtencion | INT | Capacidad diaria de atención | 50-500 | 200 | Sí |
| NumeroVentanillas | INT | Cantidad de ventanillas | 1-20 | 8 | Sí |
| MetrosCuadrados | DECIMAL(10,2) | Tamaño en metros cuadrados | 50-1000 | 250.50 | No |
| FechaApertura | DATE | Fecha de apertura de la agencia | Fecha válida | 2015-03-15 | Sí |
| GerenteAgencia | VARCHAR(100) | Nombre del gerente | Texto | Juan Pérez | No |
| HorarioApertura | TIME | Hora de apertura | HH:MM | 08:00 | Sí |
| HorarioCierre | TIME | Hora de cierre | HH:MM | 17:00 | Sí |
| Estado | VARCHAR(20) | Estado operativo | Activa, Inactiva, En Remodelación | Activa | Sí |
| TipoAgencia | VARCHAR(30) | Tipo de agencia | Principal, Secundaria, Express | Principal | Sí |

**Granularidad**: Una fila por agencia

**Actualización**: SCD Tipo 2 (se mantiene historial de cambios)

**Volumen**: ~50-100 agencias activas

---

### DimCliente

Dimensión de clientes de La Ascensión S.A.

| Campo | Tipo de Dato | Descripción | Valores Permitidos | Ejemplo | Obligatorio |
|-------|--------------|-------------|-------------------|---------|-------------|
| ID_Cliente | INT | Identificador único (PK) | Numérico único | 78901 | Sí |
| NumeroCliente | VARCHAR(20) | Número de cliente | CL-XXXXXX | CL-078901 | Sí |
| TipoCliente | VARCHAR(20) | Tipo de cliente | Individual, Corporativo | Individual | Sí |
| Segmento | VARCHAR(30) | Segmento de cliente | Premium, Gold, Silver, Standard | Gold | Sí |
| SubSegmento | VARCHAR(50) | Sub-segmento específico | Texto | Profesionales | No |
| FechaRegistro | DATE | Fecha de registro inicial | Fecha válida | 2020-05-10 | Sí |
| AntiguedadMeses | INT | Meses como cliente | 0-999 | 41 | Sí |
| RegionResidencia | VARCHAR(50) | Región donde reside | Norte, Sur, Este, Oeste, Centro | Centro | No |
| Estado | VARCHAR(20) | Estado del cliente | Activo, Inactivo, Suspendido | Activo | Sí |
| EsClienteVIP | BIT | Indicador cliente VIP | 0, 1 | 0 | Sí |

**Granularidad**: Una fila por cliente

**Actualización**: SCD Tipo 1 (se sobrescribe información)

**Volumen**: ~500,000 clientes activos

**Privacidad**: Datos personales identificables están protegidos según GDPR

---

### DimTipoServicio

Dimensión de tipos de servicios ofrecidos en agencias.

| Campo | Tipo de Dato | Descripción | Valores Permitidos | Ejemplo | Obligatorio |
|-------|--------------|-------------|-------------------|---------|-------------|
| ID_TipoServicio | INT | Identificador único (PK) | Numérico único | 12 | Sí |
| CodigoServicio | VARCHAR(10) | Código de servicio | SRV-XXX | SRV-012 | Sí |
| NombreServicio | VARCHAR(100) | Nombre descriptivo del servicio | Texto | Apertura de Cuenta | Sí |
| DescripcionDetallada | VARCHAR(500) | Descripción completa | Texto | Proceso de apertura... | No |
| Categoria | VARCHAR(50) | Categoría del servicio | Financiero, Administrativo, Consulta, Reclamo | Financiero | Sí |
| SubCategoria | VARCHAR(50) | Sub-categoría | Texto | Cuentas | No |
| TiempoPromedioAtencion | DECIMAL(10,2) | Tiempo promedio en minutos | 1-120 | 20.00 | Sí |
| TiempoMaximoAtencion | DECIMAL(10,2) | Tiempo máximo permitido | 1-180 | 35.00 | No |
| Prioridad | INT | Nivel de prioridad | 1-5 (1=Alta) | 2 | Sí |
| RequiereDocumentacion | BIT | Requiere documentos | 0, 1 | 1 | Sí |
| DisponibleEnLinea | BIT | Disponible en canal digital | 0, 1 | 0 | Sí |
| Estado | VARCHAR(20) | Estado del servicio | Activo, Inactivo, Descontinuado | Activo | Sí |

**Granularidad**: Una fila por tipo de servicio

**Actualización**: Mensual o cuando hay cambios

**Volumen**: ~50-80 tipos de servicios

---

### DimAsesor

Dimensión de asesores de atención al cliente.

| Campo | Tipo de Dato | Descripción | Valores Permitidos | Ejemplo | Obligatorio |
|-------|--------------|-------------|-------------------|---------|-------------|
| ID_Asesor | INT | Identificador único (PK) | Numérico único | 345 | Sí |
| NumeroEmpleado | VARCHAR(20) | Número de empleado | EMP-XXXXX | EMP-00345 | Sí |
| NombreCompleto | VARCHAR(100) | Nombre completo | Texto | María González Soto | Sí |
| ID_Agencia | INT | Agencia asignada (FK) | Referencia válida | 45 | Sí |
| Puesto | VARCHAR(50) | Puesto de trabajo | Asesor, Supervisor, Gerente | Asesor | Sí |
| FechaIngreso | DATE | Fecha de ingreso a la empresa | Fecha válida | 2019-08-15 | Sí |
| AntiguedadMeses | INT | Meses de antigüedad | 0-600 | 50 | Sí |
| NivelExperiencia | VARCHAR(20) | Nivel de experiencia | Junior, Semi-Senior, Senior | Semi-Senior | Sí |
| Certificaciones | VARCHAR(200) | Certificaciones obtenidas | Texto separado por comas | Atención Cliente, Ventas | No |
| HorarioTrabajo | VARCHAR(50) | Horario de trabajo | Texto | Lunes-Viernes 8-5 | No |
| Estado | VARCHAR(20) | Estado laboral | Activo, Inactivo, Licencia | Activo | Sí |

**Granularidad**: Una fila por asesor

**Actualización**: SCD Tipo 2 (se mantiene historial cuando cambian de agencia)

**Volumen**: ~300-500 asesores activos

**Privacidad**: Información sensible de RRHH no incluida

---

## Jerarquías Definidas

### Jerarquía Geográfica
```
Region
└── Zona
    └── Provincia
        └── Canton
            └── Distrito
                └── Agencia
```

### Jerarquía Temporal
```
Año
└── Semestre
    └── Trimestre
        └── Mes
            └── Semana
                └── Fecha
```

### Jerarquía de Servicios
```
Categoria
└── SubCategoria
    └── TipoServicio
```

### Jerarquía de Clientes
```
TipoCliente
└── Segmento
    └── SubSegmento
```

---

## Relaciones entre Tablas

| Tabla Origen | Columna | Tabla Destino | Columna | Cardinalidad | Tipo |
|--------------|---------|---------------|---------|--------------|------|
| FactInteraccionesPresenciales | ID_Fecha | DimFecha | ID_Fecha | N:1 | Regular |
| FactInteraccionesPresenciales | ID_Agencia | DimAgencia | ID_Agencia | N:1 | Regular |
| FactInteraccionesPresenciales | ID_Cliente | DimCliente | ID_Cliente | N:1 | Regular |
| FactInteraccionesPresenciales | ID_TipoServicio | DimTipoServicio | ID_TipoServicio | N:1 | Regular |
| FactInteraccionesPresenciales | ID_Asesor | DimAsesor | ID_Asesor | N:1 | Regular |
| FactCancelaciones | ID_Fecha | DimFecha | ID_Fecha | N:1 | Regular |
| FactCancelaciones | ID_Agencia | DimAgencia | ID_Agencia | N:1 | Regular |
| FactCancelaciones | ID_Cliente | DimCliente | ID_Cliente | N:1 | Regular |
| DimAsesor | ID_Agencia | DimAgencia | ID_Agencia | N:1 | Regular |

**Dirección de Filtros**: Unidireccional desde dimensiones hacia hechos

**Integridad Referencial**: Garantizada en el proceso ETL

---

## Reglas de Calidad de Datos

### Validaciones Obligatorias

1. **Integridad Referencial**: Todas las FK deben existir en tablas de dimensión
2. **Consistencia Temporal**: HoraFin >= HoraInicio
3. **Rangos Válidos**: CalificacionServicio entre 1-5 o NULL
4. **Unicidad**: No duplicados en claves primarias
5. **Completitud**: Campos obligatorios no pueden ser NULL

### Validaciones de Negocio

1. **DuracionMinutos** debe ser >= 0 y <= 240 (4 horas)
2. **TiempoCola** debe ser >= 0 y <= 480 (8 horas)
3. **CapacidadAtencion** debe ser coherente con **NumeroVentanillas**
4. **EstadoInteraccion** solo puede cambiar de "En Proceso" a "Completada" o "Cancelada"

### Métricas de Calidad

- **Completitud**: >= 98% de campos obligatorios completos
- **Exactitud**: >= 95% de registros sin errores de validación
- **Puntualidad**: Datos actualizados en menos de 1 hora desde ocurrencia
- **Consistencia**: 100% de integridad referencial

---

## Glosario de Términos de Negocio

| Término | Definición | Sinónimos |
|---------|------------|-----------|
| Interacción Presencial | Contacto cara a cara entre cliente y asesor en agencia física | Atención presencial, Visita |
| Tiempo en Cola | Minutos desde que cliente toma ticket hasta ser llamado | Tiempo de espera |
| Tasa de Completación | Porcentaje de interacciones finalizadas exitosamente | Tasa de finalización |
| Cancelación | Cliente que abandona antes de ser atendido | Abandono, No show |
| Ventanilla | Punto de atención individual donde asesor atiende cliente | Módulo de atención |
| Capacidad de Atención | Número máximo de clientes que pueden atenderse por día | Capacidad operativa |
| Satisfacción | Calificación del 1 al 5 otorgada por cliente post-atención | Rating, Calificación |
| Cliente VIP | Cliente con segmento Premium o condiciones especiales | Cliente preferencial |
