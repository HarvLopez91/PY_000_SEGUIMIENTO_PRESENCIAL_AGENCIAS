-- =============================================
-- Script de Creación del Modelo de Datos
-- Dashboard Seguimiento Presencial Agencias
-- La Ascensión S.A.
-- =============================================

-- =============================================
-- DIMENSIONES
-- =============================================

-- Tabla de Dimensión: Fecha
CREATE TABLE DimFecha (
    ID_Fecha INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Anio INT NOT NULL,
    Mes INT NOT NULL,
    NombreMes VARCHAR(20) NOT NULL,
    Trimestre INT NOT NULL,
    Semestre INT NOT NULL,
    Semana INT NOT NULL,
    DiaSemana INT NOT NULL,
    NombreDia VARCHAR(20) NOT NULL,
    EsFinDeSemana BIT NOT NULL,
    EsFeriado BIT NOT NULL,
    NombreFeriado VARCHAR(100),
    DiaDelAnio INT NOT NULL,
    CONSTRAINT CK_DimFecha_Mes CHECK (Mes BETWEEN 1 AND 12),
    CONSTRAINT CK_DimFecha_Trimestre CHECK (Trimestre BETWEEN 1 AND 4),
    CONSTRAINT CK_DimFecha_DiaSemana CHECK (DiaSemana BETWEEN 1 AND 7)
);

-- Índices para DimFecha
CREATE INDEX IX_DimFecha_Fecha ON DimFecha(Fecha);
CREATE INDEX IX_DimFecha_Anio_Mes ON DimFecha(Anio, Mes);

-- Tabla de Dimensión: Agencia
CREATE TABLE DimAgencia (
    ID_Agencia INT PRIMARY KEY,
    CodigoAgencia VARCHAR(10) NOT NULL UNIQUE,
    NombreAgencia VARCHAR(100) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    Zona VARCHAR(50) NOT NULL,
    Provincia VARCHAR(50) NOT NULL,
    Canton VARCHAR(50) NOT NULL,
    Distrito VARCHAR(50) NOT NULL,
    Direccion VARCHAR(200) NOT NULL,
    CodigoPostal VARCHAR(10),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    CapacidadAtencion INT NOT NULL,
    NumeroVentanillas INT NOT NULL,
    MetrosCuadrados DECIMAL(10,2),
    FechaApertura DATE NOT NULL,
    GerenteAgencia VARCHAR(100),
    HorarioApertura TIME NOT NULL,
    HorarioCierre TIME NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    TipoAgencia VARCHAR(30) NOT NULL,
    FechaVigenciaDesde DATE NOT NULL,
    FechaVigenciaHasta DATE,
    EsRegistroActual BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_DimAgencia_CapacidadAtencion CHECK (CapacidadAtencion > 0),
    CONSTRAINT CK_DimAgencia_NumeroVentanillas CHECK (NumeroVentanillas > 0),
    CONSTRAINT CK_DimAgencia_Estado CHECK (Estado IN ('Activa', 'Inactiva', 'En Remodelación'))
);

-- Índices para DimAgencia
CREATE INDEX IX_DimAgencia_Region ON DimAgencia(Region);
CREATE INDEX IX_DimAgencia_Estado ON DimAgencia(Estado);
CREATE INDEX IX_DimAgencia_EsRegistroActual ON DimAgencia(EsRegistroActual);

-- Tabla de Dimensión: Cliente
CREATE TABLE DimCliente (
    ID_Cliente INT PRIMARY KEY,
    NumeroCliente VARCHAR(20) NOT NULL UNIQUE,
    TipoCliente VARCHAR(20) NOT NULL,
    Segmento VARCHAR(30) NOT NULL,
    SubSegmento VARCHAR(50),
    FechaRegistro DATE NOT NULL,
    AntiguedadMeses INT NOT NULL,
    RegionResidencia VARCHAR(50),
    Estado VARCHAR(20) NOT NULL,
    EsClienteVIP BIT NOT NULL DEFAULT 0,
    CONSTRAINT CK_DimCliente_TipoCliente CHECK (TipoCliente IN ('Individual', 'Corporativo')),
    CONSTRAINT CK_DimCliente_Estado CHECK (Estado IN ('Activo', 'Inactivo', 'Suspendido'))
);

-- Índices para DimCliente
CREATE INDEX IX_DimCliente_Segmento ON DimCliente(Segmento);
CREATE INDEX IX_DimCliente_Estado ON DimCliente(Estado);
CREATE INDEX IX_DimCliente_TipoCliente ON DimCliente(TipoCliente);

