import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../core/chart_spec.dart';

// ---------------------------------------------------------------------------
// Catalog (items 14-25)
// ---------------------------------------------------------------------------

final List<ChartSpec> graphicAdvancedPart2 = [
  const ChartSpec(
    id: 'gr_a54',
    title: 'Embudo de conversión (marketing)',
    category: ChartCategory.advanced,
    builder: _conversionFunnelBuilder,
  ),
  const ChartSpec(
    id: 'gr_a55',
    title: 'Animación de transición de datos',
    category: ChartCategory.advanced,
    builder: _transitionAnimationBuilder,
  ),
  const ChartSpec(
    id: 'gr_a56',
    title: 'Tooltip interactivo personalizado',
    category: ChartCategory.advanced,
    builder: _customTooltipBuilder,
  ),
  const ChartSpec(
    id: 'gr_a57',
    title: 'Barras apiladas al 100%',
    category: ChartCategory.advanced,
    builder: _stacked100Builder,
  ),
  const ChartSpec(
    id: 'gr_a58',
    title: 'Múltiples ejes Y',
    category: ChartCategory.advanced,
    builder: _dualAxisBuilder,
  ),
  const ChartSpec(
    id: 'gr_a59',
    title: 'Matriz de confusión',
    category: ChartCategory.advanced,
    builder: _confusionMatrixBuilder,
  ),
  const ChartSpec(
    id: 'gr_a60',
    title: 'Grafo de red (nodos y conexiones)',
    category: ChartCategory.advanced,
    builder: _networkGraphBuilder,
  ),
  const ChartSpec(
    id: 'gr_a61',
    title: 'Diagrama de Gantt',
    category: ChartCategory.advanced,
    builder: _ganttBuilder,
  ),
  const ChartSpec(
    id: 'gr_a62',
    title: 'Brushing (selección de rango)',
    category: ChartCategory.advanced,
    builder: _brushingBuilder,
  ),
  const ChartSpec(
    id: 'gr_a63',
    title: 'Clustering visual coloreado',
    category: ChartCategory.advanced,
    builder: _clusteringBuilder,
  ),
  const ChartSpec(
    id: 'gr_a64',
    title: 'Comparación multi-grupo (small multiples)',
    category: ChartCategory.advanced,
    builder: _smallMultiplesBuilder,
  ),
  const ChartSpec(
    id: 'gr_a65',
    title: 'Dashboard combinado (sparklines + KPIs)',
    category: ChartCategory.advanced,
    builder: _kpiDashboardBuilder,
  ),
];

// ---------------------------------------------------------------------------
// 14. Embudo de conversión — same IntervalMark + FunnelShape technique as #9
// ---------------------------------------------------------------------------

Widget _conversionFunnelBuilder(BuildContext context) => const _ConversionFunnelChart();

class _ConversionFunnelChart extends StatelessWidget {
  const _ConversionFunnelChart();

  static const _data = [
    {'etapa': 'Visitas', 'valor': 5400},
    {'etapa': 'Leads', 'valor': 1600},
    {'etapa': 'Oportunidades', 'valor': 540},
    {'etapa': 'Clientes', 'valor': 180},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
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
            shape: ShapeEncode(value: FunnelShape()),
            color: ColorEncode(variable: 'etapa', values: Defaults.colors10),
            label: LabelEncode(
              encoder: (tuple) => Label(
                '${tuple['etapa']}: ${tuple['valor']}',
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
// 15. Animación de transición — Timer periodically swaps `data`; graphic's
// Mark.transition + tag animate between the old and new values automatically.
// ---------------------------------------------------------------------------

Widget _transitionAnimationBuilder(BuildContext context) => const _TransitionAnimationChart();

class _TransitionAnimationChart extends StatefulWidget {
  const _TransitionAnimationChart();

  @override
  State<_TransitionAnimationChart> createState() => _TransitionAnimationChartState();
}

class _TransitionAnimationChartState extends State<_TransitionAnimationChart> {
  static const _categorias = ['Norte', 'Sur', 'Este', 'Oeste'];
  final _random = math.Random(3);
  late List<Map<String, dynamic>> _data;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _data = _randomData();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() => _data = _randomData());
    });
  }

