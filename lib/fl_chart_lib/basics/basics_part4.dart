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

AxisTitles _numericAxis({
  double reservedSize = 32,
  double? interval,
  String Function(double)? formatter,
}) {
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: reservedSize,
      interval: interval,
      getTitlesWidget: (value, meta) => SideTitleWidget(
        meta: meta,
        child: Text(
          formatter != null ? formatter(value) : value.toStringAsFixed(0),
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
// 31. Barras — ventas mensuales
// ---------------------------------------------------------------------------

Widget _chart31(BuildContext context) {
  const labels = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];
  const values = [
    22.0, 25.0, 21.0, 28.0, 30.0, 27.0,
    32.0, 35.0, 31.0, 38.0, 42.0, 48.0,
  ];

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
                  color: Colors.indigo,
                  width: 12,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels)
            .copyWith(bottomTitles: _bottomAxis(labels, reservedSize: 24)),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 32. Barras — asistencia semanal
// ---------------------------------------------------------------------------

Widget _chart32(BuildContext context) {
  const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];
  const values = [28.0, 30.0, 27.0, 29.0, 24.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 34,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: Colors.teal,
                  width: 26,
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
// 33. Línea — tendencia tipo bursátil
// ---------------------------------------------------------------------------

Widget _chart33(BuildContext context) {
  const labels = [
    'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10',
  ];
  const values = [
    100.0, 104.0, 101.0, 108.0, 106.0,
    112.0, 109.0, 115.0, 111.0, 118.0,
  ];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 90,
        maxY: 125,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            color: Colors.green.shade700,
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels)
            .copyWith(bottomTitles: _bottomAxis(labels, reservedSize: 24)),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 34. Área — ventas acumuladas
// ---------------------------------------------------------------------------

Widget _chart34(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  const monthly = [15.0, 18.0, 12.0, 20.0, 22.0, 19.0];
  final cumulative = <double>[];
  var running = 0.0;
  for (final v in monthly) {
    running += v;
    cumulative.add(running);
  }

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 110,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < cumulative.length; i++)
                FlSpot(i.toDouble(), cumulative[i]),
            ],
            isCurved: true,
            color: Colors.indigo,
            barWidth: 2.5,
            dotData: const FlDotData(),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo.withValues(alpha: 0.45),
                  Colors.indigo.withValues(alpha: 0.03),
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
// 35. Circular — distribución de presupuesto
// ---------------------------------------------------------------------------

Widget _chart35(BuildContext context) {
  const data = [
    _LegendItem('Vivienda', Colors.indigo),
    _LegendItem('Comida', Colors.teal),
    _LegendItem('Transporte', Colors.orange),
    _LegendItem('Ocio', Colors.pink),
    _LegendItem('Ahorro', Colors.green),
  ];
  const values = [35.0, 20.0, 15.0, 12.0, 18.0];

  return _chartCard(
    chart: PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 0,
        sections: [
          for (var i = 0; i < values.length; i++)
            PieChartSectionData(
              value: values[i],
              color: data[i].color,
              title: '${values[i].toInt()}%',
              radius: 85,
              titleStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    ),
    legend: _legendRow(data),
  );
}

// ---------------------------------------------------------------------------
// 36. Barras — distribución por edad
// ---------------------------------------------------------------------------

Widget _chart36(BuildContext context) {
  const labels = ['0-18', '19-35', '36-50', '51-65', '66+'];
  const values = [18.0, 34.0, 26.0, 15.0, 7.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 40,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: Colors.deepPurple,
                  width: 26,
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
// 37. Scatter — altura vs. peso
// ---------------------------------------------------------------------------

Widget _chart37(BuildContext context) {
  const people = [
    [150.0, 50.0],
    [160.0, 58.0],
    [165.0, 62.0],
    [170.0, 68.0],
    [175.0, 74.0],
    [180.0, 80.0],
    [185.0, 88.0],
    [155.0, 54.0],
    [172.0, 70.0],
    [168.0, 64.0],
  ];

  return _chartCard(
    chart: ScatterChart(
      ScatterChartData(
        minX: 145,
        maxX: 190,
        minY: 45,
        maxY: 95,
        scatterSpots: [
          for (final p in people)
            ScatterSpot(
              p[0],
              p[1],
              dotPainter: FlDotCirclePainter(radius: 6, color: Colors.orange),
            ),
        ],
        gridData: const FlGridData(),
        titlesData: FlTitlesData(
          topTitles: _hiddenAxis(),
          rightTitles: _hiddenAxis(),
          leftTitles: _numericAxis(),
          bottomTitles: _numericAxis(reservedSize: 24),
        ),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 38. Línea — temperatura por hora
// ---------------------------------------------------------------------------

Widget _chart38(BuildContext context) {
  const values = [
    14.0, 13.0, 13.0, 12.0, 12.0, 13.0, // 00h-05h
    15.0, 17.0, 19.0, 21.0, 23.0, 25.0, // 06h-11h
    27.0, 28.0, 28.0, 27.0, 25.0, 23.0, // 12h-17h
    21.0, 19.0, 18.0, 17.0, 16.0, 15.0, // 18h-23h
  ];
  const labels = [
    '0h', '2h', '4h', '6h', '8h', '10h',
    '12h', '14h', '16h', '18h', '20h', '22h',
  ];

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
            color: Colors.orange,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withValues(alpha: 0.15),
            ),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: FlTitlesData(
          topTitles: _hiddenAxis(),
          rightTitles: _hiddenAxis(),
          leftTitles: _leftAxis(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 2,
              getTitlesWidget: (value, meta) {
                final index = value.round() ~/ 2;
                if (value.round() % 2 != 0 ||
                    index < 0 ||
                    index >= labels.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    labels[index],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 39. Barras — ranking de productos (ordenado)
// ---------------------------------------------------------------------------

Widget _chart39(BuildContext context) {
  const rawLabels = ['Monitor', 'Teclado', 'Silla', 'Mouse', 'Lámpara'];
  const rawValues = [40.0, 85.0, 62.0, 95.0, 28.0];

  final indices = List<int>.generate(rawValues.length, (i) => i)
    ..sort((a, b) => rawValues[b].compareTo(rawValues[a]));
  final labels = [for (final i in indices) rawLabels[i]];
  final values = [for (final i in indices) rawValues[i]];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 105,
        rotationQuarterTurns: 1,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: Colors.deepOrange,
                  width: 20,
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
// 40. Combinado — barras + línea (dual serie)
//
// fl_chart doesn't let a BarChart and a LineChart share one coordinate
// system out of the box, so this combines two bar series (ventas vs. meta)
// with a dashed horizontal "línea" showing the overall average — matching
// the task's suggested fallback for a bar+line combo.
// ---------------------------------------------------------------------------

Widget _chart40(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  const ventas = [22.0, 28.0, 24.0, 31.0, 35.0, 30.0];
  const meta = [25.0, 25.0, 25.0, 30.0, 30.0, 30.0];
  final average = ventas.reduce((a, b) => a + b) / ventas.length;

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 40,
        barGroups: [
          for (var i = 0; i < labels.length; i++)
            BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(toY: ventas[i], color: Colors.blue, width: 10),
                BarChartRodData(
                  toY: meta[i],
                  color: Colors.grey.shade400,
                  width: 10,
                ),
              ],
            ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: average,
              color: Colors.redAccent,
              strokeWidth: 2,
              dashArray: const [8, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topLeft,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                labelResolver: (line) => 'Promedio: ${line.y.toStringAsFixed(1)}',
              ),
            ),
          ],
        ),
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Ventas', Colors.blue),
      _LegendItem('Meta', Color(0xFFBDBDBD)),
      _LegendItem('Promedio (línea)', Colors.redAccent),
    ]),
  );
}

// ---------------------------------------------------------------------------
// Catalog export
// ---------------------------------------------------------------------------

final List<ChartSpec> flBasicsPart4 = [
  ChartSpec(
    id: 'fl_b31',
    title: 'Barras — ventas mensuales',
    category: ChartCategory.basic,
    builder: _chart31,
  ),
  ChartSpec(
    id: 'fl_b32',
    title: 'Barras — asistencia semanal',
    category: ChartCategory.basic,
    builder: _chart32,
  ),
  ChartSpec(
    id: 'fl_b33',
    title: 'Línea — tendencia tipo bursátil',
    category: ChartCategory.basic,
    builder: _chart33,
  ),
  ChartSpec(
    id: 'fl_b34',
    title: 'Área — ventas acumuladas',
    category: ChartCategory.basic,
    builder: _chart34,
  ),
  ChartSpec(
    id: 'fl_b35',
    title: 'Circular — distribución de presupuesto',
    category: ChartCategory.basic,
    builder: _chart35,
  ),
  ChartSpec(
    id: 'fl_b36',
    title: 'Barras — distribución por edad',
    category: ChartCategory.basic,
    builder: _chart36,
  ),
  ChartSpec(
    id: 'fl_b37',
    title: 'Scatter — altura vs. peso',
    category: ChartCategory.basic,
    builder: _chart37,
  ),
  ChartSpec(
    id: 'fl_b38',
    title: 'Línea — temperatura por hora',
    category: ChartCategory.basic,
    builder: _chart38,
  ),
  ChartSpec(
    id: 'fl_b39',
    title: 'Barras — ranking de productos (ordenado)',
    category: ChartCategory.basic,
    builder: _chart39,
  ),
  ChartSpec(
    id: 'fl_b40',
    title: 'Combinado — barras + línea (dual serie)',
    category: ChartCategory.basic,
    builder: _chart40,
  ),
];
