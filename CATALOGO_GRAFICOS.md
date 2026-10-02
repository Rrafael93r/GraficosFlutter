# Catálogo de Gráficos — Taller Flutter

260 gráficos distintos: 4 librerías × (40 básicos + 25 avanzados).
Los tipos estándar (barra, línea, circular, scatter) se repiten una sola vez por librería — el resto es único en todo el proyecto.

## 1. FL Chart (65)

### Básicos (40)
1. Línea — ventas (serie simple)
2. Línea — temperatura (curva suave)
3. Línea — con puntos destacados
4. Línea — estilo punteado
5. Multilínea — comparativo 2 series
6. Multilínea — comparativo 3 series
7. Área — serie simple (relleno bajo la línea)
8. Área — relleno degradado
9. Área apilada
10. Barras — vertical simple
11. Barras — horizontal (rotado)
12. Barras — agrupadas (multi-serie)
13. Barras — apiladas
14. Barras — bordes redondeados
15. Barras — valores negativos
16. Barras — degradado de color
17. Circular — porcentajes simples
18. Circular — sector explotado
19. Dona (donut)
20. Dona — con texto central (KPI)
21. Medio-dona tipo gauge
22. Scatter — puntos simples
23. Scatter — coloreado por categoría
24. Scatter — con línea de tendencia superpuesta
25. Scatter tipo burbuja (tamaño variable)
26. Histograma
27. Línea escalonada (step line)
28. Línea — doble eje Y
29. Barras — con línea de umbral/meta
30. Línea — con máximo/mínimo destacado
31. Barras — ventas mensuales
32. Barras — asistencia semanal
33. Línea — tendencia tipo bursátil
34. Área — ventas acumuladas
35. Circular — distribución de presupuesto
36. Barras — distribución por edad
37. Scatter — altura vs. peso
38. Línea — temperatura por hora
39. Barras — ranking de productos (ordenado)
40. Combinado — barras + línea (dual serie)

### Avanzados (25)
41. Radar/spider — comparación de habilidades
42. Radar — multi-serie
43. Velas japonesas (custom painter)
44. Árbol de decisiones (CustomPainter) — diagnóstico
45. Red Bayesiana (CustomPainter) — probabilidades
46. Árbol jerárquico organizacional
47. Línea animada (actualización en tiempo real)
48. Barras animadas (transición de valores)
49. Circular interactivo (tap para resaltar sector)
50. Línea interactiva (tooltip + crosshair táctil)
51. Gauge tipo velocímetro (custom painter)
52. Sparkline (mini gráfico)
53. Heatmap en grilla (custom painter)
54. Matriz de correlación
55. Curva de distribución normal
56. Probabilidad posterior de Bayes (slider interactivo)
57. Matriz de confusión
58. Waterfall (barras apiladas custom)
59. Funnel (embudo, custom painter)
60. Anillos de progreso circular
61. Radar multi-eje (5+ métricas)
62. Grafo de red (nodos y conexiones, custom painter)
63. Timeline tipo Gantt
64. Boxplot (cuartiles, custom painter)
65. Mini dashboard combinado (sparkline + KPI + flecha de tendencia)

## 2. Syncfusion Flutter Charts (65)

