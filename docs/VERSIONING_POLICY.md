# Política de Versionado - Seguimiento Presencial Agencias

## 📋 Resumen de la Política

Este proyecto implementa **versionado semántico (SemVer) con "fuente única de verdad"**:

- **La versión SOLO vive en archivo `VERSION`** 
- **Todos los demás archivos y scripts LEEN de `VERSION`**
- **Nada hardcodeado** en UI, README, CHANGELOG o scripts

## 🔢 Esquema de Versionado Semántico

Formato: `MAJOR.MINOR.PATCH` (ej: `1.2.3`)

| Tipo | Cuándo Incrementar | Ejemplo | Descripción |
|------|-------------------|---------|-------------|
| **MAJOR** | Cambios incompatibles | `1.0.0` → `2.0.0` | Breaking changes, API incompatible |
| **MINOR** | Nueva función compatible | `1.0.0` → `1.1.0` | Nuevas características sin romper compatibilidad |
| **PATCH** | Corrección de errores | `1.0.0` → `1.0.1` | Bug fixes, correcciones menores |

## 🛠️ Herramientas Disponibles

### 1. CLI de Versionado (`version_cli.py`)

```bash
# Mostrar versión actual (lee desde VERSION)
python version_cli.py current

# Incrementar versión
python version_cli.py bump patch "Fix error en dashboard"
python version_cli.py bump minor "Nueva métrica FCR"
python version_cli.py bump major "Cambio estructura datos"

# Mostrar nombre archivo Power BI
python version_cli.py powerbi
```

### 2. Módulo de Versionado (`src/versioning.py`)

```python
from src.versioning import get_version, bump_version

# Obtener versión actual
current = get_version()  # "0.1.0"

# Incrementar versión programáticamente
new_version = bump_version("minor", "Nueva funcionalidad")
```

### 3. Actualizador de Referencias (`update_versions.py`)

```bash
# Sincronizar todas las referencias de versión
python update_versions.py
```

## 📁 Archivos que Leen de VERSION

| Archivo | Cómo Lee la Versión | Propósito |
|---------|-------------------|-----------|
| `README.md` | `update_versions.py` | Mostrar versión en documentación |
| `CHANGELOG.md` | Manual/Scripts | Documentar cambios por versión |
| Archivos `.pbix` | `get_powerbi_version_string()` | Nomenclatura Power BI |
| Scripts Python | `import versioning` | Lógica de aplicación |

## 🔄 Flujo de Trabajo

### Scenario 1: Bug Fix (PATCH)
```bash
# 1. Identificar el error
# 2. Corregir el código/dashboard
# 3. Incrementar versión patch
python version_cli.py bump patch "Fix cálculo promedio interacciones"
# 4. Actualizar referencias
python update_versions.py
# 5. Commit y push
git add .
git commit -m "fix: corrección cálculo promedio interacciones

- Corregido error en medida DAX
- Actualizada versión 0.1.0 → 0.1.1"
```

### Scenario 2: Nueva Funcionalidad (MINOR)
```bash
# 1. Desarrollar nueva característica
# 2. Incrementar versión minor
python version_cli.py bump minor "Agregada página FCR agencias"
# 3. Actualizar referencias
python update_versions.py
# 4. Commit
git commit -m "feat: nueva página FCR agencias

- Agregada página de seguimiento FCR
- Nuevas métricas y visualizaciones
- Actualizada versión 0.1.1 → 0.2.0"
```

### Scenario 3: Cambio Mayor (MAJOR)
```bash
# 1. Cambio que rompe compatibilidad
# 2. Incrementar versión major
python version_cli.py bump major "Migración nueva estructura datos"
# 3. Actualizar referencias
python update_versions.py
# 4. Commit
git commit -m "feat!: migración nueva estructura datos

BREAKING CHANGE: Cambio en esquema de datos externos
- Nueva organización carpetas DATOS_EXTERNOS
- Incompatible con versiones anteriores
- Actualizada versión 0.2.0 → 1.0.0"
```

## ✅ Validaciones y Consistencia

### Verificar Consistencia
```bash
python version_cli.py validate
```

### Reglas de Oro
1. **NUNCA hardcodear versiones** en archivos
2. **Siempre leer de `VERSION`** como fuente única
3. **Actualizar referencias** después de cambiar versión
4. **Documentar razón** del cambio de versión
5. **Seguir convenciones** de commit semántico

## 🎯 Nomenclatura Power BI

El sistema genera automáticamente nombres de archivos Power BI:

```
SEGUIMIENTO_PRESENCIAL_AGENCIAS_V{version}.pbix
```

Ejemplos:
- `SEGUIMIENTO_PRESENCIAL_AGENCIAS_V0.1.0.pbix`
- `SEGUIMIENTO_PRESENCIAL_AGENCIAS_V1.2.3.pbix`

## 🔍 Troubleshooting

### Error: "Formato de versión inválido"
- Verificar que `VERSION` contiene solo `MAJOR.MINOR.PATCH`
- Sin espacios ni caracteres extra

### Error: "Archivo VERSION no encontrado"
- Ejecutar desde la raíz del proyecto
- Verificar que existe archivo `VERSION`

### Versiones desincronizadas
```bash
# Re-sincronizar todas las referencias
python update_versions.py
```