import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/chart_spec.dart';

// ---------------------------------------------------------------------------
// Shared helpers (kept file-local on purpose; each advanced_partN.dart file is
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

Widget _chartCard({
  required Widget chart,
  Widget? legend,
  double height = 300,
}) {
  return SizedBox(
    height: height,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Expanded(child: chart),
          if (legend != null) ...[const SizedBox(height: 8), legend],
        ],
      ),
    ),
  );
}

Widget _customPaintCard({
  required CustomPainter painter,
  double height = 300,
  Widget? caption,
}) {
  return SizedBox(
    height: height,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(painter: painter, child: const SizedBox.expand()),
          ),
          if (caption != null) ...[const SizedBox(height: 8), caption],
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

/// Draws centered, word-wrapped text — reused by every CustomPainter below.
void _drawText(
  Canvas canvas,
  String text,
  Offset center, {
  double fontSize = 11,
  Color color = Colors.black87,
  double? maxWidth,
  bool bold = false,
}) {
  final span = TextSpan(
    text: text,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
    ),
  );
  final tp = TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 3,
  )..layout(maxWidth: maxWidth ?? 220);
  tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
}

/// Builds a simple NxN / NxM colored-grid widget (used by correlation &
/// confusion matrices) — plain Flutter widgets, no CustomPainter needed.
Widget _coloredMatrix({
  required List<String> rowLabels,
  required List<String> colLabels,
  required List<List<double>> values, // normalized -1..1 or 0..1
  required Color Function(double value) colorFor,
  required String Function(double value) textFor,
  double cellSize = 46,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: cellSize * 0.9),
          for (final label in colLabels)
            SizedBox(
              width: cellSize,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Colors.black54),
              ),
            ),
        ],
      ),
      for (var r = 0; r < rowLabels.length; r++)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: cellSize * 0.9,
              child: Text(
                rowLabels[r],
                style: const TextStyle(fontSize: 9, color: Colors.black54),
              ),
            ),
            for (var c = 0; c < colLabels.length; c++)
              Container(
                width: cellSize,
                height: cellSize,
                margin: const EdgeInsets.all(1.5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorFor(values[r][c]),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  textFor(values[r][c]),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
    ],
  );
}

// ---------------------------------------------------------------------------
// 14. Matriz de correlación
// ---------------------------------------------------------------------------

