import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/chart_spec.dart';

// ---------------------------------------------------------------------------
// Shared helpers (kept file-local on purpose; each basics_partN.dart file is
// self-contained so these are small, private, and duplicated per file).
// ---------------------------------------------------------------------------

class _LegendItem {
  final String label;
  final Color color;

  const _LegendItem(this.label, this.color);
}

Widget _legendRow(List<_LegendItem> items) {
  return Wrap(
    alignment: WrapAlignment.center,
    spacing: 14,
    runSpacing: 4,
    children: items
        .map(
          (item) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(item.label, style: const TextStyle(fontSize: 11)),
            ],
          ),
        )
        .toList(),
  );
}

Widget _chartCard({required Widget chart, Widget? legend}) {
  return SizedBox(
    height: 320,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Expanded(child: chart),
          if (legend != null) ...[
            const SizedBox(height: 8),
            legend,
          ],
        ],
      ),
    ),
  );
}

AxisTitles _hiddenAxis() =>
    const AxisTitles(sideTitles: SideTitles(showTitles: false));

AxisTitles _bottomAxis(List<String> labels, {double reservedSize = 28}) {
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: reservedSize,
      interval: 1,
      getTitlesWidget: (value, meta) {
        final index = value.round();
        if (index < 0 || index >= labels.length) {
          return const SizedBox.shrink();
        }
        return SideTitleWidget(
          meta: meta,
          child: Text(labels[index], style: const TextStyle(fontSize: 10)),
        );
      },
    ),
  );
}

AxisTitles _leftAxis({double reservedSize = 36}) {
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: reservedSize,
      getTitlesWidget: (value, meta) => SideTitleWidget(
        meta: meta,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 10),
        ),
      ),
    ),
  );
}

FlTitlesData _basicTitles(List<String> bottomLabels) => FlTitlesData(
  topTitles: _hiddenAxis(),
  rightTitles: _hiddenAxis(),
  leftTitles: _leftAxis(),
  bottomTitles: _bottomAxis(bottomLabels),
);

// ---------------------------------------------------------------------------
// 1. Línea — ventas (serie simple)
// ---------------------------------------------------------------------------

