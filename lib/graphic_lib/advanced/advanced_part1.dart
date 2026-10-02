import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../core/chart_spec.dart';

// ---------------------------------------------------------------------------
// Catalog (items 1-13)
// ---------------------------------------------------------------------------

final List<ChartSpec> graphicAdvancedPart1 = [
  const ChartSpec(
    id: 'gr_a41',
    title: 'Mapa de calor (heatmap)',
    category: ChartCategory.advanced,
    builder: _heatmapBuilder,
  ),
  const ChartSpec(
    id: 'gr_a42',
    title: 'Treemap (aproximado con cuadrícula)',
    category: ChartCategory.advanced,
    builder: _treemapBuilder,
  ),
  const ChartSpec(
    id: 'gr_a43',
    title: 'Red bayesiana (grafo dirigido)',
    category: ChartCategory.advanced,
    builder: _bayesianNetworkBuilder,
  ),
  const ChartSpec(
    id: 'gr_a44',
    title: 'Árbol de decisión',
    category: ChartCategory.advanced,
    builder: _decisionTreeBuilder,
  ),
  const ChartSpec(
    id: 'gr_a45',
    title: 'Boxplot (cuartiles)',
    category: ChartCategory.advanced,
    builder: _boxplotBuilder,
  ),
  const ChartSpec(
    id: 'gr_a46',
    title: 'Velas japonesas (candlestick)',
    category: ChartCategory.advanced,
    builder: _candlestickBuilder,
  ),
  const ChartSpec(
    id: 'gr_a47',
    title: 'Coordenadas paralelas',
    category: ChartCategory.advanced,
    builder: _parallelCoordinatesBuilder,
  ),
  const ChartSpec(
    id: 'gr_a48',
    title: 'Matriz de correlación (scatter matrix)',
    category: ChartCategory.advanced,
    builder: _scatterMatrixBuilder,
  ),
  const ChartSpec(
    id: 'gr_a49',
    title: 'Embudo de ventas (funnel)',
    category: ChartCategory.advanced,
    builder: _funnelBuilder,
  ),
  const ChartSpec(
    id: 'gr_a50',
    title: 'Waterfall (cascada)',
    category: ChartCategory.advanced,
    builder: _waterfallBuilder,
  ),
  const ChartSpec(
    id: 'gr_a51',
    title: 'Curva de probabilidad normal',
    category: ChartCategory.advanced,
    builder: _normalCurveBuilder,
  ),
  const ChartSpec(
    id: 'gr_a52',
    title: 'Probabilidad posterior (teorema de Bayes)',
    category: ChartCategory.advanced,
    builder: _bayesPosteriorBuilder,
  ),
  const ChartSpec(
    id: 'gr_a53',
    title: 'Densidad bivariada (binning + heatmap)',
    category: ChartCategory.advanced,
    builder: _densityPlotBuilder,
  ),
];

// ---------------------------------------------------------------------------
// 1. Heatmap — PolygonMark + HeatmapShape
// ---------------------------------------------------------------------------

Widget _heatmapBuilder(BuildContext context) => const _HeatmapChart();

class _HeatmapChart extends StatelessWidget {
  const _HeatmapChart();

  static const _dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  static const _franjas = ['00-06h', '06-12h', '12-18h', '18-24h'];

