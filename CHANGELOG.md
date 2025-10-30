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
- Sistema de versionado semántico con fuente única
- CLI para gestión de versiones
- Módulo `src/versioning.py` para manejo automatizado de versiones

## [0.1.0] - 2025-10-30

### Agregado
- Estructura inicial del proyecto
- Configuración base de archivos Python
- Sistema de versionado semántico
- Documentación base del proyecto

### Notas
- Inicio del proyecto con migración a estructura GitOps
- Implementación de políticas de versionado semántico