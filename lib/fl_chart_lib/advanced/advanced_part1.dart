import 'dart:async';
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

AxisTitles _leftAxis({double reservedSize = 32}) {
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

/// Draws a rounded-rect "node" box with a label — used by flowchart-like
/// painters (decision tree, Bayesian network).
void _drawNode(
  Canvas canvas,
  Offset center,
  String text,
  Color color, {
  double width = 108,
  double height = 40,
}) {
  final rect = Rect.fromCenter(center: center, width: width, height: height);
  final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
  canvas.drawRRect(rrect, Paint()..color = color.withValues(alpha: 0.14));
  canvas.drawRRect(
    rrect,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6,
  );
  _drawText(
    canvas,
    text,
    center,
    fontSize: 10.5,
    color: Colors.black87,
    maxWidth: width - 10,
    bold: true,
  );
}

/// Draws a directed edge (line + arrowhead) between two node centers.
void _drawArrow(
  Canvas canvas,
  Offset from,
  Offset to, {
  Color color = Colors.blueGrey,
  double gap = 34,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 1.6
    ..style = PaintingStyle.stroke;
  final direction = to - from;
  final dist = direction.distance;
  if (dist == 0) return;
  final unit = direction / dist;
  final start = from + unit * gap;
  final end = to - unit * gap;
  canvas.drawLine(start, end, paint);

  const arrowSize = 8.0;
  final angle = math.atan2(unit.dy, unit.dx);
  final p1 =
      end - Offset(math.cos(angle - 0.4), math.sin(angle - 0.4)) * arrowSize;
  final p2 =
      end - Offset(math.cos(angle + 0.4), math.sin(angle + 0.4)) * arrowSize;
  final path = Path()
    ..moveTo(end.dx, end.dy)
    ..lineTo(p1.dx, p1.dy)
    ..lineTo(p2.dx, p2.dy)
    ..close();
  canvas.drawPath(path, Paint()..color = color);
}

// ---------------------------------------------------------------------------
// 1. Radar/spider — comparación de habilidades
// ---------------------------------------------------------------------------

Widget _chart41(BuildContext context) {
  const labels = [
    'Comunicación',
    'Liderazgo',
    'Técnica',
    'Creatividad',
    'Trabajo en equipo',
  ];
  const values = [4.0, 3.0, 5.0, 3.5, 4.5];

  return _chartCard(
    chart: RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: 4,
        ticksTextStyle: const TextStyle(fontSize: 9, color: Colors.black38),
        radarBorderData: BorderSide(color: Colors.grey.shade400),
        gridBorderData: BorderSide(color: Colors.grey.shade300),
        titleTextStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        getTitle: (index, angle) => RadarChartTitle(text: labels[index]),
        dataSets: [
          RadarDataSet(
            fillColor: Colors.indigo.withValues(alpha: 0.3),
            borderColor: Colors.indigo,
            entryRadius: 3,
            dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 2. Radar — multi-serie
// ---------------------------------------------------------------------------

Widget _chart42(BuildContext context) {
  const labels = ['Velocidad', 'Fuerza', 'Resistencia', 'Técnica', 'Mentalidad'];
  const personA = [4.5, 3.5, 4.0, 5.0, 3.0];
  const personB = [3.0, 4.5, 3.5, 3.0, 4.5];

  return _chartCard(
    chart: RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: 4,
        ticksTextStyle: const TextStyle(fontSize: 9, color: Colors.black38),
        radarBorderData: BorderSide(color: Colors.grey.shade400),
        gridBorderData: BorderSide(color: Colors.grey.shade300),
        titleTextStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        getTitle: (index, angle) => RadarChartTitle(text: labels[index]),
        dataSets: [
          RadarDataSet(
            fillColor: Colors.indigo.withValues(alpha: 0.25),
            borderColor: Colors.indigo,
            entryRadius: 3,
            dataEntries: personA.map((v) => RadarEntry(value: v)).toList(),
          ),
          RadarDataSet(
            fillColor: Colors.orange.withValues(alpha: 0.25),
            borderColor: Colors.orange,
            entryRadius: 3,
            dataEntries: personB.map((v) => RadarEntry(value: v)).toList(),
          ),
        ],
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Jugador A', Colors.indigo),
      _LegendItem('Jugador B', Colors.orange),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 3. Velas japonesas (custom painter)
//
// fl_chart 1.2.0 ships a native `CandlestickChart`/`CandlestickChartData`
// widget (OHLC), so we use it directly instead of hand-rolling a painter.
// ---------------------------------------------------------------------------

Widget _chart43(BuildContext context) {
  final spots = <CandlestickSpot>[
    CandlestickSpot(x: 0, open: 10, high: 14, low: 9, close: 13),
    CandlestickSpot(x: 1, open: 13, high: 15, low: 11, close: 12),
    CandlestickSpot(x: 2, open: 12, high: 12.5, low: 8, close: 9),
    CandlestickSpot(x: 3, open: 9, high: 11, low: 8.5, close: 10.5),
    CandlestickSpot(x: 4, open: 10.5, high: 13, low: 10, close: 12.8),
    CandlestickSpot(x: 5, open: 12.8, high: 16, low: 12, close: 15.5),
    CandlestickSpot(x: 6, open: 15.5, high: 15.8, low: 13, close: 13.5),
    CandlestickSpot(x: 7, open: 13.5, high: 14, low: 11, close: 11.5),
    CandlestickSpot(x: 8, open: 11.5, high: 13.2, low: 11, close: 12.9),
  ];

  return _chartCard(
    chart: CandlestickChart(
      CandlestickChartData(
        candlestickSpots: spots,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          topTitles: _hiddenAxis(),
          rightTitles: _hiddenAxis(),
          leftTitles: _leftAxis(),
          bottomTitles: _bottomAxis(
            List.generate(spots.length, (i) => 'D${i + 1}'),
          ),
        ),
      ),
    ),
    legend: const Text(
      'Verde = cierre alcista, rojo = cierre bajista',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 4. Árbol de decisiones (CustomPainter) — diagnóstico
// ---------------------------------------------------------------------------

class _DecisionTreePainter extends CustomPainter {
  const _DecisionTreePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Offset abs(double fx, double fy) => Offset(fx * size.width, fy * size.height);

    final root = abs(0.5, 0.1);
    final l1a = abs(0.25, 0.46);
    final l1b = abs(0.75, 0.46);
    final l2a = abs(0.12, 0.86);
    final l2b = abs(0.38, 0.86);
    final l2c = abs(0.62, 0.86);
    final l2d = abs(0.88, 0.86);

    final linePaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1.6;

    void connect(Offset a, Offset b, String label) {
      canvas.drawLine(a, b, linePaint);
      final mid = Offset.lerp(a, b, 0.5)!;
      _drawText(canvas, label, mid, fontSize: 9.5, color: Colors.black54);
    }

    connect(root, l1a, 'Sí');
    connect(root, l1b, 'No');
    connect(l1a, l2a, 'Sí');
    connect(l1a, l2b, 'No');
    connect(l1b, l2c, 'Sí');
    connect(l1b, l2d, 'No');

    _drawNode(canvas, root, '¿Fiebre > 38°C?', Colors.indigo, width: 120);
    _drawNode(canvas, l1a, '¿Tos persistente?', Colors.indigo);
    _drawNode(canvas, l1b, '¿Dolor de cabeza fuerte?', Colors.indigo, width: 128);
    _drawNode(canvas, l2a, 'Posible gripe', Colors.red.shade400, width: 92);
    _drawNode(canvas, l2b, 'Monitorear', Colors.green.shade400, width: 86);
    _drawNode(canvas, l2c, 'Consultar médico', Colors.red.shade400, width: 100);
    _drawNode(canvas, l2d, 'Reposo en casa', Colors.green.shade400, width: 96);
  }

  @override
  bool shouldRepaint(covariant _DecisionTreePainter oldDelegate) => false;
}

Widget _chart44(BuildContext context) {
  return _customPaintCard(painter: const _DecisionTreePainter(), height: 320);
}

// ---------------------------------------------------------------------------
// 5. Red Bayesiana (CustomPainter) — probabilidades
// ---------------------------------------------------------------------------

class _BayesNetPainter extends CustomPainter {
  const _BayesNetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Offset abs(double fx, double fy) => Offset(fx * size.width, fy * size.height);

    final clima = abs(0.5, 0.12);
    final lluvia = abs(0.22, 0.48);
    final trafico = abs(0.78, 0.48);
    final accidente = abs(0.5, 0.86);

    _drawArrow(canvas, clima, lluvia, color: Colors.blueGrey);
    _drawArrow(canvas, clima, trafico, color: Colors.blueGrey);
    _drawArrow(canvas, lluvia, accidente, color: Colors.blueGrey);
    _drawArrow(canvas, trafico, accidente, color: Colors.blueGrey);
    _drawArrow(canvas, lluvia, trafico, color: Colors.blueGrey.shade300);

    _drawText(
      canvas,
      'P=0.65',
      Offset.lerp(lluvia, accidente, 0.5)!,
      fontSize: 9,
      color: Colors.black54,
    );
    _drawText(
      canvas,
      'P=0.40',
      Offset.lerp(trafico, accidente, 0.5)!,
      fontSize: 9,
      color: Colors.black54,
    );

    _drawNode(canvas, clima, 'Clima\nP(lluvia)=0.3', Colors.indigo, width: 118);
    _drawNode(canvas, lluvia, 'Lluvia', Colors.teal, width: 90);
    _drawNode(canvas, trafico, 'Tráfico', Colors.orange.shade700, width: 90);
    _drawNode(
      canvas,
      accidente,
      'Accidente',
      Colors.red.shade400,
      width: 104,
    );
  }

  @override
  bool shouldRepaint(covariant _BayesNetPainter oldDelegate) => false;
}

Widget _chart45(BuildContext context) {
  return _customPaintCard(
    painter: const _BayesNetPainter(),
    height: 320,
    caption: const Text(
      'Flechas = dependencia probabilística entre eventos',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 6. Árbol jerárquico organizacional
// ---------------------------------------------------------------------------

Widget _chart46(BuildContext context) {
  Widget box(String title, String subtitle, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(subtitle, style: const TextStyle(fontSize: 9, color: Colors.black54)),
      ],
    ),
  );

  Widget connector() => Container(width: 1, height: 16, color: Colors.grey.shade400);

  return SizedBox(
    height: 300,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          box('CEO', 'Dirección general', Colors.indigo),
          connector(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              box('Gerente Ventas', 'Comercial', Colors.teal),
              box('Gerente TI', 'Tecnología', Colors.teal),
              box('Gerente RRHH', 'Personal', Colors.teal),
            ],
          ),
          connector(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              box('Vendedor', 'Staff', Colors.orange),
              box('Desarrollador', 'Staff', Colors.orange),
              box('Analista', 'Staff', Colors.orange),
            ],
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 7. Línea animada (actualización en tiempo real)
// ---------------------------------------------------------------------------

class _LiveLineChart extends StatefulWidget {
  const _LiveLineChart();

  @override
  State<_LiveLineChart> createState() => _LiveLineChartState();
}

class _LiveLineChartState extends State<_LiveLineChart> {
  final List<double> _data = [50, 52, 49, 53, 55];
  final math.Random _random = math.Random();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final last = _data.last;
        final next = (last + (_random.nextDouble() - 0.5) * 14).clamp(10.0, 100.0);
        _data.add(next);
        if (_data.length > 20) {
          _data.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (var i = 0; i < _data.length; i++) FlSpot(i.toDouble(), _data[i]),
    ];

    return _chartCard(
      chart: LineChart(
        LineChartData(
          minY: 0,
          maxY: 110,
          titlesData: FlTitlesData(
            topTitles: _hiddenAxis(),
            rightTitles: _hiddenAxis(),
            leftTitles: _leftAxis(),
            bottomTitles: _hiddenAxis(),
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.teal,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 400),
      ),
      legend: const Text(
        'Nuevo valor cada segundo (ventana móvil de 20 puntos)',
        style: TextStyle(fontSize: 11, color: Colors.black54),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Barras animadas (transición de valores)
// ---------------------------------------------------------------------------

class _AnimatedBarsChart extends StatefulWidget {
  const _AnimatedBarsChart();

  @override
  State<_AnimatedBarsChart> createState() => _AnimatedBarsChartState();
}

class _AnimatedBarsChartState extends State<_AnimatedBarsChart> {
  final math.Random _random = math.Random();
  List<double> _values = [30, 55, 40, 70, 45];

  void _randomize() {
    setState(() {
      _values = _values.map((_) => 10 + _random.nextDouble() * 80).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];

    return SizedBox(
      height: 320,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    topTitles: _hiddenAxis(),
                    rightTitles: _hiddenAxis(),
                    leftTitles: _leftAxis(),
                    bottomTitles: _bottomAxis(labels),
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    for (var i = 0; i < _values.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: _values[i],
                            color: Colors.deepPurple,
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                  ],
                ),
                duration: const Duration(milliseconds: 600),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _randomize,
              child: const Text('Aleatorizar valores'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. Circular interactivo (tap para resaltar sector)
// ---------------------------------------------------------------------------

class _InteractivePieChart extends StatefulWidget {
  const _InteractivePieChart();

  @override
  State<_InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<_InteractivePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    const labels = ['Móvil', 'Escritorio', 'Tablet', 'Otros'];
    const values = [45.0, 30.0, 15.0, 10.0];
    const colors = [Colors.indigo, Colors.teal, Colors.orange, Colors.pinkAccent];

    return _chartCard(
      chart: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 36,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                final section = response?.touchedSection;
                if (!event.isInterestedForInteractions || section == null) {
                  _touchedIndex = -1;
                  return;
                }
                _touchedIndex = section.touchedSectionIndex;
              });
            },
          ),
          sections: [
            for (var i = 0; i < values.length; i++)
              PieChartSectionData(
                value: values[i],
                color: colors[i],
                radius: i == _touchedIndex ? 70 : 58,
                title: '${values[i].toInt()}%',
                titleStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
      legend: _legendRow([
        for (var i = 0; i < labels.length; i++) _LegendItem(labels[i], colors[i]),
      ]),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. Línea interactiva (tooltip + crosshair táctil)
// ---------------------------------------------------------------------------

Widget _chart50(BuildContext context) {
  const spots = [
    FlSpot(0, 3),
    FlSpot(1, 4.2),
    FlSpot(2, 3.8),
    FlSpot(3, 5.5),
    FlSpot(4, 4.9),
    FlSpot(5, 6.3),
    FlSpot(6, 5.8),
    FlSpot(7, 7.1),
  ];

  return _chartCard(
    chart: LineChart(
      LineChartData(
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: _hiddenAxis(),
          rightTitles: _hiddenAxis(),
          leftTitles: _leftAxis(),
          bottomTitles: _bottomAxis(
            List.generate(spots.length, (i) => 'S${i + 1}'),
          ),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        // Built-in touch handling (on by default) already draws a tooltip
        // bubble plus a vertical crosshair + enlarged dot at the touched spot.
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => touchedSpots
                .map(
                  (spot) => LineTooltipItem(
                    spot.y.toStringAsFixed(1),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 2.5,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    ),
    legend: const Text(
      'Toca o arrastra sobre la línea para ver el valor',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 11. Gauge tipo velocímetro (custom painter)
// ---------------------------------------------------------------------------

class _GaugePainter extends CustomPainter {
  final double value; // 0..1

  const _GaugePainter(this.value);

  static const _startAngle = math.pi * 0.75; // 135°
  static const _sweepAngle = math.pi * 1.5; // 270°

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.62);
    final radius = math.min(size.width, size.height) * 0.42;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeWidth = 16.0;

    const zoneFractions = [0.60, 0.25, 0.15];
    const zoneColors = [Color(0xFF4CAF50), Color(0xFFFFC107), Color(0xFFF44336)];

    var start = _startAngle;
    for (var i = 0; i < zoneFractions.length; i++) {
      final sweep = _sweepAngle * zoneFractions[i];
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = zoneColors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
      start += sweep;
    }

    final needleAngle = _startAngle + _sweepAngle * value.clamp(0.0, 1.0);
    final needleEnd =
        center +
        Offset(math.cos(needleAngle), math.sin(needleAngle)) *
            (radius - strokeWidth / 2);
    canvas.drawLine(
      center,
      needleEnd,
      Paint()
        ..color = Colors.black87
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 7, Paint()..color = Colors.black87);

    _drawText(
      canvas,
      '${(value * 180).round()} km/h',
      Offset(center.dx, center.dy + radius * 0.42),
      fontSize: 15,
      color: Colors.black87,
      bold: true,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value;
}

Widget _chart51(BuildContext context) {
  return _customPaintCard(painter: const _GaugePainter(0.68), height: 300);
}

// ---------------------------------------------------------------------------
// 12. Sparkline (mini gráfico)
// ---------------------------------------------------------------------------

Widget _chart52(BuildContext context) {
  const values = [5.0, 6.0, 5.5, 7.0, 6.8, 8.0, 7.5, 9.0, 8.7, 10.0];
  final spots = [
    for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
  ];

  return SizedBox(
    height: 140,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tendencia últimos 10 días',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          SizedBox(
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
                    color: Colors.green,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 13. Heatmap en grilla (custom painter)
// ---------------------------------------------------------------------------

class _HeatmapPainter extends CustomPainter {
  final List<List<double>> values;
  final List<String> rowLabels;
  final List<String> colLabels;

  const _HeatmapPainter(this.values, this.rowLabels, this.colLabels);

  static const _leftMargin = 32.0;
  static const _topMargin = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rows = values.length;
    final cols = values.first.length;
    final gridW = size.width - _leftMargin;
    final gridH = size.height - _topMargin;
    final cellW = gridW / cols;
    final cellH = gridH / rows;

    for (var c = 0; c < cols; c++) {
      _drawText(
        canvas,
        colLabels[c],
        Offset(_leftMargin + c * cellW + cellW / 2, _topMargin / 2),
        fontSize: 9,
        color: Colors.black54,
      );
    }
    for (var r = 0; r < rows; r++) {
      _drawText(
        canvas,
        rowLabels[r],
        Offset(_leftMargin / 2, _topMargin + r * cellH + cellH / 2),
        fontSize: 9,
        color: Colors.black54,
      );
    }

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final v = values[r][c].clamp(0.0, 1.0);
        final color = Color.lerp(
          const Color(0xFFE3F2FD),
          const Color(0xFF0D47A1),
          v,
        )!;
        final rect = Rect.fromLTWH(
          _leftMargin + c * cellW + 2,
          _topMargin + r * cellH + 2,
          cellW - 4,
          cellH - 4,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) => false;
}

Widget _chart53(BuildContext context) {
  final rand = math.Random(7);
  final values = List.generate(5, (_) => List.generate(7, (_) => rand.nextDouble()));
  const rowLabels = ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Sem 5'];
  const colLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  return _customPaintCard(
    painter: _HeatmapPainter(values, rowLabels, colLabels),
    height: 300,
    caption: const Text(
      'Intensidad de actividad por día (claro = bajo, oscuro = alto)',
      style: TextStyle(fontSize: 11, color: Colors.black54),
      textAlign: TextAlign.center,
    ),
  );
}

// ---------------------------------------------------------------------------
// Catalog
// ---------------------------------------------------------------------------

final List<ChartSpec> flAdvancedPart1 = [
  ChartSpec(
    id: 'fl_a41',
    title: 'Radar/spider — comparación de habilidades',
    category: ChartCategory.advanced,
    builder: _chart41,
  ),
  ChartSpec(
    id: 'fl_a42',
    title: 'Radar — multi-serie',
    category: ChartCategory.advanced,
    builder: _chart42,
  ),
  ChartSpec(
    id: 'fl_a43',
    title: 'Velas japonesas (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart43,
  ),
  ChartSpec(
    id: 'fl_a44',
    title: 'Árbol de decisiones (CustomPainter) — diagnóstico',
    category: ChartCategory.advanced,
    builder: _chart44,
  ),
  ChartSpec(
    id: 'fl_a45',
    title: 'Red Bayesiana (CustomPainter) — probabilidades',
    category: ChartCategory.advanced,
    builder: _chart45,
  ),
  ChartSpec(
    id: 'fl_a46',
    title: 'Árbol jerárquico organizacional',
    category: ChartCategory.advanced,
    builder: _chart46,
  ),
  ChartSpec(
    id: 'fl_a47',
    title: 'Línea animada (actualización en tiempo real)',
    category: ChartCategory.advanced,
    builder: (context) => const _LiveLineChart(),
  ),
  ChartSpec(
    id: 'fl_a48',
    title: 'Barras animadas (transición de valores)',
    category: ChartCategory.advanced,
    builder: (context) => const _AnimatedBarsChart(),
  ),
  ChartSpec(
    id: 'fl_a49',
    title: 'Circular interactivo (tap para resaltar sector)',
    category: ChartCategory.advanced,
    builder: (context) => const _InteractivePieChart(),
  ),
  ChartSpec(
    id: 'fl_a50',
    title: 'Línea interactiva (tooltip + crosshair táctil)',
    category: ChartCategory.advanced,
    builder: _chart50,
  ),
  ChartSpec(
    id: 'fl_a51',
    title: 'Gauge tipo velocímetro (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart51,
  ),
  ChartSpec(
    id: 'fl_a52',
    title: 'Sparkline (mini gráfico)',
    category: ChartCategory.advanced,
    builder: _chart52,
  ),
  ChartSpec(
    id: 'fl_a53',
    title: 'Heatmap en grilla (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart53,
  ),
];
