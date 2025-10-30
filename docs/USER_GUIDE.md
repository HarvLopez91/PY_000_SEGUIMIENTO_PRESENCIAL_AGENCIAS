# Guía de Usuario - Dashboard Seguimiento Presencial Agencias

## Introducción

Bienvenido al Dashboard de Seguimiento Presencial de Agencias de La Ascensión S.A. Esta herramienta le permitirá analizar y monitorear las interacciones presenciales en nuestras agencias, identificar áreas de mejora y tomar decisiones basadas en datos.

## Acceso al Dashboard

### Requisitos Previos
- Cuenta corporativa de Microsoft
- Licencia de Power BI asignada
- Permisos de acceso otorgados por el administrador

### Pasos de Acceso
1. Ingrese a Power BI Service: https://app.powerbi.com
2. Navegue a "Mi área de trabajo" o el workspace asignado
3. Busque el dashboard "Seguimiento Presencial Agencias"
4. Haga clic para abrir

## Páginas del Dashboard

### 1. Vista General (Overview)

**Propósito**: Resumen ejecutivo con los KPIs principales

**Visualizaciones**:
- Tarjetas de KPIs principales:
  - Total de interacciones del período
  - Tasa de completación
  - Satisfacción promedio
  - Tasa de cancelación
- Gráfico de tendencia de interacciones por día
- Top 5 agencias por volumen de atención
- Distribución de interacciones por tipo de servicio

**Filtros Disponibles**:
- Rango de fechas
- Región
- Agencia específica

**Cómo Usar**:
1. Seleccione el período que desea analizar
2. Aplique filtros de región/agencia si lo requiere
3. Observe los KPIs principales para identificar tendencias
4. Haga clic en cualquier visual para filtrar los demás

### 2. Análisis de Atención

**Propósito**: Análisis detallado del proceso de atención

**Visualizaciones**:
- Tiempo promedio de atención por tipo de servicio
- Tiempo promedio en cola por hora del día
- Distribución de interacciones por hora
- Gráfico de capacidad utilizada vs disponible
- Análisis de duración de atención por agencia

**Métricas Clave**:
- Tiempo promedio de atención: XX minutos
- Tiempo promedio en cola: XX minutos
- Horas pico: [horarios identificados]
- Capacidad promedio utilizada: XX%

**Insights a Buscar**:
- Identifique las horas con mayor tiempo de espera
- Compare tiempos de atención entre agencias
- Detecte servicios que requieren más tiempo del previsto

### 3. Análisis de Cancelaciones

**Propósito**: Entender las causas y patrones de cancelaciones

**Visualizaciones**:
- Tasa de cancelación por agencia
- Principales motivos de cancelación
- Tiempo promedio de espera antes de cancelar
- Tendencia de cancelaciones en el tiempo
- Distribución de cancelaciones por día de la semana

**Métricas Clave**:
- Tasa global de cancelación: XX%
- Tiempo promedio antes de cancelar: XX minutos
- Principal motivo de cancelación: [motivo]

**Acciones Recomendadas**:
- Si la tasa > 10%: Revisar capacidad y asignación de personal
- Si tiempo de espera > 20 min: Optimizar procesos
- Analizar patrones por día/hora para redistribuir recursos

### 4. Rendimiento de Agencias

**Propósito**: Comparar el desempeño entre agencias

**Visualizaciones**:
- Ranking de agencias por satisfacción
- Comparativo de productividad (interacciones por asesor)
- Mapa geográfico de performance
- Matriz de agencias (satisfacción vs volumen)
- Tendencia de mejora/deterioro por agencia

**Métricas por Agencia**:
- Volumen de atención
- Satisfacción promedio
- Tasa de cancelación
- Productividad
- Tiempo promedio de atención

**Cómo Interpretar**:
- **Alto volumen + Alta satisfacción**: Agencia modelo
- **Alto volumen + Baja satisfacción**: Sobrecarga
- **Bajo volumen + Baja satisfacción**: Requiere intervención
- **Bajo volumen + Alta satisfacción**: Subutilización

### 5. Análisis de Asesores

**Propósito**: Evaluar el rendimiento individual y del equipo

**Visualizaciones**:
- Productividad por asesor
- Calificación promedio por asesor
- Distribución de carga de trabajo
- Top performers del período
- Comparativo de tiempo de atención

**Métricas de Asesor**:
- Número de atenciones completadas
- Satisfacción promedio recibida
- Tiempo promedio de atención
- Tasa de resolución en primera interacción

**Privacidad**:
Los datos individuales son visibles solo para gerentes directos y RRHH, siguiendo políticas de privacidad corporativa.

### 6. Análisis Temporal

**Propósito**: Identificar patrones y tendencias en el tiempo

**Visualizaciones**:
- Análisis de estacionalidad
- Comparativo año sobre año
- Tendencias por trimestre/mes
- Identificación de días atípicos
- Proyección de demanda futura

**Insights Temporales**:
- Meses de mayor demanda
- Días de la semana más concurridos
- Impacto de feriados y eventos especiales
- Tendencias de crecimiento/decrecimiento

## Uso de Filtros y Segmentadores

