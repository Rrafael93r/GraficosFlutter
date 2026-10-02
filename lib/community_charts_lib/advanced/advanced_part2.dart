import 'dart:math' as math;

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
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
  double height = 320,
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

/// Simple ordinal (category, value) sample used by several Series below.
class _OrdinalValue {
  final String label;
  final num value;

  const _OrdinalValue(this.label, this.value);
}

/// Simple numeric (x, y) sample used by LineChart demos.
class _NumPoint {
  final num x;
  final double y;

  const _NumPoint(this.x, this.y);
}

// ---------------------------------------------------------------------------
// 14. Matriz de correlación (custom painter)
// ---------------------------------------------------------------------------

class _CorrelationMatrixPainter extends CustomPainter {
  final List<String> labels;
  final List<List<double>> matrix; // values in [-1, 1]

  const _CorrelationMatrixPainter(this.labels, this.matrix);

  static const _leftMargin = 70.0;
  static const _topMargin = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    final n = labels.length;
    final gridW = size.width - _leftMargin;
    final gridH = size.height - _topMargin;
    final cellW = gridW / n;
    final cellH = gridH / n;

    for (var c = 0; c < n; c++) {
      _drawText(
        canvas,
        labels[c],
        Offset(_leftMargin + c * cellW + cellW / 2, _topMargin / 2),
        fontSize: 9,
        color: Colors.black54,
      );
    }
    for (var r = 0; r < n; r++) {
      _drawText(
        canvas,
        labels[r],
        Offset(_leftMargin / 2, _topMargin + r * cellH + cellH / 2),
        fontSize: 9,
        color: Colors.black54,
        maxWidth: _leftMargin - 8,
      );
    }

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final v = matrix[r][c].clamp(-1.0, 1.0);
        final color = v >= 0
            ? Color.lerp(Colors.white, Colors.indigo, v)!
            : Color.lerp(Colors.white, Colors.red, -v)!;
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
        _drawText(
          canvas,
          v.toStringAsFixed(2),
          rect.center,
          fontSize: 9.5,
          color: v.abs() > 0.6 ? Colors.white : Colors.black87,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CorrelationMatrixPainter oldDelegate) => false;
}