-- Tabla de Dimensión: Tipo de Servicio
CREATE TABLE DimTipoServicio (
    ID_TipoServicio INT PRIMARY KEY,
    CodigoServicio VARCHAR(10) NOT NULL UNIQUE,
    NombreServicio VARCHAR(100) NOT NULL,
    DescripcionDetallada VARCHAR(500),
    Categoria VARCHAR(50) NOT NULL,
    SubCategoria VARCHAR(50),
    TiempoPromedioAtencion DECIMAL(10,2) NOT NULL,
    TiempoMaximoAtencion DECIMAL(10,2),
    Prioridad INT NOT NULL,
    RequiereDocumentacion BIT NOT NULL,
    DisponibleEnLinea BIT NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT CK_DimTipoServicio_Prioridad CHECK (Prioridad BETWEEN 1 AND 5),
    CONSTRAINT CK_DimTipoServicio_TiempoPromedio CHECK (TiempoPromedioAtencion > 0),
    CONSTRAINT CK_DimTipoServicio_Estado CHECK (Estado IN ('Activo', 'Inactivo', 'Descontinuado'))
);

-- Índices para DimTipoServicio
CREATE INDEX IX_DimTipoServicio_Categoria ON DimTipoServicio(Categoria);
CREATE INDEX IX_DimTipoServicio_Estado ON DimTipoServicio(Estado);

-- Tabla de Dimensión: Asesor
CREATE TABLE DimAsesor (
    ID_Asesor INT PRIMARY KEY,
    NumeroEmpleado VARCHAR(20) NOT NULL UNIQUE,
    NombreCompleto VARCHAR(100) NOT NULL,
    ID_Agencia INT NOT NULL,
    Puesto VARCHAR(50) NOT NULL,
    FechaIngreso DATE NOT NULL,
    AntiguedadMeses INT NOT NULL,
    NivelExperiencia VARCHAR(20) NOT NULL,
    Certificaciones VARCHAR(200),
    HorarioTrabajo VARCHAR(50),
    Estado VARCHAR(20) NOT NULL,
    FechaVigenciaDesde DATE NOT NULL,
    FechaVigenciaHasta DATE,
    EsRegistroActual BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_DimAsesor_NivelExperiencia CHECK (NivelExperiencia IN ('Junior', 'Semi-Senior', 'Senior')),
    CONSTRAINT CK_DimAsesor_Estado CHECK (Estado IN ('Activo', 'Inactivo', 'Licencia')),
    CONSTRAINT FK_DimAsesor_Agencia FOREIGN KEY (ID_Agencia) REFERENCES DimAgencia(ID_Agencia)
);

-- Índices para DimAsesor
CREATE INDEX IX_DimAsesor_Agencia ON DimAsesor(ID_Agencia);
CREATE INDEX IX_DimAsesor_Estado ON DimAsesor(Estado);
CREATE INDEX IX_DimAsesor_EsRegistroActual ON DimAsesor(EsRegistroActual);

-- =============================================
-- TABLAS DE HECHOS
-- =============================================

-- Tabla de Hechos: Interacciones Presenciales
CREATE TABLE FactInteraccionesPresenciales (
    ID_Interaccion INT PRIMARY KEY,
    ID_Fecha INT NOT NULL,
    ID_Agencia INT NOT NULL,
    ID_Cliente INT NOT NULL,
    ID_TipoServicio INT NOT NULL,
    ID_Asesor INT NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    DuracionMinutos DECIMAL(10,2) NOT NULL,
    EstadoInteraccion VARCHAR(20) NOT NULL,
    CalificacionServicio INT,
    TiempoCola DECIMAL(10,2) NOT NULL,
    NumeroTicket VARCHAR(20) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    UsuarioCreacion VARCHAR(50) NOT NULL DEFAULT 'sistema_auto',
    CONSTRAINT FK_FactInteracciones_Fecha FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha),
    CONSTRAINT FK_FactInteracciones_Agencia FOREIGN KEY (ID_Agencia) REFERENCES DimAgencia(ID_Agencia),
    CONSTRAINT FK_FactInteracciones_Cliente FOREIGN KEY (ID_Cliente) REFERENCES DimCliente(ID_Cliente),
    CONSTRAINT FK_FactInteracciones_TipoServicio FOREIGN KEY (ID_TipoServicio) REFERENCES DimTipoServicio(ID_TipoServicio),
    CONSTRAINT FK_FactInteracciones_Asesor FOREIGN KEY (ID_Asesor) REFERENCES DimAsesor(ID_Asesor),
    CONSTRAINT CK_FactInteracciones_Duracion CHECK (DuracionMinutos >= 0 AND DuracionMinutos <= 240),
    CONSTRAINT CK_FactInteracciones_TiempoCola CHECK (TiempoCola >= 0 AND TiempoCola <= 480),
    CONSTRAINT CK_FactInteracciones_Calificacion CHECK (CalificacionServicio IS NULL OR CalificacionServicio BETWEEN 1 AND 5),
    CONSTRAINT CK_FactInteracciones_Estado CHECK (EstadoInteraccion IN ('Completada', 'Cancelada', 'En Proceso'))
);

