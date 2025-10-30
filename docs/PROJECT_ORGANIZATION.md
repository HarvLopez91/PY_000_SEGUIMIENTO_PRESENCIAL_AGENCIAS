# Política de Orden y No-Duplicación

## Objetivo
Mantener el proyecto organizado, evitar archivos duplicados y garantizar que cada archivo tenga un propósito único y claro.

## 🔍 Reglas de Verificación ANTES de Crear Archivos

### 1. **Verificación Obligatoria**
```bash
# SIEMPRE ejecutar antes de crear cualquier archivo
python src/utils/file_checker.py "nuevo_archivo.py" "propósito del archivo"
```

### 2. **Búsqueda de Archivos Existentes**
- **Verificar nombres similares**: El sistema detecta variaciones como `backup`, `copy`, `temp`, `old`, `v1`, etc.
- **Revisar propósito similar**: ¿Ya existe un archivo que cumpla la misma función?
- **Consultar equipo**: Si no estás seguro, preguntar antes de crear

## 📁 Organización de Documentación

### **Regla Principal: TODO en `docs/`**
```
docs/
├── VERSIONING_POLICY.md      # Política de versionado
├── TESTING_RULES.md          # Reglas de testing
├── PROJECT_ORGANIZATION.md   # Esta documentación
├── api/                      # Documentación de APIs
├── guides/                   # Guías de usuario
└── examples/                 # Ejemplos de uso
```

### **PROHIBIDO: `.md` fuera de `docs/`**
- ❌ `README_extra.md` en raíz
- ❌ `manual.md` en `src/`
- ❌ `notes.md` en cualquier lugar
- ✅ `docs/guides/manual.md`
- ✅ `docs/examples/usage.md`

**Excepciones permitidas:**
- `README.md` (raíz del proyecto)
- `CHANGELOG.md` (raíz del proyecto)
- `LICENSE.md` (raíz del proyecto)

## 🚫 Prevención de Archivos Pesados

### **Archivos Excluidos Automáticamente**
```gitignore
# Archivos grandes Power BI
*.pbix.large
*.pdf
*.xlsx
*.csv

# Excepto datos de prueba pequeños
!tests/data/*.csv
!tests/data/*.xlsx
```

### **Límites de Tamaño**
- **Archivos de código**: < 5 MB
- **Documentación**: < 1 MB  
- **Datos de prueba**: < 100 KB cada uno
- **Assets**: < 2 MB

### **Alternativas para Archivos Grandes**
1. **Almacenamiento externo**: OneDrive, SharePoint
2. **Git LFS**: Para archivos binarios grandes
3. **Compresión**: Usar .zip para múltiples archivos
4. **Referencias**: Links a ubicaciones externas

## 🔧 Herramientas de Verificación

### **file_checker.py**
```bash
# Verificar antes de crear
python src/utils/file_checker.py "nuevo_script.py" "automatizar reportes"

# Salida ejemplo:
🔍 Verificando: nuevo_script.py
📋 Propósito: automatizar reportes
==========================================
⚠️  ADVERTENCIAS:
   ⚠️  Archivos similares encontrados: ['src/utils/report_generator.py']
💡 SUGERENCIAS:
   💡 Considera extender/modificar: src/utils/report_generator.py
   💡 Si es diferente, usa nombres más específicos
📁 Ubicación recomendada: src/utils/nuevo_script.py
✅ ¿Crear archivo? NO (revisar duplicados)
```

### **Comandos Make Integrados**
```bash
make check-duplicates     # Buscar archivos duplicados
make clean-duplicates     # Limpiar archivos temporales duplicados
make lint-organization    # Verificar organización del proyecto
```

## 📋 Estructura Recomendada

### **Ubicaciones por Tipo de Archivo**

| Tipo | Ubicación | Ejemplo |
|------|-----------|---------|
| **Documentación** | `docs/` | `docs/api/endpoints.md` |
| **Tests** | `tests/` | `tests/test_versioning.py` |
| **CLI Scripts** | `src/cli/` | `src/cli/version_cli.py` |
| **Utilidades** | `src/utils/` | `src/utils/file_checker.py` |
| **Ejemplos** | `src/examples/` | `src/examples/simple_demo.py` |
| **Core Logic** | `src/` | `src/versioning.py` |
| **Config** | Raíz | `pyproject.toml`, `Makefile` |

### **Nomenclatura Consistente**
```bash
# ✅ CORRECTO
src/utils/data_processor.py
src/utils/report_generator.py
tests/test_data_processor.py
docs/guides/data_processing.md

# ❌ INCORRECTO  
data_proc.py
reportGen.py
test_data_proc_v2.py
DataProcessingNotes.md
```

## 🔄 Workflow de Creación

### **Proceso Obligatorio**
1. **Planificar**: ¿Qué archivo necesito y por qué?
2. **Verificar**: `python src/utils/file_checker.py archivo.py "propósito"`
3. **Evaluar**: ¿Puedo reutilizar/extender archivo existente?
4. **Ubicar**: ¿Dónde va según la estructura?
5. **Crear**: Solo si no hay duplicación
6. **Documentar**: Actualizar documentación relevante

### **Preguntas de Verificación**
- [ ] ¿Ya existe un archivo que cumpla esta función?
- [ ] ¿Estoy ubicando el archivo en el directorio correcto?
- [ ] ¿El nombre es descriptivo y no ambiguo?
- [ ] ¿El archivo es menor al límite de tamaño?
- [ ] ¿He documentado el propósito en el header del archivo?

## 🚨 Casos de Consulta Obligatoria

### **SIEMPRE Consultar Antes de Borrar**
- Archivos `.md` (pueden contener info importante)
- Archivos de configuración (`.json`, `.toml`, `.yaml`)
- Scripts de más de 50 líneas
- Cualquier archivo con datos o logs

### **Política de Respaldo**
```bash
# Antes de borrar archivos importantes
mkdir -p tmp/backup_$(date +%Y%m%d)
cp archivo_importante.py tmp/backup_$(date +%Y%m%d)/
```

## 📊 Métricas de Orden

### **Indicadores de Buena Organización**
- [ ] 0 archivos `.md` fuera de `docs/`
- [ ] 0 archivos duplicados detectados
- [ ] 0 archivos > límite de tamaño
- [ ] 100% archivos en ubicación correcta
- [ ] < 10 archivos en raíz del proyecto

### **Comandos de Verificación**
```bash
# Verificar estado general
make check-organization

# Generar reporte de orden
python src/utils/file_checker.py --report

# Limpiar duplicados temporales
make clean-duplicates
```

---

## ⚡ Automatización

### **Hooks de Git (Opcional)**
```bash
# pre-commit hook - verificar antes de commit
#!/bin/bash
python src/utils/file_checker.py --validate-all
```

### **CI/CD Checks**
- Verificar tamaño de archivos
- Detectar duplicados
- Validar estructura de directorios
- Confirmar documentación actualizada

Esta política garantiza un proyecto limpio, organizado y sin duplicaciones innecesarias.