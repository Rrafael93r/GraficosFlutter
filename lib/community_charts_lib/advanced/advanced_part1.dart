import 'dart:async';
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

/// Simple ordinal (category, value) sample used by several Series below.
class _OrdinalValue {
  final String label;
  final num value;

  const _OrdinalValue(this.label, this.value);
}

/// Simple numeric (x, y) sample used by LineChart/ScatterPlotChart demos.
class _NumPoint {
  final num x;
  final double y;

  const _NumPoint(this.x, this.y);
}

// ---------------------------------------------------------------------------
// 1. Sunburst — jerarquía (treemap aproximado, sin SunburstChart nativo)
//
// community_charts_flutter 1.0.4 no expone un widget SunburstChart (el
// renderer de sunburst/treemap existe internamente en community_charts_common
// pero no está envuelto como widget de Flutter en esta versión). Se aproxima
// con un treemap jerárquico (departamento -> producto) usando Containers
// proporcionales al valor.
// ---------------------------------------------------------------------------

Widget _chart41(BuildContext context) {
  const data = <String, Map<String, double>>{
    'Electrónica': {'Celulares': 420, 'Laptops': 310, 'Audio': 90},
    'Hogar': {'Muebles': 260, 'Cocina': 150},
    'Ropa': {'Hombre': 180, 'Mujer': 220, 'Niños': 70},
  };
  const deptColors = [Colors.indigo, Colors.teal, Colors.deepOrange];

  final deptTotals = [
    for (final entry in data.entries)
      entry.value.values.fold<double>(0, (a, b) => a + b),
  ];
  final grandTotal = deptTotals.fold<double>(0, (a, b) => a + b);
  final deptKeys = data.keys.toList();
  final deptValues = data.values.toList();

  return SizedBox(
    height: 320,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sunburst no disponible en esta versión: aproximado con treemap '
            '(departamento → producto)',
            style: TextStyle(fontSize: 10.5, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < deptKeys.length; i++)
                  Expanded(
                    flex: (deptTotals[i] / grandTotal * 1000).round(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        children: [
                          for (final entry in deptValues[i].entries)
                            Expanded(
                              flex: (entry.value / deptTotals[i] * 1000).round(),
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                alignment: Alignment.center,
                                color: deptColors[i % deptColors.length]
                                    .withValues(
                                      alpha: 0.35 +
                                          0.5 * (entry.value / deptTotals[i]),
                                    ),
                                child: Text(
                                  '${entry.key}\n${entry.value.toInt()}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          _legendRow([
            for (var i = 0; i < deptKeys.length; i++)
              _LegendItem(deptKeys[i], deptColors[i % deptColors.length]),
          ]),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 2. BarChart — con RangeAnnotation (bandas de referencia)
// ---------------------------------------------------------------------------

Widget _chart42(BuildContext context) {
  const data = [
    _OrdinalValue('2019', 42),
    _OrdinalValue('2020', 58),
    _OrdinalValue('2021', 75),
    _OrdinalValue('2022', 63),
    _OrdinalValue('2023', 88),
    _OrdinalValue('2024', 95),
  ];

  final series = [
    charts.Series<_OrdinalValue, String>(
      id: 'Ventas',
      domainFn: (d, _) => d.label,
      measureFn: (d, _) => d.value,
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      data: data,
    ),
  ];

  return _chartCard(
    chart: charts.BarChart(
      series,
      animate: true,
      behaviors: [
        charts.RangeAnnotation([
          charts.RangeAnnotationSegment(
            0,
            60,
            charts.RangeAnnotationAxisType.measure,
            startLabel: 'Meta mínima',
            color: const charts.Color(r: 255, g: 205, b: 210, a: 140),
          ),
          charts.RangeAnnotationSegment(
            80,
            100,
            charts.RangeAnnotationAxisType.measure,
            startLabel: 'Meta superada',
            color: const charts.Color(r: 200, g: 230, b: 201, a: 140),
          ),
        ]),
      ],
    ),
    legend: const Text(
      'Bandas de referencia: rojo = bajo meta, verde = meta superada',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 3. LineChart — crosshair interactivo (LinePointHighlighter + SelectNearest)
// ---------------------------------------------------------------------------

Widget _chart43(BuildContext context) {
  final data = [
    for (var i = 0; i <= 20; i++)
      _NumPoint(i, 50 + 20 * math.sin(i / 2.5) + i * 0.6),
  ];

  final series = [
    charts.Series<_NumPoint, num>(
      id: 'Señal',
      domainFn: (d, _) => d.x,
      measureFn: (d, _) => d.y,
      colorFn: (_, _) => charts.MaterialPalette.indigo.shadeDefault,
      data: data,
    ),
  ];

  return _chartCard(
    chart: charts.LineChart(
      series,
      animate: true,
      behaviors: [
        charts.LinePointHighlighter(
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
        ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
      ],
    ),
    legend: const Text(
      'Arrastra sobre la línea: líneas guía horizontal/vertical (crosshair)',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 4. BarChart — con viewport deslizante (pan)
// ---------------------------------------------------------------------------

Widget _chart44(BuildContext context) {
  const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];
  final rand = math.Random(3);
  final data = [
    for (final m in months) _OrdinalValue(m, 20 + rand.nextInt(80)),
  ];

  final series = [
    charts.Series<_OrdinalValue, String>(
      id: 'Ventas',
      domainFn: (d, _) => d.label,
      measureFn: (d, _) => d.value,
      colorFn: (_, _) => charts.MaterialPalette.teal.shadeDefault,
      data: data,
    ),
  ];

  return _chartCard(
    chart: charts.BarChart(
      series,
      animate: true,
      domainAxis: charts.OrdinalAxisSpec(
        viewport: charts.OrdinalViewport(months.first, 5),
      ),
      behaviors: [charts.PanBehavior()],
    ),
    legend: const Text(
      'Arrastra horizontalmente: ventana deslizante de 5 meses visibles de 12',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 5. LineChart — con zoom (pan and zoom behavior)
// ---------------------------------------------------------------------------

Widget _chart45(BuildContext context) {
  final rand = math.Random(9);
  var last = 50.0;
  final data = <_NumPoint>[];
  for (var i = 0; i < 80; i++) {
    last = (last + (rand.nextDouble() - 0.5) * 8).clamp(5.0, 100.0);
    data.add(_NumPoint(i, last));
  }

  final series = [
    charts.Series<_NumPoint, num>(
      id: 'Serie',
      domainFn: (d, _) => d.x,
      measureFn: (d, _) => d.y,
      colorFn: (_, _) => charts.MaterialPalette.deepOrange.shadeDefault,
      data: data,
    ),
  ];

  return _chartCard(
    chart: charts.LineChart(
      series,
      animate: false,
      behaviors: [charts.PanAndZoomBehavior()],
    ),
    legend: const Text(
      'Pellizca para zoom y arrastra para explorar 80 puntos de datos',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 6. ComboChart — eje secundario (dual axis)
// ---------------------------------------------------------------------------

class _RegionMetric {
  final String region;
  final int revenue;
  final double conversion;

  const _RegionMetric(this.region, this.revenue, this.conversion);
}

Widget _chart46(BuildContext context) {
  const data = [
    _RegionMetric('Norte', 420, 2.4),
    _RegionMetric('Sur', 310, 3.1),
    _RegionMetric('Este', 275, 1.8),
    _RegionMetric('Oeste', 390, 4.2),
  ];
  const secondaryAxisId = 'secondaryConversion';

  final series = [
    charts.Series<_RegionMetric, String>(
      id: 'Ingresos (k\$)',
      domainFn: (d, _) => d.region,
      measureFn: (d, _) => d.revenue,
      colorFn: (_, _) => charts.MaterialPalette.blue.shadeDefault,
      data: data,
    ),
    charts.Series<_RegionMetric, String>(
      id: 'Conversión (%)',
      domainFn: (d, _) => d.region,
      measureFn: (d, _) => d.conversion,
      colorFn: (_, _) => charts.MaterialPalette.red.shadeDefault,
      data: data,
    )
      ..setAttribute(charts.measureAxisIdKey, secondaryAxisId)
      ..setAttribute(charts.rendererIdKey, 'customLine'),
  ];

  return _chartCard(
    chart: charts.OrdinalComboChart(
      series,
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
      ),
      customSeriesRenderers: [
        charts.LineRendererConfig(customRendererId: 'customLine'),
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
      ),
      secondaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Ingresos (eje izq.)', Colors.blue),
      _LegendItem('Conversión % (eje der.)', Colors.red),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 7. BarChart — animación de entrada personalizada
// ---------------------------------------------------------------------------

class _AnimatedEntryBarChart extends StatefulWidget {
  const _AnimatedEntryBarChart();

  @override
  State<_AnimatedEntryBarChart> createState() =>
      _AnimatedEntryBarChartState();
}

class _AnimatedEntryBarChartState extends State<_AnimatedEntryBarChart> {
  bool _toggled = false;

  List<charts.Series<_OrdinalValue, String>> _series() {
    final values = _toggled ? [30, 80, 45, 95, 60] : [60, 40, 75, 35, 90];
    const labels = ['A', 'B', 'C', 'D', 'E'];
    final data = [
      for (var i = 0; i < labels.length; i++) _OrdinalValue(labels[i], values[i]),
    ];
    return [
      charts.Series<_OrdinalValue, String>(
        id: 'Valores',
        domainFn: (d, _) => d.label,
        measureFn: (d, _) => d.value,
        colorFn: (_, _) => charts.MaterialPalette.purple.shadeDefault,
        data: data,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: charts.BarChart(
                _series(),
                animate: true,
                animationDuration: const Duration(milliseconds: 1200),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => setState(() => _toggled = !_toggled),
              child: const Text('Transición animada (1.2 s)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8. LineChart — tiempo real (datos en vivo)
// ---------------------------------------------------------------------------

class _LiveLineChart extends StatefulWidget {
  const _LiveLineChart();

  @override
  State<_LiveLineChart> createState() => _LiveLineChartState();
}

class _LiveLineChartState extends State<_LiveLineChart> {
  final List<_NumPoint> _data = [
    for (var i = 0; i < 10; i++) _NumPoint(i, 50),
  ];
  final math.Random _rand = math.Random();
  Timer? _timer;
  int _nextX = 10;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final last = _data.last.y;
        final next =
            (last + (_rand.nextDouble() - 0.5) * 16).clamp(10.0, 100.0);
        _data.add(_NumPoint(_nextX++, next));
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
    final series = [
      charts.Series<_NumPoint, num>(
        id: 'Sensor',
        domainFn: (d, _) => d.x,
        measureFn: (d, _) => d.y,
        colorFn: (_, _) => charts.MaterialPalette.green.shadeDefault,
        data: List<_NumPoint>.from(_data),
      ),
    ];

    return _chartCard(
      chart: charts.LineChart(
        series,
        animate: true,
        animationDuration: const Duration(milliseconds: 400),
      ),
      legend: const Text(
        'Nuevo valor cada segundo (ventana móvil de 20 puntos)',
        style: TextStyle(fontSize: 11, color: Colors.black54),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. PieChart — interactivo (tap para resaltar sector)
// ---------------------------------------------------------------------------

class _InteractivePieChart extends StatefulWidget {
  const _InteractivePieChart();

  @override
  State<_InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<_InteractivePieChart> {
  String? _selectedLabel;
  num? _selectedValue;

  void _onSelectionChanged(charts.SelectionModel<String> model) {
    final selected = model.selectedDatum;
    setState(() {
      if (selected.isEmpty) {
        _selectedLabel = null;
        _selectedValue = null;
      } else {
        final d = selected.first.datum as _OrdinalValue;
        _selectedLabel = d.label;
        _selectedValue = d.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const data = [
      _OrdinalValue('Móvil', 45),
      _OrdinalValue('Escritorio', 30),
      _OrdinalValue('Tablet', 15),
      _OrdinalValue('Otros', 10),
    ];
    final colors = [
      charts.MaterialPalette.blue,
      charts.MaterialPalette.teal,
      charts.MaterialPalette.deepOrange,
      charts.MaterialPalette.gray,
    ];

    final series = [
      charts.Series<_OrdinalValue, String>(
        id: 'Tráfico',
        domainFn: (d, _) => d.label,
        measureFn: (d, _) => d.value,
        colorFn: (_, i) => colors[i! % colors.length].shadeDefault,
        data: data,
      ),
    ];

    return _chartCard(
      chart: charts.PieChart<String>(
        series,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 50),
        behaviors: [charts.SelectNearest()],
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: _onSelectionChanged,
          ),
        ],
      ),
      legend: Text(
        _selectedLabel == null
            ? 'Toca un sector para ver su detalle'
            : '$_selectedLabel: $_selectedValue%',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. BarChart — leyenda con selección de series (toggle)
// ---------------------------------------------------------------------------

Widget _chart50(BuildContext context) {
  const desktop = [
    _OrdinalValue('2021', 5),
    _OrdinalValue('2022', 25),
    _OrdinalValue('2023', 100),
    _OrdinalValue('2024', 75),
  ];
  const tablet = [
    _OrdinalValue('2021', 25),
    _OrdinalValue('2022', 50),
    _OrdinalValue('2023', 10),
    _OrdinalValue('2024', 20),
  ];
  const mobile = [
    _OrdinalValue('2021', 10),
    _OrdinalValue('2022', 15),
    _OrdinalValue('2023', 50),
    _OrdinalValue('2024', 45),
  ];
  const other = [
    _OrdinalValue('2021', 20),
    _OrdinalValue('2022', 35),
    _OrdinalValue('2023', 15),
    _OrdinalValue('2024', 10),
  ];

  charts.Series<_OrdinalValue, String> buildSeries(
    String id,
    List<_OrdinalValue> data,
  ) {
    return charts.Series<_OrdinalValue, String>(
      id: id,
      domainFn: (d, _) => d.label,
      measureFn: (d, _) => d.value,
      data: data,
    );
  }

  final series = [
    buildSeries('Desktop', desktop),
    buildSeries('Tablet', tablet),
    buildSeries('Mobile', mobile),
    buildSeries('Other', other),
  ];

  return _chartCard(
    chart: charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend()],
    ),
    legend: const Text(
      'Toca una entrada de la leyenda para mostrar/ocultar esa serie',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 11. ScatterPlotChart — mapeo avanzado de tamaño de punto
// ---------------------------------------------------------------------------

class _Bubble {
  final num x;
  final num y;
  final double radius;

  const _Bubble(this.x, this.y, this.radius);
}

Widget _chart51(BuildContext context) {
  const data = [
    _Bubble(10, 30, 4),
    _Bubble(20, 55, 8),
    _Bubble(35, 40, 14),
    _Bubble(50, 70, 20),
    _Bubble(65, 45, 10),
    _Bubble(80, 85, 18),
  ];

  final series = [
    charts.Series<_Bubble, num>(
      id: 'Clientes',
      domainFn: (d, _) => d.x,
      measureFn: (d, _) => d.y,
      radiusPxFn: (d, _) => d.radius,
      colorFn: (_, _) => charts.MaterialPalette.cyan.shadeDefault,
      data: data,
    ),
  ];

  return _chartCard(
    chart: charts.ScatterPlotChart(series, animate: true),
    legend: const Text(
      'El tamaño del punto codifica una tercera dimensión (volumen de compra)',
      style: TextStyle(fontSize: 11, color: Colors.black54),
    ),
  );
}

// ---------------------------------------------------------------------------
// 12. Gauge tipo velocímetro (custom painter)
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

    const zoneFractions = [0.3, 0.4, 0.3];
    const zoneColors = [
      Color(0xFFF44336),
      Color(0xFFFFC107),
      Color(0xFF4CAF50),
    ];

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
    final needleEnd = center +
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
      '${(value * 100).round()}% satisfacción',
      Offset(center.dx, center.dy + radius * 0.42),
      fontSize: 14,
      color: Colors.black87,
      bold: true,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value;
}

Widget _chart52(BuildContext context) {
  return _customPaintCard(painter: const _GaugePainter(0.82), height: 300);
}

// ---------------------------------------------------------------------------
// 13. Heatmap en grilla (custom painter)
// ---------------------------------------------------------------------------

class _HeatmapPainter extends CustomPainter {
  final List<List<double>> values;
  final List<String> rowLabels;
  final List<String> colLabels;

  const _HeatmapPainter(this.values, this.rowLabels, this.colLabels);

  static const _leftMargin = 70.0;
  static const _topMargin = 22.0;

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
        maxWidth: _leftMargin - 8,
      );
    }

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final v = values[r][c].clamp(0.0, 1.0);
        final color = Color.lerp(
          const Color(0xFFFFF3E0),
          const Color(0xFFE65100),
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
  final rand = math.Random(11);
  final values = List.generate(4, (_) => List.generate(6, (_) => rand.nextDouble()));
  const rowLabels = ['Norte', 'Sur', 'Este', 'Oeste'];
  const colLabels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];

  return _customPaintCard(
    painter: _HeatmapPainter(values, rowLabels, colLabels),
    height: 300,
    caption: const Text(
      'Intensidad de ventas por región y mes (claro = bajo, oscuro = alto)',
      style: TextStyle(fontSize: 11, color: Colors.black54),
      textAlign: TextAlign.center,
    ),
  );
}

// ---------------------------------------------------------------------------
// Catalog
// ---------------------------------------------------------------------------

final List<ChartSpec> communityAdvancedPart1 = [
  ChartSpec(
    id: 'cc_a41',
    title: 'Sunburst — jerarquía (treemap aproximado, sin SunburstChart nativo)',
    category: ChartCategory.advanced,
    builder: _chart41,
  ),
  ChartSpec(
    id: 'cc_a42',
    title: 'BarChart — con RangeAnnotation (bandas de referencia)',
    category: ChartCategory.advanced,
    builder: _chart42,
  ),
  ChartSpec(
    id: 'cc_a43',
    title: 'LineChart — crosshair interactivo (LinePointHighlighter + SelectNearest)',
    category: ChartCategory.advanced,
    builder: _chart43,
  ),
  ChartSpec(
    id: 'cc_a44',
    title: 'BarChart — con viewport deslizante (pan)',
    category: ChartCategory.advanced,
    builder: _chart44,
  ),
  ChartSpec(
    id: 'cc_a45',
    title: 'LineChart — con zoom (pan and zoom behavior)',
    category: ChartCategory.advanced,
    builder: _chart45,
  ),
  ChartSpec(
    id: 'cc_a46',
    title: 'ComboChart — eje secundario (dual axis)',
    category: ChartCategory.advanced,
    builder: _chart46,
  ),
  ChartSpec(
    id: 'cc_a47',
    title: 'BarChart — animación de entrada personalizada',
    category: ChartCategory.advanced,
    builder: (context) => const _AnimatedEntryBarChart(),
  ),
  ChartSpec(
    id: 'cc_a48',
    title: 'LineChart — tiempo real (datos en vivo)',
    category: ChartCategory.advanced,
    builder: (context) => const _LiveLineChart(),
  ),
  ChartSpec(
    id: 'cc_a49',
    title: 'PieChart — interactivo (tap para resaltar sector)',
    category: ChartCategory.advanced,
    builder: (context) => const _InteractivePieChart(),
  ),
  ChartSpec(
    id: 'cc_a50',
    title: 'BarChart — leyenda con selección de series (toggle)',
    category: ChartCategory.advanced,
    builder: _chart50,
  ),
  ChartSpec(
    id: 'cc_a51',
    title: 'ScatterPlotChart — mapeo avanzado de tamaño de punto',
    category: ChartCategory.advanced,
    builder: _chart51,
  ),
  ChartSpec(
    id: 'cc_a52',
    title: 'Gauge tipo velocímetro (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart52,
  ),
  ChartSpec(
    id: 'cc_a53',
    title: 'Heatmap en grilla (custom painter)',
    category: ChartCategory.advanced,
    builder: _chart53,
  ),
];
