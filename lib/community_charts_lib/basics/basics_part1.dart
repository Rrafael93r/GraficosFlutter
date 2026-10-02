import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import '../../core/chart_spec.dart';

/// Simple ordinal sample data point (e.g. category + amount).
class _OrdinalSales {
  final String category;
  final int amount;

  _OrdinalSales(this.category, this.amount);
}

/// Simple linear/numeric sample data point.
class _LinearSales {
  final int x;
  final int y;

  _LinearSales(this.x, this.y);
}

// ---------------------------------------------------------------------------
// 1. BarChart — simple (vertical)
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _simpleBarData() {
  final data = [
    _OrdinalSales('Lun', 15),
    _OrdinalSales('Mar', 32),
    _OrdinalSales('Mié', 21),
    _OrdinalSales('Jue', 40),
    _OrdinalSales('Vie', 28),
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

Widget _buildSimpleBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _simpleBarData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 2. BarChart — horizontal
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _horizontalBarData() {
  final data = [
    _OrdinalSales('Norte', 55),
    _OrdinalSales('Sur', 38),
    _OrdinalSales('Este', 72),
    _OrdinalSales('Oeste', 46),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Regiones',
      colorFn: (_, _) => charts.MaterialPalette.teal.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildHorizontalBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _horizontalBarData(),
      animate: true,
      vertical: false,
    ),
  );
}

// ---------------------------------------------------------------------------
// 3. BarChart — agrupado
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _groupedBarData() {
  final desktop = [
    _OrdinalSales('2021', 25),
    _OrdinalSales('2022', 45),
    _OrdinalSales('2023', 60),
    _OrdinalSales('2024', 50),
  ];
  final mobile = [
    _OrdinalSales('2021', 40),
    _OrdinalSales('2022', 30),
    _OrdinalSales('2023', 55),
    _OrdinalSales('2024', 70),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Escritorio',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: desktop,
    ),
    charts.Series<_OrdinalSales, String>(
      id: 'Móvil',
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: mobile,
    ),
  ];
}

Widget _buildGroupedBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _groupedBarData(),
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 4. BarChart — apilado
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _stackedBarData() {
  final desktop = [
    _OrdinalSales('2021', 25),
    _OrdinalSales('2022', 45),
    _OrdinalSales('2023', 60),
    _OrdinalSales('2024', 50),
  ];
  final mobile = [
    _OrdinalSales('2021', 40),
    _OrdinalSales('2022', 30),
    _OrdinalSales('2023', 55),
    _OrdinalSales('2024', 70),
  ];
  final tablet = [
    _OrdinalSales('2021', 10),
    _OrdinalSales('2022', 15),
    _OrdinalSales('2023', 12),
    _OrdinalSales('2024', 18),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Escritorio',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: desktop,
    ),
    charts.Series<_OrdinalSales, String>(
      id: 'Móvil',
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: mobile,
    ),
    charts.Series<_OrdinalSales, String>(
      id: 'Tablet',
      colorFn: (_, _) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: tablet,
    ),
  ];
}

Widget _buildStackedBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _stackedBarData(),
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 5. BarChart — con etiquetas de datos
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _labeledBarData() {
  final data = [
    _OrdinalSales('Ene', 12),
    _OrdinalSales('Feb', 28),
    _OrdinalSales('Mar', 45),
    _OrdinalSales('Abr', 33),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Pedidos',
      colorFn: (_, _) => charts.MaterialPalette.purple.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      labelAccessorFn: (_OrdinalSales d, _) => '${d.amount}',
      data: data,
    ),
  ];
}

Widget _buildLabeledBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _labeledBarData(),
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(),
    ),
  );
}