### Básicos (40)
1. LineSeries — ventas
2. SplineSeries — curva suave
3. StepLineSeries
4. FastLineSeries (datasets grandes)
5. LineSeries múltiple — comparativo
6. AreaSeries
7. SplineAreaSeries
8. StepAreaSeries
9. StackedAreaSeries
10. StackedArea100Series
11. ColumnSeries (barra vertical)
12. BarSeries (barra horizontal)
13. StackedColumnSeries
14. StackedBarSeries
15. StackedColumn100Series
16. RangeColumnSeries
17. RangeAreaSeries
18. PieSeries
19. DoughnutSeries
20. RadialBarSeries
21. SfPyramidChart básico
22. SfFunnelChart básico
23. ScatterSeries
24. BubbleSeries
25. HistogramSeries
26. ColumnSeries — con etiquetas de datos
27. LineSeries — con marcadores
28. ColumnSeries — eje logarítmico
29. LineSeries — con zoom y pan
30. ColumnSeries — con trackball tooltip
31. LineSeries — con crosshair
32. ColumnSeries — ventas mensuales
33. BarSeries — ranking de productos
34. DoughnutSeries — con KPI central
35. AreaSeries — ingresos acumulados
36. ScatterSeries — correlación
37. ColumnSeries — eje secundario (dual axis)
38. LineSeries — temperatura por hora
39. PieSeries — con sector explotado
40. Combinado — ColumnSeries + LineSeries

### Avanzados (25)
41. CandleSeries (velas japonesas)
42. HiloSeries
43. HiloOpenCloseSeries
44. BoxAndWhiskerSeries
45. ErrorBarSeries
46. WaterfallSeries
47. RadialBarSeries multi-nivel
48. Trendline — regresión lineal
49. Trendline — regresión polinómica
50. Zoom por pinch (mobile)
51. Indicador técnico — media móvil
52. Range selector
53. SfTreemap — distribución jerárquica
54. Circular con annotation central tipo gauge
55. Cartesian con múltiples paneles (panes)
56. ColumnSeries 3D
57. Animación personalizada de entrada
58. Drill-down (categoría → subcategoría)
59. Red Bayesiana (annotations + shapes custom)
60. Árbol de decisiones (annotations + conectores)
61. Streaming de datos en tiempo real
62. Banda tipo Bollinger
63. Tooltip sincronizado multi-eje
64. Comparación multi-doughnut
65. Dashboard combinado — indicador técnico + trendline

## 3. Graphic (65)

### Básicos (40)
1. PointMark — scatter simple
2. PointMark — scatter coloreado por categoría
3. PointMark — bubble (canal de tamaño)
4. LineMark — ventas
5. LineMark — curva suavizada
6. LineMark — multi-serie comparativo
7. LineMark — step
8. AreaMark — simple
9. AreaMark — degradado
10. AreaMark — apilada (position stack)
11. IntervalMark — barra vertical
12. IntervalMark — barra horizontal (coord transpuesta)
13. IntervalMark — barra agrupada (dodge)
14. IntervalMark — barra apilada (stack)
15. IntervalMark — ancho variable
16. IntervalMark — valores negativos
17. IntervalMark + PolarCoord — circular (pie)
18. IntervalMark + PolarCoord — dona
19. IntervalMark + PolarCoord — rose chart
20. LineMark + PolarCoord — radar
21. PointMark — correlación altura/peso
22. IntervalMark — histograma
23. LineMark — temperatura por hora
24. AreaMark — ingresos acumulados
25. IntervalMark — ranking ordenado
26. PointMark — dispersión con línea de tendencia
27. LineMark — ventas mensuales
28. IntervalMark — asistencia semanal
29. PointMark — bubble ponderado
30. LineMark — doble canal (color + forma)
31. IntervalMark — distribución por edad
32. AreaMark — stream graph
33. LineMark — tendencia bursátil
34. IntervalMark — presupuesto por categoría
35. PointMark — nube de puntos categorizada
36. LineMark — comparación 3 series
37. IntervalMark — top productos
38. AreaMark — dos áreas superpuestas
39. LineMark — interpolación spline
40. IntervalMark — combinado barra + línea

