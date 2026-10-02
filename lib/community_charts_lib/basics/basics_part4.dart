import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import '../../core/chart_spec.dart';

class _TimeSeriesSales {
  final DateTime time;
  final int sales;

  _TimeSeriesSales(this.time, this.sales);
}

class _OrdinalSales {
  final String category;
  final int amount;

  _OrdinalSales(this.category, this.amount);
}

class _LinearSales {
  final int x;
  final int y;

  _LinearSales(this.x, this.y);
}

class _PieSlice {
  final String label;
  final int value;

  _PieSlice(this.label, this.value);
}

class _ScatterPoint {
  final int x;
  final int y;
  final double radius;

  _ScatterPoint(this.x, this.y, this.radius);
}

// ---------------------------------------------------------------------------
// 31. TimeSeriesChart — con rango de fechas
// ---------------------------------------------------------------------------
List<charts.Series<_TimeSeriesSales, DateTime>> _dateRangeTimeSeriesData() {
  final data = [
    _TimeSeriesSales(DateTime(2024, 1, 1), 18),
    _TimeSeriesSales(DateTime(2024, 1, 5), 24),
    _TimeSeriesSales(DateTime(2024, 1, 10), 30),
    _TimeSeriesSales(DateTime(2024, 1, 15), 22),
    _TimeSeriesSales(DateTime(2024, 1, 20), 40),
    _TimeSeriesSales(DateTime(2024, 1, 25), 35),
    _TimeSeriesSales(DateTime(2024, 1, 30), 45),
  ];
  return [
    charts.Series<_TimeSeriesSales, DateTime>(
      id: 'Ventas',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_TimeSeriesSales d, _) => d.time,
      measureFn: (_TimeSeriesSales d, _) => d.sales,
      data: data,
    ),
  ];
}

