# Reglas de Testing y Limpieza

## 📋 Resumen de Políticas

### 🧪 Regla 1: Tests Solo en `tests/`
- **TODOS los tests** deben estar en el directorio `tests/`
- **Estructura clara**: `test_[modulo].py` para cada módulo
- **No tests** en directorios `src/`, `docs/`, o raíz del proyecto

### 🧹 Regla 2: Eliminación de Artefactos  
- Al finalizar desarrollo, **ejecutar `make clean`**
- **Eliminar automáticamente**: cache, temporales, logs
- **No commitear** artefactos de desarrollo

### 📝 Regla 3: Consulta para Notas de Revisión
- Si se generan **notas `.md` para revisión**, **consultar antes de borrar**
- Documentación importante debe preservarse
- Solo eliminar después de aprobación

## 🧪 Estructura de Testing

### Organización de Tests
```
tests/
├── __init__.py                 # Configuración de tests
├── test_versioning.py         # Tests del sistema de versionado
├── test_utils.py              # Tests de utilidades (futuro)
└── fixtures/                  # Datos de prueba (si necesario)
    └── sample_data.json
```

### Convenciones de Naming
- **Archivos**: `test_[modulo].py`
- **Clases**: `Test[Funcionalidad]`
- **Métodos**: `test_[comportamiento_especifico]`

### Ejemplo de Test
```python
class TestVersionManager(unittest.TestCase):
    """Tests para la clase VersionManager."""
    
    def setUp(self):
        """Configurar entorno de prueba temporal."""
        self.test_dir = tempfile.mkdtemp()
        # ... configuración ...
    
    def tearDown(self):
        """Limpiar entorno de prueba."""
        shutil.rmtree(self.test_dir)
    
    def test_get_current_version(self):
        """Test de lectura de versión actual."""
        # ... implementación ...
```

## 🛠️ Herramientas de Testing

### Comando Make (Recomendado)
```bash
# Ejecutar todos los tests
make test

# Tests con output verbose
make test-v

# Tests con cobertura
make coverage

# Limpieza completa
make clean

# Verificación completa
make check
```

### Comando PowerShell (Windows)
```powershell
# Limpieza completa
.\Clean.ps1 -All

# Solo tests
.\Clean.ps1 -Test

# Dry run (ver qué se eliminaría)
.\Clean.ps1 -All -DryRun

# Solo temporales
.\Clean.ps1 -Temp
```

### Comando Python Directo
```bash
# Ejecutar tests específicos
python -m pytest tests/test_versioning.py -v

# Con cobertura
python -m pytest tests/ --cov=src --cov-report=html
```

## 🧹 Tipos de Limpieza

### Limpieza Estándar (`make clean`)
Elimina artefactos comunes de desarrollo:
- `__pycache__/` y `*.pyc`
- `.pytest_cache/`
- `htmlcov/` y `.coverage`
- `*.tmp`, `*.bak`, `*~`

### Limpieza Completa (`make clean-all`)
Incluye todo lo anterior más:
- Archivos de log (`*.log`)
- Contenido de `tmp/`
- Artefactos de Power BI (`*.pbix.backup`, `*.pbix.lock`)

### Limpieza Específica
```bash
make clean-test    # Solo artefactos de testing
make clean-logs    # Solo archivos de log
make clean-tmp     # Solo archivos temporales
```

## 📊 Configuración de Testing

### pytest.ini (pyproject.toml)
```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = ["-v", "--tb=short"]
markers = [
    "unit: tests unitarios",
    "integration: tests de integración",
    "version: tests de versionado"
]
```

### Cobertura de Código
```toml
[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*", "*/__init__.py"]

[tool.coverage.report]
exclude_lines = ["pragma: no cover", "if __name__ == .__main__.:"]
```

## 🔍 Validación de Tests

### Tests Requeridos
- ✅ **Versionado**: `test_versioning.py`
- ✅ **Parsing**: Validación de formatos de versión
- ✅ **Incrementos**: Tests de bump version
- ✅ **Archivos**: Lectura/escritura de VERSION
- ✅ **Errores**: Manejo de casos edge

### Cobertura Mínima
- **Target**: 80% de cobertura en `src/`
- **Crítico**: 100% en funciones de versionado
- **Reportes**: HTML en `htmlcov/`

## 🚀 Flujo de Trabajo

### Antes de Commit
```bash
# 1. Ejecutar tests
make test

# 2. Verificar cobertura
make coverage

# 3. Limpiar artefactos
make clean

# 4. Commit cambios
git add . && git commit -m "..."
```

### Antes de Release
```bash
# 1. Verificación completa
make check

# 2. Preparar para producción
make prepare-prod

# 3. Validar versión
python version_cli.py current

# 4. Generar archivo Power BI
python version_cli.py powerbi
```

## ⚠️ Reglas Importantes

### ❌ NO Hacer
- **No** commitear archivos `__pycache__/`
- **No** incluir `.coverage` o `htmlcov/` en git
- **No** dejar archivos temporales (`*.tmp`, `*.bak`)
- **No** borrar notas `.md` sin consultar

### ✅ SÍ Hacer
- **Ejecutar** `make clean` antes de commits
- **Mantener** tests en `tests/` únicamente
- **Consultar** antes de eliminar documentación
- **Validar** que tests pasan antes de merge

## 🔧 Troubleshooting

### Error: "Tests no encontrados"
```bash
# Verificar estructura
ls tests/test_*.py

# Ejecutar desde raíz del proyecto
cd /path/to/project && make test
```

### Error: "Módulo no encontrado"
```bash
# Verificar PYTHONPATH
export PYTHONPATH="${PYTHONPATH}:./src"

# O usar pytest con path
python -m pytest tests/ -v
```

### Limpieza No Funciona
```bash
# Verificar permisos
ls -la

# Forzar limpieza manual
find . -name "__pycache__" -exec rm -rf {} +
```