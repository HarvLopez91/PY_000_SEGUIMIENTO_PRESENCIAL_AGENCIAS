# Dashboard BI - Seguimiento Presencial Agencias

## Descripción

Dashboard de Business Intelligence desarrollado en Power BI para el seguimiento y análisis de interacciones presenciales en agencias de **La Ascensión S.A.** Forma parte del Centro de Gestión del Cliente y proporciona métricas clave sobre atención presencial, cancelaciones y rendimiento de agencias.

## Características Principales

### KPIs Monitoreados
- **Total de Interacciones**: Volumen de atención presencial
- **Tasa de Completación**: Porcentaje de interacciones finalizadas exitosamente
- **Satisfacción Promedio**: Calificación promedio otorgada por clientes (escala 1-5)
- **Tasa de Cancelación**: Porcentaje de clientes que abandonan sin atención
- **Tiempos de Atención**: Duración promedio de servicio
- **Tiempos en Cola**: Tiempo de espera promedio

### Análisis Disponibles
1. **Vista General**: Resumen ejecutivo con KPIs principales
2. **Análisis de Atención**: Tiempos, capacidad utilizada y distribución horaria
3. **Análisis de Cancelaciones**: Motivos, patrones y tendencias
4. **Rendimiento de Agencias**: Comparativo entre agencias y rankings
5. **Análisis de Asesores**: Productividad y rendimiento individual
6. **Análisis Temporal**: Tendencias, estacionalidad y proyecciones

## Estructura del Proyecto

```
PY_000_SEGUIMIENTO_PRESENCIAL_AGENCIAS/
│
├── docs/                           # Documentación
│   ├── TECHNICAL_DOCUMENTATION.md  # Documentación técnica completa
│   ├── USER_GUIDE.md               # Guía de usuario
│   ├── DATA_DICTIONARY.md          # Diccionario de datos
│   └── DEPLOYMENT_GUIDE.md         # Guía de despliegue
│
├── data/                           # Esquemas y datos
│   └── schema.sql                  # Script de creación de BD
│
├── scripts/                        # Scripts ETL
│   └── etl_dashboard.py            # Script principal de ETL
│
├── powerbi/                        # Configuración Power BI
│   └── config.py                   # Configuraciones del dashboard
│
├── dax/                            # Medidas DAX
│   └── measures.dax                # Biblioteca de medidas
│
├── visualizations/                 # Especificaciones
│   └── VISUALIZATION_SPECS.md      # Specs de visualizaciones
│
├── requirements.txt                # Dependencias Python
└── README.md                       # Este archivo
```

## Requisitos Técnicos

### Software Necesario
- **Power BI Desktop**: Versión 2023.10 o superior
- **Power BI Service**: Licencia Pro o Premium
- **SQL Server**: 2019 o superior
- **Python**: 3.8+ (para scripts ETL)

### Dependencias Python
```bash
pip install -r requirements.txt
```

## Instalación Rápida

### 1. Configurar Base de Datos
```bash
# Ejecutar script de creación de esquema
sqlcmd -S [servidor] -d [base_datos] -i data/schema.sql
```

### 2. Configurar ETL
```bash
# Instalar dependencias
pip install -r requirements.txt

# Ejecutar ETL inicial
python scripts/etl_dashboard.py
```

### 3. Configurar Power BI
1. Abrir Power BI Desktop
2. Conectar a la base de datos dimensional
3. Importar medidas DAX desde `dax/measures.dax`
4. Configurar visualizaciones según `visualizations/VISUALIZATION_SPECS.md`
5. Configurar Row-Level Security (RLS)
6. Publicar en Power BI Service

## Documentación

### Para Usuarios
- **[Guía de Usuario](docs/USER_GUIDE.md)**: Manual completo de uso del dashboard
- **[Diccionario de Datos](docs/DATA_DICTIONARY.md)**: Descripción de todas las tablas y campos

### Para Desarrolladores
- **[Documentación Técnica](docs/TECHNICAL_DOCUMENTATION.md)**: Arquitectura y modelo de datos
- **[Guía de Despliegue](docs/DEPLOYMENT_GUIDE.md)**: Instrucciones de instalación y configuración
- **[Especificaciones de Visualizaciones](visualizations/VISUALIZATION_SPECS.md)**: Detalle de cada visualización

## Modelo de Datos

### Tablas de Hechos
- **FactInteraccionesPresenciales**: Registro de todas las interacciones
- **FactCancelaciones**: Registro de abandonos sin atención

### Dimensiones
- **DimFecha**: Calendario con 10 años de datos
- **DimAgencia**: Información de agencias físicas
- **DimCliente**: Datos de clientes
- **DimTipoServicio**: Catálogo de servicios
- **DimAsesor**: Información de asesores

## Actualización de Datos

### Frecuencia
- **Datos transaccionales**: Cada 30 minutos
- **Dimensiones**: Actualización diaria (2:00 AM)
- **Histórico**: Carga mensual completa

### ETL Programado
El proceso ETL se ejecuta automáticamente mediante un cron job configurado en el servidor.

## Seguridad

### Row-Level Security (RLS)
El dashboard implementa seguridad a nivel de fila con los siguientes roles:
- **Administrador**: Acceso completo sin restricciones
- **Gerente Regional**: Acceso limitado a su región
- **Gerente de Agencia**: Acceso solo a su agencia
- **Analista**: Acceso completo de solo lectura

### Autenticación
- Integración con Azure Active Directory
- Multi-Factor Authentication (MFA) requerido
- Auditoría de accesos habilitada

## Soporte

### Contacto
- **Email**: soporte.bi@laascension.com
- **Teléfono**: +XXX-XXX-XXXX ext. 1234
- **Horario**: Lunes a Viernes, 8:00 AM - 6:00 PM

### Recursos Adicionales
- Portal de Capacitación: https://training.laascension.com/bi
- Video Tutoriales: https://videos.laascension.com/dashboard-presencial
- Comunidad de Usuarios: Microsoft Teams - Canal "BI Dashboard Support"

## Versión

**Versión Actual**: 1.0.0  
**Fecha de Lanzamiento**: 2023-10-30  
**Última Actualización**: 2023-10-30

## Licencia

© 2023 La Ascensión S.A. Todos los derechos reservados.  
Este proyecto es de uso interno exclusivo de La Ascensión S.A.

## Changelog

### v1.0.0 (2023-10-30)
- ✨ Lanzamiento inicial del dashboard
- 📊 6 páginas de análisis implementadas
- 🔐 Row-Level Security configurado
- 📈 50+ medidas DAX creadas
- 📚 Documentación completa
- 🔄 Proceso ETL automatizado
- 🎨 Diseño responsive implementado

## Autores

**Centro de Gestión del Cliente**  
**Equipo de Business Intelligence**  
La Ascensión S.A.

---

Para más información, consulte la [documentación técnica completa](docs/TECHNICAL_DOCUMENTATION.md).
