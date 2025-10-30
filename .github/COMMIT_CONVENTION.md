# Conventional Commits Configuration

## Configuración para Conventional Commits

Este proyecto utiliza la especificación [Conventional Commits](https://www.conventionalcommits.org/es/) para estandarizar los mensajes de commit.

### Formato del Mensaje

```
<tipo>[ámbito opcional]: <descripción>

[cuerpo opcional]

[pie(s) opcional(es)]
```

### Tipos Permitidos

- **feat**: Nueva funcionalidad
- **fix**: Corrección de errores  
- **docs**: Cambios en documentación
- **style**: Cambios de formato/estilo visual
- **refactor**: Refactorización de código/consultas DAX
- **perf**: Mejoras de rendimiento
- **test**: Añadir o corregir tests
- **chore**: Tareas de mantenimiento

### Ámbitos Sugeridos

- **dashboard**: Cambios en el archivo .pbix principal
- **data**: Modificaciones en fuentes de datos
- **metrics**: Cambios en medidas DAX o KPIs
- **docs**: Documentación del proyecto
- **config**: Configuración y licencias

### Ejemplos

```bash
# Nueva funcionalidad
feat(metrics): add "Promedio de Interacciones por Día" measure

# Corrección de error
fix(timezone): correct Last_Update_Time calculation to UTC-5

# Documentación
docs(changelog): update version 1.2.1 release notes

# Mantenimiento
chore(license): renew ZoomCharts license registration

# Refactorización
refactor(data): optimize Last_Update_Time table creation logic

# Mejora de rendimiento
perf(dashboard): eliminate intermediate tables in data model
```

### Breaking Changes

Para cambios que rompen compatibilidad, usar `!` después del tipo:

```bash
feat(dashboard)!: restructure data model for new requirements

BREAKING CHANGE: Previous versions of the dashboard will need data refresh
```

### Herramientas Recomendadas

- **commitizen**: Para generar commits interactivamente
- **commitlint**: Para validar formato de commits
- **husky**: Para hooks de pre-commit

### Validación de Commits

Los commits deben seguir este patrón regex:
```regex
^(feat|fix|docs|style|refactor|perf|test|chore)(\(.+\))?: .{1,50}
```