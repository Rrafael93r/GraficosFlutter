import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import '../../core/chart_spec.dart';

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

  _ScatterPoint(this.x, this.y);
}

// ---------------------------------------------------------------------------
// 21. BarChart — valores negativos
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _negativeValuesBarData() {
  final data = [
    _OrdinalSales('Ene', 12),
    _OrdinalSales('Feb', -8),
    _OrdinalSales('Mar', 20),
    _OrdinalSales('Abr', -15),
    _OrdinalSales('May', 5),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Balance',
      colorFn: (_OrdinalSales d, _) => d.amount < 0
          ? charts.MaterialPalette.red.shadeDefault
          : charts.MaterialPalette.green.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildNegativeValuesBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _negativeValuesBarData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 22. BarChart — barra de rango (comparación)
// ---------------------------------------------------------------------------
// community_charts_flutter has no dedicated "range bar" renderer, so the
// comparison between a minimum and maximum value per category is approximated
// with a grouped bar chart of two series.
List<charts.Series<_OrdinalSales, String>> _rangeComparisonBarData() {
  final minimums = [
    _OrdinalSales('Lun', 12),
    _OrdinalSales('Mar', 18),
    _OrdinalSales('Mié', 10),
    _OrdinalSales('Jue', 20),
  ];
  final maximums = [
    _OrdinalSales('Lun', 28),
    _OrdinalSales('Mar', 35),
    _OrdinalSales('Mié', 22),
    _OrdinalSales('Jue', 40),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Mínimo',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault.lighter,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: minimums,
    ),
    charts.Series<_OrdinalSales, String>(
      id: 'Máximo',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: maximums,
    ),
  ];
}

Widget _buildRangeComparisonBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _rangeComparisonBarData(),
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 23. LineChart — con leyenda interactiva (selección de series)
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _interactiveLegendLineData() {
  final a = [
    _LinearSales(0, 10),
    _LinearSales(1, 22),
    _LinearSales(2, 18),
    _LinearSales(3, 30),
  ];
  final b = [
    _LinearSales(0, 25),
    _LinearSales(1, 15),
    _LinearSales(2, 32),
    _LinearSales(3, 20),
  ];
  final c = [
    _LinearSales(0, 5),
    _LinearSales(1, 28),
    _LinearSales(2, 12),
    _LinearSales(3, 35),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Equipo A',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: a,
    ),
    charts.Series<_LinearSales, int>(
      id: 'Equipo B',
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: b,
    ),
    charts.Series<_LinearSales, int>(
      id: 'Equipo C',
      colorFn: (_, _) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: c,
    ),
  ];
}

Widget _buildInteractiveLegendLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    // SeriesLegend defaults to LegendTapHandling.hide: tapping an entry
    // toggles the visibility of that series on the chart.
    child: charts.LineChart(
      _interactiveLegendLineData(),
      animate: true,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 24. BarChart — ranking ordenado
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _rankingBarData() {
  final data = [
    _OrdinalSales('Producto D', 18),
    _OrdinalSales('Producto A', 62),
    _OrdinalSales('Producto C', 35),
    _OrdinalSales('Producto B', 47),
    _OrdinalSales('Producto E', 24),
  ]..sort((a, b) => b.amount.compareTo(a.amount));

  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Ranking',
      colorFn: (_, _) => charts.MaterialPalette.cyan.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildRankingBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _rankingBarData(),
      animate: true,
      vertical: false,
      // Keep the sorted (ranked) order instead of the default alphabetical
      // ordinal ordering.
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 25. LineChart — tendencia animada
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _animatedTrendLineData() {
  final data = [
    _LinearSales(0, 8),
    _LinearSales(1, 14),
    _LinearSales(2, 19),
    _LinearSales(3, 27),
    _LinearSales(4, 36),
    _LinearSales(5, 48),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Crecimiento',
      colorFn: (_, _) => charts.MaterialPalette.deepOrange.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: data,
    ),
  ];
}

Widget _buildAnimatedTrendLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _animatedTrendLineData(),
      animate: true,
      animationDuration: const Duration(milliseconds: 1500),
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    ),
  );
}

// ---------------------------------------------------------------------------
// 26. BarChart — distribución por edad
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _ageDistributionBarData() {
  final data = [
    _OrdinalSales('0-17', 120),
    _OrdinalSales('18-24', 95),
    _OrdinalSales('25-34', 160),
    _OrdinalSales('35-44', 140),
    _OrdinalSales('45-59', 110),
    _OrdinalSales('60+', 70),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Personas',
      colorFn: (_, _) => charts.MaterialPalette.indigo.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      data: data,
    ),
  ];
}

Widget _buildAgeDistributionBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _ageDistributionBarData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 27. PieChart — distribución de presupuesto
// ---------------------------------------------------------------------------
List<charts.Series<_PieSlice, String>> _budgetPieData() {
  final data = [
    _PieSlice('Marketing', 30),
    _PieSlice('Desarrollo', 40),
    _PieSlice('Operaciones', 15),
    _PieSlice('Administración', 15),
  ];
  return [
    charts.Series<_PieSlice, String>(
      id: 'Presupuesto',
      domainFn: (_PieSlice d, _) => d.label,
      measureFn: (_PieSlice d, _) => d.value,
      data: data,
    ),
  ];
}

