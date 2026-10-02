import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import '../../core/chart_spec.dart';

class _TimeSeriesSales {
  final DateTime time;
  final int sales;

  _TimeSeriesSales(this.time, this.sales);
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

// ---------------------------------------------------------------------------
// 11. TimeSeriesChart — ventas diarias
// ---------------------------------------------------------------------------
List<charts.Series<_TimeSeriesSales, DateTime>> _dailySalesData() {
  final data = [
    _TimeSeriesSales(DateTime(2024, 1, 1), 20),
    _TimeSeriesSales(DateTime(2024, 1, 2), 35),
    _TimeSeriesSales(DateTime(2024, 1, 3), 28),
    _TimeSeriesSales(DateTime(2024, 1, 4), 45),
    _TimeSeriesSales(DateTime(2024, 1, 5), 38),
    _TimeSeriesSales(DateTime(2024, 1, 6), 52),
    _TimeSeriesSales(DateTime(2024, 1, 7), 47),
  ];
  return [
    charts.Series<_TimeSeriesSales, DateTime>(
      id: 'Ventas diarias',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_TimeSeriesSales d, _) => d.time,
      measureFn: (_TimeSeriesSales d, _) => d.sales,
      data: data,
    ),
  ];
}

Widget _buildDailyTimeSeriesChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.TimeSeriesChart(
      _dailySalesData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 12. TimeSeriesChart — multi-serie temporal
// ---------------------------------------------------------------------------
List<charts.Series<_TimeSeriesSales, DateTime>> _multiTimeSeriesData() {
  final store1 = [
    _TimeSeriesSales(DateTime(2024, 1, 1), 15),
    _TimeSeriesSales(DateTime(2024, 1, 2), 25),
    _TimeSeriesSales(DateTime(2024, 1, 3), 20),
    _TimeSeriesSales(DateTime(2024, 1, 4), 32),
  ];
  final store2 = [
    _TimeSeriesSales(DateTime(2024, 1, 1), 22),
    _TimeSeriesSales(DateTime(2024, 1, 2), 18),
    _TimeSeriesSales(DateTime(2024, 1, 3), 30),
    _TimeSeriesSales(DateTime(2024, 1, 4), 27),
  ];
  return [
    charts.Series<_TimeSeriesSales, DateTime>(
      id: 'Tienda Centro',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_TimeSeriesSales d, _) => d.time,
      measureFn: (_TimeSeriesSales d, _) => d.sales,
      data: store1,
    ),
    charts.Series<_TimeSeriesSales, DateTime>(
      id: 'Tienda Norte',
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (_TimeSeriesSales d, _) => d.time,
      measureFn: (_TimeSeriesSales d, _) => d.sales,
      data: store2,
    ),
  ];
}

Widget _buildMultiTimeSeriesChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.TimeSeriesChart(
      _multiTimeSeriesData(),
      animate: true,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 13. PieChart — porcentajes
// ---------------------------------------------------------------------------
List<charts.Series<_PieSlice, String>> _percentagePieData() {
  final data = [
    _PieSlice('Android', 45),
    _PieSlice('iOS', 35),
    _PieSlice('Otros', 20),
  ];
  final total = data.fold<int>(0, (sum, d) => sum + d.value);
  return [
    charts.Series<_PieSlice, String>(
      id: 'Plataformas',
      domainFn: (_PieSlice d, _) => d.label,
      measureFn: (_PieSlice d, _) => d.value,
      labelAccessorFn: (_PieSlice d, _) =>
          '${(d.value * 100 / total).round()}%',
      data: data,
    ),
  ];
}

Widget _buildPercentagePieChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.PieChart<String>(
      _percentagePieData(),
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
        charts.ArcLabelDecorator(),
      ]),
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 14. PieChart — dona (arcWidth)
// ---------------------------------------------------------------------------
List<charts.Series<_PieSlice, String>> _donutPieData() {
  final data = [
    _PieSlice('Alquiler', 40),
    _PieSlice('Comida', 25),
    _PieSlice('Transporte', 15),
    _PieSlice('Ocio', 20),
  ];
  return [
    charts.Series<_PieSlice, String>(
      id: 'Gastos',
      domainFn: (_PieSlice d, _) => d.label,
      measureFn: (_PieSlice d, _) => d.value,
      data: data,
    ),
  ];
}

