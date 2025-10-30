# Copilot Instructions - Seguimiento Presencial Agencias

## Contexto del Proyecto
Este proyecto es un dashboard de Power BI para el seguimiento de interacciones presenciales en agencias de La Ascensión S.A. Es parte del Centro de Gestión del Cliente y rastrea métricas de atención presencial, cancelaciones y performance de agencias.

## Arquitectura del Proyecto

### Estructura de Archivos Principal
- **`SEGUIMIENTO_PRESENCIAL_AGENCIAS_V1.2.1.pbix`**: Dashboard principal activo
- **`DATOS_EXTERNOS/`**: Fuentes de datos organizadas por año/mes/semana
- **`DOCUMENTACION/changelog_SEGUIMIENTO_PRESENCIAL_AGENCIAS.txt`**: Control de versiones y cambios
- **`VERSIONES_ANTERIORES/`**: Historial de versiones del dashboard

### Convenciones de Versionado
Sigue versionado semántico (V[mayor].[menor].[corrección]):
- **Mayor**: Cambios significativos que afectan funcionalidad principal
- **Menor**: Nuevas funcionalidades sin romper compatibilidad
- **Corrección**: Fixes de errores y optimizaciones

### Estructura de Datos Externa

#### Organización Temporal
```
DATOS_EXTERNOS/
├── [año]/
│   ├── [mes_nombre]/
│   │   ├── Sem_[numero]_[fecha_inicio]_a_[fecha_fin]/
│   │   │   ├── [día]/
│   │   │   │   └── Registro de Clientes*.xlsx
```

#### Fuentes de Datos Históricas
- **01_Base_Presencial**: Datos hasta diciembre 2022
- **02_interacciones oficina principal**: Datos hasta abril 2023  
- **03_Registro de Clientes en Atención Presencial**: Datos hasta septiembre 2025

## Patrones Específicos del Proyecto

### Gestión de Cancelaciones
- Las tipificaciones de cancelaciones pre-21/10/2024 están parametrizadas
- Categorías clave: "Cancelación - Servicio", "Cancelación - Precio", "Cancelación - Beneficios"

### Métricas Clave
- **"Promedio de Interacciones por Día"**: Medida principal de performance
- **"Consolidado Mes en Curso"**: Página dedicada para seguimiento mensual
- **Last_Update_Time**: Marca de tiempo UTC-5 para actualización de datos

### Consideraciones Técnicas
- **ZoomCharts**: Licencia registrada para objetos visuales específicos
- **Zona Horaria**: UTC-5 para todas las marcas de tiempo
- **Optimización**: Se priorizan consultas eficientes eliminando tablas intermedias

## Flujo de Trabajo de Desarrollo

### Al Hacer Cambios
1. Actualizar version en filename siguiendo convención semántica
2. Documentar cambios en `DOCUMENTACION/changelog_SEGUIMIENTO_PRESENCIAL_AGENCIAS.txt`
3. Mover versión anterior a `VERSIONES_ANTERIORES/`
4. Validar métricas de tiempo con zona horaria UTC-5

### Compromisos Pendientes
- Retenciones de las agencias
- FCR agencias  
- Mapeo descargas de Certificados vs Portal Clientes

## Consideraciones Importantes
- Mantener consistencia en nombres de archivos con prefijos numéricos
- Respetar estructura temporal estricta para datos externos
- Validar licencias de componentes visuales antes de deployment
- Optimizar consultas DAX para mejorar performance del modelo