  List<Map<String, dynamic>> _randomData() {
    return [
      for (final c in _categorias) {'categoria': c, 'valor': 20 + _random.nextInt(80)},
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Los datos cambian solos cada 2s; graphic anima la transición.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: Chart(
            data: _data,
            variables: {
              'categoria': Variable(accessor: (Map m) => m['categoria'] as String),
              'valor': Variable(accessor: (Map m) => m['valor'] as num, scale: LinearScale(min: 0, max: 110)),
            },
            marks: [
              IntervalMark(
                transition: Transition(duration: const Duration(milliseconds: 700), curve: Curves.easeInOut),
                entrance: const {MarkEntrance.y},
                tag: (tuple) => tuple['categoria'].toString(),
                color: ColorEncode(value: const Color(0xff1890ff)),
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
// 16. Tooltip interactivo personalizado — PointMark + custom TooltipRenderer
// ---------------------------------------------------------------------------

Widget _customTooltipBuilder(BuildContext context) => const _CustomTooltipChart();

class _CustomTooltipChart extends StatelessWidget {
  const _CustomTooltipChart();

  static const _data = [
    {'producto': 'Mouse', 'precio': 25.0, 'calificacion': 4.2},
    {'producto': 'Teclado', 'precio': 45.0, 'calificacion': 4.5},
    {'producto': 'Monitor', 'precio': 180.0, 'calificacion': 4.0},
    {'producto': 'Webcam', 'precio': 60.0, 'calificacion': 3.6},
    {'producto': 'Audífonos', 'precio': 90.0, 'calificacion': 4.7},
    {'producto': 'Micrófono', 'precio': 120.0, 'calificacion': 4.1},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data,
        variables: {
          'producto': Variable(accessor: (Map m) => m['producto'] as String),
          'precio': Variable(accessor: (Map m) => m['precio'] as num),
          'calificacion': Variable(accessor: (Map m) => m['calificacion'] as num, scale: LinearScale(min: 0, max: 5)),
        },
        marks: [
          PointMark(
            position: Varset('precio') * Varset('calificacion'),
            size: SizeEncode(value: 10),
            color: ColorEncode(
              value: const Color(0xff1890ff),
              updaters: {
                'tap': {false: (Color c) => c.withAlpha(90)},
              },
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        selections: {'tap': PointSelection(toggle: true)},
        tooltip: TooltipGuide(
          renderer: (Size size, Offset anchor, Map<int, Tuple> selected) {
            final tuple = selected.values.first;
            final text =
                '${tuple['producto']}\n\$${(tuple['precio'] as num).toStringAsFixed(0)} · ★${tuple['calificacion']}';
            final painter = TextPainter(
              text: TextSpan(
                text: text,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: 120);

            final box = Rect.fromCenter(
              center: anchor - const Offset(0, 30),
              width: painter.width + 16,
              height: painter.height + 14,
            );

            return [
              RectElement(
                rect: box,
                borderRadius: BorderRadius.circular(6),
                style: PaintStyle(fillColor: Colors.black87, elevation: 3),
              ),
              LabelElement(
                text: text,
                anchor: box.center,
                style: LabelStyle(
                  textStyle: TextStyle(color: Colors.white, fontSize: 11),
                  align: Alignment.center,
                  textAlign: TextAlign.center,
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 17. Apilado 100% — Proportion(nest: categoria) normalizes each group to 1
// ---------------------------------------------------------------------------

Widget _stacked100Builder(BuildContext context) => const _Stacked100Chart();

class _Stacked100Chart extends StatelessWidget {
  const _Stacked100Chart();

  static const _data = [
    {'categoria': '2023', 'tipo': 'Online', 'valor': 320},
    {'categoria': '2023', 'tipo': 'Tienda', 'valor': 480},
    {'categoria': '2023', 'tipo': 'Mayorista', 'valor': 200},
    {'categoria': '2024', 'tipo': 'Online', 'valor': 560},
    {'categoria': '2024', 'tipo': 'Tienda', 'valor': 410},
    {'categoria': '2024', 'tipo': 'Mayorista', 'valor': 150},
    {'categoria': '2025', 'tipo': 'Online', 'valor': 700},
    {'categoria': '2025', 'tipo': 'Tienda', 'valor': 300},
    {'categoria': '2025', 'tipo': 'Mayorista', 'valor': 120},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Chart(
        data: _data,
        variables: {
          'categoria': Variable(accessor: (Map m) => m['categoria'] as String),
          'tipo': Variable(accessor: (Map m) => m['tipo'] as String),
          'valor': Variable(accessor: (Map m) => m['valor'] as num),
        },
        transforms: [
          Proportion(variable: 'valor', nest: Varset('categoria'), as: 'porcentaje'),
        ],
        marks: [
          IntervalMark(
            position: Varset('categoria') * Varset('porcentaje') / Varset('tipo'),
            color: ColorEncode(variable: 'tipo', values: Defaults.colors10),
            modifiers: [StackModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 18. Múltiples ejes Y — approximated with a shared normalized [0,1] axis
// (graphic's position scale is shared per dimension across marks, so a truly
// independent secondary scale isn't directly expressible); a legend clarifies
// each series' real range.
// ---------------------------------------------------------------------------

Widget _dualAxisBuilder(BuildContext context) => const _DualAxisChart();

class _DualAxisChart extends StatelessWidget {
  const _DualAxisChart();

  static const _meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  static const _ventas = [40.0, 55.0, 48.0, 70.0, 65.0, 90.0];
  static const _temperatura = [14.0, 16.0, 19.0, 23.0, 27.0, 31.0];

  List<Map<String, dynamic>> _data() {
    final ventasMin = _ventas.reduce(math.min);
    final ventasMax = _ventas.reduce(math.max);
    final tempMin = _temperatura.reduce(math.min);
    final tempMax = _temperatura.reduce(math.max);

    final rows = <Map<String, dynamic>>[];
    for (var i = 0; i < _meses.length; i++) {
      rows.add({
        'mes': _meses[i],
        'serie': 'Ventas (k\$)',
        'valorNorm': (_ventas[i] - ventasMin) / (ventasMax - ventasMin),
      });
      rows.add({
        'mes': _meses[i],
        'serie': 'Temperatura (°C)',
        'valorNorm': (_temperatura[i] - tempMin) / (tempMax - tempMin),
      });
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 290,
          child: Chart(
            data: _data(),
            variables: {
              'mes': Variable(accessor: (Map m) => m['mes'] as String, scale: OrdinalScale(values: _meses)),
              'valorNorm': Variable(accessor: (Map m) => m['valorNorm'] as num, scale: LinearScale(min: 0, max: 1)),
              'serie': Variable(accessor: (Map m) => m['serie'] as String),
            },
            marks: [
              LineMark(
                position: Varset('mes') * Varset('valorNorm') / Varset('serie'),
                color: ColorEncode(
                  variable: 'serie',
                  values: const [Color(0xff1890ff), Color(0xffef6c00)],
                ),
                size: SizeEncode(value: 2),
              ),
            ],
            axes: [Defaults.horizontalAxis],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Eje normalizado 0-1 (graphic comparte una sola escala de posición por '
          'dimensión). Azul = Ventas 40k-90k · Naranja = Temperatura 14-31°C.',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 19. Matriz de confusión — PolygonMark + HeatmapShape over a fixed NxN grid
// ---------------------------------------------------------------------------

Widget _confusionMatrixBuilder(BuildContext context) => const _ConfusionMatrixChart();

class _ConfusionMatrixChart extends StatelessWidget {
  const _ConfusionMatrixChart();

  static const _clases = ['Gato', 'Perro', 'Pájaro'];
  static const _conteos = [
    [42, 4, 1],
    [6, 38, 3],
    [2, 5, 35],
  ];

  List<Map<String, dynamic>> _data() {
    final rows = <Map<String, dynamic>>[];
    for (var actual = 0; actual < _clases.length; actual++) {
      for (var pred = 0; pred < _clases.length; pred++) {
        rows.add({
          'real': _clases[actual],
          'prediccion': _clases[pred],
          'conteo': _conteos[actual][pred],
        });
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Chart(
        data: _data(),
        variables: {
          'prediccion': Variable(accessor: (Map m) => m['prediccion'] as String, scale: OrdinalScale(values: _clases)),
          'real': Variable(accessor: (Map m) => m['real'] as String, scale: OrdinalScale(values: _clases)),
          'conteo': Variable(accessor: (Map m) => m['conteo'] as num),
        },
        marks: [
          PolygonMark(
            shape: ShapeEncode(value: HeatmapShape(borderRadius: BorderRadius.circular(4))),
            color: ColorEncode(
              variable: 'conteo',
              values: const [Color(0xffe8f5e9), Color(0xff1b5e20)],
            ),
            label: LabelEncode(
              encoder: (tuple) => Label(
                '${tuple['conteo']}',
                LabelStyle(textStyle: TextStyle(color: Colors.black87, fontSize: 12)),
              ),
            ),
          ),
        ],
        axes: [
          AxisGuide(dim: Dim.x, variable: 'prediccion', label: LabelStyle(textStyle: Defaults.textStyle)),
          Defaults.verticalAxis,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 20. Grafo de red — CustomPainter (graphic has no node/edge graph model)
// ---------------------------------------------------------------------------

Widget _networkGraphBuilder(BuildContext context) => const _NetworkGraphChart();

class _NetworkGraphChart extends StatelessWidget {
  const _NetworkGraphChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      width: double.infinity,
      child: CustomPaint(painter: _NetworkGraphPainter()),
    );
  }
}

class _NetworkGraphPainter extends CustomPainter {
  static const _labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  static const _positions = [
    Offset(0.15, 0.20),
    Offset(0.50, 0.10),
    Offset(0.85, 0.25),
    Offset(0.25, 0.60),
    Offset(0.60, 0.55),
    Offset(0.90, 0.70),
    Offset(0.40, 0.90),
  ];
  static const _edges = [
    [0, 1],
    [1, 2],
    [0, 3],
    [1, 4],
    [2, 5],
    [3, 4],
    [4, 5],
    [3, 6],
    [4, 6],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    Offset toCanvas(Offset n) => Offset(n.dx * size.width, n.dy * size.height);

    final edgePaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1.6;

    for (final edge in _edges) {
      canvas.drawLine(
        toCanvas(_positions[edge[0]]),
        toCanvas(_positions[edge[1]]),
        edgePaint,
      );
    }

    for (var i = 0; i < _positions.length; i++) {
      final center = toCanvas(_positions[i]);
      canvas.drawCircle(center, 22, Paint()..color = Defaults.colors10[i % Defaults.colors10.length]);
      canvas.drawCircle(
        center,
        22,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      final painter = TextPainter(
        text: TextSpan(
          text: _labels[i],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// 21. Gantt — IntervalMark with blend(start,end) + transposed coordinate
// ---------------------------------------------------------------------------

Widget _ganttBuilder(BuildContext context) => const _GanttChart();

class _GanttChart extends StatelessWidget {
  const _GanttChart();

  static const _data = [
    {'tarea': 'Análisis', 'inicio': 0, 'fin': 3, 'fase': 'Planeación'},
    {'tarea': 'Diseño', 'inicio': 2, 'fin': 6, 'fase': 'Planeación'},
    {'tarea': 'Desarrollo', 'inicio': 5, 'fin': 14, 'fase': 'Ejecución'},
    {'tarea': 'Pruebas', 'inicio': 12, 'fin': 17, 'fase': 'Ejecución'},
    {'tarea': 'Despliegue', 'inicio': 16, 'fin': 19, 'fase': 'Cierre'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Chart(
        data: _data,
        variables: {
          'tarea': Variable(
            accessor: (Map m) => m['tarea'] as String,
            scale: OrdinalScale(values: _data.map((e) => e['tarea'] as String).toList()),
          ),
          'inicio': Variable(accessor: (Map m) => m['inicio'] as num),
          'fin': Variable(accessor: (Map m) => m['fin'] as num),
          'fase': Variable(accessor: (Map m) => m['fase'] as String),
        },
        marks: [
          IntervalMark(
            position: Varset('tarea') * (Varset('inicio') + Varset('fin')),
            size: SizeEncode(value: 22),
            color: ColorEncode(variable: 'fase', values: Defaults.colors10),
            shape: ShapeEncode(value: RectShape(borderRadius: BorderRadius.circular(3))),
          ),
        ],
        coord: RectCoord(transposed: true),
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 22. Brushing — IntervalSelection dims a chart range while dragging
// ---------------------------------------------------------------------------

Widget _brushingBuilder(BuildContext context) => const _BrushingChart();

class _BrushingChart extends StatelessWidget {
  const _BrushingChart();

  static List<Map<String, dynamic>> _data() {
    return [
      for (var i = 0; i < 30; i++)
        {'dia': i, 'valor': 50 + 30 * math.sin(i / 3) + (i % 5) * 2},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Arrastra sobre el gráfico para resaltar un rango (brushing).',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: Chart(
            data: _data(),
            variables: {
              'dia': Variable(accessor: (Map m) => m['dia'] as num),
              'valor': Variable(accessor: (Map m) => m['valor'] as num),
            },
            marks: [
              LineMark(
                color: ColorEncode(value: const Color(0xff9e9e9e)),
                size: SizeEncode(value: 1.5),
              ),
              PointMark(
                size: SizeEncode(value: 6),
                color: ColorEncode(
                  value: const Color(0xff6a1b9a),
                  updaters: {
                    'brush': {false: (Color c) => c.withAlpha(60)},
                  },
                ),
              ),
            ],
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
            selections: {
              'brush': IntervalSelection(dim: Dim.x, color: const Color(0x1a6a1b9a)),
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 23. Clustering visual coloreado — PointMark colored by precomputed cluster
// ---------------------------------------------------------------------------

Widget _clusteringBuilder(BuildContext context) => const _ClusteringChart();

class _ClusteringChart extends StatelessWidget {
  const _ClusteringChart();

  static List<Map<String, dynamic>> _data() {
    final random = math.Random(11);
    const centers = [
      {'cx': 2.0, 'cy': 2.0, 'label': 'Grupo A'},
      {'cx': 8.0, 'cy': 3.0, 'label': 'Grupo B'},
      {'cx': 5.0, 'cy': 8.0, 'label': 'Grupo C'},
    ];
    final rows = <Map<String, dynamic>>[];
    for (final center in centers) {
      for (var i = 0; i < 18; i++) {
        rows.add({
          'x': (center['cx'] as double) + (random.nextDouble() - 0.5) * 2.4,
          'y': (center['cy'] as double) + (random.nextDouble() - 0.5) * 2.4,
          'cluster': center['label'],
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
          'x': Variable(accessor: (Map m) => m['x'] as num),
          'y': Variable(accessor: (Map m) => m['y'] as num),
          'cluster': Variable(accessor: (Map m) => m['cluster'] as String),
        },
        marks: [
          PointMark(
            size: SizeEncode(value: 7),
            color: ColorEncode(variable: 'cluster', values: Defaults.colors10),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 24. Comparación multi-grupo — small multiples (Wrap of mini IntervalMarks)
// ---------------------------------------------------------------------------

Widget _smallMultiplesBuilder(BuildContext context) => const _SmallMultiplesChart();

class _SmallMultiplesChart extends StatelessWidget {
  const _SmallMultiplesChart();

  static const _regiones = {
    'Norte': [30, 45, 38, 52],
    'Sur': [22, 28, 35, 30],
    'Este': [40, 36, 48, 55],
    'Oeste': [18, 24, 20, 29],
  };
  static const _trimestres = ['Q1', 'Q2', 'Q3', 'Q4'];

  Widget _miniChart(String region, List<int> valores, Color color) {
    final data = [
      for (var i = 0; i < _trimestres.length; i++) {'trimestre': _trimestres[i], 'valor': valores[i]},
    ];
    return SizedBox(
      width: 160,
      height: 160,
      child: Column(
        children: [
          Text(region, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Expanded(
            child: Chart(
              data: data,
              variables: {
                'trimestre': Variable(accessor: (Map m) => m['trimestre'] as String, scale: OrdinalScale(values: _trimestres)),
                'valor': Variable(accessor: (Map m) => m['valor'] as num, scale: LinearScale(min: 0, max: 60)),
              },
              marks: [IntervalMark(color: ColorEncode(value: color))],
              axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _regiones.entries.toList();
    return SingleChildScrollView(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var i = 0; i < entries.length; i++)
            _miniChart(entries[i].key, entries[i].value, Defaults.colors10[i]),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 25. Dashboard combinado — KPI cards with a graphic LineMark sparkline each
// ---------------------------------------------------------------------------

Widget _kpiDashboardBuilder(BuildContext context) => const _KpiDashboardChart();

class _KpiDashboardChart extends StatelessWidget {
  const _KpiDashboardChart();

  static const _kpis = [
    {'titulo': 'Ingresos', 'valor': '\$48.2k', 'subida': true, 'serie': [10, 14, 12, 18, 22, 25, 30]},
    {'titulo': 'Usuarios activos', 'valor': '3,210', 'subida': true, 'serie': [8, 9, 9, 11, 10, 13, 15]},
    {'titulo': 'Tasa de rebote', 'valor': '4.1%', 'subida': false, 'serie': [9, 8, 7, 7, 6, 6, 5]},
  ];

  Widget _sparkline(List<int> serie, Color color) {
    final data = [
      for (var i = 0; i < serie.length; i++) {'i': i, 'v': serie[i]},
    ];
    return SizedBox(
      width: 90,
      height: 36,
      child: Chart(
        data: data,
        variables: {
          'i': Variable(accessor: (Map m) => m['i'] as num),
          'v': Variable(accessor: (Map m) => m['v'] as num),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            color: ColorEncode(value: color),
            size: SizeEncode(value: 2),
          ),
        ],
        padding: (_) => EdgeInsets.zero,
      ),
    );
  }

  Widget _kpiCard(Map<String, dynamic> kpi) {
    final subida = kpi['subida'] as bool;
    final color = subida ? const Color(0xff2e7d32) : const Color(0xffc62828);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kpi['titulo'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  kpi['valor'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Icon(
                  subida ? Icons.trending_up : Icons.trending_down,
                  color: color,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 6),
            _sparkline(List<int>.from(kpi['serie'] as List), color),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        children: [
          for (var i = 0; i < _kpis.length; i++) ...[
            _kpiCard(_kpis[i]),
            if (i != _kpis.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}