Widget _buildBudgetPieChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.PieChart<String>(
      _budgetPieData(),
      animate: true,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}

// ---------------------------------------------------------------------------
// 28. ScatterPlotChart — altura vs. peso
// ---------------------------------------------------------------------------
List<charts.Series<_ScatterPoint, int>> _heightWeightScatterData() {
  final data = [
    _ScatterPoint(150, 48),
    _ScatterPoint(158, 54),
    _ScatterPoint(162, 60),
    _ScatterPoint(167, 65),
    _ScatterPoint(172, 70),
    _ScatterPoint(178, 78),
    _ScatterPoint(183, 85),
    _ScatterPoint(190, 92),
  ];
  return [
    charts.Series<_ScatterPoint, int>(
      id: 'Altura (cm) vs. Peso (kg)',
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (_ScatterPoint d, _) => d.x,
      measureFn: (_ScatterPoint d, _) => d.y,
      data: data,
    ),
  ];
}

Widget _buildHeightWeightScatterChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.ScatterPlotChart(
      _heightWeightScatterData(),
      animate: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// 29. LineChart — temperatura por hora
// ---------------------------------------------------------------------------
List<charts.Series<_LinearSales, int>> _hourlyTemperatureLineData() {
  final data = [
    _LinearSales(0, 14),
    _LinearSales(3, 12),
    _LinearSales(6, 13),
    _LinearSales(9, 18),
    _LinearSales(12, 24),
    _LinearSales(15, 26),
    _LinearSales(18, 21),
    _LinearSales(21, 16),
  ];
  return [
    charts.Series<_LinearSales, int>(
      id: 'Temperatura (°C)',
      colorFn: (_, _) => charts.MaterialPalette.deepOrange.shadeDefault,
      domainFn: (_LinearSales d, _) => d.x,
      measureFn: (_LinearSales d, _) => d.y,
      data: data,
    ),
  ];
}

Widget _buildHourlyTemperatureLineChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.LineChart(
      _hourlyTemperatureLineData(),
      animate: true,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    ),
  );
}

// ---------------------------------------------------------------------------
// 30. BarChart — asistencia semanal
// ---------------------------------------------------------------------------
List<charts.Series<_OrdinalSales, String>> _weeklyAttendanceBarData() {
  final data = [
    _OrdinalSales('Lun', 92),
    _OrdinalSales('Mar', 88),
    _OrdinalSales('Mié', 95),
    _OrdinalSales('Jue', 80),
    _OrdinalSales('Vie', 70),
  ];
  return [
    charts.Series<_OrdinalSales, String>(
      id: 'Asistencia (%)',
      colorFn: (_, _) => charts.MaterialPalette.teal.shadeDefault,
      domainFn: (_OrdinalSales d, _) => d.category,
      measureFn: (_OrdinalSales d, _) => d.amount,
      labelAccessorFn: (_OrdinalSales d, _) => '${d.amount}%',
      data: data,
    ),
  ];
}

Widget _buildWeeklyAttendanceBarChart(BuildContext context) {
  return SizedBox(
    height: 320,
    child: charts.BarChart(
      _weeklyAttendanceBarData(),
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    ),
  );
}

final List<ChartSpec> communityBasicsPart3 = [
  ChartSpec(
    id: 'cc_b21',
    title: 'BarChart — valores negativos',
    category: ChartCategory.basic,
    builder: _buildNegativeValuesBarChart,
  ),
  ChartSpec(
    id: 'cc_b22',
    title: 'BarChart — barra de rango (comparación)',
    category: ChartCategory.basic,
    builder: _buildRangeComparisonBarChart,
  ),
  ChartSpec(
    id: 'cc_b23',
    title: 'LineChart — con leyenda interactiva (selección de series)',
    category: ChartCategory.basic,
    builder: _buildInteractiveLegendLineChart,
  ),
  ChartSpec(
    id: 'cc_b24',
    title: 'BarChart — ranking ordenado',
    category: ChartCategory.basic,
    builder: _buildRankingBarChart,
  ),
  ChartSpec(
    id: 'cc_b25',
    title: 'LineChart — tendencia animada',
    category: ChartCategory.basic,
    builder: _buildAnimatedTrendLineChart,
  ),
  ChartSpec(
    id: 'cc_b26',
    title: 'BarChart — distribución por edad',
    category: ChartCategory.basic,
    builder: _buildAgeDistributionBarChart,
  ),
  ChartSpec(
    id: 'cc_b27',
    title: 'PieChart — distribución de presupuesto',
    category: ChartCategory.basic,
    builder: _buildBudgetPieChart,
  ),
  ChartSpec(
    id: 'cc_b28',
    title: 'ScatterPlotChart — altura vs. peso',
    category: ChartCategory.basic,
    builder: _buildHeightWeightScatterChart,
  ),
  ChartSpec(
    id: 'cc_b29',
    title: 'LineChart — temperatura por hora',
    category: ChartCategory.basic,
    builder: _buildHourlyTemperatureLineChart,
  ),
  ChartSpec(
    id: 'cc_b30',
    title: 'BarChart — asistencia semanal',
    category: ChartCategory.basic,
    builder: _buildWeeklyAttendanceBarChart,
  ),
];