-- Índices para FactInteraccionesPresenciales
CREATE INDEX IX_FactInteracciones_Fecha ON FactInteraccionesPresenciales(ID_Fecha);
CREATE INDEX IX_FactInteracciones_Agencia ON FactInteraccionesPresenciales(ID_Agencia);
CREATE INDEX IX_FactInteracciones_Cliente ON FactInteraccionesPresenciales(ID_Cliente);
CREATE INDEX IX_FactInteracciones_TipoServicio ON FactInteraccionesPresenciales(ID_TipoServicio);
CREATE INDEX IX_FactInteracciones_Asesor ON FactInteraccionesPresenciales(ID_Asesor);
CREATE INDEX IX_FactInteracciones_Estado ON FactInteraccionesPresenciales(EstadoInteraccion);
CREATE INDEX IX_FactInteracciones_FechaCreacion ON FactInteraccionesPresenciales(FechaCreacion);

-- Tabla de Hechos: Cancelaciones
CREATE TABLE FactCancelaciones (
    ID_Cancelacion INT PRIMARY KEY,
    ID_Fecha INT NOT NULL,
    ID_Agencia INT NOT NULL,
    ID_Cliente INT,
    MotivoCancelacion VARCHAR(100) NOT NULL,
    TiempoEsperaAntesCancelacion DECIMAL(10,2) NOT NULL,
    HoraCancelacion TIME NOT NULL,
    NumeroTicket VARCHAR(20),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_FactCancelaciones_Fecha FOREIGN KEY (ID_Fecha) REFERENCES DimFecha(ID_Fecha),
    CONSTRAINT FK_FactCancelaciones_Agencia FOREIGN KEY (ID_Agencia) REFERENCES DimAgencia(ID_Agencia),
    CONSTRAINT FK_FactCancelaciones_Cliente FOREIGN KEY (ID_Cliente) REFERENCES DimCliente(ID_Cliente),
    CONSTRAINT CK_FactCancelaciones_TiempoEspera CHECK (TiempoEsperaAntesCancelacion >= 0 AND TiempoEsperaAntesCancelacion <= 480)
);

-- Índices para FactCancelaciones
CREATE INDEX IX_FactCancelaciones_Fecha ON FactCancelaciones(ID_Fecha);
CREATE INDEX IX_FactCancelaciones_Agencia ON FactCancelaciones(ID_Agencia);
CREATE INDEX IX_FactCancelaciones_Cliente ON FactCancelaciones(ID_Cliente);
CREATE INDEX IX_FactCancelaciones_FechaCreacion ON FactCancelaciones(FechaCreacion);

-- =============================================
-- VISTAS PARA REPORTERÍA
-- =============================================

-- Vista consolidada de todas las interacciones
CREATE VIEW vw_InteraccionesConsolidadas AS
SELECT 
    i.ID_Interaccion,
    f.Fecha,
    f.Anio,
    f.Mes,
    f.NombreMes,
    f.NombreDia,
    a.CodigoAgencia,
    a.NombreAgencia,
    a.Region,
    a.Zona,
    c.NumeroCliente,
    c.TipoCliente,
    c.Segmento,
    ts.NombreServicio,
    ts.Categoria AS CategoriaServicio,
    ase.NombreCompleto AS NombreAsesor,
    ase.NivelExperiencia,
    i.HoraInicio,
    i.HoraFin,
    i.DuracionMinutos,
    i.TiempoCola,
    i.EstadoInteraccion,
    i.CalificacionServicio,
    i.NumeroTicket