// ---------------------------------------------------------------------------
// 6. BarChart — eje invertido
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _invertedAxisBarData() {
  final data = [
    _OrdinalSales('A', 20),
    _OrdinalSales('B', 55),
    _OrdinalSales('C', 35),
    _OrdinalSales('D', 65),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Valores',
      colorFn: (_, _) => charts.MaterialPalette.deepOrange.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildInvertedAxisBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    // flipVerticalAxis inverts the measure axis direction, so bars grow
    // from the top down instead of bottom up.
    child: charts.BarChart(
      _invertedAxisBarData(),
      animate: true,
      flipVerticalAxis: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 7. LineChart — ventas
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _salesLineData() {
  final data = [
    _LinearSales(0, 5),
    _LinearSales(1, 25),
    _LinearSales(2, 100),
    _LinearSales(3, 75),
    _LinearSales(4, 90),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Ventas',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: data,
    ),
  ];
}

Widget _buildSalesLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _salesLineData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 8. LineChart — multi-serie
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _multiSeriesLineData() {
  final a = [
    _LinearSales(0, 5),
    _LinearSales(1, 25),
    _LinearSales(2, 60),
    _LinearSales(3, 40),
  ];
  final b = [
    _LinearSales(0, 15),
    _LinearSales(1, 35),
    _LinearSales(2, 20),
    _LinearSales(3, 55),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Producto A',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: a,
    ),
    charts.Series<_LinearSales, int>(
      id: 'Producto B',
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: b,
    ),
  ];
}

Widget _buildMultiSeriesLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _multiSeriesLineData(),
      animate: true,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 9. LineChart — área rellena
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _filledAreaLineData() {
  final data = [
    _LinearSales(0, 10),
    _LinearSales(1, 30),
    _LinearSales(2, 22),
    _LinearSales(3, 45),
    _LinearSales(4, 38),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Tráfico',
      colorFn: (_, _) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: data,
    ),
  ];
}

Widget _buildFilledAreaLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _filledAreaLineData(),
      animate: true,
      defaultRenderer: charts.LineRendererConfig(includeArea: true),
    ),
  );
}

// ---------------------------------------------------------------------------
// 10. LineChart — con puntos (symbol renderer)
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _pointsLineData() {
  final data = [
    _LinearSales(0, 5),
    _LinearSales(1, 25),
    _LinearSales(2, 100),
    _LinearSales(3, 75),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Sesiones',
      colorFn: (_, _) => charts.MaterialPalette.indigo.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: data,
    ),
  ];
}

Widget _buildPointsLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _pointsLineData(),
      animate: true,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    ),
  );
}

final List<ChartSpec> communityBasicsPart1 = [
  ChartSpec(
    id: 'cc_b01',
    title: 'BarChart — simple (vertical)',
    category: ChartCategory.basic,
    builder: _buildSimpleBarChart,
  ),
  ChartSpec(
    id: 'cc_b02',
    title: 'BarChart — horizontal',
    category: ChartCategory.basic,
    builder: _buildHorizontalBarChart,
  ),
  ChartSpec(
    id: 'cc_b03',
    title: 'BarChart — agrupado',
    category: ChartCategory.basic,
    builder: _buildGroupedBarChart,
  ),
  ChartSpec(
    id: 'cc_b04',
    title: 'BarChart — apilado',
    category: ChartCategory.basic,
    builder: _buildStackedBarChart,
  ),
  ChartSpec(
    id: 'cc_b05',
    title: 'BarChart — con etiquetas de datos',
    category: ChartCategory.basic,
    builder: _buildLabeledBarChart,
  ),
  ChartSpec(
    id: 'cc_b06',
    title: 'BarChart — eje invertido',
    category: ChartCategory.basic,
    builder: _buildInvertedAxisBarChart,
  ),
  ChartSpec(
    id: 'cc_b07',
    title: 'LineChart — ventas',
    category: ChartCategory.basic,
    builder: _buildSalesLineChart,
  ),
  ChartSpec(
    id: 'cc_b08',
    title: 'LineChart — multi-serie',
    category: ChartCategory.basic,
    builder: _buildMultiSeriesLineChart,
  ),
  ChartSpec(
    id: 'cc_b09',
    title: 'LineChart — área rellena',
    category: ChartCategory.basic,
    builder: _buildFilledAreaLineChart,
  ),
  ChartSpec(
    id: 'cc_b10',
    title: 'LineChart — con puntos (symbol renderer)',
    category: ChartCategory.basic,
    builder: _buildPointsLineChart,
  ),
];
