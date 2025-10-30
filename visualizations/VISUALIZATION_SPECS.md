# Especificaciones de Visualizaciones
# Dashboard Seguimiento Presencial Agencias

## Página 1: Vista General (Overview)

### Visualización 1.1: Tarjetas de KPIs Principales
**Tipo**: Tarjetas (Cards)
**Ubicación**: Fila superior, distribuidas en 4 columnas
**Dimensiones**: 300x150 px cada una

#### KPI 1: Total Interacciones
- **Medida**: `TotalInteracciones`
- **Formato**: `#,##0`
- **Color de fondo**: Azul corporativo (#003366)
- **Color de texto**: Blanco
- **Icono**: 👥
- **Indicador de tendencia**: Mostrar variación vs período anterior
- **Tooltip**: "Total de interacciones presenciales en el período seleccionado"

#### KPI 2: Tasa de Completación
- **Medida**: `TasaCompletacion%`
- **Formato**: `0.0%`
- **Color dinámico**:
  - Verde (#28A745): >= 95%
  - Amarillo (#FFC107): 85% - 94.9%
  - Rojo (#DC3545): < 85%
- **Icono**: ✓
- **Meta visual**: Línea indicadora en 95%

#### KPI 3: Satisfacción Promedio
- **Medida**: `SatisfaccionPromedio`
- **Formato**: `0.00 ⭐`
- **Visualización**: Gauge semicircular (0-5)
- **Rangos de color**:
  - Verde: 4.0-5.0
  - Amarillo: 3.5-3.99
  - Rojo: < 3.5
- **Meta**: 4.0

#### KPI 4: Tasa de Cancelación
- **Medida**: `TasaCancelacion%`
- **Formato**: `0.0%`
- **Color dinámico**:
  - Verde: <= 5%
  - Amarillo: 5.1% - 15%
  - Rojo: > 15%
- **Icono**: ✗
- **Orientación**: Menor es mejor

---

### Visualización 1.2: Gráfico de Tendencia de Interacciones
**Tipo**: Gráfico de Líneas y Columnas Combinado
**Ubicación**: Centro izquierda
**Dimensiones**: 600x400 px

**Configuración**:
- **Eje X**: `DimFecha[Fecha]`
- **Eje Y Principal (Columnas)**: `TotalInteracciones`
  - Color: Azul corporativo
  - Etiquetas de datos: Sí
- **Eje Y Secundario (Línea)**: `SatisfaccionPromedio`
  - Color: Verde
  - Marcadores: Sí
  - Grosor línea: 3px
- **Línea de tendencia**: Promedio móvil 7 días
- **Marcadores especiales**: Resaltar fines de semana y feriados
- **Interactividad**: Drill-down a nivel de hora
- **Tooltip personalizado**: Mostrar todos los KPIs del día

---

### Visualización 1.3: Top 5 Agencias por Volumen
**Tipo**: Gráfico de Barras Horizontales
**Ubicación**: Centro derecha
**Dimensiones**: 400x400 px

**Configuración**:
- **Eje Y**: `DimAgencia[NombreAgencia]`
- **Eje X**: `TotalInteracciones`
- **Ordenamiento**: Descendente por volumen
- **Límite**: Top 5
- **Color**: Gradiente azul (más oscuro = mayor volumen)
- **Etiquetas de datos**: Cantidad de interacciones
- **Barra de datos**: Sí
- **Tooltip**: 
  - Nombre de agencia
  - Total interacciones
  - Satisfacción promedio
  - Tasa de cancelación
  - Ranking

---

### Visualización 1.4: Distribución por Tipo de Servicio
**Tipo**: Gráfico de Dona (Donut Chart)
**Ubicación**: Inferior centro
**Dimensiones**: 400x300 px

**Configuración**:
- **Categoría**: `DimTipoServicio[Categoria]`
- **Valores**: `TotalInteracciones`
- **Colores**: Paleta corporativa
- **Etiquetas**: Porcentajes
- **Centro del dona**: Total general
- **Leyenda**: Posición derecha
- **Interactividad**: Click para filtrar por categoría

---

### Visualización 1.5: Filtros Globales
**Tipo**: Segmentadores (Slicers)
**Ubicación**: Panel izquierdo vertical
**Dimensiones**: 200x600 px

**Filtros incluidos**:
1. **Rango de Fechas**
   - Tipo: Date Range Slicer
   - Predefinidos: Hoy, Ayer, Últimos 7 días, Últimos 30 días, Mes actual, Personalizado
   
2. **Región**
   - Tipo: Lista con búsqueda
   - Multi-selección: Sí
   - Selección predeterminada: Todas
   
3. **Agencia**
   - Tipo: Dropdown con búsqueda
   - Dependiente de: Región
   - Multi-selección: Sí
   
4. **Tipo de Cliente**
   - Tipo: Botones
   - Opciones: Todos, Individual, Corporativo
   
5. **Segmento**
   - Tipo: Lista
   - Multi-selección: Sí

---

## Página 2: Análisis de Atención

### Visualización 2.1: Tiempo Promedio de Atención por Tipo de Servicio
**Tipo**: Gráfico de Barras Agrupadas
**Ubicación**: Superior izquierda
**Dimensiones**: 600x350 px

**Configuración**:
- **Eje Y**: `DimTipoServicio[NombreServicio]`
- **Eje X**: `PromedioTiempoAtencion` (minutos)
- **Agrupación**: `DimTipoServicio[Categoria]`
- **Ordenamiento**: Por tiempo descendente
- **Colores**: Por categoría
- **Línea de referencia**: Tiempo objetivo (línea punteada)
- **Etiquetas**: Tiempo en minutos
- **Tooltip**: Incluir desviación estándar

---

### Visualización 2.2: Tiempo en Cola por Hora del Día
**Tipo**: Gráfico de Área
**Ubicación**: Superior derecha
**Dimensiones**: 600x350 px

**Configuración**:
- **Eje X**: Hora (0-23)
- **Eje Y**: `PromedioTiempoCola` (minutos)
- **Relleno**: Gradiente (verde → amarillo → rojo)
- **Línea de meta**: 15 minutos (línea roja punteada)
- **Marcadores**: Horas pico
- **Interactividad**: Hover para ver detalle
- **Anotaciones**: Identificar horarios críticos

---

### Visualización 2.3: Distribución de Interacciones por Hora
**Tipo**: Histograma
**Ubicación**: Centro izquierda
**Dimensiones**: 500x300 px

**Configuración**:
- **Eje X**: Hora del día (intervalos de 1 hora)
- **Eje Y**: Cantidad de interacciones
- **Color**: Azul corporativo
- **Overlay**: Línea de capacidad disponible
- **Identificación**: Horas de sobrecarga (rojo) y subutilización (verde)
- **Agrupación secundaria**: Por día de la semana

---

### Visualización 2.4: Capacidad Utilizada vs Disponible
**Tipo**: Gauge (Velocímetro)
**Ubicación**: Centro derecha
**Dimensiones**: 400x300 px

**Configuración**:
- **Medida**: `CapacidadUtilizada%`
- **Rango**: 0% - 150%
- **Rangos de color**:
  - Verde (óptimo): 70% - 90%
  - Amarillo (advertencia): 50% - 69% o 91% - 100%
  - Rojo (crítico): < 50% o > 100%
- **Aguja**: Posición actual
- **Valor objetivo**: 80%
- **Etiquetas**: Mostrar porcentaje actual

---

### Visualización 2.5: Análisis de Duración por Agencia
**Tipo**: Box Plot (Diagrama de Caja)
**Ubicación**: Inferior
**Dimensiones**: 1000x300 px

**Configuración**:
- **Eje X**: Agencias (ordenadas por mediana)
- **Eje Y**: Duración de atención (minutos)
- **Elementos**:
  - Caja: Q1 - Q3
  - Línea en caja: Mediana
  - Bigotes: Min - Max (excluyendo outliers)
  - Puntos: Outliers
- **Color**: Por cumplimiento de SLA
- **Línea de referencia**: Tiempo objetivo

---

## Página 3: Análisis de Cancelaciones

### Visualización 3.1: Tasa de Cancelación por Agencia
**Tipo**: Mapa de Calor (Heat Map)
**Ubicación**: Superior
**Dimensiones**: 1000x400 px

**Configuración**:
- **Filas**: Agencias
- **Columnas**: Días de la semana / Horas
- **Valores**: `TasaCancelacion`
- **Escala de color**:
  - Verde claro: 0% - 5%
  - Amarillo: 5.1% - 10%
  - Naranja: 10.1% - 15%
  - Rojo: > 15%
- **Etiquetas**: Porcentaje en cada celda
- **Ordenamiento**: Por tasa promedio

---

### Visualización 3.2: Principales Motivos de Cancelación
**Tipo**: Gráfico de Barras Apiladas Horizontal
**Ubicación**: Centro izquierda
**Dimensiones**: 500x400 px

**Configuración**:
- **Eje Y**: `FactCancelaciones[MotivoCancelacion]`
- **Eje X**: Cantidad (apilado 100%)
- **Segmentación**: Por agencia
- **Ordenamiento**: Descendente por total
- **Colores**: Degradado rojo
- **Top**: 10 motivos principales
- **Drill-through**: A detalle de cancelaciones por motivo

---

### Visualización 3.3: Tiempo Antes de Cancelar
**Tipo**: Histograma con Curva de Distribución
**Ubicación**: Centro derecha
**Dimensiones**: 500x400 px

**Configuración**:
- **Eje X**: Tiempo de espera (bins de 5 minutos)
- **Eje Y Principal**: Frecuencia (barras)
- **Eje Y Secundario**: Curva de distribución acumulada
- **Estadísticas**:
  - Media (línea vertical)
  - Mediana (línea punteada)
  - Percentil 75 (marcador)
- **Color de barras**: Gradiente amarillo a rojo
- **Anotación**: Punto crítico de abandono

---

### Visualización 3.4: Tendencia de Cancelaciones en el Tiempo
**Tipo**: Gráfico de Líneas con Bandas de Confianza
**Ubicación**: Inferior izquierda
**Dimensiones**: 600x300 px

**Configuración**:
- **Eje X**: Fecha
- **Eje Y**: `TasaCancelacion`
- **Línea principal**: Tasa diaria
- **Banda**: Intervalo de confianza 95%
- **Línea de tendencia**: Regresión lineal
- **Línea de meta**: Objetivo 10%
- **Marcadores**: Eventos especiales
- **Interactividad**: Zoom y pan

---

### Visualización 3.5: Distribución por Día de la Semana
**Tipo**: Gráfico Radial (Radar Chart)
**Ubicación**: Inferior derecha
**Dimensiones**: 400x300 px

**Configuración**:
- **Ejes**: Días de la semana
- **Valores**: `TasaCancelacion`
- **Múltiples series**: Comparar semanas
- **Área sombreada**: Sí
- **Color**: Gradiente azul-rojo
- **Marcadores**: En cada día
- **Referencia**: Promedio general (círculo)

---

## Página 4: Rendimiento de Agencias

### Visualización 4.1: Ranking de Agencias por Satisfacción
**Tipo**: Tabla con Barras de Datos
**Ubicación**: Izquierda
**Dimensiones**: 400x600 px

**Configuración**:
- **Columnas**:
  1. Ranking (#)
  2. Código Agencia
  3. Nombre Agencia
  4. Satisfacción (con barra de datos)
  5. Volumen
  6. Tasa Cancelación
  7. Tendencia (icono ↑↓→)
- **Formato condicional**:
  - Satisfacción: Color por valor
  - Tasa Cancelación: Íconos de alerta
- **Ordenamiento**: Por satisfacción descendente
- **Scroll**: Vertical
- **Totales**: No mostrar

---

### Visualización 4.2: Matriz Volumen vs Satisfacción
**Tipo**: Gráfico de Dispersión (Scatter Plot)
**Ubicación**: Centro superior
**Dimensiones**: 600x400 px

**Configuración**:
- **Eje X**: `TotalInteracciones` (Volumen)
- **Eje Y**: `SatisfaccionPromedio`
- **Burbujas**: Una por agencia
- **Tamaño de burbuja**: `CapacidadAtencion`
- **Color**: Por `Region`
- **Etiquetas**: Código de agencia
- **Cuadrantes**:
  - Q1 (alto-alto): Verde - Agencias modelo
  - Q2 (alto-bajo): Rojo - Sobrecargadas
  - Q3 (bajo-bajo): Naranja - Requieren intervención
  - Q4 (bajo-alto): Azul - Subutilizadas
- **Líneas de referencia**: En medianas de X e Y
- **Interactividad**: Drill-through a detalle de agencia

---

### Visualización 4.3: Mapa Geográfico de Performance
**Tipo**: Mapa de Forma (Shape Map)
**Ubicación**: Centro inferior
**Dimensiones**: 600x400 px

**Configuración**:
- **Ubicación**: Por coordenadas o dirección de agencia
- **Color de marcador**: Por `ScoreRendimientoAgencia`
- **Tamaño de marcador**: Por `TotalInteracciones`
- **Escala de color**:
  - Verde oscuro: Score > 0.8
  - Verde claro: Score 0.6 - 0.8
  - Amarillo: Score 0.4 - 0.6
  - Rojo: Score < 0.4
- **Tooltip**: KPIs principales de la agencia
- **Capas**: Regiones administrativas
- **Controles**: Zoom, pan

---

### Visualización 4.4: Productividad por Agencia
**Tipo**: Gráfico de Cascada (Waterfall)
**Ubicación**: Derecha superior
**Dimensiones**: 400x300 px

**Configuración**:
- **Categorías**: Agencias ordenadas por productividad
- **Valores**: `InteraccionesPorAsesor`
- **Barras**: 
  - Verdes: Por encima del promedio
  - Rojas: Por debajo del promedio
- **Línea de promedio**: Horizontal
- **Total**: Al final
- **Etiquetas**: Valor numérico

---

### Visualización 4.5: Tendencia de Mejora/Deterioro
**Tipo**: Slope Chart (Gráfico de Pendiente)
**Ubicación**: Derecha inferior
**Dimensiones**: 400x300 px

**Configuración**:
- **Eje X**: Dos puntos (Período anterior vs Período actual)
- **Líneas**: Una por agencia
- **Eje Y**: `SatisfaccionPromedio`
- **Color de línea**:
  - Verde: Mejora
  - Rojo: Deterioro
  - Gris: Sin cambio
- **Grosor de línea**: Proporcional a magnitud del cambio
- **Etiquetas**: Solo en agencias con cambio significativo
- **Highlight**: Top 3 mejoras y deterioros

---

## Página 5: Análisis de Asesores

### Visualización 5.1: Productividad Individual
**Tipo**: Gráfico de Columnas Clusterizado
**Ubicación**: Superior
**Dimensiones**: 1000x350 px

**Configuración**:
- **Eje X**: Nombre del asesor
- **Eje Y**: Métricas múltiples (columnas agrupadas):
  - Interacciones completadas
  - Tiempo promedio de atención
  - Satisfacción promedio
- **Colores**: Uno por métrica
- **Ordenamiento**: Por satisfacción descendente
- **Líneas de referencia**: Promedio de cada métrica
- **Filtro**: Por agencia
- **Drill-through**: A detalle de asesor

---

### Visualización 5.2: Distribución de Calificaciones por Asesor
**Tipo**: Gráfico de Violín (Violin Plot)
**Ubicación**: Centro izquierda
**Dimensiones**: 500x400 px

**Configuración**:
- **Eje X**: Asesores (top 20 por volumen)
- **Eje Y**: Calificación de servicio (1-5)
- **Distribución**: Ancho del violín = frecuencia
- **Mediana**: Línea horizontal
- **Media**: Punto
- **Cuartiles**: Barras internas
- **Color**: Gradiente por promedio
- **Comparación**: Contra distribución global

---

### Visualización 5.3: Carga de Trabajo
**Tipo**: Gráfico de Gantt Modificado
**Ubicación**: Centro derecha
**Dimensiones**: 500x400 px

**Configuración**:
- **Eje Y**: Asesores
- **Eje X**: Horas del día
- **Barras**: Períodos de actividad
- **Color**: Por utilización
  - Verde: 70-90% de utilización
  - Amarillo: 50-69% o 91-100%
  - Rojo: <50% o >100%
- **Interactividad**: Click para detalle de interacciones
- **Agrupación**: Por turno de trabajo

---

### Visualización 5.4: Top Performers del Período
**Tipo**: Tarjetas con Ranking
**Ubicación**: Inferior izquierda
**Dimensiones**: 600x300 px

**Configuración**:
- **Criterios de ranking**:
  1. Mayor satisfacción (>= 100 interacciones)
  2. Mayor productividad
  3. Menor tiempo promedio de atención
- **Mostrar**: Top 3 de cada categoría
- **Diseño**: Tarjetas con foto/avatar
- **Información**:
  - Nombre
  - Agencia
  - Métrica destacada
  - Tendencia
- **Formato**: Medalla oro/plata/bronce

---

### Visualización 5.5: Comparativo de Tiempos de Atención
**Tipo**: Gráfico de Bullet
**Ubicación**: Inferior derecha
**Dimensiones**: 600x300 px

**Configuración**:
- **Categorías**: Asesores
- **Valor actual**: Tiempo promedio real
- **Valor objetivo**: Tiempo estándar del servicio
- **Rangos**:
  - Excelente: < 80% del objetivo
  - Bueno: 80-100% del objetivo
  - Aceptable: 100-120% del objetivo
  - Requiere mejora: > 120% del objetivo
- **Ordenamiento**: Por diferencia con objetivo
- **Filtro**: Por tipo de servicio

---

## Página 6: Análisis Temporal

### Visualización 6.1: Análisis de Estacionalidad
**Tipo**: Gráfico de Descomposición Temporal
**Ubicación**: Superior
**Dimensiones**: 1000x400 px

**Configuración**:
- **Componentes apilados verticalmente**:
  1. Serie original (interacciones diarias)
  2. Tendencia (promedio móvil)
  3. Estacionalidad (patrón semanal/mensual)
  4. Residuo (variación no explicada)
- **Eje X**: Tiempo
- **Sincronización**: Zoom sincronizado entre componentes
- **Colores**: Azul (original), Verde (tendencia), Naranja (estacionalidad)
- **Interactividad**: Brush para seleccionar período

---

### Visualización 6.2: Comparativo Año sobre Año
**Tipo**: Gráfico de Líneas Múltiples
**Ubicación**: Centro izquierda
**Dimensiones**: 600x350 px

**Configuración**:
- **Eje X**: Mes del año (Enero - Diciembre)
- **Líneas**: Una por año (últimos 3 años)
- **Eje Y**: `TotalInteracciones`
- **Colores**: Gradiente del más antiguo (claro) al más reciente (oscuro)
- **Marcadores**: En cada mes
- **Área sombreada**: Rango min-max histórico
- **Anotaciones**: Eventos significativos
- **Leyenda**: Con variación % vs año anterior

---

### Visualización 6.3: Tendencias Trimestrales
**Tipo**: Small Multiples (Gráficos Pequeños Múltiples)
**Ubicación**: Centro derecha
**Dimensiones**: 600x350 px

**Configuración**:
- **Grilla**: 2x2 (un gráfico por trimestre)
- **Tipo de subgráfico**: Líneas
- **Eje X**: Semanas del trimestre
- **Eje Y**: KPIs principales
- **Escalas**: Sincronizadas para comparación
- **Highlight**: Tendencia del trimestre (↑↓)
- **Color**: Por cumplimiento de meta trimestral

---

### Visualización 6.4: Días Atípicos (Anomalías)
**Tipo**: Scatter Plot con Detección de Anomalías
**Ubicación**: Inferior izquierda
**Dimensiones**: 500x300 px

**Configuración**:
- **Eje X**: Fecha
- **Eje Y**: `TotalInteracciones`
- **Puntos normales**: Azul claro, pequeños
- **Anomalías**: Rojo, grandes
- **Bandas de confianza**: 95% y 99%
- **Algoritmo**: Basado en desviación estándar o ML
- **Tooltip en anomalías**:
  - Fecha
  - Valor real vs esperado
  - Posible causa (si se identificó)
  - Eventos del día
- **Filtro**: Por tipo de anomalía (alta/baja)

---

### Visualización 6.5: Proyección de Demanda
**Tipo**: Gráfico de Pronóstico
**Ubicación**: Inferior derecha
**Dimensiones**: 500x300 px

**Configuración**:
- **Eje X**: Fecha (histórico + futuro)
- **Línea azul sólida**: Datos históricos
- **Línea azul punteada**: Proyección (30 días)
- **Banda gris**: Intervalo de confianza
- **Puntos**: Valores reales cuando estén disponibles
- **Algoritmo**: Suavizamiento exponencial o ARIMA
- **Anotaciones**: Eventos planificados futuros
- **Precisión**: Mostrar MAPE del modelo

---

## Configuración Global de Interactividad

### Cross-Filtering (Filtrado Cruzado)
- **Habilitado**: Sí en todas las páginas
- **Dirección**: Bidireccional entre visualizaciones de la misma página
- **Excepción**: KPIs no filtran otros visuales (solo se filtran)

### Drill-Through (Navegación Detallada)
- **Configurado**: 
  - Desde ranking de agencias → Detalle de agencia
  - Desde gráfico de asesores → Detalle de asesor
  - Desde motivos de cancelación → Lista de cancelaciones
- **Botón de regreso**: Visible en todas las páginas de drill-through

### Tooltips Personalizados
- **Páginas de tooltip**: Creadas para:
  - Agencia (muestra todos los KPIs)
  - Asesor (performance individual)
  - Servicio (estadísticas del servicio)

### Bookmarks (Marcadores)
- **Estados predefinidos**:
  - Vista Ejecutiva (solo KPIs)
  - Vista Completa (todos los visuales)
  - Vista Regional (filtrado por región)
  - Análisis Semanal
  - Análisis Mensual

### Botones de Navegación
- **Botones de página**: En cada página
- **Botón de reset**: Limpiar todos los filtros
- **Botón de ayuda**: Link a documentación
- **Botón de exportar**: Exportar vista actual

---

## Responsive Design

### Diseño Adaptativo
- **Layout para Desktop**: 1920x1080 (óptimo)
- **Layout para Tablet**: 1024x768
- **Layout para Móvil**: 768x1024 (vertical)
- **Ajustes automáticos**: Reorganización de visuales por tamaño

### Mobile Layout
- **Prioridad de visuales**: KPIs → Tendencias → Detalles
- **Segmentadores**: Colapsables en menú hamburguesa
- **Gráficos complejos**: Simplificados o alternativas
- **Interactividad táctil**: Optimizada para gestos

---

## Temas y Estilos

### Tema Corporativo "La Ascensión"
- **Fuente principal**: Segoe UI (títulos: Bold, contenido: Regular)
- **Fuente secundaria**: Arial (fallback)
- **Tamaño de fuente**:
  - Títulos: 18pt
  - Subtítulos: 14pt
  - Contenido: 11pt
  - Footnotes: 9pt
- **Fondo de página**: Blanco (#FFFFFF)
- **Fondo de visuales**: Gris muy claro (#F8F9FA)
- **Bordes**: Gris claro (#E0E0E0), 1px
- **Sombras**: Sutiles en tarjetas

### Accesibilidad
- **Contraste**: WCAG AA compliance
- **Colores amigables**: Para daltonismo
- **Texto alternativo**: En todas las visualizaciones
- **Navegación por teclado**: Soportada
- **Screen reader**: Compatible

---

*Fin de Especificaciones de Visualizaciones*
*Versión: 1.0*
*Fecha: 2023-10-30*
