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

### Agregado
- Lectura simplificada de versión desde código Python
- Patrón recomendado: `VERSION = Path("VERSION").read_text().strip()`
- Demo completo en `src/example_usage.py` con 4 métodos de lectura
- Script `simple_version_demo.py` con ejemplos prácticos
- Constante VERSION exportada desde `src/versioning.py`
- Documentación actualizada con patrones de lectura

### Mejorado
- Módulo `src/versioning.py` ahora exporta constante VERSION
- Documentación en `docs/VERSIONING_POLICY.md` incluye patrón simple
- Ejemplos de uso más prácticos y realistas

## [0.1.0] - 2025-10-30

### Agregado
- Estructura inicial del proyecto
- Configuración base de archivos Python
- Sistema de versionado semántico
- Documentación base del proyecto

### Notas
- Inicio del proyecto con migración a estructura GitOps
- Implementación de políticas de versionado semántico