# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/),
y este proyecto adhiere al [Versionado Semántico](https://semver.org/lang/es/).

## 📋 Política de Versionado (SemVer + "fuente única")

- **La versión SOLO vive en archivo `VERSION`** - fuente única de verdad
- **UI, README, CHANGELOG y scripts leen de `VERSION`** - nada hardcodeado
- **Incrementos de versión**:
  - `PATCH` (0.1.0 → 0.1.1): Corrección de bugs/errores
  - `MINOR` (0.1.1 → 0.2.0): Nueva funcionalidad compatible
  - `MAJOR` (0.2.0 → 1.0.0): Cambio incompatible/breaking

## [Sin Publicar]

### PASO 10 - ORDEN Y NO-DUPLICACIÓN [2025-10-30]
#### Agregado
- **file_checker.py**: Herramienta para verificar duplicación antes de crear archivos
- **PROJECT_ORGANIZATION.md**: Documentación completa de política de orden
- **Comandos Make**: check-duplicates, check-organization, clean-duplicates, lint-organization
- **Reglas .gitignore**: Exclusión de archivos pesados y patrones de duplicación

#### Modificado
- **Makefile**: Agregados comandos para gestión de organización
- **.gitignore**: Patrones mejorados para prevenir archivos pesados y duplicados

#### Reglas Implementadas
- ✅ Verificación obligatoria antes de crear archivos
- ✅ Documentación concentrada en `docs/` (prohibido .md sueltos)
- ✅ Exclusión automática de archivos pesados
- ✅ Herramientas de detección de duplicados

### PASO 9 - REGLAS DE TESTING Y LIMPIEZA [2025-10-30]
#### Agregado
- Sistema completo de testing y limpieza
- Reglas estrictas: tests solo en `tests/`, limpieza con `make clean`
- Suite de tests para versionado con 9 tests automatizados
- Script PowerShell `Clean.ps1` para limpieza en Windows
- Makefile con comandos: test, coverage, clean, lint
- Configuración pytest en `pyproject.toml`
- Documentación completa en `docs/TESTING_RULES.md`

### Mejorado  
- Política de consulta antes de eliminar notas `.md` de revisión
- Validación automática de consistencia de versiones
- Herramientas multiplataforma (Make + PowerShell)

## [0.1.0] - 2025-10-30

### Agregado
- Estructura inicial del proyecto
- Configuración base de archivos Python
- Sistema de versionado semántico
- Documentación base del proyecto

### Notas
- Inicio del proyecto con migración a estructura GitOps
- Implementación de políticas de versionado semántico