### Filtros Globales (Aplican a todas las páginas)
- **Período de Análisis**: Seleccione fechas específicas o rangos predefinidos
- **Región**: Filtre por región geográfica
- **Tipo de Cliente**: Individual o Corporativo

### Filtros de Página
Cada página tiene filtros específicos adicionales. Estos solo afectan la página actual.

### Cómo Usar Filtros
1. Haga clic en el icono de filtro (embudo) en el panel derecho
2. Seleccione los valores deseados
3. Para múltiples selecciones, mantenga presionado Ctrl (Windows) o Cmd (Mac)
4. Para limpiar filtros, haga clic en el icono de borrador

### Filtros Avanzados
Usuarios avanzados pueden crear filtros personalizados usando expresiones DAX en el modo de edición.

## Exportación de Datos

### Exportar a Excel
1. Haga clic derecho sobre cualquier visualización
2. Seleccione "Exportar datos"
3. Elija "Datos resumidos" o "Datos subyacentes"
4. Guarde el archivo Excel generado

### Exportar a PDF
1. Haga clic en "Archivo" > "Exportar a PDF"
2. Seleccione las páginas a incluir
3. Descargue el PDF generado

### Exportar a PowerPoint
1. Haga clic en "Archivo" > "Exportar a PowerPoint"
2. Se generará una presentación con capturas de las visualizaciones
3. Edite según necesidad

## Suscripciones y Alertas

### Configurar Suscripciones
1. Haga clic en "Suscribirse" en la barra superior
2. Configure la frecuencia (diaria, semanal, mensual)
3. Agregue destinatarios adicionales si lo desea
4. Guarde la suscripción

### Crear Alertas de Datos
1. Seleccione una tarjeta o indicador
2. Haga clic en los tres puntos (...)
3. Seleccione "Administrar alertas"
4. Defina umbrales y condiciones
5. Configure notificaciones

Ejemplo: "Alertar cuando la tasa de cancelación > 15%"

## Actualización de Datos

### Frecuencia de Actualización
- **Datos en tiempo real**: Actualización cada 30 minutos
- **Última actualización**: Visible en la esquina superior derecha

### Actualización Manual
1. Haga clic en el icono de actualizar
2. Espere a que se complete la actualización
3. Verifique la fecha/hora de última actualización

## Mejores Prácticas

### Para Análisis Efectivo
1. **Comience con la Vista General**: Obtenga contexto antes de profundizar
2. **Use Filtros Estratégicamente**: No sobrecargue con múltiples filtros simultáneos
3. **Compare Períodos**: Use comparativas para identificar cambios
4. **Busque Patrones**: No solo números, sino tendencias y anomalías
5. **Documente Insights**: Tome notas de hallazgos importantes

### Para Presentaciones
1. **Use Capturas de Pantalla**: Documente insights con imágenes
2. **Contextualice Datos**: Explique el "por qué" detrás de los números
3. **Prepare Narrativas**: Cuente una historia con los datos
4. **Anticipe Preguntas**: Tenga datos de respaldo listos

### Para Toma de Decisiones
1. **Verifique la Frescura de Datos**: Confirme última actualización
2. **Valide Anomalías**: Investigue valores atípicos antes de concluir
3. **Considere Contexto**: Factores externos pueden influir en métricas
4. **Use Múltiples Métricas**: No se base en un solo KPI

## Preguntas Frecuentes (FAQ)

**P: ¿Por qué no veo datos de ciertas agencias?**
R: Puede tener restricciones de seguridad (RLS). Contacte al administrador si requiere acceso adicional.

**P: ¿Cómo puedo sugerir nuevas visualizaciones?**
R: Envíe sus sugerencias a centrocliente@laascension.com con el asunto "Mejora Dashboard BI".

**P: ¿Los datos incluyen interacciones telefónicas o digitales?**
R: No, este dashboard es exclusivo para atención presencial en agencias físicas.

**P: ¿Puedo crear mis propios cálculos?**
R: Los usuarios con permisos de edición pueden crear medidas personalizadas. Contacte al equipo de BI.

**P: ¿Qué hacer si encuentro datos incorrectos?**
R: Reporte inmediatamente a calidaddatos@laascension.com con detalles específicos.

## Soporte Técnico

### Contacto
- **Email**: soporte.bi@laascension.com
- **Teléfono**: +XXX-XXX-XXXX ext. 1234
- **Horario**: Lunes a Viernes, 8:00 AM - 6:00 PM

### Recursos Adicionales
- Portal de Capacitación: https://training.laascension.com/bi
- Video Tutoriales: https://videos.laascension.com/dashboard-presencial
- Comunidad de Usuarios: Teams - Canal "BI Dashboard Support"

## Glosario de Términos

- **Interacción Presencial**: Contacto cara a cara entre cliente y asesor en agencia
- **Tasa de Completación**: Porcentaje de interacciones finalizadas exitosamente
- **Tasa de Cancelación**: Porcentaje de clientes que abandonan sin ser atendidos
- **Tiempo en Cola**: Minutos transcurridos desde llegada hasta inicio de atención
- **Satisfacción**: Calificación del 1 al 5 otorgada por el cliente
- **Capacidad Utilizada**: Porcentaje de capacidad operativa en uso
- **Ventanilla**: Punto de atención individual en la agencia