Widget _buildDateRangeTimeSeriesChart(BuildContext context) {
  return SizedBox(
    height: 320,
    // Restrict the visible viewport to a specific date range.
    child: charts.TimeSeriesChart(
      _dateRangeTimeSeriesData(),
      animate: true,
      domainAxis: charts.DateTimeAxisSpec(
        viewport: charts.DateTimeExtents(
          start: DateTime(2024, 1, 8),
          end: DateTime(2024, 1, 28),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 32. BarChart — etiquetas rotadas en eje X
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _rotatedLabelsBarData() {
  final data = [
    _OrdinalSales('Ingeniería', 42),
    _OrdinalSales('Marketing', 28),
    _OrdinalSales('Recursos Humanos', 15),
    _OrdinalSales('Atención al Cliente', 33),
    _OrdinalSales('Administración', 20),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Empleados',
      colorFn: (_, _) => charts.MaterialPalette.purple.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildRotatedLabelsBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _rotatedLabelsBarData(),
      animate: true,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 45,
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 33. LineChart — línea punteada (dash pattern)
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _dashedLineData() {
  final actual = [
    _LinearSales(0, 10),
    _LinearSales(1, 22),
    _LinearSales(2, 18),
    _LinearSales(3, 30),
  ];
  final forecast = [
    _LinearSales(0, 10),
    _LinearSales(1, 18),
    _LinearSales(2, 25),
    _LinearSales(3, 34),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Real',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: actual,
    ),
    charts.Series<_LinearSales, int>(
      id: 'Proyección',
      colorFn: (_, _) => charts.MaterialPalette.gray.shadeDefault,
      // Dash pattern renders this series as a dotted/dashed line.
      dashPatternFn: (_, _) => [4, 4],
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: forecast,
    ),
  ];
}

Widget _buildDashedLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _dashedLineData(),
      animate: true,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 34. BarChart — colores por segmento
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _segmentColoredBarData() {
  final palette = [
    charts.MaterialPalette.blue.shadeDefault,
    charts.MaterialPalette.red.shadeDefault,
    charts.MaterialPalette.green.shadeDefault,
    charts.MaterialPalette.purple.shadeDefault,
    charts.MaterialPalette.deepOrange.shadeDefault,
  ];
  final data = [
    _OrdinalSales('A', 25),
    _OrdinalSales('B', 40),
    _OrdinalSales('C', 18),
    _OrdinalSales('D', 32),
    _OrdinalSales('E', 27),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Segmentos',
      // Each bar gets its own color based on its position in the data.
      colorFn: (_OrdinalSales d, int? index) =>
          palette[(index ?? 0) % palette.length],
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildSegmentColoredBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _segmentColoredBarData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 35. PieChart — sector resaltado
// ---------------------------------------------------------------------------
List<charts.Series<_PieSlice, String>> _highlightedSectorPieData() {
  const highlighted = 'Premium';
  final data = [
    _PieSlice('Básico', 30),
    _PieSlice(highlighted, 45),
    _PieSlice('Estándar', 25),
  ];
  return [
    charts.Series<_PieSlice, String>(
      id: 'Planes',
      // Give the highlighted slice a distinct, brighter color than the rest.
      colorFn: (_PieSlice d, _) => d.label == highlighted
          ? charts.MaterialPalette.deepOrange.shadeDefault
          : charts.MaterialPalette.gray.shade300,
      domainFn: (_PieSlice d, _) => d.label,
      measureFn: (_PieSlice d, _) => d.value,
      labelAccessorFn: (_PieSlice d, _) => d.label,
      data: data,
    ),
  ];
}

Widget _buildHighlightedSectorPieChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.PieChart<String>(
      _highlightedSectorPieData(),
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
        charts.ArcLabelDecorator(
          labelPosition: charts.ArcLabelPosition.outside,
        ),
      ]),
    ),
  );
}

// ---------------------------------------------------------------------------
// 36. ScatterPlotChart — con línea de tendencia
// ---------------------------------------------------------------------------
List<charts.Series<_ScatterPoint, int>> _scatterWithTrendData() {
  final points = [
    _ScatterPoint(5, 12, 4.0),
    _ScatterPoint(12, 22, 4.0),
    _ScatterPoint(20, 18, 4.0),
    _ScatterPoint(28, 35, 4.0),
    _ScatterPoint(35, 30, 4.0),
    _ScatterPoint(42, 48, 4.0),
    _ScatterPoint(50, 44, 4.0),
  ];
  // Two endpoints describing a simple linear trend line across the data.
  final trend = [
    _ScatterPoint(0, 8, 0.0),
    _ScatterPoint(55, 52, 0.0),
  ];
  return [
    charts.Series<_ScatterPoint, int>(
      id: 'Observaciones',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      radiusPxFn: (_ScatterPoint d, _) => d.radius,
      data: points,
    ),
    charts.Series<_ScatterPoint, int>(
      id: 'Tendencia',
      colorFn: (_, _) => charts.MaterialPalette.deepOrange.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      data: trend,
    )
      // Route the trend line through a custom line renderer so it is drawn
      // as a continuous line rather than a set of points.
      ..setAttribute(charts.rendererIdKey, 'customLine'),
  ];
}

Widget _buildScatterWithTrendChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.ScatterPlotChart(
      _scatterWithTrendData(),
      animate: true,
      customSeriesRenderers: [
        charts.LineRendererConfig(customRendererId: 'customLine'),
      ],
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 37. LineChart — doble serie comparativa
// ---------------------------------------------------------------------------
// LineChart only supports a numeric domain, so months are represented as an
// index (0 = enero, 1 = febrero, ...).
List<charts.Series<_LinearSales, int>> _comparativeLineData() {
  final thisYear = [
    _LinearSales(0, 20),
    _LinearSales(1, 28),
    _LinearSales(2, 35),
    _LinearSales(3, 42),
  ];
  final lastYear = [
    _LinearSales(0, 15),
    _LinearSales(1, 24),
    _LinearSales(2, 30),
    _LinearSales(3, 33),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Este año',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: thisYear,
    ),
    charts.Series<_LinearSales, int>(
      id: 'Año anterior',
      colorFn: (_, _) => charts.MaterialPalette.gray.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: lastYear,
    ),
  ];
}

Widget _buildComparativeLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _comparativeLineData(),
      animate: true,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 38. BarChart — con línea de meta/umbral (RangeAnnotation)
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _thresholdBarData() {
  final data = [
    _OrdinalSales('Ene', 32),
    _OrdinalSales('Feb', 48),
    _OrdinalSales('Mar', 38),
    _OrdinalSales('Abr', 55),
    _OrdinalSales('May', 44),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Ventas',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildThresholdBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _thresholdBarData(),
      animate: true,
      behaviors: [
        charts.RangeAnnotation([
          charts.RangeAnnotationSegment(
            45,
            45,
            charts.RangeAnnotationAxisType.measure,
            startLabel: 'Meta: 45',
            color: charts.MaterialPalette.red.shadeDefault,
          ),
        ]),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// 39. BarChart — con tooltip personalizado
// ---------------------------------------------------------------------------
class _CustomTooltipBarChart extends StatefulWidget {
  const _CustomTooltipBarChart();

  @override
  State<_CustomTooltipBarChart> createState() =>
      _CustomTooltipBarChartState();
}

class _CustomTooltipBarChartState extends State<_CustomTooltipBarChart> {
  String? _selectedCategory;
  num? _selectedValue;

  static List<charts.Series<_OrdinalSales, String>> _data() {
    final data = [
      _OrdinalSales('Lun', 24),
      _OrdinalSales('Mar', 38),
      _OrdinalSales('Mié', 30),
      _OrdinalSales('Jue', 45),
      _OrdinalSales('Vie', 36),
    ];
    return [
      charts.Series<_OrdinalSales, String>(
        id: 'Pedidos',
        colorFn: (_, _) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (_OrdinalSales d, _) => d.category,
        measureFn: (_OrdinalSales d, _) => d.amount,
        data: data,
      ),
    ];
  }

  void _onSelectionChanged(charts.SelectionModel<String> model) {
    final selected = model.selectedDatum;
    setState(() {
      if (selected.isNotEmpty) {
        final datum = selected.first.datum as _OrdinalSales;
        _selectedCategory = datum.category;
        _selectedValue = datum.amount;
      } else {
        _selectedCategory = null;
        _selectedValue = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 270,
          child: charts.BarChart(
            _data(),
            animate: true,
            selectionModels: [
              charts.SelectionModelConfig<String>(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _selectedCategory != null
                ? '$_selectedCategory: $_selectedValue pedidos'
                : 'Toca una barra para ver el detalle',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

Widget _buildCustomTooltipBarChart(BuildContext context) {
  return const SizedBox(
    height: 320,
    child: _CustomTooltipBarChart(),
  );
}

// ---------------------------------------------------------------------------
// 40. ComboChart — barras apiladas + línea de total
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _stackedComboWithTotalData() {
  final online = [
    _OrdinalSales('Ene', 20),
    _OrdinalSales('Feb', 25),
    _OrdinalSales('Mar', 30),
    _OrdinalSales('Abr', 28),
  ];
  final tienda = [
    _OrdinalSales('Ene', 15),
    _OrdinalSales('Feb', 18),
    _OrdinalSales('Mar', 20),
    _OrdinalSales('Abr', 22),
  ];
  final total = [
    _OrdinalSales('Ene', 35),
    _OrdinalSales('Feb', 43),
    _OrdinalSales('Mar', 50),
    _OrdinalSales('Abr', 50),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Online',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: online,
    ),
    charts.Series<_OrdinalSales, String>(
      id: 'Tienda',
      colorFn: (_, _) => charts.MaterialPalette.teal.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: tienda,
    ),
    charts.Series<_OrdinalSales, String>(
      id: 'Total',
      colorFn: (_, _) => charts.MaterialPalette.black,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: total,
    )
      // Render the running total as a line above the stacked bars.
      ..setAttribute(charts.rendererIdKey, 'customLine'),
  ];
}

Widget _buildStackedComboWithTotalChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.OrdinalComboChart(
      _stackedComboWithTotalData(),
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.stacked,
      ),
      customSeriesRenderers: [
        charts.LineRendererConfig(customRendererId: 'customLine'),
      ],
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

final List<ChartSpec> communityBasicsPart4 = [
  ChartSpec(
    id: 'cc_b31',
    title: 'TimeSeriesChart — con rango de fechas',
    category: ChartCategory.basic,
    builder: _buildDateRangeTimeSeriesChart,
  ),
  ChartSpec(
    id: 'cc_b32',
    title: 'BarChart — etiquetas rotadas en eje X',
    category: ChartCategory.basic,
    builder: _buildRotatedLabelsBarChart,
  ),
  ChartSpec(
    id: 'cc_b33',
    title: 'LineChart — línea punteada (dash pattern)',
    category: ChartCategory.basic,
    builder: _buildDashedLineChart,
  ),
  ChartSpec(
    id: 'cc_b34',
    title: 'BarChart — colores por segmento',
    category: ChartCategory.basic,
    builder: _buildSegmentColoredBarChart,
  ),
  ChartSpec(
    id: 'cc_b35',
    title: 'PieChart — sector resaltado',
    category: ChartCategory.basic,
    builder: _buildHighlightedSectorPieChart,
  ),
  ChartSpec(
    id: 'cc_b36',
    title: 'ScatterPlotChart — con línea de tendencia',
    category: ChartCategory.basic,
    builder: _buildScatterWithTrendChart,
  ),
  ChartSpec(
    id: 'cc_b37',
    title: 'LineChart — doble serie comparativa',
    category: ChartCategory.basic,
    builder: _buildComparativeLineChart,
  ),
  ChartSpec(
    id: 'cc_b38',
    title: 'BarChart — con línea de meta/umbral (RangeAnnotation)',
    category: ChartCategory.basic,
    builder: _buildThresholdBarChart,
  ),
  ChartSpec(
    id: 'cc_b39',
    title: 'BarChart — con tooltip personalizado',
    category: ChartCategory.basic,
    builder: _buildCustomTooltipBarChart,
  ),
  ChartSpec(
    id: 'cc_b40',
    title: 'ComboChart — barras apiladas + línea de total',
    category: ChartCategory.basic,
    builder: _buildStackedComboWithTotalChart,
  ),
];