FROM FactInteraccionesPresenciales i
INNER JOIN DimFecha f ON i.ID_Fecha = f.ID_Fecha
INNER JOIN DimAgencia a ON i.ID_Agencia = a.ID_Agencia
INNER JOIN DimCliente c ON i.ID_Cliente = c.ID_Cliente
INNER JOIN DimTipoServicio ts ON i.ID_TipoServicio = ts.ID_TipoServicio
INNER JOIN DimAsesor ase ON i.ID_Asesor = ase.ID_Asesor
WHERE a.EsRegistroActual = 1 AND ase.EsRegistroActual = 1;

-- Vista de cancelaciones consolidadas
CREATE VIEW vw_CancelacionesConsolidadas AS
SELECT 
    can.ID_Cancelacion,
    f.Fecha,
    f.Anio,
    f.Mes,
    f.NombreMes,
    a.CodigoAgencia,
    a.NombreAgencia,
    a.Region,
    c.NumeroCliente,
    c.Segmento,
    can.MotivoCancelacion,
    can.TiempoEsperaAntesCancelacion,
    can.HoraCancelacion,
    can.NumeroTicket
FROM FactCancelaciones can
INNER JOIN DimFecha f ON can.ID_Fecha = f.ID_Fecha
INNER JOIN DimAgencia a ON can.ID_Agencia = a.ID_Agencia
LEFT JOIN DimCliente c ON can.ID_Cliente = c.ID_Cliente
WHERE a.EsRegistroActual = 1;

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS PARA ETL
-- =============================================

-- Procedimiento para popular DimFecha
CREATE PROCEDURE sp_PopularDimFecha
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Fecha DATE = @FechaInicio;
    
    WHILE @Fecha <= @FechaFin
    BEGIN
        INSERT INTO DimFecha (
            ID_Fecha, Fecha, Anio, Mes, NombreMes, Trimestre, Semestre,
            Semana, DiaSemana, NombreDia, EsFinDeSemana, EsFeriado, DiaDelAnio
        )
        VALUES (
            CAST(FORMAT(@Fecha, 'yyyyMMdd') AS INT),
            @Fecha,
            YEAR(@Fecha),
            MONTH(@Fecha),
            CASE MONTH(@Fecha)
                WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
                WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
                WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
                WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
            END,
            DATEPART(QUARTER, @Fecha),
            CASE WHEN MONTH(@Fecha) <= 6 THEN 1 ELSE 2 END,
            DATEPART(WEEK, @Fecha),
            DATEPART(WEEKDAY, @Fecha),
            CASE DATEPART(WEEKDAY, @Fecha)
                WHEN 1 THEN 'Domingo' WHEN 2 THEN 'Lunes' WHEN 3 THEN 'Martes'
                WHEN 4 THEN 'Miércoles' WHEN 5 THEN 'Jueves' WHEN 6 THEN 'Viernes'
                WHEN 7 THEN 'Sábado'
            END,
            CASE WHEN DATEPART(WEEKDAY, @Fecha) IN (1, 7) THEN 1 ELSE 0 END,
            0, -- EsFeriado se actualiza por separado
            DATEPART(DAYOFYEAR, @Fecha)
        );
        
        SET @Fecha = DATEADD(DAY, 1, @Fecha);
    END
END;
GO

-- =============================================
-- GRANTS DE SEGURIDAD
-- =============================================

-- Role para lectura de datos
CREATE ROLE rol_LecturaDashboard;
GRANT SELECT ON vw_InteraccionesConsolidadas TO rol_LecturaDashboard;
GRANT SELECT ON vw_CancelacionesConsolidadas TO rol_LecturaDashboard;

-- Role para carga ETL
CREATE ROLE rol_ETL_Dashboard;
GRANT SELECT, INSERT, UPDATE ON DimFecha TO rol_ETL_Dashboard;
GRANT SELECT, INSERT, UPDATE ON DimAgencia TO rol_ETL_Dashboard;
GRANT SELECT, INSERT, UPDATE ON DimCliente TO rol_ETL_Dashboard;
GRANT SELECT, INSERT, UPDATE ON DimTipoServicio TO rol_ETL_Dashboard;
GRANT SELECT, INSERT, UPDATE ON DimAsesor TO rol_ETL_Dashboard;
GRANT SELECT, INSERT ON FactInteraccionesPresenciales TO rol_ETL_Dashboard;
GRANT SELECT, INSERT ON FactCancelaciones TO rol_ETL_Dashboard;

-- =============================================
-- FIN DEL SCRIPT
-- =============================================