### Avanzados (25)
41. PolygonMark — heatmap
42. PolygonMark — treemap-like
43. LineMark + PolarCoord — red bayesiana (custom)
44. CustomMark — árbol de decisiones
45. IntervalMark — boxplot (cuartiles)
46. CustomMark — velas japonesas
47. LineMark — coordenadas paralelas
48. PointMark — matriz de correlación (scatter matrix)
49. IntervalMark — funnel
50. IntervalMark — waterfall
51. LineMark — curva de probabilidad normal
52. LineMark — probabilidad posterior Bayes (interactivo)
53. PolygonMark — density plot
54. IntervalMark — embudo de conversión
55. LineMark — animación de transición
56. PointMark — tooltip interactivo personalizado
57. IntervalMark — apilado 100%
58. LineMark — múltiples ejes Y
59. PolygonMark — matriz de confusión
60. CustomMark — grafo de red (nodos/conexiones)
61. IntervalMark — Gantt (timeline)
62. LineMark — brushing / selección de rango
63. PointMark — clustering visual coloreado
64. IntervalMark — comparación multi-grupo (small multiples)
65. CustomMark — dashboard combinado (sparklines + KPIs)

## 4. Community Charts for Flutter (65)

### Básicos (40)
1. BarChart — simple (vertical)
2. BarChart — horizontal
3. BarChart — agrupado
4. BarChart — apilado
5. BarChart — con etiquetas de datos
6. BarChart — eje invertido
7. LineChart — ventas
8. LineChart — multi-serie
9. LineChart — área rellena
10. LineChart — con puntos (symbol renderer)
11. TimeSeriesChart — ventas diarias
12. TimeSeriesChart — multi-serie temporal
13. PieChart — porcentajes
14. PieChart — dona (arcWidth)
15. PieChart — etiquetas externas
16. ScatterPlotChart — simple
17. ScatterPlotChart — burbuja (tamaño variable)
18. ScatterPlotChart — coloreado por categoría
19. ComboChart ordinal — barra + línea
20. ComboChart numérico — barra + línea
21. BarChart — valores negativos
22. BarChart — barra de rango (comparación)
23. LineChart — con leyenda interactiva (selección de series)
24. BarChart — ranking ordenado
25. LineChart — tendencia animada
26. BarChart — distribución por edad
27. PieChart — distribución de presupuesto
28. ScatterPlotChart — altura vs. peso
29. LineChart — temperatura por hora
30. BarChart — asistencia semanal
31. TimeSeriesChart — con rango de fechas
32. BarChart — etiquetas rotadas en eje X
33. LineChart — línea punteada (dash pattern)
34. BarChart — colores por segmento
35. PieChart — sector resaltado
36. ScatterPlotChart — con línea de tendencia
37. LineChart — doble serie comparativa
38. BarChart — con línea de meta/umbral (RangeAnnotation)
39. BarChart — con tooltip personalizado
40. ComboChart — barras apiladas + línea de total

### Avanzados (25)
41. Sunburst — jerarquía (o treemap si no disponible en esta versión)
42. BarChart — con RangeAnnotation (bandas de referencia)
43. LineChart — crosshair interactivo (LinePointHighlighter + SelectNearest)
44. BarChart — con viewport deslizante (pan)
45. LineChart — con zoom (pan and zoom behavior)
46. ComboChart — eje secundario (dual axis)
47. BarChart — animación de entrada personalizada
48. LineChart — tiempo real (datos en vivo)
49. PieChart — interactivo (tap para resaltar sector)
50. BarChart — leyenda con selección de series (toggle)
51. ScatterPlotChart — mapeo avanzado de tamaño de punto
52. Gauge tipo velocímetro (custom painter)
53. Heatmap en grilla (custom painter)
54. Matriz de correlación (custom painter)
55. Curva de distribución normal
56. Probabilidad posterior de Bayes (slider interactivo)
57. Matriz de confusión (custom painter)
58. Waterfall (barras en cascada)
59. Funnel (embudo, custom painter)
60. Árbol de decisiones (custom painter)
61. Red Bayesiana (custom painter)
62. Grafo de red (custom painter)
63. Boxplot (custom painter)
64. Timeline tipo Gantt
65. Dashboard combinado (sparkline + KPI + flecha de tendencia)
