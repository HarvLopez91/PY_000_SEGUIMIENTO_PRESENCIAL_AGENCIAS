# Guía de Inicio Rápido
## Dashboard Seguimiento Presencial Agencias - La Ascensión S.A.

### 🎯 Propósito del Proyecto

Este repositorio contiene la **estructura completa** de un Dashboard de Business Intelligence desarrollado en Power BI para el seguimiento y análisis de interacciones presenciales en agencias de La Ascensión S.A.

### 📦 Contenido del Repositorio

El proyecto incluye:

1. **Documentación Completa**
   - Guía de Usuario
   - Documentación Técnica
   - Diccionario de Datos
   - Guía de Despliegue

2. **Modelo de Datos**
   - Script SQL de creación de esquema
   - Definición de tablas de hechos y dimensiones
   - Vistas y procedimientos almacenados

3. **Medidas DAX**
   - 50+ medidas calculadas
   - KPIs principales
   - Métricas de rendimiento
   - Indicadores visuales

4. **Scripts ETL**
   - Script Python de extracción, transformación y carga
   - Validación de calidad de datos
   - Logging y manejo de errores

5. **Configuración**
   - Configuración de Power BI
   - Parámetros del dashboard
   - Paleta de colores corporativa

6. **Especificaciones de Visualizaciones**
   - Detalle de cada página del dashboard
   - Configuración de cada visual
   - Interactividad y navegación

### 🚀 Inicio Rápido

#### Paso 1: Revisar Documentación
Comience leyendo:
1. [README.md](README.md) - Visión general del proyecto
2. [docs/TECHNICAL_DOCUMENTATION.md](docs/TECHNICAL_DOCUMENTATION.md) - Arquitectura y modelo de datos

#### Paso 2: Preparar Ambiente
```bash
# Clonar repositorio
git clone https://github.com/HarvLopez91/PY_000_SEGUIMIENTO_PRESENCIAL_AGENCIAS.git
cd PY_000_SEGUIMIENTO_PRESENCIAL_AGENCIAS

# Instalar dependencias Python
pip install -r requirements.txt
```

#### Paso 3: Configurar Base de Datos
```bash
# Ejecutar script de creación de esquema
sqlcmd -S [servidor] -d [base_datos] -i data/schema.sql
```

#### Paso 4: Configurar Power BI Desktop
1. Abrir Power BI Desktop
2. Conectar a la base de datos
3. Importar medidas DAX desde `dax/measures.dax`
4. Seguir especificaciones en `visualizations/VISUALIZATION_SPECS.md`

#### Paso 5: Desplegar
Siga las instrucciones completas en [docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md)

### 📚 Estructura de Archivos

```
PY_000_SEGUIMIENTO_PRESENCIAL_AGENCIAS/
│
├── README.md                       # Visión general del proyecto
├── QUICK_START.md                  # Guía de inicio rápido (este archivo)
├── .gitignore                      # Archivos a ignorar en Git
├── requirements.txt                # Dependencias Python
│
├── docs/                           # 📖 Documentación
│   ├── TECHNICAL_DOCUMENTATION.md  # Arquitectura y modelo de datos
│   ├── USER_GUIDE.md               # Manual de usuario del dashboard
│   ├── DATA_DICTIONARY.md          # Diccionario completo de datos
│   └── DEPLOYMENT_GUIDE.md         # Guía paso a paso de despliegue
│
├── data/                           # 💾 Datos y Esquemas
│   └── schema.sql                  # Script de creación de BD (339 líneas)
│
├── scripts/                        # 🔧 Scripts ETL
│   └── etl_dashboard.py            # ETL principal en Python (469 líneas)
│
├── dax/                            # 📊 Medidas DAX
│   └── measures.dax                # Biblioteca de medidas (487 líneas)
│
├── powerbi/                        # ⚙️ Configuración Power BI
│   └── config.py                   # Configuraciones del dashboard (337 líneas)
│
└── visualizations/                 # 🎨 Visualizaciones
    └── VISUALIZATION_SPECS.md      # Especificaciones detalladas (683 líneas)
```

### 🎯 KPIs Principales del Dashboard

| KPI | Descripción | Meta |
|-----|-------------|------|
| Total Interacciones | Volumen de atención presencial | - |
| Tasa de Completación | % de interacciones finalizadas | ≥ 95% |
| Satisfacción Promedio | Calificación promedio de clientes | ≥ 4.0 |
| Tasa de Cancelación | % de abandonos sin atención | ≤ 10% |
| Tiempo Promedio Atención | Duración promedio de servicio | ≤ 20 min |
| Tiempo Promedio en Cola | Espera promedio del cliente | ≤ 15 min |

### 📊 Páginas del Dashboard

1. **Vista General**: Resumen ejecutivo con KPIs principales
2. **Análisis de Atención**: Tiempos, capacidad y distribución horaria
3. **Análisis de Cancelaciones**: Motivos, patrones y tendencias
4. **Rendimiento de Agencias**: Comparativo y rankings
5. **Análisis de Asesores**: Productividad individual
6. **Análisis Temporal**: Tendencias y proyecciones

### 🔐 Seguridad

El dashboard implementa **Row-Level Security (RLS)** con 4 roles:

- **Administrador**: Acceso completo sin restricciones
- **Gerente Regional**: Datos de su región
- **Gerente de Agencia**: Datos de su agencia
- **Analista**: Acceso completo de solo lectura

### 🔄 Actualización de Datos

- **Frecuencia**: Cada 30 minutos
- **Método**: Script Python ETL automatizado
- **Modo**: Incremental con validación de calidad

### 📖 Documentación Completa

#### Para Usuarios del Dashboard
- **[Guía de Usuario](docs/USER_GUIDE.md)** (274 líneas)
  - Cómo acceder al dashboard
  - Descripción de cada página
  - Uso de filtros y segmentadores
  - Exportación de datos
  - Suscripciones y alertas

#### Para Personal Técnico
- **[Documentación Técnica](docs/TECHNICAL_DOCUMENTATION.md)** (228 líneas)
  - Arquitectura del sistema
  - Modelo de datos detallado
  - Medidas DAX principales
  - Requisitos técnicos
  - Proceso de actualización

- **[Diccionario de Datos](docs/DATA_DICTIONARY.md)** (303 líneas)
  - Descripción de todas las tablas
  - Definición de cada campo
  - Relaciones y jerarquías
  - Reglas de calidad de datos
  - Glosario de términos

- **[Guía de Despliegue](docs/DEPLOYMENT_GUIDE.md)** (827 líneas)
  - Requisitos previos
  - Instalación paso a paso
  - Configuración de BD
  - Configuración de Power BI
  - Despliegue en Power BI Service
  - Troubleshooting

#### Para Desarrolladores
- **[Especificaciones de Visualizaciones](visualizations/VISUALIZATION_SPECS.md)** (683 líneas)
  - Detalle de cada visualización
  - Configuración de gráficos
  - Interactividad y navegación
  - Temas y estilos
  - Diseño responsive

### 🛠️ Componentes Técnicos

#### Base de Datos (data/schema.sql)
- 5 Tablas de Dimensiones
- 2 Tablas de Hechos
- Vistas consolidadas
- Procedimientos almacenados
- Índices optimizados

#### Medidas DAX (dax/measures.dax)
- Medidas base (conteo, totales)
- Tasas y porcentajes
- Tiempos y duraciones
- Satisfacción y calidad
- Productividad
- Comparativas temporales
- Rankings y tendencias
- Indicadores visuales

#### Script ETL (scripts/etl_dashboard.py)
- Conexión a fuentes de datos
- Extracción incremental
- Transformación y validación
- Carga optimizada en lotes
- Actualización de dimensiones SCD
- Validación de calidad de datos
- Logging completo

#### Configuración (powerbi/config.py)
- Información del dashboard
- Fuentes de datos
- Configuración de actualización
- Páginas del dashboard
- Seguridad y RLS
- KPIs y métricas
- Paleta de colores
- Alertas y notificaciones

### 💡 Casos de Uso Principales

1. **Gerencia Ejecutiva**
   - Monitorear KPIs en tiempo real
   - Identificar tendencias y patrones
   - Tomar decisiones estratégicas

2. **Gerencia Regional/Agencia**
   - Evaluar rendimiento de su unidad
   - Comparar contra otras agencias
   - Identificar áreas de mejora

3. **Analistas de BI**
   - Análisis profundo de datos
   - Generación de reportes
   - Identificación de insights

4. **Recursos Humanos**
   - Evaluar rendimiento de asesores
   - Identificar necesidades de capacitación
   - Planificación de recursos

### 🆘 Soporte

**Email**: soporte.bi@laascension.com  
**Teléfono**: +XXX-XXX-XXXX ext. 1234  
**Horario**: Lunes a Viernes, 8:00 AM - 6:00 PM

### 📝 Notas Importantes

⚠️ **Este es un proyecto de estructura y documentación**
- Los datos de ejemplo no están incluidos
- Se requiere configurar las fuentes de datos reales
- Las credenciales deben configurarse según su ambiente
- Ajustar configuraciones según necesidades específicas

✅ **Listo para Uso**
- Toda la documentación está completa
- Scripts están listos para personalizar
- Modelo de datos está definido
- Especificaciones de visualizaciones detalladas

### 🎓 Próximos Pasos Recomendados

1. ✅ Revisar documentación completa
2. ✅ Configurar ambiente de desarrollo
3. ✅ Cargar datos de prueba
4. ✅ Crear archivo .pbix siguiendo especificaciones
5. ✅ Configurar seguridad RLS
6. ✅ Realizar pruebas de usuario
7. ✅ Desplegar a producción
8. ✅ Capacitar usuarios finales

### 📊 Estadísticas del Proyecto

- **Total de líneas de código/documentación**: 4,420+
- **Archivos de documentación**: 5 (incluyendo Quick Start)
- **Medidas DAX**: 50+
- **Páginas del dashboard**: 6
- **Tablas del modelo**: 7
- **Visualizaciones definidas**: 30+

---

**¿Necesita ayuda?** Consulte la documentación detallada o contacte al equipo de soporte.

**Versión**: 1.0.0  
**Fecha**: 2023-10-30  
**Autor**: Centro de Gestión del Cliente - Equipo BI - La Ascensión S.A.