Widget _chart01(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  const values = [12.0, 19.0, 14.0, 25.0, 22.0, 30.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 35,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            color: Colors.indigo,
            barWidth: 3,
            dotData: const FlDotData(),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 2. Línea — temperatura (curva suave)
// ---------------------------------------------------------------------------

Widget _chart02(BuildContext context) {
  const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const values = [18.0, 20.0, 19.0, 23.0, 25.0, 24.0, 21.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 10,
        maxY: 30,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            color: Colors.deepOrange,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.deepOrange.withValues(alpha: 0.18),
            ),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 3. Línea — con puntos destacados
// ---------------------------------------------------------------------------

Widget _chart03(BuildContext context) {
  const labels = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'];
  const values = [10.0, 15.0, 9.0, 22.0, 13.0, 18.0];
  final maxIndex = values.indexOf(values.reduce((a, b) => a > b ? a : b));
  final minIndex = values.indexOf(values.reduce((a, b) => a < b ? a : b));

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 26,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            color: Colors.teal,
            barWidth: 2.5,
            dotData: FlDotData(
              getDotPainter: (spot, percent, bar, index) {
                if (index == maxIndex) {
                  return FlDotCirclePainter(
                    radius: 7,
                    color: Colors.green,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                if (index == minIndex) {
                  return FlDotCirclePainter(
                    radius: 7,
                    color: Colors.redAccent,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(
                  radius: 3,
                  color: Colors.teal,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Máximo', Colors.green),
      _LegendItem('Mínimo', Colors.redAccent),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 4. Línea — estilo punteado
// ---------------------------------------------------------------------------

Widget _chart04(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  const values = [500.0, 620.0, 700.0, 810.0, 880.0, 950.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 400,
        maxY: 1000,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            color: Colors.purple,
            barWidth: 3,
            dashArray: const [8, 4],
            dotData: const FlDotData(show: false),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 5. Multilínea — comparativo 2 series
// ---------------------------------------------------------------------------

Widget _chart05(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  const ingresos = [40.0, 45.0, 42.0, 50.0, 55.0, 60.0];
  const gastos = [30.0, 32.0, 35.0, 33.0, 38.0, 40.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 65,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < ingresos.length; i++)
                FlSpot(i.toDouble(), ingresos[i]),
            ],
            color: Colors.green,
            barWidth: 2.5,
            dotData: const FlDotData(),
          ),
          LineChartBarData(
            spots: [
              for (var i = 0; i < gastos.length; i++)
                FlSpot(i.toDouble(), gastos[i]),
            ],
            color: Colors.redAccent,
            barWidth: 2.5,
            dotData: const FlDotData(),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Ingresos', Colors.green),
      _LegendItem('Gastos', Colors.redAccent),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 6. Multilínea — comparativo 3 series
// ---------------------------------------------------------------------------

Widget _chart06(BuildContext context) {
  const labels = ['Q1', 'Q2', 'Q3', 'Q4', 'Q5'];
  const productoA = [20.0, 24.0, 22.0, 28.0, 30.0];
  const productoB = [15.0, 18.0, 20.0, 19.0, 23.0];
  const productoC = [10.0, 12.0, 14.0, 17.0, 16.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 32,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < productoA.length; i++)
                FlSpot(i.toDouble(), productoA[i]),
            ],
            color: Colors.blue,
            barWidth: 2.5,
            dotData: const FlDotData(),
          ),
          LineChartBarData(
            spots: [
              for (var i = 0; i < productoB.length; i++)
                FlSpot(i.toDouble(), productoB[i]),
            ],
            color: Colors.orange,
            barWidth: 2.5,
            dotData: const FlDotData(),
          ),
          LineChartBarData(
            spots: [
              for (var i = 0; i < productoC.length; i++)
                FlSpot(i.toDouble(), productoC[i]),
            ],
            color: Colors.purple,
            barWidth: 2.5,
            dotData: const FlDotData(),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Producto A', Colors.blue),
      _LegendItem('Producto B', Colors.orange),
      _LegendItem('Producto C', Colors.purple),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 7. Área — serie simple (relleno bajo la línea)
// ---------------------------------------------------------------------------

Widget _chart07(BuildContext context) {
  const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const values = [120.0, 150.0, 130.0, 170.0, 200.0, 240.0, 210.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 260,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blueAccent.withValues(alpha: 0.35),
            ),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 8. Área — relleno degradado
// ---------------------------------------------------------------------------

Widget _chart08(BuildContext context) {
  const labels = ['00h', '04h', '08h', '12h', '16h', '20h'];
  const values = [20.0, 15.0, 45.0, 80.0, 65.0, 30.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            color: Colors.purple,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple.withValues(alpha: 0.5),
                  Colors.purple.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 9. Área apilada
// ---------------------------------------------------------------------------

Widget _chart09(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  const online = [12.0, 15.0, 14.0, 18.0, 20.0, 22.0];
  const tienda = [8.0, 9.0, 11.0, 10.0, 12.0, 13.0];
  final total = [for (var i = 0; i < online.length; i++) online[i] + tienda[i]];

  final lineOnline = LineChartBarData(
    spots: [
      for (var i = 0; i < online.length; i++) FlSpot(i.toDouble(), online[i]),
    ],
    color: Colors.blueAccent,
    barWidth: 2,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.blueAccent.withValues(alpha: 0.55),
    ),
  );
  final lineTotal = LineChartBarData(
    spots: [
      for (var i = 0; i < total.length; i++) FlSpot(i.toDouble(), total[i]),
    ],
    color: Colors.orangeAccent,
    barWidth: 2,
    dotData: const FlDotData(show: false),
  );

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 40,
        lineBarsData: [lineOnline, lineTotal],
        betweenBarsData: [
          BetweenBarsData(
            fromIndex: 0,
            toIndex: 1,
            color: Colors.orangeAccent.withValues(alpha: 0.55),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Online', Colors.blueAccent),
      _LegendItem('Tienda', Colors.orangeAccent),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 10. Barras — vertical simple
// ---------------------------------------------------------------------------

Widget _chart10(BuildContext context) {
  const labels = ['Teclado', 'Mouse', 'Monitor', 'Audífonos', 'Webcam'];
  const values = [32.0, 48.0, 20.0, 27.0, 15.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 55,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: Colors.cyan,
                  width: 22,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Catalog export
// ---------------------------------------------------------------------------

final List<ChartSpec> flBasicsPart1 = [
  ChartSpec(
    id: 'fl_b01',
    title: 'Línea — ventas (serie simple)',
    category: ChartCategory.basic,
    builder: _chart01,
  ),
  ChartSpec(
    id: 'fl_b02',
    title: 'Línea — temperatura (curva suave)',
    category: ChartCategory.basic,
    builder: _chart02,
  ),
  ChartSpec(
    id: 'fl_b03',
    title: 'Línea — con puntos destacados',
    category: ChartCategory.basic,
    builder: _chart03,
  ),
  ChartSpec(
    id: 'fl_b04',
    title: 'Línea — estilo punteado',
    category: ChartCategory.basic,
    builder: _chart04,
  ),
  ChartSpec(
    id: 'fl_b05',
    title: 'Multilínea — comparativo 2 series',
    category: ChartCategory.basic,
    builder: _chart05,
  ),
  ChartSpec(
    id: 'fl_b06',
    title: 'Multilínea — comparativo 3 series',
    category: ChartCategory.basic,
    builder: _chart06,
  ),
  ChartSpec(
    id: 'fl_b07',
    title: 'Área — serie simple (relleno bajo la línea)',
    category: ChartCategory.basic,
    builder: _chart07,
  ),
  ChartSpec(
    id: 'fl_b08',
    title: 'Área — relleno degradado',
    category: ChartCategory.basic,
    builder: _chart08,
  ),
  ChartSpec(
    id: 'fl_b09',
    title: 'Área apilada',
    category: ChartCategory.basic,
    builder: _chart09,
  ),
  ChartSpec(
    id: 'fl_b10',
    title: 'Barras — vertical simple',
    category: ChartCategory.basic,
    builder: _chart10,
  ),
];