Widget _chart54(BuildContext context) {
  const vars = ['Edad', 'Ingreso', 'Gasto', 'Ahorro', 'Deuda'];
  const matrix = [
    [1.00, 0.62, 0.18, 0.74, -0.35],
    [0.62, 1.00, 0.45, 0.58, -0.20],
    [0.18, 0.45, 1.00, -0.40, 0.30],
    [0.74, 0.58, -0.40, 1.00, -0.55],
    [-0.35, -0.20, 0.30, -0.55, 1.00],
  ];

  Color colorFor(double v) {
    if (v >= 0) {
      return Color.lerp(Colors.white, Colors.indigo, v)!;
    }
    return Color.lerp(Colors.white, Colors.red.shade400, -v)!;
  }

  return SizedBox(
    height: 320,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _coloredMatrix(
                  rowLabels: vars,
                  colLabels: vars,
                  values: matrix,
                  colorFor: colorFor,
                  textFor: (v) => v.toStringAsFixed(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Azul = correlación positiva, rojo = negativa',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 15. Curva de distribución normal
// ---------------------------------------------------------------------------

double _normalPdf(double x, double mu, double sigma) {
  final coefficient = 1 / (sigma * math.sqrt(2 * math.pi));
  final exponent = -0.5 * math.pow((x - mu) / sigma, 2);
  return coefficient * math.exp(exponent);
}

Widget _chart55(BuildContext context) {
  const mu = 0.0;
  const sigma = 1.0;
  const steps = 60;
  const range = 4.0;

  final spots = <FlSpot>[
    for (var i = 0; i <= steps; i++)
      FlSpot(
        -range + (2 * range * i / steps),
        _normalPdf(-range + (2 * range * i / steps), mu, sigma),
      ),
  ];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: _hiddenAxis(),
          rightTitles: _hiddenAxis(),
          leftTitles: _leftAxis(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.deepPurple,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.deepPurple.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    ),
    legend: const Text(
      'Distribución normal estándar (μ=0, σ=1)',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 16. Probabilidad posterior de Bayes (slider interactivo)
// ---------------------------------------------------------------------------

double _bayesPosterior({
  required double prior,
  required double sensitivity,
  required double falsePositive,
}) {
  final probabilityPositive =
      (sensitivity * prior) + (falsePositive * (1 - prior));
  if (probabilityPositive <= 0) return 0;
  return (sensitivity * prior) / probabilityPositive;
}

class _BayesSliderDemo extends StatefulWidget {
  const _BayesSliderDemo();

  @override
  State<_BayesSliderDemo> createState() => _BayesSliderDemoState();
}

class _BayesSliderDemoState extends State<_BayesSliderDemo> {
  double _prior = 0.01;
  double _sensitivity = 0.95;
  double _falsePositive = 0.05;

  Widget _slider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${(value * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 12),
        ),
        Slider(
          value: value,
          min: 0,
          max: 1,
          divisions: 100,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final posterior = _bayesPosterior(
      prior: _prior,
      sensitivity: _sensitivity,
      falsePositive: _falsePositive,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _slider(
            label: 'Prevalencia de la enfermedad',
            value: _prior,
            onChanged: (v) => setState(() => _prior = v),
          ),
          _slider(
            label: 'Sensibilidad de la prueba',
            value: _sensitivity,
            onChanged: (v) => setState(() => _sensitivity = v),
          ),
          _slider(
            label: 'Tasa de falsos positivos',
            value: _falsePositive,
            onChanged: (v) => setState(() => _falsePositive = v),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Text(
                  'Probabilidad posterior (dado un resultado positivo)',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(posterior * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: posterior.clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: Colors.indigo.withValues(alpha: 0.15),
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 17. Matriz de confusión
// ---------------------------------------------------------------------------

Widget _chart57(BuildContext context) {
  const matrix = [
    [85.0, 10.0],
    [5.0, 90.0],
  ];
  const rowLabels = ['Real: Sí', 'Real: No'];
  const colLabels = ['Pred: Sí', 'Pred: No'];
  const cellTags = [
    ['TP', 'FN'],
    ['FP', 'TN'],
  ];

  Color colorFor(double v) => Color.lerp(
    Colors.white,
    Colors.teal,
    (v / 100).clamp(0.0, 1.0),
  )!;

  return SizedBox(
    height: 300,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: _coloredMatrix(
                rowLabels: rowLabels,
                colLabels: colLabels,
                values: matrix,
                colorFor: colorFor,
                textFor: (v) => v.toStringAsFixed(0),
                cellSize: 70,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _legendRow(const [
            _LegendItem('TP/TN = aciertos', Colors.teal),
            _LegendItem('FP/FN = errores', Colors.white70),
          ]),
          Text(
            '(${cellTags[0][0]}=verdadero positivo, ${cellTags[1][1]}=verdadero negativo)',
            style: const TextStyle(fontSize: 9, color: Colors.black45),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 18. Waterfall (barras apiladas custom)
// ---------------------------------------------------------------------------

Widget _chart58(BuildContext context) {
  const labels = ['Inicial', 'Ventas', 'Costos', 'Impuestos', 'Final'];
  const deltas = [100.0, 60.0, -35.0, -15.0, 0.0]; // last is computed total

  final cumulative = <double>[deltas[0]];
  for (var i = 1; i < deltas.length - 1; i++) {
    cumulative.add(cumulative.last + deltas[i]);
  }
  final total = cumulative.last;

  final groups = <BarChartGroupData>[];
  // First bar: starts at 0.
  groups.add(
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: deltas[0],
          color: Colors.blueGrey,
          width: 26,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    ),
  );
  // Intermediate floating bars.
  var running = deltas[0];
  for (var i = 1; i < deltas.length - 1; i++) {
    final next = running + deltas[i];
    groups.add(
      BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            fromY: math.min(running, next),
            toY: math.max(running, next),
            color: deltas[i] >= 0 ? Colors.green.shade400 : Colors.red.shade400,
            width: 26,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
    running = next;
  }
  // Final total bar: starts at 0.
  groups.add(
    BarChartGroupData(
      x: deltas.length - 1,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: total,
          color: Colors.indigo,
          width: 26,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    ),
  );

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: _hiddenAxis(),
          rightTitles: _hiddenAxis(),
          leftTitles: _leftAxis(),
          bottomTitles: _bottomAxis(labels),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: groups,
      ),
    ),
    legend: _legendRow([
      const _LegendItem('Aumenta', Colors.green),
      const _LegendItem('Disminuye', Colors.red),
      const _LegendItem('Total', Colors.indigo),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 19. Funnel (embudo, custom painter)
// ---------------------------------------------------------------------------

class _FunnelPainter extends CustomPainter {
  final List<(String, double)> stages; // label, value 0..1 (share of first stage)
  final List<Color> colors;

  const _FunnelPainter(this.stages, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final n = stages.length;
    final stageHeight = size.height / n;
    final maxWidth = size.width * 0.9;

    for (var i = 0; i < n; i++) {
      final topFraction = stages[i].$2;
      final bottomFraction = i + 1 < n ? stages[i + 1].$2 : stages[i].$2 * 0.7;
      final topWidth = maxWidth * topFraction;
      final bottomWidth = maxWidth * bottomFraction;

      final top = i * stageHeight;
      final bottom = (i + 1) * stageHeight;
      final cx = size.width / 2;

      final path = Path()
        ..moveTo(cx - topWidth / 2, top)
        ..lineTo(cx + topWidth / 2, top)
        ..lineTo(cx + bottomWidth / 2, bottom - 4)
        ..lineTo(cx - bottomWidth / 2, bottom - 4)
        ..close();

      canvas.drawPath(path, Paint()..color = colors[i % colors.length]);

      _drawText(
        canvas,
        '${stages[i].$1}\n(${(topFraction * 100).round()}%)',
        Offset(cx, top + stageHeight / 2 - 2),
        fontSize: 11,
        color: Colors.white,
        bold: true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FunnelPainter oldDelegate) => false;
}

Widget _chart59(BuildContext context) {
  const stages = [
    ('Visitas', 1.0),
    ('Leads', 0.55),
    ('Oportunidades', 0.30),
    ('Clientes', 0.12),
  ];
  const colors = [
    Color(0xFF3949AB),
    Color(0xFF1E88E5),
    Color(0xFF26A69A),
    Color(0xFF66BB6A),
  ];

  return _customPaintCard(
    painter: const _FunnelPainter(stages, colors),
    height: 320,
  );
}

// ---------------------------------------------------------------------------
// 20. Anillos de progreso circular
// ---------------------------------------------------------------------------

Widget _chart60(BuildContext context) {
  Widget ring(double size, double value, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: 10,
        backgroundColor: color.withValues(alpha: 0.15),
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  return SizedBox(
    height: 300,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ring(200, 0.82, Colors.indigo),
                  ring(150, 0.64, Colors.teal),
                  ring(100, 0.45, Colors.orange),
                  const Text(
                    '3 metas',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _legendRow(const [
            _LegendItem('Ventas 82%', Colors.indigo),
            _LegendItem('Soporte 64%', Colors.teal),
            _LegendItem('Marketing 45%', Colors.orange),
          ]),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 21. Radar multi-eje (5+ métricas)
// ---------------------------------------------------------------------------

Widget _chart61(BuildContext context) {
  const labels = [
    'Velocidad',
    'Fuerza',
    'Resistencia',
    'Agilidad',
    'Precisión',
    'Técnica',
  ];
  const values = [4.2, 3.8, 4.5, 4.0, 3.5, 4.8];

  return _chartCard(
    chart: RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: 5,
        ticksTextStyle: const TextStyle(fontSize: 9, color: Colors.black38),
        radarBorderData: BorderSide(color: Colors.grey.shade400),
        gridBorderData: BorderSide(color: Colors.grey.shade300),
        titleTextStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
        getTitle: (index, angle) => RadarChartTitle(text: labels[index]),
        dataSets: [
          RadarDataSet(
            fillColor: Colors.teal.withValues(alpha: 0.3),
            borderColor: Colors.teal,
            entryRadius: 3,
            dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 22. Grafo de red (nodos y conexiones, custom painter)
// ---------------------------------------------------------------------------

class _NetworkGraphPainter extends CustomPainter {
  const _NetworkGraphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 36;
    const labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final nodes = <Offset>[
      for (var i = 0; i < labels.length; i++)
        center +
            Offset(
              radius * math.cos(2 * math.pi * i / labels.length - math.pi / 2),
              radius * math.sin(2 * math.pi * i / labels.length - math.pi / 2),
            ),
    ];

    const edges = [
      [0, 1],
      [0, 2],
      [1, 3],
      [2, 3],
      [3, 4],
      [4, 5],
      [5, 6],
      [6, 0],
      [1, 5],
    ];

    final edgePaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..strokeWidth = 1.6;
    for (final edge in edges) {
      canvas.drawLine(nodes[edge[0]], nodes[edge[1]], edgePaint);
    }

    for (var i = 0; i < nodes.length; i++) {
      canvas.drawCircle(nodes[i], 18, Paint()..color = Colors.indigo.shade300);
      canvas.drawCircle(
        nodes[i],
        18,
        Paint()
          ..color = Colors.indigo
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
      _drawText(
        canvas,
        labels[i],
        nodes[i],
        fontSize: 12,
        color: Colors.white,
        bold: true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkGraphPainter oldDelegate) => false;
}

Widget _chart62(BuildContext context) {
  return _customPaintCard(
    painter: const _NetworkGraphPainter(),
    height: 320,
    caption: const Text(
      'Nodos = entidades, líneas = conexiones de la red',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 23. Timeline tipo Gantt
//
// fl_chart has no native horizontal-bar support, so each task row is drawn
// with plain Flutter widgets (LayoutBuilder + Stack/Positioned) sized
// proportionally to its start/end day offsets — this renders a true
// horizontal Gantt timeline reliably across screen sizes.
// ---------------------------------------------------------------------------

Widget _chart63(BuildContext context) {
  const tasks = [
    ('Análisis', 0, 4, Colors.indigo),
    ('Diseño', 3, 8, Colors.teal),
    ('Desarrollo', 7, 18, Colors.orange),
    ('Pruebas', 15, 21, Colors.purple),
    ('Despliegue', 20, 24, Colors.green),
  ];
  const totalDays = 24.0;

  return SizedBox(
    height: 300,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final task in tasks)
                      Row(
                        children: [
                          SizedBox(
                            width: 76,
                            child: Text(
                              task.$1,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Positioned(
                                  left: (task.$2 / totalDays) * (width - 76),
                                  width:
                                      ((task.$3 - task.$2) / totalDays) *
                                      (width - 76),
                                  child: Container(
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: task.$4,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Días 0 a 24 — cada barra = duración de la tarea',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 24. Boxplot (cuartiles, custom painter)
// ---------------------------------------------------------------------------

class _BoxPlotStats {
  final String label;
  final double min;
  final double q1;
  final double median;
  final double q3;
  final double max;

  const _BoxPlotStats(this.label, this.min, this.q1, this.median, this.q3, this.max);
}

class _BoxPlotPainter extends CustomPainter {
  final List<_BoxPlotStats> groups;

  const _BoxPlotPainter(this.groups);

  @override
  void paint(Canvas canvas, Size size) {
    final globalMax = groups.map((g) => g.max).reduce(math.max);
    final globalMin = groups.map((g) => g.min).reduce(math.min);
    final range = (globalMax - globalMin) == 0 ? 1 : globalMax - globalMin;

    final slotWidth = size.width / groups.length;
    final boxWidth = slotWidth * 0.4;

    double yFor(double v) =>
        size.height - ((v - globalMin) / range) * (size.height - 24) - 12;

    final linePaint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 1.8;
    final boxPaint = Paint()..color = Colors.indigo.withValues(alpha: 0.25);
    final boxBorder = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      final cx = slotWidth * i + slotWidth / 2;

      final yMin = yFor(g.min);
      final yQ1 = yFor(g.q1);
      final yMedian = yFor(g.median);
      final yQ3 = yFor(g.q3);
      final yMax = yFor(g.max);

      // Whiskers.
      canvas.drawLine(Offset(cx, yMin), Offset(cx, yQ1), linePaint);
      canvas.drawLine(Offset(cx, yQ3), Offset(cx, yMax), linePaint);
      canvas.drawLine(
        Offset(cx - boxWidth / 4, yMin),
        Offset(cx + boxWidth / 4, yMin),
        linePaint,
      );
      canvas.drawLine(
        Offset(cx - boxWidth / 4, yMax),
        Offset(cx + boxWidth / 4, yMax),
        linePaint,
      );

      // Box (Q1 to Q3).
      final rect = Rect.fromLTRB(cx - boxWidth / 2, yQ3, cx + boxWidth / 2, yQ1);
      canvas.drawRect(rect, boxPaint);
      canvas.drawRect(rect, boxBorder);

      // Median line.
      canvas.drawLine(
        Offset(cx - boxWidth / 2, yMedian),
        Offset(cx + boxWidth / 2, yMedian),
        Paint()
          ..color = Colors.deepOrange
          ..strokeWidth = 2.2,
      );

      _drawText(
        canvas,
        g.label,
        Offset(cx, size.height - 4),
        fontSize: 10,
        color: Colors.black54,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BoxPlotPainter oldDelegate) => false;
}

Widget _chart64(BuildContext context) {
  const groups = [
    _BoxPlotStats('Grupo A', 10, 22, 30, 38, 48),
    _BoxPlotStats('Grupo B', 14, 26, 34, 42, 55),
    _BoxPlotStats('Grupo C', 8, 18, 25, 33, 40),
  ];

  return _customPaintCard(
    painter: const _BoxPlotPainter(groups),
    height: 300,
    caption: const Text(
      'Caja = rango intercuartílico, línea naranja = mediana',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 25. Mini dashboard combinado (sparkline + KPI + flecha de tendencia)
// ---------------------------------------------------------------------------

Widget _chart65(BuildContext context) {
  const values = [8.0, 7.5, 9.0, 8.7, 10.2, 11.0, 12.5];
  final spots = [
    for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
  ];
  final isUp = values.last >= values.first;

  return SizedBox(
    height: 130,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 60,
              child: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: isUp ? Colors.green : Colors.red,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (isUp ? Colors.green : Colors.red)
                            .withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingresos (miles)',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
                Text(
                  '\$${values.last.toStringAsFixed(1)}K',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isUp ? Icons.trending_up : Icons.trending_down,
            color: isUp ? Colors.green : Colors.red,
            size: 32,
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Catalog
// ---------------------------------------------------------------------------

final List<ChartSpec> flAdvancedPart2 = [
  ChartSpec(
    id: 'fl_a54',
    title: 'Matriz de correlación',
    category: ChartCategory.advanced,
    builder: _chart54,
  ),
  ChartSpec(
    id: 'fl_a55',
    title: 'Curva de distribución normal',
    category: ChartCategory.advanced,
    builder: _chart55,
  ),
  ChartSpec(
    id: 'fl_a56',
    title: 'Probabilidad posterior de Bayes (slider interactivo)',
    category: ChartCategory.advanced,
    builder: (context) => const _BayesSliderDemo(),
  ),
  ChartSpec(
    id: 'fl_a57',
    title: 'Matriz de confusión',
    category: ChartCategory.advanced,
    builder: _chart57,
  ),
  ChartSpec(
    id: 'fl_a58',
    title: 'Waterfall (barras apiladas custom)',
    category: ChartCategory.advanced,
    builder: _chart58,
  ),
  ChartSpec(
    id: 'fl_a59',
    title: 'Funnel (embudo, custom painter)',
    category: ChartCategory.advanced,
    builder: _chart59,
  ),
  ChartSpec(
    id: 'fl_a60',
    title: 'Anillos de progreso circular',
    category: ChartCategory.advanced,
    builder: _chart60,
  ),
  ChartSpec(
    id: 'fl_a61',
    title: 'Radar multi-eje (5+ métricas)',
    category: ChartCategory.advanced,
    builder: _chart61,
  ),
  ChartSpec(
    id: 'fl_a62',
    title: 'Grafo de red (nodos y conexiones, custom painter)',
    category: ChartCategory.advanced,
    builder: _chart62,
  ),
  ChartSpec(
    id: 'fl_a63',
    title: 'Timeline tipo Gantt',
    category: ChartCategory.advanced,
    builder: _chart63,
  ),
  ChartSpec(
    id: 'fl_a64',
    title: 'Boxplot (cuartiles, custom painter)',
    category: ChartCategory.advanced,
    builder: _chart64,
  ),
  ChartSpec(
    id: 'fl_a65',
    title: 'Mini dashboard combinado (sparkline + KPI + flecha de tendencia)',
    category: ChartCategory.advanced,
    builder: _chart65,
  ),
];