Widget _buildDonutPieChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.PieChart<String>(
      _donutPieData(),
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(arcWidth: 60),
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 15. PieChart — etiquetas externas
// ---------------------------------------------------------------------------
List<charts.Series<_PieSlice, String>> _outsideLabelPieData() {
  final data = [
    _PieSlice('Norte', 30),
    _PieSlice('Sur', 20),
    _PieSlice('Este', 25),
    _PieSlice('Oeste', 25),
  ];
  return [
    charts.Series<_PieSlice, String>(
      id: 'Regiones',
      domainFn: (_PieSlice d, _) => d.label,
      measureFn: (_PieSlice d, _) => d.value,
      labelAccessorFn: (_PieSlice d, _) => '${d.label}: ${d.value}',
      data: data,
    ),
  ];
}

Widget _buildOutsideLabelPieChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.PieChart<String>(
      _outsideLabelPieData(),
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
// 16. ScatterPlotChart — simple
// ---------------------------------------------------------------------------
List<charts.Series<_ScatterPoint, int>> _simpleScatterData() {
  final data = [
    _ScatterPoint(5, 12, 4.0),
    _ScatterPoint(12, 25, 4.0),
    _ScatterPoint(20, 18, 4.0),
    _ScatterPoint(28, 40, 4.0),
    _ScatterPoint(35, 30, 4.0),
    _ScatterPoint(42, 55, 4.0),
  ];
  return [
    charts.Series<_ScatterPoint, int>(
      id: 'Mediciones',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      radiusPxFn: (_ScatterPoint d, _) => d.radius,
      data: data,
    ),
  ];
}

Widget _buildSimpleScatterChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.ScatterPlotChart(
      _simpleScatterData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 17. ScatterPlotChart — burbuja (tamaño variable)
// ---------------------------------------------------------------------------
List<charts.Series<_ScatterPoint, int>> _bubbleScatterData() {
  final data = [
    _ScatterPoint(10, 20, 3.0),
    _ScatterPoint(20, 35, 6.0),
    _ScatterPoint(30, 15, 9.0),
    _ScatterPoint(40, 45, 12.0),
    _ScatterPoint(50, 30, 15.0),
    _ScatterPoint(60, 50, 8.0),
  ];
  return [
    charts.Series<_ScatterPoint, int>(
      id: 'Población por ciudad',
      colorFn: (_, _) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      // Providing a radius function makes the point size vary (bubble chart).
      radiusPxFn: (_ScatterPoint d, _) => d.radius,
      data: data,
    ),
  ];
}

Widget _buildBubbleScatterChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.ScatterPlotChart(
      _bubbleScatterData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 18. ScatterPlotChart — coloreado por categoría
// ---------------------------------------------------------------------------
List<charts.Series<_ScatterPoint, int>> _categoryColoredScatterData() {
  final categoryA = [
    _ScatterPoint(5, 10, 5.0),
    _ScatterPoint(15, 22, 5.0),
    _ScatterPoint(25, 14, 5.0),
  ];
  final categoryB = [
    _ScatterPoint(8, 30, 5.0),
    _ScatterPoint(18, 42, 5.0),
    _ScatterPoint(30, 36, 5.0),
  ];
  final categoryC = [
    _ScatterPoint(12, 50, 5.0),
    _ScatterPoint(22, 58, 5.0),
    _ScatterPoint(34, 48, 5.0),
  ];
  return [
    charts.Series<_ScatterPoint, int>(
      id: 'Categoría A',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      radiusPxFn: (_ScatterPoint d, _) => d.radius,
      data: categoryA,
    ),
    charts.Series<_ScatterPoint, int>(
      id: 'Categoría B',
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      radiusPxFn: (_ScatterPoint d, _) => d.radius,
      data: categoryB,
    ),
    charts.Series<_ScatterPoint, int>(
      id: 'Categoría C',
      colorFn: (_, _) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      radiusPxFn: (_ScatterPoint d, _) => d.radius,
      data: categoryC,
    ),
  ];
}

Widget _buildCategoryColoredScatterChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.ScatterPlotChart(
      _categoryColoredScatterData(),
      animate: true,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 19. ComboChart ordinal — barra + línea
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _ordinalComboData() {
  final bars = [
    _OrdinalSales('2021', 20),
    _OrdinalSales('2022', 35),
    _OrdinalSales('2023', 42),
    _OrdinalSales('2024', 50),
  ];
  final line = [
    _OrdinalSales('2021', 25),
    _OrdinalSales('2022', 30),
    _OrdinalSales('2023', 38),
    _OrdinalSales('2024', 45),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Ingresos',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: bars,
    ),
    charts.Series<_OrdinalSales, String>(
      id: 'Meta',
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: line,
    )
      // Route this series through the custom line renderer registered below.
      ..setAttribute(charts.rendererIdKey, 'customLine'),
  ];
}

Widget _buildOrdinalComboChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.OrdinalComboChart(
      _ordinalComboData(),
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
      ),
      customSeriesRenderers: [
        charts.LineRendererConfig(customRendererId: 'customLine'),
      ],
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 20. ComboChart numérico — barra + línea
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, num>> _numericComboData() {
  final bars = [
    _LinearSales(0, 15),
    _LinearSales(1, 28),
    _LinearSales(2, 22),
    _LinearSales(3, 40),
  ];
  final line = [
    _LinearSales(0, 18),
    _LinearSales(1, 24),
    _LinearSales(2, 30),
    _LinearSales(3, 35),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Unidades',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: bars,
    )
      // Route this series through the custom bar renderer registered below.
      ..setAttribute(charts.rendererIdKey, 'customBar'),
    charts.Series<_LinearSales, int>(
      id: 'Promedio móvil',
      colorFn: (_, _) => charts.MaterialPalette.deepOrange.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: line,
    ),
  ];
}

Widget _buildNumericComboChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.NumericComboChart(
      _numericComboData(),
      animate: true,
      // The default renderer (line) applies to series with no rendererIdKey.
      defaultRenderer: charts.LineRendererConfig(),
      customSeriesRenderers: [
        charts.BarRendererConfig(customRendererId: 'customBar'),
      ],
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

final List<ChartSpec> communityBasicsPart2 = [
  ChartSpec(
    id: 'cc_b11',
    title: 'TimeSeriesChart — ventas diarias',
    category: ChartCategory.basic,
    builder: _buildDailyTimeSeriesChart,
  ),
  ChartSpec(
    id: 'cc_b12',
    title: 'TimeSeriesChart — multi-serie temporal',
    category: ChartCategory.basic,
    builder: _buildMultiTimeSeriesChart,
  ),
  ChartSpec(
    id: 'cc_b13',
    title: 'PieChart — porcentajes',
    category: ChartCategory.basic,
    builder: _buildPercentagePieChart,
  ),
  ChartSpec(
    id: 'cc_b14',
    title: 'PieChart — dona (arcWidth)',
    category: ChartCategory.basic,
    builder: _buildDonutPieChart,
  ),
  ChartSpec(
    id: 'cc_b15',
    title: 'PieChart — etiquetas externas',
    category: ChartCategory.basic,
    builder: _buildOutsideLabelPieChart,
  ),
  ChartSpec(
    id: 'cc_b16',
    title: 'ScatterPlotChart — simple',
    category: ChartCategory.basic,
    builder: _buildSimpleScatterChart,
  ),
  ChartSpec(
    id: 'cc_b17',
    title: 'ScatterPlotChart — burbuja (tamaño variable)',
    category: ChartCategory.basic,
    builder: _buildBubbleScatterChart,
  ),
  ChartSpec(
    id: 'cc_b18',
    title: 'ScatterPlotChart — coloreado por categoría',
    category: ChartCategory.basic,
    builder: _buildCategoryColoredScatterChart,
  ),
  ChartSpec(
    id: 'cc_b19',
    title: 'ComboChart ordinal — barra + línea',
    category: ChartCategory.basic,
    builder: _buildOrdinalComboChart,
  ),
  ChartSpec(
    id: 'cc_b20',
    title: 'ComboChart numérico — barra + línea',
    category: ChartCategory.basic,
    builder: _buildNumericComboChart,
  ),
];