  List<Map<String, dynamic>> _data() {
    final rows = <Map<String, dynamic>>[];
    for (var d = 0; d < _dias.length; d++) {
      for (var f = 0; f < _franjas.length; f++) {
        final base = (math.sin(d * 0.9 + f * 1.3) + 1) * 50;
        final weekend = d >= 5 ? 20 : 0;
        rows.add({
          'dia': _dias[d],
          'franja': _franjas[f],
          'actividad': (base + weekend).round(),
        });
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data(),
        variables: {
          'dia': Variable(
            accessor: (Map m) => m['dia'] as String,
            scale: OrdinalScale(values: _dias),
          ),
          'franja': Variable(
            accessor: (Map m) => m['franja'] as String,
            scale: OrdinalScale(values: _franjas),
          ),
          'actividad': Variable(accessor: (Map m) => m['actividad'] as num),
        },
        marks: [
          PolygonMark(
            shape: ShapeEncode(
              value: HeatmapShape(borderRadius: BorderRadius.circular(3)),
            ),
            color: ColorEncode(
              variable: 'actividad',
              values: const [
                Color(0xffe3f2fd),
                Color(0xff1e88e5),
                Color(0xff0d47a1),
              ],
            ),
            label: LabelEncode(
              encoder: (tuple) => Label(
                '${tuple['actividad']}',
                LabelStyle(
                  textStyle: TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Treemap-like — PolygonMark + HeatmapShape over category/subcategory grid
//
// `graphic` has no recursive squarified-treemap layout, so this approximates a
// treemap with a uniform category x subcategory grid whose color encodes the
// value (a common "treemap-like" fallback when only grid tiling is available).
// ---------------------------------------------------------------------------

Widget _treemapBuilder(BuildContext context) => const _TreemapChart();

class _TreemapChart extends StatelessWidget {
  const _TreemapChart();

  static const _data = [
    {'categoria': 'Electrónica', 'sub': 'Teléfonos', 'ventas': 420},
    {'categoria': 'Electrónica', 'sub': 'Laptops', 'ventas': 310},
    {'categoria': 'Electrónica', 'sub': 'Audio', 'ventas': 150},
    {'categoria': 'Hogar', 'sub': 'Cocina', 'ventas': 220},
    {'categoria': 'Hogar', 'sub': 'Muebles', 'ventas': 180},
    {'categoria': 'Hogar', 'sub': 'Decoración', 'ventas': 95},
    {'categoria': 'Ropa', 'sub': 'Hombre', 'ventas': 260},
    {'categoria': 'Ropa', 'sub': 'Mujer', 'ventas': 340},
    {'categoria': 'Ropa', 'sub': 'Niños', 'ventas': 130},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data,
        variables: {
          'categoria': Variable(accessor: (Map m) => m['categoria'] as String),
          'sub': Variable(accessor: (Map m) => m['sub'] as String),
          'ventas': Variable(accessor: (Map m) => m['ventas'] as num),
        },
        marks: [
          PolygonMark(
            shape: ShapeEncode(
              value: HeatmapShape(borderRadius: BorderRadius.circular(4)),
            ),
            color: ColorEncode(
              variable: 'ventas',
              values: const [Color(0xfffff3e0), Color(0xffef6c00)],
            ),
            label: LabelEncode(
              encoder: (tuple) => Label(
                '${tuple['sub']}\n${tuple['ventas']}',
                LabelStyle(
                  textStyle: TextStyle(fontSize: 9, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Red bayesiana — CustomPainter (graphic has no node/edge graph model)
// ---------------------------------------------------------------------------

Widget _bayesianNetworkBuilder(BuildContext context) =>
    const _BayesianNetworkChart();

class _BayesianNetworkChart extends StatelessWidget {
  const _BayesianNetworkChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      width: double.infinity,
      child: CustomPaint(painter: _BayesianNetworkPainter()),
    );
  }
}

class _BayesNode {
  final String label;
  final Offset pos; // normalized 0..1
  const _BayesNode(this.label, this.pos);
}

class _BayesEdge {
  final int from;
  final int to;
  final String prob;
  const _BayesEdge(this.from, this.to, this.prob);
}

class _BayesianNetworkPainter extends CustomPainter {
  static const _nodes = [
    _BayesNode('Clima', Offset(0.2, 0.15)),
    _BayesNode('Tráfico', Offset(0.8, 0.15)),
    _BayesNode('Lluvia', Offset(0.2, 0.75)),
    _BayesNode('Accidente', Offset(0.8, 0.75)),
  ];

  static const _edges = [
    _BayesEdge(0, 2, 'P=0.70'),
    _BayesEdge(0, 1, 'P=0.40'),
    _BayesEdge(2, 3, 'P=0.55'),
    _BayesEdge(1, 3, 'P=0.35'),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    Offset toCanvas(Offset n) => Offset(n.dx * size.width, n.dy * size.height);

    final edgePaint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final edge in _edges) {
      final start = toCanvas(_nodes[edge.from].pos);
      final end = toCanvas(_nodes[edge.to].pos);
      _drawArrow(canvas, start, end, edgePaint);

      final mid = Offset.lerp(start, end, 0.5)!;
      _drawText(
        canvas,
        edge.prob,
        mid,
        const TextStyle(
          fontSize: 11,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w600,
        ),
        background: Colors.white,
      );
    }

    final nodePaint = Paint()..color = const Color(0xff1890ff);
    for (final node in _nodes) {
      final center = toCanvas(node.pos);
      canvas.drawCircle(center, 34, nodePaint);
      canvas.drawCircle(
        center,
        34,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
      _drawText(
        canvas,
        node.label,
        center,
        const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    const nodeRadius = 34.0;
    final direction = end - start;
    final length = direction.distance;
    if (length == 0) return;
    final unit = direction / length;
    final trimmedStart = start + unit * nodeRadius;
    final trimmedEnd = end - unit * nodeRadius;
    canvas.drawLine(trimmedStart, trimmedEnd, paint);

    const arrowSize = 9.0;
    final angle = math.atan2(unit.dy, unit.dx);
    final p1 = trimmedEnd -
        Offset(
          arrowSize * math.cos(angle - math.pi / 7),
          arrowSize * math.sin(angle - math.pi / 7),
        );
    final p2 = trimmedEnd -
        Offset(
          arrowSize * math.cos(angle + math.pi / 7),
          arrowSize * math.sin(angle + math.pi / 7),
        );
    final path = Path()
      ..moveTo(trimmedEnd.dx, trimmedEnd.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = paint.color);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style, {
    Color? background,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    final offset = center - Offset(painter.width / 2, painter.height / 2);
    if (background != null) {
      final rect = Rect.fromCenter(
        center: center,
        width: painter.width + 6,
        height: painter.height + 2,
      );
      canvas.drawRect(rect, Paint()..color = background);
    }
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// 4. Árbol de decisión — CustomPainter (graphic has no tree layout model)
// ---------------------------------------------------------------------------

Widget _decisionTreeBuilder(BuildContext context) => const _DecisionTreeChart();

class _DecisionTreeChart extends StatelessWidget {
  const _DecisionTreeChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      width: double.infinity,
      child: CustomPaint(painter: _DecisionTreePainter()),
    );
  }
}

class _TreeNode {
  final String label;
  final String? edgeLabel;
  final List<_TreeNode> children;
  const _TreeNode(this.label, {this.edgeLabel, this.children = const []});
}

class _DecisionTreePainter extends CustomPainter {
  static const _root = _TreeNode(
    '¿Ingreso > 3000?',
    children: [
      _TreeNode(
        '¿Edad > 30?',
        edgeLabel: 'Sí',
        children: [
          _TreeNode('Aprobar crédito', edgeLabel: 'Sí'),
          _TreeNode(
            '¿Historial OK?',
            edgeLabel: 'No',
            children: [
              _TreeNode('Aprobar crédito', edgeLabel: 'Sí'),
              _TreeNode('Rechazar', edgeLabel: 'No'),
            ],
          ),
        ],
      ),
      _TreeNode(
        '¿Tiene aval?',
        edgeLabel: 'No',
        children: [
          _TreeNode('Aprobar con aval', edgeLabel: 'Sí'),
          _TreeNode('Rechazar', edgeLabel: 'No'),
        ],
      ),
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    final levels = <List<_PositionedNode>>[];
    _collectLevels(_root, 0, levels);

    final levelHeight = size.height / levels.length;
    final positioned = <_TreeNode, Offset>{};

    for (var level = 0; level < levels.length; level++) {
      final nodesInLevel = levels[level];
      final slotWidth = size.width / nodesInLevel.length;
      for (var i = 0; i < nodesInLevel.length; i++) {
        final center = Offset(
          slotWidth * (i + 0.5),
          levelHeight * level + levelHeight / 2,
        );
        positioned[nodesInLevel[i].node] = center;
      }
    }

    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5;

    void drawEdges(_TreeNode node) {
      final from = positioned[node]!;
      for (final child in node.children) {
        final to = positioned[child]!;
        canvas.drawLine(from, to, linePaint);
        if (child.edgeLabel != null) {
          final mid = Offset.lerp(from, to, 0.45)!;
          _drawLabel(
            canvas,
            child.edgeLabel!,
            mid,
            const TextStyle(fontSize: 10, color: Colors.deepOrange),
            fill: Colors.white,
          );
        }
        drawEdges(child);
      }
    }

    drawEdges(_root);

    for (final entry in positioned.entries) {
      final node = entry.key;
      final center = entry.value;
      final isLeaf = node.children.isEmpty;
      _drawBox(
        canvas,
        node.label,
        center,
        fill: isLeaf ? const Color(0xff2e7d32) : const Color(0xff1565c0),
      );
    }
  }

  void _collectLevels(
    _TreeNode node,
    int depth,
    List<List<_PositionedNode>> levels,
  ) {
    if (levels.length <= depth) levels.add([]);
    levels[depth].add(_PositionedNode(node));
    for (final child in node.children) {
      _collectLevels(child, depth + 1, levels);
    }
  }

  void _drawBox(
    Canvas canvas,
    String text,
    Offset center, {
    required Color fill,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 110);

    final rect = Rect.fromCenter(
      center: center,
      width: painter.width + 16,
      height: painter.height + 14,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rrect, Paint()..color = fill);
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style, {
    Color? fill,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    if (fill != null) {
      canvas.drawRect(
        Rect.fromCenter(
          center: center,
          width: painter.width + 4,
          height: painter.height + 2,
        ),
        Paint()..color = fill,
      );
    }
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PositionedNode {
  final _TreeNode node;
  const _PositionedNode(this.node);
}

// ---------------------------------------------------------------------------
// 5. Boxplot — approximated with layered IntervalMarks (box + whiskers) and a
// PointMark for the median. `graphic` has no native box-and-whisker shape.
// ---------------------------------------------------------------------------

Widget _boxplotBuilder(BuildContext context) => const _BoxplotChart();

class _BoxplotChart extends StatelessWidget {
  const _BoxplotChart();

  static const _data = [
    {'grupo': 'A', 'min': 12, 'q1': 20, 'mediana': 28, 'q3': 35, 'max': 48},
    {'grupo': 'B', 'min': 8, 'q1': 15, 'mediana': 22, 'q3': 30, 'max': 40},
    {'grupo': 'C', 'min': 18, 'q1': 26, 'mediana': 33, 'q3': 41, 'max': 55},
    {'grupo': 'D', 'min': 5, 'q1': 11, 'mediana': 17, 'q3': 24, 'max': 33},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data,
        variables: {
          'grupo': Variable(accessor: (Map m) => m['grupo'] as String),
          'min': Variable(accessor: (Map m) => m['min'] as num),
          'q1': Variable(accessor: (Map m) => m['q1'] as num),
          'mediana': Variable(accessor: (Map m) => m['mediana'] as num),
          'q3': Variable(accessor: (Map m) => m['q3'] as num),
          'max': Variable(accessor: (Map m) => m['max'] as num),
        },
        marks: [
          // Whisker: thin line from min to max.
          IntervalMark(
            position: Varset('grupo') * (Varset('min') + Varset('max')),
            size: SizeEncode(value: 2),
            color: ColorEncode(value: Colors.grey.shade600),
          ),
          // Box: q1 to q3.
          IntervalMark(
            position: Varset('grupo') * (Varset('q1') + Varset('q3')),
            size: SizeEncode(value: 34),
            color: ColorEncode(value: const Color(0xff1890ff).withAlpha(180)),
            shape: ShapeEncode(
              value: RectShape(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          // Median marker.
          PointMark(
            position: Varset('grupo') * Varset('mediana'),
            size: SizeEncode(value: 10),
            shape: ShapeEncode(value: SquareShape()),
            color: ColorEncode(value: Colors.black87),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Velas japonesas — CustomMark with the package's built-in CandlestickShape
// ---------------------------------------------------------------------------

Widget _candlestickBuilder(BuildContext context) => const _CandlestickChart();

class _CandlestickChart extends StatelessWidget {
  const _CandlestickChart();

  static List<Map<String, dynamic>> _data() {
    final rows = <Map<String, dynamic>>[];
    double price = 100;
    for (var i = 1; i <= 10; i++) {
      final open = price;
      final delta = math.sin(i * 0.8) * 6 + (i.isEven ? 2 : -3);
      final close = open + delta;
      final high = math.max(open, close) + 2 + (i % 3);
      final low = math.min(open, close) - 2 - (i % 2);
      rows.add({
        'periodo': 'D$i',
        'open': open,
        'close': close,
        'high': high,
        'low': low,
      });
      price = close;
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data(),
        variables: {
          'periodo': Variable(accessor: (Map m) => m['periodo'] as String),
          'open': Variable(accessor: (Map m) => m['open'] as num),
          'close': Variable(accessor: (Map m) => m['close'] as num),
          'high': Variable(accessor: (Map m) => m['high'] as num),
          'low': Variable(accessor: (Map m) => m['low'] as num),
        },
        marks: [
          CustomMark(
            position: Varset('periodo') *
                (Varset('open') + Varset('close') + Varset('high') + Varset('low')),
            shape: ShapeEncode(value: CandlestickShape(hollow: false)),
            size: SizeEncode(value: 10),
            color: ColorEncode(
              encoder: (tuple) {
                final open = tuple['open'] as num;
                final close = tuple['close'] as num;
                return close >= open
                    ? const Color(0xff2e7d32)
                    : const Color(0xffc62828);
              },
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Coordenadas paralelas — LineMark over long-format normalized data.
//
// Each sample becomes several tuples (one per axis). Plotting `axis` (ordinal)
// against normalized `valor` and nesting by `muestra` draws one connected line
// per sample crossing all parallel vertical axes — a standard parallel
// coordinates look using only the regular multi-series line recipe.
// ---------------------------------------------------------------------------

Widget _parallelCoordinatesBuilder(BuildContext context) =>
    const _ParallelCoordinatesChart();

class _ParallelCoordinatesChart extends StatelessWidget {
  const _ParallelCoordinatesChart();

  static const _axes = ['Edad', 'Ingreso', 'Gasto', 'Satisfacción'];
  static const _raw = [
    {'muestra': 'Cliente 1', 'Edad': 25.0, 'Ingreso': 2800.0, 'Gasto': 900.0, 'Satisfacción': 7.0},
    {'muestra': 'Cliente 2', 'Edad': 42.0, 'Ingreso': 5200.0, 'Gasto': 2100.0, 'Satisfacción': 9.0},
    {'muestra': 'Cliente 3', 'Edad': 35.0, 'Ingreso': 3600.0, 'Gasto': 1500.0, 'Satisfacción': 5.0},
    {'muestra': 'Cliente 4', 'Edad': 58.0, 'Ingreso': 4100.0, 'Gasto': 800.0, 'Satisfacción': 6.0},
    {'muestra': 'Cliente 5', 'Edad': 30.0, 'Ingreso': 6000.0, 'Gasto': 3000.0, 'Satisfacción': 8.0},
  ];

  List<Map<String, dynamic>> _normalized() {
    final mins = <String, double>{};
    final maxs = <String, double>{};
    for (final axis in _axes) {
      final values = _raw.map((r) => r[axis] as double);
      mins[axis] = values.reduce(math.min);
      maxs[axis] = values.reduce(math.max);
    }

    final rows = <Map<String, dynamic>>[];
    for (final sample in _raw) {
      for (final axis in _axes) {
        final v = sample[axis] as double;
        final min = mins[axis]!;
        final max = maxs[axis]!;
        final norm = max == min ? 0.5 : (v - min) / (max - min);
        rows.add({
          'muestra': sample['muestra'],
          'eje': axis,
          'valor': norm,
        });
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _normalized(),
        variables: {
          'eje': Variable(
            accessor: (Map m) => m['eje'] as String,
            scale: OrdinalScale(values: _axes),
          ),
          'valor': Variable(
            accessor: (Map m) => m['valor'] as num,
            scale: LinearScale(min: 0, max: 1),
          ),
          'muestra': Variable(accessor: (Map m) => m['muestra'] as String),
        },
        marks: [
          LineMark(
            position: Varset('eje') * Varset('valor') / Varset('muestra'),
            color: ColorEncode(variable: 'muestra', values: Defaults.colors10),
            size: SizeEncode(value: 2),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        tooltip: TooltipGuide(variables: const ['muestra', 'eje', 'valor']),
        selections: {
          'hover': PointSelection(
            on: const {GestureType.hover, GestureType.tap},
            variable: 'muestra',
          ),
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Matriz de correlación — grid of small PointMark scatter charts (facets)
// ---------------------------------------------------------------------------

Widget _scatterMatrixBuilder(BuildContext context) => const _ScatterMatrixChart();

class _ScatterMatrixChart extends StatelessWidget {
  const _ScatterMatrixChart();

  static List<Map<String, dynamic>> _points() {
    final rows = <Map<String, dynamic>>[];
    for (var i = 0; i < 30; i++) {
      final t = i / 30;
      rows.add({
        'x': 10 + t * 40 + math.sin(i * 0.7) * 5,
        'y': 5 + t * 25 + math.cos(i * 0.5) * 4,
        'z': 20 - t * 10 + math.sin(i * 1.1) * 6,
      });
    }
    return rows;
  }

  Widget _pairChart(String varX, String varY, List<Map<String, dynamic>> data) {
    return Column(
      children: [
        Text('$varX vs $varY', style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 4),
        Expanded(
          child: Chart(
            data: data,
            variables: {
              varX: Variable(accessor: (Map m) => m[varX] as num),
              varY: Variable(accessor: (Map m) => m[varY] as num),
            },
            marks: [
              PointMark(
                size: SizeEncode(value: 4),
                color: ColorEncode(value: const Color(0xff1890ff)),
              ),
            ],
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _points();
    const pairs = [
      ['x', 'y'],
      ['x', 'z'],
      ['y', 'z'],
    ];
    return SizedBox(
      height: 360,
      child: Row(
        children: [
          for (final pair in pairs) ...[
            Expanded(child: _pairChart(pair[0], pair[1], data)),
            if (pair != pairs.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. Embudo de ventas — IntervalMark + native FunnelShape
// ---------------------------------------------------------------------------

Widget _funnelBuilder(BuildContext context) => const _FunnelChart();

class _FunnelChart extends StatelessWidget {
  const _FunnelChart();

  static const _data = [
    {'etapa': 'Prospectos', 'valor': 1000},
    {'etapa': 'Contactados', 'valor': 720},
    {'etapa': 'Propuestas', 'valor': 430},
    {'etapa': 'Negociación', 'valor': 240},
    {'etapa': 'Cierre', 'valor': 110},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data,
        variables: {
          'etapa': Variable(
            accessor: (Map m) => m['etapa'] as String,
            scale: OrdinalScale(values: _data.map((e) => e['etapa'] as String).toList()),
          ),
          'valor': Variable(accessor: (Map m) => m['valor'] as num),
        },
        marks: [
          IntervalMark(
            shape: ShapeEncode(value: FunnelShape(labelPosition: 0.5)),
            color: ColorEncode(variable: 'etapa', values: Defaults.colors10),
            label: LabelEncode(
              encoder: (tuple) => Label(
                '${tuple['etapa']}\n${tuple['valor']}',
                LabelStyle(
                  textStyle: TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
        coord: RectCoord(transposed: true),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. Waterfall — IntervalMark with explicit start/end (blend) per step
// ---------------------------------------------------------------------------

Widget _waterfallBuilder(BuildContext context) => const _WaterfallChart();

class _WaterfallChart extends StatelessWidget {
  const _WaterfallChart();

  static List<Map<String, dynamic>> _steps() {
    const raw = [
      {'paso': 'Inicio', 'delta': 500, 'tipo': 'total'},
      {'paso': '+Ventas', 'delta': 320, 'tipo': 'incremento'},
      {'paso': '-Costos', 'delta': -180, 'tipo': 'decremento'},
      {'paso': '+Otros ingresos', 'delta': 90, 'tipo': 'incremento'},
      {'paso': '-Impuestos', 'delta': -110, 'tipo': 'decremento'},
      {'paso': 'Final', 'delta': 0, 'tipo': 'total'},
    ];

    final rows = <Map<String, dynamic>>[];
    num running = 0;
    for (var i = 0; i < raw.length; i++) {
      final step = raw[i];
      final isTotal = step['tipo'] == 'total';
      num start;
      num end;
      if (isTotal) {
        // A "total" step (opening/closing balance) is a full column from 0.
        start = 0;
        end = i == 0 ? (step['delta'] as num) : running;
      } else {
        start = running;
        end = running + (step['delta'] as num);
      }
      rows.add({
        'paso': step['paso'],
        'inicio': math.min(start, end),
        'fin': math.max(start, end),
        'tipo': step['tipo'],
      });
      running = end;
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final data = _steps();
    return SizedBox(
      height: 340,
      child: Chart(
        data: data,
        variables: {
          'paso': Variable(
            accessor: (Map m) => m['paso'] as String,
            scale: OrdinalScale(values: data.map((e) => e['paso'] as String).toList()),
          ),
          'inicio': Variable(accessor: (Map m) => m['inicio'] as num),
          'fin': Variable(accessor: (Map m) => m['fin'] as num),
          'tipo': Variable(accessor: (Map m) => m['tipo'] as String),
        },
        marks: [
          IntervalMark(
            position: Varset('paso') * (Varset('inicio') + Varset('fin')),
            color: ColorEncode(
              variable: 'tipo',
              values: const [Color(0xff1565c0), Color(0xff2e7d32), Color(0xffc62828)],
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 11. Curva de probabilidad normal — LineMark over a computed Gaussian PDF
// ---------------------------------------------------------------------------

Widget _normalCurveBuilder(BuildContext context) => const _NormalCurveChart();

class _NormalCurveChart extends StatelessWidget {
  const _NormalCurveChart();

  static const double _mu = 0;
  static const double _sigma = 1.2;

  static double _pdf(double x) {
    final coef = 1 / (_sigma * math.sqrt(2 * math.pi));
    final exponent = -0.5 * math.pow((x - _mu) / _sigma, 2);
    return coef * math.exp(exponent);
  }

  static List<Map<String, dynamic>> _data() {
    final rows = <Map<String, dynamic>>[];
    for (var i = -40; i <= 40; i++) {
      final x = i / 10;
      rows.add({'x': x, 'densidad': _pdf(x)});
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data(),
        variables: {
          'x': Variable(accessor: (Map m) => m['x'] as num, scale: LinearScale(min: -4, max: 4)),
          'densidad': Variable(accessor: (Map m) => m['densidad'] as num, scale: LinearScale(min: 0)),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 2),
            color: ColorEncode(value: const Color(0xff1890ff)),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 12. Probabilidad posterior (Bayes) — interactive sliders + LineMark curve
// ---------------------------------------------------------------------------

Widget _bayesPosteriorBuilder(BuildContext context) => const _BayesPosteriorChart();

double _bayes({
  required double prior,
  required double sensitivity,
  required double falsePositive,
}) {
  final probabilityPositive = (sensitivity * prior) + (falsePositive * (1 - prior));
  if (probabilityPositive == 0) return 0;
  return (sensitivity * prior) / probabilityPositive;
}

class _BayesPosteriorChart extends StatefulWidget {
  const _BayesPosteriorChart();

  @override
  State<_BayesPosteriorChart> createState() => _BayesPosteriorChartState();
}

class _BayesPosteriorChartState extends State<_BayesPosteriorChart> {
  double _prior = 0.1;
  double _sensitivity = 0.9;
  double _falsePositive = 0.05;

  List<Map<String, dynamic>> _curve() {
    final rows = <Map<String, dynamic>>[];
    for (var i = 0; i <= 40; i++) {
      final p = i / 40;
      rows.add({
        'prior': p,
        'posterior': _bayes(
          prior: p,
          sensitivity: _sensitivity,
          falsePositive: _falsePositive,
        ),
      });
    }
    return rows;
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 1,
          ),
        ),
        SizedBox(width: 44, child: Text('${(value * 100).toStringAsFixed(0)}%')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final posterior = _bayes(
      prior: _prior,
      sensitivity: _sensitivity,
      falsePositive: _falsePositive,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _slider('Prior', _prior, (v) => setState(() => _prior = v)),
        _slider('Sensibilidad', _sensitivity, (v) => setState(() => _sensitivity = v)),
        _slider('Falsos positivos', _falsePositive, (v) => setState(() => _falsePositive = v)),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Posterior: ${(posterior * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Chart(
            data: _curve(),
            variables: {
              'prior': Variable(accessor: (Map m) => m['prior'] as num, scale: LinearScale(min: 0, max: 1)),
              'posterior': Variable(accessor: (Map m) => m['posterior'] as num, scale: LinearScale(min: 0, max: 1)),
            },
            marks: [
              LineMark(
                shape: ShapeEncode(value: BasicLineShape(smooth: true)),
                color: ColorEncode(value: const Color(0xff6a1b9a)),
              ),
            ],
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 13. Densidad bivariada — PolygonMark + HeatmapShape over binned 2D samples
// ---------------------------------------------------------------------------

Widget _densityPlotBuilder(BuildContext context) => const _DensityPlotChart();

class _DensityPlotChart extends StatelessWidget {
  const _DensityPlotChart();

  static const _bins = 10;

  static List<Map<String, dynamic>> _data() {
    final random = math.Random(7);
    final counts = List.generate(_bins, (_) => List.filled(_bins, 0));

    double gauss() {
      final u1 = 1 - random.nextDouble();
      final u2 = random.nextDouble();
      return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
    }

    for (var i = 0; i < 600; i++) {
      final sampleX = 0.5 + gauss() * 0.15;
      final sampleY = 0.5 + gauss() * 0.15;
      final bx = (sampleX * _bins).floor().clamp(0, _bins - 1);
      final by = (sampleY * _bins).floor().clamp(0, _bins - 1);
      counts[bx][by]++;
    }

    final rows = <Map<String, dynamic>>[];
    for (var x = 0; x < _bins; x++) {
      for (var y = 0; y < _bins; y++) {
        rows.add({'binX': x, 'binY': y, 'densidad': counts[x][y]});
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data(),
        variables: {
          'binX': Variable(accessor: (Map m) => m['binX'] as num),
          'binY': Variable(accessor: (Map m) => m['binY'] as num),
          'densidad': Variable(accessor: (Map m) => m['densidad'] as num),
        },
        marks: [
          PolygonMark(
            shape: ShapeEncode(value: HeatmapShape(tileCounts: const [_bins, _bins])),
            color: ColorEncode(
              variable: 'densidad',
              values: const [
                Color(0xffffffff),
                Color(0xffffcc80),
                Color(0xffe65100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