Widget _chart54(BuildContext context) {
  const labels = ['Edad', 'Ingreso', 'Gasto', 'Ahorro', 'Deuda'];
  const matrix = [
    [1.0, 0.42, -0.18, 0.55, -0.30],
    [0.42, 1.0, 0.61, 0.38, -0.22],
    [-0.18, 0.61, 1.0, -0.45, 0.50],
    [0.55, 0.38, -0.45, 1.0, -0.60],
    [-0.30, -0.22, 0.50, -0.60, 1.0],
  ];

  return _customPaintCard(
    painter: const _CorrelationMatrixPainter(labels, matrix),
    height: 320,
    caption: const Text(
      'Azul = correlación positiva, rojo = correlación negativa',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 15. Curva de distribución normal
// ---------------------------------------------------------------------------

Widget _chart55(BuildContext context) {
  const mu = 0.0;
  const sigma = 1.0;
  double pdf(double x) =>
      (1 / (sigma * math.sqrt(2 * math.pi))) *
      math.exp(-0.5 * math.pow((x - mu) / sigma, 2));

  final data = [
    for (var i = -40; i <= 40; i++) _NumPoint(i / 10.0, pdf(i / 10.0)),
  ];

  final series = [
    charts.Series<_NumPoint, num>(
      id: 'Densidad',
      domainFn: (d, _) => d.x,
      measureFn: (d, _) => d.y,
      colorFn: (_, _) => charts.MaterialPalette.indigo.shadeDefault,
      data: data,
    ),
  ];

  return _chartCard(
    chart: charts.LineChart(series, animate: true),
    legend: const Text(
      'Distribución normal μ=0, σ=1 — densidad de probabilidad',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 16. Probabilidad posterior de Bayes (slider interactivo)
// ---------------------------------------------------------------------------

class _BayesPosteriorCard extends StatefulWidget {
  const _BayesPosteriorCard();

  @override
  State<_BayesPosteriorCard> createState() => _BayesPosteriorCardState();
}

class _BayesPosteriorCardState extends State<_BayesPosteriorCard> {
  double _prior = 0.1;
  double _sensitivity = 0.9;
  double _falsePositive = 0.08;

  double get _posterior {
    final probabilityPositive =
        (_sensitivity * _prior) + (_falsePositive * (1 - _prior));
    if (probabilityPositive == 0) return 0;
    return (_sensitivity * _prior) / probabilityPositive;
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 118,
          child: Text(label, style: const TextStyle(fontSize: 11)),
        ),
        Expanded(
          child: Slider(value: value, min: 0.01, max: 0.99, onChanged: onChanged),
        ),
        SizedBox(
          width: 44,
          child: Text(
            '${(value * 100).toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final series = [
      charts.Series<_OrdinalValue, String>(
        id: 'Probabilidad',
        domainFn: (d, _) => d.label,
        measureFn: (d, _) => d.value,
        colorFn: (d, _) => d.label == 'Posterior'
            ? charts.MaterialPalette.green.shadeDefault
            : charts.MaterialPalette.gray.shadeDefault,
        data: [
          _OrdinalValue('Prior', _prior * 100),
          _OrdinalValue('Posterior', _posterior * 100),
        ],
      ),
    ];

    return SizedBox(
      height: 360,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            _slider('Prevalencia (prior)', _prior, (v) => setState(() => _prior = v)),
            _slider('Sensibilidad', _sensitivity, (v) => setState(() => _sensitivity = v)),
            _slider('Falsos positivos', _falsePositive, (v) => setState(() => _falsePositive = v)),
            const SizedBox(height: 4),
            Text(
              'P(enfermedad | positivo) = ${(_posterior * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Expanded(child: charts.BarChart(series, animate: true)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 17. Matriz de confusión (custom painter)
// ---------------------------------------------------------------------------

class _ConfusionMatrixPainter extends CustomPainter {
  final int tp;
  final int fp;
  final int fn;
  final int tn;

  const _ConfusionMatrixPainter({
    required this.tp,
    required this.fp,
    required this.fn,
    required this.tn,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 90.0;
    const topMargin = 34.0;
    final gridW = size.width - leftMargin;
    final gridH = size.height - topMargin;
    final cellW = gridW / 2;
    final cellH = gridH / 2;
    final maxV = [tp, fp, fn, tn].reduce(math.max).toDouble();

    _drawText(
      canvas,
      'Predicho:\nPositivo',
      Offset(leftMargin + cellW / 2, topMargin / 2),
      fontSize: 9.5,
      color: Colors.black54,
    );
    _drawText(
      canvas,
      'Predicho:\nNegativo',
      Offset(leftMargin + cellW + cellW / 2, topMargin / 2),
      fontSize: 9.5,
      color: Colors.black54,
    );
    _drawText(
      canvas,
      'Real:\nPositivo',
      Offset(leftMargin / 2, topMargin + cellH / 2),
      fontSize: 9,
      color: Colors.black54,
      maxWidth: leftMargin - 8,
    );
    _drawText(
      canvas,
      'Real:\nNegativo',
      Offset(leftMargin / 2, topMargin + cellH + cellH / 2),
      fontSize: 9,
      color: Colors.black54,
      maxWidth: leftMargin - 8,
    );

    void cell(int r, int c, int value, Color color, String label) {
      final rect = Rect.fromLTWH(
        leftMargin + c * cellW + 3,
        topMargin + r * cellH + 3,
        cellW - 6,
        cellH - 6,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        Paint()..color = color.withValues(alpha: 0.25 + 0.55 * (value / maxV)),
      );
      _drawText(
        canvas,
        '$label\n$value',
        rect.center,
        fontSize: 12,
        bold: true,
        color: Colors.black87,
      );
    }

    cell(0, 0, tp, Colors.green, 'VP');
    cell(0, 1, fn, Colors.red, 'FN');
    cell(1, 0, fp, Colors.red, 'FP');
    cell(1, 1, tn, Colors.green, 'VN');
  }

  @override
  bool shouldRepaint(covariant _ConfusionMatrixPainter oldDelegate) => false;
}

Widget _chart57(BuildContext context) {
  return _customPaintCard(
    painter: const _ConfusionMatrixPainter(tp: 85, fp: 12, fn: 9, tn: 94),
    height: 300,
    caption: const Text(
      'VP/VN = aciertos, FP/FN = errores del clasificador',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 18. Waterfall (barras en cascada)
//
// community_charts_flutter no tiene una primitiva de "barra flotante", así
// que se aproxima con BarChart apilado: una serie "Base" invisible
// (charts.Color.transparent) que posiciona el inicio de cada barra, y una
// serie "Delta" visible encima con la magnitud del cambio.
// ---------------------------------------------------------------------------

class _WaterfallStep {
  final String label;
  final double delta;

  const _WaterfallStep(this.label, this.delta);
}

Widget _chart58(BuildContext context) {
  const steps = [
    _WaterfallStep('Inicio', 100),
    _WaterfallStep('Ventas', 45),
    _WaterfallStep('Devoluciones', -20),
    _WaterfallStep('Costos', -35),
    _WaterfallStep('Impuestos', -15),
    _WaterfallStep('Final', 0),
  ];

  var cumulative = 0.0;
  final bases = <double>[];
  final deltas = <double>[];
  final isTotal = <bool>[];
  for (var i = 0; i < steps.length; i++) {
    final isLast = i == steps.length - 1;
    if (isLast) {
      bases.add(0);
      deltas.add(cumulative);
      isTotal.add(true);
      continue;
    }
    final d = steps[i].delta;
    if (d >= 0) {
      bases.add(cumulative);
      deltas.add(d);
    } else {
      bases.add(cumulative + d);
      deltas.add(-d);
    }
    cumulative += d;
    isTotal.add(false);
  }

  final baseData = [
    for (var i = 0; i < steps.length; i++) _OrdinalValue(steps[i].label, bases[i]),
  ];
  final deltaData = [
    for (var i = 0; i < steps.length; i++) _OrdinalValue(steps[i].label, deltas[i]),
  ];

  final series = [
    charts.Series<_OrdinalValue, String>(
      id: 'Base',
      domainFn: (d, _) => d.label,
      measureFn: (d, _) => d.value,
      colorFn: (_, _) => charts.Color.transparent,
      data: baseData,
    ),
    charts.Series<_OrdinalValue, String>(
      id: 'Delta',
      domainFn: (d, _) => d.label,
      measureFn: (d, _) => d.value,
      colorFn: (_, i) {
        final idx = i!;
        if (isTotal[idx]) return charts.MaterialPalette.blue.shadeDefault;
        return steps[idx].delta >= 0
            ? charts.MaterialPalette.green.shadeDefault
            : charts.MaterialPalette.red.shadeDefault;
      },
      data: deltaData,
    ),
  ];

  return _chartCard(
    chart: charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
    ),
    legend: _legendRow(const [
      _LegendItem('Aumento', Colors.green),
      _LegendItem('Disminución', Colors.red),
      _LegendItem('Total', Colors.blue),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 19. Funnel (embudo, custom painter)
// ---------------------------------------------------------------------------

class _FunnelPainter extends CustomPainter {
  final List<String> labels;
  final List<double> values; // descending
  final List<Color> colors;

  const _FunnelPainter(this.labels, this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = values.first;
    final stageH = size.height / values.length;

    for (var i = 0; i < values.length; i++) {
      final topWidthFrac = values[i] / maxV;
      final bottomWidthFrac =
          i + 1 < values.length ? values[i + 1] / maxV : topWidthFrac * 0.85;
      final topHalf = size.width * topWidthFrac / 2;
      final bottomHalf = size.width * bottomWidthFrac / 2;
      final top = i * stageH;
      final bottom = (i + 1) * stageH;
      final cx = size.width / 2;

      final path = Path()
        ..moveTo(cx - topHalf, top)
        ..lineTo(cx + topHalf, top)
        ..lineTo(cx + bottomHalf, bottom)
        ..lineTo(cx - bottomHalf, bottom)
        ..close();

      canvas.drawPath(path, Paint()..color = colors[i % colors.length]);
      _drawText(
        canvas,
        '${labels[i]}\n${values[i].toInt()}',
        Offset(cx, top + stageH / 2),
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
  const labels = ['Visitas', 'Leads', 'Oportunidades', 'Clientes'];
  const values = [10000.0, 3200.0, 980.0, 410.0];
  const colors = [Colors.indigo, Colors.blue, Colors.teal, Colors.green];

  return _customPaintCard(
    painter: const _FunnelPainter(labels, values, colors),
    height: 320,
    caption: const Text(
      'Embudo de conversión: visitas → clientes',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 20. Árbol de decisiones (custom painter)
// ---------------------------------------------------------------------------

class _DecisionTreePainter extends CustomPainter {
  const _DecisionTreePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Offset abs(double fx, double fy) =>
        Offset(fx * size.width, fy * size.height);

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

    _drawNode(canvas, root, '¿Ingresos > \$3M?', Colors.indigo, width: 128);
    _drawNode(
      canvas,
      l1a,
      '¿Historial crediticio bueno?',
      Colors.indigo,
      width: 136,
    );
    _drawNode(canvas, l1b, '¿Tiene codeudor?', Colors.indigo, width: 112);
    _drawNode(canvas, l2a, 'Aprobar', Colors.green.shade400, width: 86);
    _drawNode(
      canvas,
      l2b,
      'Revisión manual',
      Colors.orange.shade400,
      width: 104,
    );
    _drawNode(
      canvas,
      l2c,
      'Aprobar con aval',
      Colors.green.shade400,
      width: 104,
    );
    _drawNode(canvas, l2d, 'Rechazar', Colors.red.shade400, width: 90);
  }

  @override
  bool shouldRepaint(covariant _DecisionTreePainter oldDelegate) => false;
}

Widget _chart60(BuildContext context) {
  return _customPaintCard(painter: const _DecisionTreePainter(), height: 320);
}

// ---------------------------------------------------------------------------
// 21. Red Bayesiana (custom painter)
// ---------------------------------------------------------------------------

class _BayesNetPainter extends CustomPainter {
  const _BayesNetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Offset abs(double fx, double fy) =>
        Offset(fx * size.width, fy * size.height);

    final robo = abs(0.22, 0.14);
    final terremoto = abs(0.78, 0.14);
    final alarma = abs(0.5, 0.48);
    final juan = abs(0.26, 0.86);
    final maria = abs(0.74, 0.86);

    _drawArrow(canvas, robo, alarma, color: Colors.blueGrey);
    _drawArrow(canvas, terremoto, alarma, color: Colors.blueGrey);
    _drawArrow(canvas, alarma, juan, color: Colors.blueGrey);
    _drawArrow(canvas, alarma, maria, color: Colors.blueGrey);

    _drawText(
      canvas,
      'P=0.90',
      Offset.lerp(alarma, juan, 0.5)!,
      fontSize: 9,
      color: Colors.black54,
    );
    _drawText(
      canvas,
      'P=0.70',
      Offset.lerp(alarma, maria, 0.5)!,
      fontSize: 9,
      color: Colors.black54,
    );

    _drawNode(canvas, robo, 'Robo\nP=0.001', Colors.indigo, width: 96);
    _drawNode(
      canvas,
      terremoto,
      'Terremoto\nP=0.002',
      Colors.indigo,
      width: 104,
    );
    _drawNode(canvas, alarma, 'Alarma', Colors.teal, width: 90);
    _drawNode(canvas, juan, 'Juan llama', Colors.orange.shade700, width: 96);
    _drawNode(
      canvas,
      maria,
      'María llama',
      Colors.orange.shade700,
      width: 100,
    );
  }

  @override
  bool shouldRepaint(covariant _BayesNetPainter oldDelegate) => false;
}

Widget _chart61(BuildContext context) {
  return _customPaintCard(
    painter: const _BayesNetPainter(),
    height: 320,
    caption: const Text(
      'Red bayesiana clásica: Robo/Terremoto → Alarma → Llamadas',
      style: TextStyle(fontSize: 11, color: Colors.black54),
      textAlign: TextAlign.center,
    ),
  );
}

// ---------------------------------------------------------------------------
// 22. Grafo de red (custom painter)
// ---------------------------------------------------------------------------

class _NetworkGraphPainter extends CustomPainter {
  const _NetworkGraphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const labels = ['A', 'B', 'C', 'D', 'E', 'F'];
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 36;
    final points = <Offset>[
      for (var i = 0; i < labels.length; i++)
        center +
            Offset(
              radius * math.cos(2 * math.pi * i / labels.length - math.pi / 2),
              radius * math.sin(2 * math.pi * i / labels.length - math.pi / 2),
            ),
    ];

    const edges = [
      [0, 1],
      [1, 2],
      [2, 3],
      [3, 4],
      [4, 5],
      [5, 0],
      [0, 2],
      [1, 4],
      [2, 5],
    ];

    final edgePaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..strokeWidth = 1.6;

    for (final e in edges) {
      canvas.drawLine(points[e[0]], points[e[1]], edgePaint);
    }

    for (var i = 0; i < labels.length; i++) {
      canvas.drawCircle(
        points[i],
        20,
        Paint()..color = Colors.indigo.withValues(alpha: 0.18),
      );
      canvas.drawCircle(
        points[i],
        20,
        Paint()
          ..color = Colors.indigo
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
      _drawText(
        canvas,
        labels[i],
        points[i],
        fontSize: 12,
        bold: true,
        color: Colors.black87,
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
      'Grafo de red no dirigido: nodos y conexiones entre entidades',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 23. Boxplot (custom painter)
// ---------------------------------------------------------------------------

class _BoxplotStats {
  final String label;
  final double min;
  final double q1;
  final double median;
  final double q3;
  final double max;

  const _BoxplotStats(
    this.label,
    this.min,
    this.q1,
    this.median,
    this.q3,
    this.max,
  );
}

class _BoxplotPainter extends CustomPainter {
  final List<_BoxplotStats> groups;

  const _BoxplotPainter(this.groups);

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 36.0;
    const bottomMargin = 24.0;
    final maxV = groups.map((g) => g.max).reduce(math.max);
    final minV = groups.map((g) => g.min).reduce(math.min);
    final gridH = size.height - bottomMargin;
    final gridW = size.width - leftMargin;
    final slotW = gridW / groups.length;

    double y(double v) => gridH - (v - minV) / (maxV - minV) * gridH;

    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    canvas.drawLine(Offset(leftMargin, 0), Offset(leftMargin, gridH), axisPaint);
    canvas.drawLine(
      Offset(leftMargin, gridH),
      Offset(size.width, gridH),
      axisPaint,
    );

    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      final cx = leftMargin + slotW * i + slotW / 2;
      final boxPaint = Paint()
        ..color = Colors.indigo
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      final fillPaint = Paint()..color = Colors.indigo.withValues(alpha: 0.15);

      canvas.drawLine(Offset(cx, y(g.min)), Offset(cx, y(g.q1)), boxPaint);
      canvas.drawLine(Offset(cx, y(g.q3)), Offset(cx, y(g.max)), boxPaint);
      canvas.drawLine(
        Offset(cx - 10, y(g.min)),
        Offset(cx + 10, y(g.min)),
        boxPaint,
      );
      canvas.drawLine(
        Offset(cx - 10, y(g.max)),
        Offset(cx + 10, y(g.max)),
        boxPaint,
      );

      final boxRect = Rect.fromLTRB(cx - 22, y(g.q3), cx + 22, y(g.q1));
      canvas.drawRect(boxRect, fillPaint);
      canvas.drawRect(boxRect, boxPaint);

      canvas.drawLine(
        Offset(cx - 22, y(g.median)),
        Offset(cx + 22, y(g.median)),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2.2,
      );

      _drawText(
        canvas,
        g.label,
        Offset(cx, gridH + 12),
        fontSize: 10,
        color: Colors.black54,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BoxplotPainter oldDelegate) => false;
}

Widget _chart63(BuildContext context) {
  const groups = [
    _BoxplotStats('Grupo A', 20, 35, 48, 60, 78),
    _BoxplotStats('Grupo B', 15, 28, 33, 42, 55),
    _BoxplotStats('Grupo C', 30, 45, 58, 70, 92),
  ];

  return _customPaintCard(
    painter: const _BoxplotPainter(groups),
    height: 300,
    caption: const Text(
      'Caja = rango intercuartílico (Q1–Q3), línea roja = mediana, bigotes = mín/máx',
      style: TextStyle(fontSize: 11, color: Colors.black54),
      textAlign: TextAlign.center,
    ),
  );
}

// ---------------------------------------------------------------------------
// 24. Timeline tipo Gantt
//
// Misma técnica de "barra flotante" que el waterfall: serie "Inicio"
// transparente + serie "Duración" visible, sobre un BarChart horizontal
// (vertical: false) apilado.
// ---------------------------------------------------------------------------

class _GanttTask {
  final String task;
  final double start;
  final double duration;

  const _GanttTask(this.task, this.start, this.duration);
}

Widget _chart64(BuildContext context) {
  const tasks = [
    _GanttTask('Diseño', 0, 3),
    _GanttTask('Desarrollo', 3, 6),
    _GanttTask('Pruebas', 7, 3),
    _GanttTask('Despliegue', 10, 2),
  ];

  final baseData = [for (final t in tasks) _OrdinalValue(t.task, t.start)];
  final durationData = [
    for (final t in tasks) _OrdinalValue(t.task, t.duration),
  ];

  final series = [
    charts.Series<_OrdinalValue, String>(
      id: 'Inicio',
      domainFn: (d, _) => d.label,
      measureFn: (d, _) => d.value,
      colorFn: (_, _) => charts.Color.transparent,
      data: baseData,
    ),
    charts.Series<_OrdinalValue, String>(
      id: 'Duración',
      domainFn: (d, _) => d.label,
      measureFn: (d, _) => d.value,
      colorFn: (_, _) => charts.MaterialPalette.indigo.shadeDefault,
      data: durationData,
    ),
  ];

  return _chartCard(
    chart: charts.BarChart(
      series,
      animate: true,
      vertical: false,
      barGroupingType: charts.BarGroupingType.stacked,
    ),
    legend: const Text(
      'Barras flotantes: segmento invisible = inicio, segmento visible = duración (días)',
      style: TextStyle(fontSize: 11, color: Colors.black54),
      textAlign: TextAlign.center,
    ),
  );
}

// ---------------------------------------------------------------------------
// 25. Dashboard combinado (sparkline + KPI + flecha de tendencia)
// ---------------------------------------------------------------------------

Widget _chart65(BuildContext context) {
  const values = [62.0, 65.0, 61.0, 70.0, 73.0, 78.0, 82.0];
  final data = [
    for (var i = 0; i < values.length; i++) _NumPoint(i, values[i]),
  ];
  final trendUp = values.last >= values.first;

  final series = [
    charts.Series<_NumPoint, num>(
      id: 'Tendencia',
      domainFn: (d, _) => d.x,
      measureFn: (d, _) => d.y,
      colorFn: (_, _) => trendUp
          ? charts.MaterialPalette.green.shadeDefault
          : charts.MaterialPalette.red.shadeDefault,
      data: data,
    ),
  ];

  final changePct = (values.last - values.first) / values.first * 100;

  return SizedBox(
    height: 180,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Usuarios activos',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  '${values.last.toInt()}k',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: trendUp ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    Text(
                      '${changePct.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: trendUp ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: charts.LineChart(
              series,
              animate: false,
              domainAxis: charts.NumericAxisSpec(
                renderSpec: charts.NoneRenderSpec<num>(),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.NoneRenderSpec<num>(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Catalog
// ---------------------------------------------------------------------------

final List<ChartSpec> communityAdvancedPart2 = [
  ChartSpec(
    id: 'cc_a54',
    title: 'Matriz de correlación (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart54,
  ),
  ChartSpec(
    id: 'cc_a55',
    title: 'Curva de distribución normal',
    category: ChartCategory.advanced,
    builder: _chart55,
  ),
  ChartSpec(
    id: 'cc_a56',
    title: 'Probabilidad posterior de Bayes (slider interactivo)',
    category: ChartCategory.advanced,
    builder: (context) => const _BayesPosteriorCard(),
  ),
  ChartSpec(
    id: 'cc_a57',
    title: 'Matriz de confusión (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart57,
  ),
  ChartSpec(
    id: 'cc_a58',
    title: 'Waterfall (barras en cascada)',
    category: ChartCategory.advanced,
    builder: _chart58,
  ),
  ChartSpec(
    id: 'cc_a59',
    title: 'Funnel (embudo, custom painter)',
    category: ChartCategory.advanced,
    builder: _chart59,
  ),
  ChartSpec(
    id: 'cc_a60',
    title: 'Árbol de decisiones (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart60,
  ),
  ChartSpec(
    id: 'cc_a61',
    title: 'Red Bayesiana (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart61,
  ),
  ChartSpec(
    id: 'cc_a62',
    title: 'Grafo de red (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart62,
  ),
  ChartSpec(
    id: 'cc_a63',
    title: 'Boxplot (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart63,
  ),
  ChartSpec(
    id: 'cc_a64',
    title: 'Timeline tipo Gantt',
    category: ChartCategory.advanced,
    builder: _chart64,
  ),
  ChartSpec(
    id: 'cc_a65',
    title: 'Dashboard combinado (sparkline + KPI + flecha de tendencia)',
    category: ChartCategory.advanced,
    builder: _chart65,
  ),
];
