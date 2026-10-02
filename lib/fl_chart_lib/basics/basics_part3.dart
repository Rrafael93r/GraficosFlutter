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
// 21. Medio-dona tipo gauge
// ---------------------------------------------------------------------------

Widget _chart21(BuildContext context) {
  const satisfaction = 78.0;

  return _chartCard(
    chart: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PieChart(
          PieChartData(
            startDegreeOffset: 180,
            centerSpaceRadius: 70,
            sectionsSpace: 0,
            sections: [
              PieChartSectionData(
                value: satisfaction,
                color: Colors.green,
                showTitle: false,
                radius: 34,
              ),
              PieChartSectionData(
                value: 100 - satisfaction,
                color: Colors.grey.shade300,
                showTitle: false,
                radius: 34,
              ),
              PieChartSectionData(
                value: 100,
                color: Colors.transparent,
                showTitle: false,
                radius: 34,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${satisfaction.toInt()}%',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const Text('Satisfacción', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// 22. Scatter — puntos simples
// ---------------------------------------------------------------------------

Widget _chart22(BuildContext context) {
  const points = [
    [1.0, 52.0],
    [2.0, 58.0],
    [3.0, 60.0],
    [4.0, 65.0],
    [5.0, 70.0],
    [6.0, 74.0],
    [7.0, 80.0],
    [8.0, 85.0],
    [9.0, 90.0],
    [10.0, 94.0],
  ];

  return _chartCard(
    chart: ScatterChart(
      ScatterChartData(
        minX: 0,
        maxX: 11,
        minY: 40,
        maxY: 100,
        scatterSpots: [
          for (final p in points)
            ScatterSpot(
              p[0],
              p[1],
              dotPainter: FlDotCirclePainter(radius: 6, color: Colors.indigo),
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
// 23. Scatter — coloreado por categoría
// ---------------------------------------------------------------------------

Widget _chart23(BuildContext context) {
  const setosa = [
    [5.1, 3.5],
    [4.9, 3.0],
    [5.0, 3.6],
    [5.4, 3.9],
  ];
  const versicolor = [
    [6.0, 2.9],
    [6.2, 2.8],
    [5.9, 3.0],
    [6.3, 2.5],
  ];
  const virginica = [
    [7.1, 3.0],
    [6.8, 3.2],
    [7.3, 2.9],
    [7.0, 3.3],
  ];

  return _chartCard(
    chart: ScatterChart(
      ScatterChartData(
        minX: 4,
        maxX: 8,
        minY: 2,
        maxY: 4.5,
        scatterSpots: [
          for (final p in setosa)
            ScatterSpot(
              p[0],
              p[1],
              dotPainter: FlDotCirclePainter(radius: 6, color: Colors.teal),
            ),
          for (final p in versicolor)
            ScatterSpot(
              p[0],
              p[1],
              dotPainter: FlDotCirclePainter(radius: 6, color: Colors.deepOrange),
            ),
          for (final p in virginica)
            ScatterSpot(
              p[0],
              p[1],
              dotPainter: FlDotCirclePainter(radius: 6, color: Colors.purple),
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
    legend: _legendRow(const [
      _LegendItem('Setosa', Colors.teal),
      _LegendItem('Versicolor', Colors.deepOrange),
      _LegendItem('Virginica', Colors.purple),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 24. Scatter — con línea de tendencia superpuesta
//
// fl_chart's ScatterChartData doesn't support an arbitrary sloped overlay
// line, so this uses LineChartData with an invisible (zero-width) series to
// render the scattered points as dots, plus a second visible straight series
// acting as the trend line — both share the exact same coordinate system.
// ---------------------------------------------------------------------------

Widget _chart24(BuildContext context) {
  const points = [
    [1.0, 8.0],
    [2.0, 12.0],
    [3.0, 10.0],
    [4.0, 16.0],
    [5.0, 15.0],
    [6.0, 20.0],
    [7.0, 19.0],
    [8.0, 24.0],
  ];
  // Simple trend endpoints (approximate linear fit from first to last point).
  const trendStart = [1.0, 9.0];
  const trendEnd = [8.0, 23.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minX: 0,
        maxX: 9,
        minY: 0,
        maxY: 28,
        lineBarsData: [
          LineChartBarData(
            spots: [for (final p in points) FlSpot(p[0], p[1])],
            barWidth: 0,
            color: Colors.transparent,
            dotData: FlDotData(
              getDotPainter: (spot, percent, bar, index) =>
                  FlDotCirclePainter(radius: 5, color: Colors.blueAccent),
            ),
          ),
          LineChartBarData(
            spots: [
              FlSpot(trendStart[0], trendStart[1]),
              FlSpot(trendEnd[0], trendEnd[1]),
            ],
            color: Colors.redAccent,
            barWidth: 2,
            dashArray: const [6, 4],
            dotData: const FlDotData(show: false),
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
    legend: _legendRow(const [
      _LegendItem('Datos', Colors.blueAccent),
      _LegendItem('Tendencia', Colors.redAccent),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 25. Scatter tipo burbuja (tamaño variable)
// ---------------------------------------------------------------------------

Widget _chart25(BuildContext context) {
  // x: ingreso promedio (miles), y: esperanza de vida (años), size: población (M)
  const cities = [
    [10.0, 68.0, 4.0],
    [18.0, 72.0, 9.0],
    [25.0, 75.0, 14.0],
    [32.0, 78.0, 6.0],
    [40.0, 80.0, 20.0],
    [15.0, 70.0, 11.0],
  ];

  return _chartCard(
    chart: ScatterChart(
      ScatterChartData(
        minX: 5,
        maxX: 45,
        minY: 60,
        maxY: 85,
        scatterSpots: [
          for (final c in cities)
            ScatterSpot(
              c[0],
              c[1],
              dotPainter: FlDotCirclePainter(
                radius: 4 + c[2],
                color: Colors.deepPurple.withValues(alpha: 0.65),
              ),
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
// 26. Histograma
// ---------------------------------------------------------------------------

Widget _chart26(BuildContext context) {
  const labels = ['0-10', '10-20', '20-30', '30-40', '40-50', '50-60'];
  const frequencies = [3.0, 9.0, 18.0, 22.0, 12.0, 5.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 26,
        alignment: BarChartAlignment.spaceEvenly,
        groupsSpace: 0,
        barGroups: [
          for (var i = 0; i < frequencies.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: frequencies[i],
                  color: Colors.blueGrey,
                  width: 34,
                  borderRadius: BorderRadius.zero,
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
// 27. Línea escalonada (step line)
// ---------------------------------------------------------------------------

Widget _chart27(BuildContext context) {
  const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const values = [40.0, 40.0, 55.0, 55.0, 30.0, 30.0, 45.0];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        maxY: 65,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isStepLineChart: true,
            lineChartStepData: const LineChartStepData(
              stepDirection: LineChartStepData.stepDirectionForward,
            ),
            color: Colors.cyan.shade700,
            barWidth: 3,
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
// 28. Línea — doble eje Y
// ---------------------------------------------------------------------------

Widget _chart28(BuildContext context) {
  const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const temperatura = [16.0, 18.0, 21.0, 24.0, 23.0, 19.0, 17.0];
  const humedad = [70.0, 65.0, 55.0, 40.0, 45.0, 60.0, 72.0];

  const tempMin = 10.0;
  const tempMax = 30.0;
  const humMin = 20.0;
  const humMax = 90.0;

  double normalizeHumidity(double h) =>
      tempMin + (h - humMin) / (humMax - humMin) * (tempMax - tempMin);

  double denormalizeToHumidity(double v) =>
      humMin + (v - tempMin) / (tempMax - tempMin) * (humMax - humMin);

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: tempMin,
        maxY: tempMax,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < temperatura.length; i++)
                FlSpot(i.toDouble(), temperatura[i]),
            ],
            color: Colors.redAccent,
            barWidth: 2.5,
            dotData: const FlDotData(),
          ),
          LineChartBarData(
            spots: [
              for (var i = 0; i < humedad.length; i++)
                FlSpot(i.toDouble(), normalizeHumidity(humedad[i])),
            ],
            color: Colors.blue,
            barWidth: 2.5,
            dotData: const FlDotData(),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: FlTitlesData(
          topTitles: _hiddenAxis(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(
                  '${value.toInt()}°',
                  style: const TextStyle(fontSize: 10, color: Colors.redAccent),
                ),
              ),
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(
                  '${denormalizeToHumidity(value).round()}%',
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
            ),
          ),
          bottomTitles: _bottomAxis(labels),
        ),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Temperatura (°C, eje izq.)', Colors.redAccent),
      _LegendItem('Humedad (%, eje der.)', Colors.blue),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 29. Barras — con línea de umbral/meta
// ---------------------------------------------------------------------------

Widget _chart29(BuildContext context) {
  const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
  const values = [60.0, 75.0, 50.0, 90.0, 85.0, 70.0];
  const meta = 72.0;

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: values[i] >= meta ? Colors.green : Colors.orange,
                  width: 22,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: meta,
              color: Colors.redAccent,
              strokeWidth: 2,
              dashArray: const [8, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                labelResolver: (line) => 'Meta: ${line.y.toInt()}',
              ),
            ),
          ],
        ),
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 30. Línea — con máximo/mínimo destacado
// ---------------------------------------------------------------------------

Widget _chart30(BuildContext context) {
  const labels = ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8'];
  const values = [102.0, 108.0, 97.0, 115.0, 121.0, 110.0, 93.0, 119.0];
  final maxIndex = values.indexOf(values.reduce((a, b) => a > b ? a : b));
  final minIndex = values.indexOf(values.reduce((a, b) => a < b ? a : b));

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 85,
        maxY: 130,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            color: Colors.indigo,
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
                return FlDotCirclePainter(radius: 3, color: Colors.indigo);
              },
            ),
          ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow([
      _LegendItem('Máximo: ${values[maxIndex].toInt()}', Colors.green),
      _LegendItem('Mínimo: ${values[minIndex].toInt()}', Colors.redAccent),
    ]),
  );
}

// ---------------------------------------------------------------------------
// Catalog export
// ---------------------------------------------------------------------------

final List<ChartSpec> flBasicsPart3 = [
  ChartSpec(
    id: 'fl_b21',
    title: 'Medio-dona tipo gauge',
    category: ChartCategory.basic,
    builder: _chart21,
  ),
  ChartSpec(
    id: 'fl_b22',
    title: 'Scatter — puntos simples',
    category: ChartCategory.basic,
    builder: _chart22,
  ),
  ChartSpec(
    id: 'fl_b23',
    title: 'Scatter — coloreado por categoría',
    category: ChartCategory.basic,
    builder: _chart23,
  ),
  ChartSpec(
    id: 'fl_b24',
    title: 'Scatter — con línea de tendencia superpuesta',
    category: ChartCategory.basic,
    builder: _chart24,
  ),
  ChartSpec(
    id: 'fl_b25',
    title: 'Scatter tipo burbuja (tamaño variable)',
    category: ChartCategory.basic,
    builder: _chart25,
  ),
  ChartSpec(
    id: 'fl_b26',
    title: 'Histograma',
    category: ChartCategory.basic,
    builder: _chart26,
  ),
  ChartSpec(
    id: 'fl_b27',
    title: 'Línea escalonada (step line)',
    category: ChartCategory.basic,
    builder: _chart27,
  ),
  ChartSpec(
    id: 'fl_b28',
    title: 'Línea — doble eje Y',
    category: ChartCategory.basic,
    builder: _chart28,
  ),
  ChartSpec(
    id: 'fl_b29',
    title: 'Barras — con línea de umbral/meta',
    category: ChartCategory.basic,
    builder: _chart29,
  ),
  ChartSpec(
    id: 'fl_b30',
    title: 'Línea — con máximo/mínimo destacado',
    category: ChartCategory.basic,
    builder: _chart30,
  ),
];
