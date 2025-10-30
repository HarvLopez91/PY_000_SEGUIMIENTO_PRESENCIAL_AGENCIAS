# Seguimiento Presencial Agencias

## 📋 Descripción del Proyecto

Dashboard de Business Intelligence desarrollado en Power BI para el seguimiento y análisis de interacciones presenciales en agencias de La Ascensión S.A. Forma parte del Centro de Gestión del Cliente y proporciona métricas clave sobre atención presencial, cancelaciones y rendimiento de agencias.

## 🎯 Objetivos

- **Objetivo Principal**: Monitorear y analizar las interacciones presenciales en tiempo real
- **Objetivos Específicos**:
  - Rastrear métricas de atención presencial por agencia
  - Analizar patrones de cancelaciones y sus tipificaciones
  - Medir el rendimiento mediante "Promedio de Interacciones por Día"
  - Consolidar datos mensuales para seguimiento ejecutivo

## 🛠️ Stack Tecnológico

- **Herramienta Principal**: Microsoft Power BI Desktop
- **Fuentes de Datos**: Microsoft Excel (.xlsx)
- **Visualizaciones**: ZoomCharts (licenciado)
- **Versionado**: Semántico (V[mayor].[menor].[corrección])
- **Control de Versiones**: Git
- **Zona Horaria**: UTC-5 (Colombia)

## 📂 Estructura del Proyecto

```
PBI_000_SEGUIMIENTO_PRESENCIAL_AGENCIAS/
├── SEGUIMIENTO_PRESENCIAL_AGENCIAS_V[versión].pbix  # Dashboard principal
├── DATOS_EXTERNOS/                                   # Fuentes de datos
│   ├── [año]/[mes]/Sem_[num]_[fechas]/[día]/        # Estructura temporal
│   └── [archivos_históricos].xlsx                   # Datos base
├── DOCUMENTACION/                                    # Documentación del proyecto
│   └── changelog_SEGUIMIENTO_PRESENCIAL_AGENCIAS.txt
├── VERSIONES_ANTERIORES/                            # Historial de versiones
└── .github/                                         # Configuración Git
    └── copilot-instructions.md
```

## 🚀 Configuración del Repositorio

### Información del Repositorio
- **Nombre**: `pbi-seguimiento-presencial-agencias`
- **Rama Principal**: `main`
- **Licencia**: Propietaria (La Ascensión S.A.)

### Estrategia de Branching

#### Ramas Principales
- `main`: Rama principal con versiones estables del dashboard

#### Ramas de Trabajo
- `feat/*`: Nuevas funcionalidades (ej: `feat/consolidado-mes-actual`)
- `fix/*`: Corrección de errores (ej: `fix/timezone-utc5`)
- `chore/*`: Tareas de mantenimiento (ej: `chore/update-zoomcharts-license`)

### Convención de Commits (Conventional Commits)

```
<tipo>[ámbito opcional]: <descripción>

[cuerpo opcional]

[pie(s) opcional(es)]
```

#### Tipos de Commit
- `feat`: Nueva funcionalidad
- `fix`: Corrección de errores
- `docs`: Cambios en documentación
- `style`: Cambios de formato/estilo visual
- `refactor`: Refactorización de código/consultas DAX
- `perf`: Mejoras de rendimiento
- `test`: Añadir o corregir tests
- `chore`: Tareas de mantenimiento

#### Ejemplos de Commits
```bash
feat(metrics): add "Promedio de Interacciones por Día" measure
fix(timezone): correct Last_Update_Time to UTC-5
docs(changelog): update version 1.2.1 release notes
chore(license): renew ZoomCharts license registration
refactor(data): optimize Last_Update_Time table creation
```

## 📊 Métricas y KPIs Principales

- **Promedio de Interacciones por Día**: Medida principal de performance
- **Consolidado Mes en Curso**: Seguimiento mensual ejecutivo
- **Tipificaciones de Cancelaciones**: Análisis por categorías
- **Last_Update_Time**: Marca de tiempo de actualización (UTC-5)

## 🔄 Flujo de Desarrollo

### 1. Crear Nueva Rama
```bash
git checkout main
git pull origin main
git checkout -b feat/nueva-funcionalidad
```

### 2. Realizar Cambios
- Actualizar el archivo .pbix
- Documentar cambios en el changelog
- Seguir convenciones de versionado

### 3. Commit y Push
```bash
git add .
git commit -m "feat(dashboard): add new cancellation analysis page"
git push origin feat/nueva-funcionalidad
```

### 4. Crear Pull Request
- Revisar cambios con el equipo
- Validar métricas y rendimiento
- Merge a `main` tras aprobación

### 5. Actualizar Versión
- Mover versión anterior a `VERSIONES_ANTERIORES/`
- Actualizar nombre del archivo principal
- Documentar en changelog

## 📝 Gestión de Versiones

Seguimos versionado semántico:
- **Mayor (V2.0.0)**: Cambios que rompen compatibilidad
- **Menor (V1.1.0)**: Nuevas funcionalidades compatibles
- **Corrección (V1.1.1)**: Fixes y optimizaciones

## 🔍 Compromisos Pendientes

- [ ] Retenciones de las agencias
- [ ] FCR (First Call Resolution) agencias
- [ ] Mapeo descargas de Certificados vs Portal Clientes

## 📞 Contacto

**Equipo**: Centro de Gestión del Cliente - La Ascensión S.A.  
**Área**: Business Intelligence (BI)

---

*Última actualización: Octubre 2025*
