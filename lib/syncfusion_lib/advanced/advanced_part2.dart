import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/chart_spec.dart';

/// Punto OHLC (open-high-low-close) usado por los gráficos financieros.
class _Ohlc {
  const _Ohlc(this.date, this.open, this.high, this.low, this.close);

  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
}

final List<_Ohlc> _serieFinanciera = <_Ohlc>[
  _Ohlc(DateTime(2024, 1, 1), 100, 108, 96, 104),
  _Ohlc(DateTime(2024, 1, 2), 104, 110, 101, 107),
  _Ohlc(DateTime(2024, 1, 3), 107, 112, 103, 103),
  _Ohlc(DateTime(2024, 1, 4), 103, 106, 95, 99),
  _Ohlc(DateTime(2024, 1, 5), 99, 101, 90, 93),
  _Ohlc(DateTime(2024, 1, 6), 93, 100, 91, 98),
  _Ohlc(DateTime(2024, 1, 7), 98, 105, 96, 102),
  _Ohlc(DateTime(2024, 1, 8), 102, 111, 101, 109),
  _Ohlc(DateTime(2024, 1, 9), 109, 118, 107, 115),
  _Ohlc(DateTime(2024, 1, 10), 115, 120, 110, 112),
  _Ohlc(DateTime(2024, 1, 11), 112, 115, 104, 106),
  _Ohlc(DateTime(2024, 1, 12), 106, 109, 98, 101),
  _Ohlc(DateTime(2024, 1, 13), 101, 108, 100, 107),
  _Ohlc(DateTime(2024, 1, 14), 107, 116, 105, 113),
  _Ohlc(DateTime(2024, 1, 15), 113, 121, 111, 119),
];

class _ChartPoint {
  const _ChartPoint(this.x, this.y);
  final String x;
  final double y;
}

class _CategoryData {
  const _CategoryData(this.categoria, this.valor, this.subcategorias);
  final String categoria;
  final double valor;
  final List<_ChartPoint> subcategorias;
}

final List<_CategoryData> _ventasPorCategoria = <_CategoryData>[
  _CategoryData('Electrónica', 420, <_ChartPoint>[
    _ChartPoint('Celulares', 210),
    _ChartPoint('Laptops', 140),
    _ChartPoint('Accesorios', 70),
  ]),
  _CategoryData('Hogar', 280, <_ChartPoint>[
    _ChartPoint('Muebles', 120),
    _ChartPoint('Cocina', 100),
    _ChartPoint('Decoración', 60),
  ]),
  _CategoryData('Ropa', 190, <_ChartPoint>[
    _ChartPoint('Hombre', 80),
    _ChartPoint('Mujer', 90),
    _ChartPoint('Niños', 20),
  ]),
  _CategoryData('Deportes', 150, <_ChartPoint>[
    _ChartPoint('Fútbol', 60),
    _ChartPoint('Gimnasio', 55),
    _ChartPoint('Ciclismo', 35),
  ]),
];

final List<ChartSpec> syncAdvancedPart2 = <ChartSpec>[
  ChartSpec(
    id: 'sync_a54',
    title: 'Circular con anotación central (gauge)',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCircularChart(
          title: const ChartTitle(text: 'Cumplimiento de objetivo'),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '78%',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  Text(
                    'Cumplido',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
          series: <CircularSeries<_ChartPoint, String>>[
            DoughnutSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Cumplido', 78),
                _ChartPoint('Restante', 22),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              pointColorMapper:
                  (_ChartPoint p, _) =>
                      p.x == 'Cumplido' ? Colors.indigo : Colors.grey.shade300,
              innerRadius: '75%',
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a55',
    title: 'Paneles apilados — dos ejes vinculados',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      // Esta versión de syncfusion_flutter_charts no expone un concepto de
      // "panes" múltiples dentro de un mismo SfCartesianChart (solo admite
      // varios ejes Y superpuestos vía `axes`). Se aproxima el panel
      // múltiple apilando dos SfCartesianChart en una Column, cada uno
      // mostrando una magnitud distinta de la misma serie temporal.
      return SizedBox(
        height: 420,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Panel 1 — Precio de cierre'),
                primaryXAxis: const DateTimeAxis(isVisible: false),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Cierre'),
                ),
                series: <CartesianSeries<_Ohlc, DateTime>>[
                  LineSeries<_Ohlc, DateTime>(
                    dataSource: _serieFinanciera,
                    xValueMapper: (_Ohlc p, _) => p.date,
                    yValueMapper: (_Ohlc p, _) => p.close,
                    name: 'Cierre',
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Panel 2 — Rango diario'),
                primaryXAxis: const DateTimeAxis(
                  title: AxisTitle(text: 'Fecha'),
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Rango (alto-bajo)'),
                ),
                series: <CartesianSeries<_Ohlc, DateTime>>[
                  ColumnSeries<_Ohlc, DateTime>(
                    dataSource: _serieFinanciera,
                    xValueMapper: (_Ohlc p, _) => p.date,
                    yValueMapper: (_Ohlc p, _) => p.high - p.low,
                    name: 'Rango',
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a56',
    title: 'ColumnSeries con efecto 3D (gradiente)',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      // Esta versión de syncfusion_flutter_charts no incluye series de
      // columnas 3D nativas (no existe ColumnSeries3D ni un modo `view3D`
      // para SfCartesianChart). Se aproxima el efecto de profundidad con
      // gradientes verticales y bordes oscurecidos en un ColumnSeries normal.
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas por categoría (efecto 3D)'),
          primaryXAxis: const CategoryAxis(title: AxisTitle(text: 'Categoría')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Ventas')),
          series: <CartesianSeries<_CategoryData, String>>[
            ColumnSeries<_CategoryData, String>(
              dataSource: _ventasPorCategoria,
              xValueMapper: (_CategoryData p, _) => p.categoria,
              yValueMapper: (_CategoryData p, _) => p.valor,
              name: 'Ventas',
              width: 0.6,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              borderColor: Colors.indigo.shade900,
              borderWidth: 1.5,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.indigo.shade300,
                  Colors.indigo.shade700,
                  Colors.indigo.shade900,
                ],
                stops: const <double>[0.0, 0.6, 1.0],
              ),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a57',
    title: 'Animación de entrada personalizada',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return const SizedBox(height: 320, child: _CustomAnimationDemo());
    },
  ),
  ChartSpec(
    id: 'sync_a58',
    title: 'Drill-down — categoría a subcategoría',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return const SizedBox(height: 320, child: _DrilldownDemo());
    },
  ),
  ChartSpec(
    id: 'sync_a59',
    title: 'Red bayesiana — nodos y conexiones',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return const SizedBox(height: 340, child: _BayesianNetworkDemo());
    },
  ),
  ChartSpec(
    id: 'sync_a60',
    title: 'Árbol de decisiones — nodos y conectores',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return const SizedBox(height: 360, child: _DecisionTreeDemo());
    },
  ),
  ChartSpec(
    id: 'sync_a61',
    title: 'Streaming de datos en tiempo real',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return const SizedBox(height: 320, child: _RealtimeStreamDemo());
    },
  ),
  ChartSpec(
    id: 'sync_a62',
    title: 'Banda tipo Bollinger',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Bandas de Bollinger sobre cierre'),
          primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Precio')),
          legend: const Legend(isVisible: true),
          trackballBehavior: TrackballBehavior(enable: true),
          series: <CartesianSeries<dynamic, DateTime>>[
            RangeAreaSeries<_BollingerPoint, DateTime>(
              dataSource: _bandasBollinger,
              xValueMapper: (_BollingerPoint p, _) => p.date,
              highValueMapper: (_BollingerPoint p, _) => p.bandaSuperior,
              lowValueMapper: (_BollingerPoint p, _) => p.bandaInferior,
              name: 'Banda',
              color: Colors.indigo.withValues(alpha: 0.15),
              borderColor: Colors.indigo.withValues(alpha: 0.4),
              borderWidth: 1,
            ),
            LineSeries<_BollingerPoint, DateTime>(
              dataSource: _bandasBollinger,
              xValueMapper: (_BollingerPoint p, _) => p.date,
              yValueMapper: (_BollingerPoint p, _) => p.media,
              name: 'Media móvil',
              color: Colors.indigo,
              width: 2,
            ),
            LineSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              yValueMapper: (_Ohlc p, _) => p.close,
              name: 'Cierre',
              color: Colors.blueGrey,
              width: 1,
              dashArray: const <double>[4, 3],
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a63',
    title: 'Tooltip sincronizado multi-eje',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Precio y rango con tooltip combinado'),
          primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
          primaryYAxis: const NumericAxis(
            name: 'precioAxis',
            title: AxisTitle(text: 'Cierre'),
          ),
          axes: const <ChartAxis>[
            NumericAxis(
              name: 'rangoAxis',
              opposedPosition: true,
              title: AxisTitle(text: 'Rango'),
            ),
          ],
          legend: const Legend(isVisible: true),
          trackballBehavior: TrackballBehavior(
            enable: true,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            lineType: TrackballLineType.vertical,
          ),
          series: <CartesianSeries<_Ohlc, DateTime>>[
            LineSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              yValueMapper: (_Ohlc p, _) => p.close,
              yAxisName: 'precioAxis',
              name: 'Cierre',
              color: Colors.indigo,
            ),
            ColumnSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              yValueMapper: (_Ohlc p, _) => p.high - p.low,
              yAxisName: 'rangoAxis',
              name: 'Rango',
              color: Colors.teal.withValues(alpha: 0.5),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a64',
    title: 'Comparación multi-doughnut',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: GridView.count(
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          children:
              _ventasPorCategoria.map((_CategoryData categoria) {
                return Column(
                  children: <Widget>[
                    Text(
                      categoria.categoria,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: SfCircularChart(
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                        ),
                        series: <CircularSeries<_ChartPoint, String>>[
                          DoughnutSeries<_ChartPoint, String>(
                            dataSource: categoria.subcategorias,
                            xValueMapper: (_ChartPoint p, _) => p.x,
                            yValueMapper: (_ChartPoint p, _) => p.y,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a65',
    title: 'Dashboard combinado — SMA + tendencia',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 340,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Panel técnico: SMA + tendencia'),
          primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Precio')),
          legend: const Legend(isVisible: true),
          trackballBehavior: TrackballBehavior(enable: true),
          indicators: <TechnicalIndicator<_Ohlc, DateTime>>[
            SmaIndicator<_Ohlc, DateTime>(
              seriesName: 'Cierre',
              period: 4,
              valueField: 'y',
              signalLineColor: Colors.deepOrange,
              name: 'SMA(4)',
            ),
          ],
          series: <CartesianSeries<_Ohlc, DateTime>>[
            LineSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              yValueMapper: (_Ohlc p, _) => p.close,
              name: 'Cierre',
              color: Colors.blueGrey,
              trendlines: <Trendline>[
                Trendline(
                  type: TrendlineType.linear,
                  color: Colors.red,
                  name: 'Tendencia',
                  forwardForecast: 2,
                ),
              ],
            ),
          ],
        ),
      );
    },
  ),
];

/// --- Datos de bandas de Bollinger (calculadas manualmente con SMA(4) y
/// desviación estándar simple sobre el cierre). ---
class _BollingerPoint {
  const _BollingerPoint(
    this.date,
    this.media,
    this.bandaSuperior,
    this.bandaInferior,
  );
  final DateTime date;
  final double media;
  final double bandaSuperior;
  final double bandaInferior;
}

List<_BollingerPoint> _calcularBollinger(List<_Ohlc> datos, int periodo) {
  final List<_BollingerPoint> resultado = <_BollingerPoint>[];
  for (int i = periodo - 1; i < datos.length; i++) {
    final List<double> ventana =
        datos.sublist(i - periodo + 1, i + 1).map((_Ohlc p) => p.close).toList();
    final double media =
        ventana.reduce((double a, double b) => a + b) / ventana.length;
    final double varianza =
        ventana
            .map((double v) => math.pow(v - media, 2).toDouble())
            .reduce((double a, double b) => a + b) /
        ventana.length;
    final double desviacion = math.sqrt(varianza);
    resultado.add(
      _BollingerPoint(
        datos[i].date,
        media,
        media + (2 * desviacion),
        media - (2 * desviacion),
      ),
    );
  }
  return resultado;
}

final List<_BollingerPoint> _bandasBollinger = _calcularBollinger(
  _serieFinanciera,
  4,
);

/// Demostración de animación de entrada personalizada: alterna entre una
/// duración/curva "rápida" y una "lenta" al refrescar los datos, mostrando
/// cómo `animationDuration` junto con una curva propia controla el efecto.
class _CustomAnimationDemo extends StatefulWidget {
  const _CustomAnimationDemo();

  @override
  State<_CustomAnimationDemo> createState() => _CustomAnimationDemoState();
}

class _CustomAnimationDemoState extends State<_CustomAnimationDemo> {
  double _duracion = 600;
  int _seed = 0;

  List<_ChartPoint> get _datos {
    final math.Random random = math.Random(_seed);
    return List<_ChartPoint>.generate(8, (int i) {
      return _ChartPoint('P${i + 1}', 20 + random.nextInt(80).toDouble());
    });
  }

  void _reanimar({required bool rapido}) {
    setState(() {
      _duracion = rapido ? 350 : 2200;
      _seed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () => _reanimar(rapido: true),
              child: const Text('Animación rápida'),
            ),
            TextButton(
              onPressed: () => _reanimar(rapido: false),
              child: const Text('Animación lenta'),
            ),
          ],
        ),
        Expanded(
          child: SfCartesianChart(
            key: ValueKey<int>(_seed),
            title: const ChartTitle(text: 'Barras con animación personalizada'),
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(),
            series: <CartesianSeries<_ChartPoint, String>>[
              ColumnSeries<_ChartPoint, String>(
                dataSource: _datos,
                xValueMapper: (_ChartPoint p, _) => p.x,
                yValueMapper: (_ChartPoint p, _) => p.y,
                name: 'Valor',
                color: Colors.purple,
                animationDuration: _duracion,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Drill-down: al tocar una categoría se reemplaza el dataSource mostrado
/// por sus subcategorías, con un botón para volver atrás.
class _DrilldownDemo extends StatefulWidget {
  const _DrilldownDemo();

  @override
  State<_DrilldownDemo> createState() => _DrilldownDemoState();
}

class _DrilldownDemoState extends State<_DrilldownDemo> {
  _CategoryData? _seleccionada;

  @override
  Widget build(BuildContext context) {
    final bool enDetalle = _seleccionada != null;
    final List<dynamic> datos =
        enDetalle ? _seleccionada!.subcategorias : _ventasPorCategoria;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (enDetalle)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _seleccionada = null),
              ),
            Text(
              enDetalle
                  ? 'Detalle: ${_seleccionada!.categoria}'
                  : 'Toca una categoría para ver el detalle',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Ventas')),
            series: <CartesianSeries<dynamic, String>>[
              ColumnSeries<dynamic, String>(
                dataSource: datos,
                xValueMapper:
                    (dynamic p, _) =>
                        enDetalle
                            ? (p as _ChartPoint).x
                            : (p as _CategoryData).categoria,
                yValueMapper:
                    (dynamic p, _) =>
                        enDetalle
                            ? (p as _ChartPoint).y
                            : (p as _CategoryData).valor,
                name: 'Ventas',
                color: Colors.cyan.shade700,
                onPointTap: (ChartPointDetails details) {
                  if (!enDetalle) {
                    setState(() {
                      _seleccionada =
                          _ventasPorCategoria[details.pointIndex!];
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Red bayesiana simplificada: nodos posicionados sobre un SfCartesianChart
/// vacío (usado solo como lienzo, con ejes ocultos) mediante
/// `CartesianChartAnnotation`, y las conexiones dibujadas con un
/// `CustomPainter` superpuesto.
class _BayesianNetworkDemo extends StatelessWidget {
  const _BayesianNetworkDemo();

  static const List<_RedNodo> _nodos = <_RedNodo>[
    _RedNodo('Clima', 1, 5),
    _RedNodo('Tráfico', 3, 7),
    _RedNodo('Accidente', 3, 3),
    _RedNodo('Retraso', 5, 5),
  ];

  static const List<List<int>> _conexiones = <List<int>>[
    <int>[0, 1],
    <int>[0, 2],
    <int>[1, 3],
    <int>[2, 3],
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: CustomPaint(
            painter: _ConexionesPainter(_nodos, _conexiones),
          ),
        ),
        SfCartesianChart(
          primaryXAxis: const NumericAxis(
            isVisible: false,
            minimum: 0,
            maximum: 6,
          ),
          primaryYAxis: const NumericAxis(
            isVisible: false,
            minimum: 0,
            maximum: 8,
          ),
          plotAreaBorderWidth: 0,
          annotations:
              _nodos.map((_RedNodo nodo) {
                return CartesianChartAnnotation(
                  x: nodo.x,
                  y: nodo.y,
                  coordinateUnit: CoordinateUnit.point,
                  widget: _NodoWidget(texto: nodo.nombre),
                );
              }).toList(),
          series: const <CartesianSeries<dynamic, dynamic>>[],
        ),
      ],
    );
  }
}

class _RedNodo {
  const _RedNodo(this.nombre, this.x, this.y);
  final String nombre;
  final double x;
  final double y;
}

class _NodoWidget extends StatelessWidget {
  const _NodoWidget({required this.texto});
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        border: Border.all(color: Colors.indigo, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Dibuja líneas de conexión aproximadas entre los centros de los nodos,
/// ubicados usando una proyección lineal simple del espacio de datos
/// (0..6, 0..8) al tamaño del lienzo.
class _ConexionesPainter extends CustomPainter {
  _ConexionesPainter(this.nodos, this.conexiones);
  final List<_RedNodo> nodos;
  final List<List<int>> conexiones;

  Offset _proyectar(Size size, _RedNodo nodo) {
    final double dx = (nodo.x / 6) * size.width;
    final double dy = size.height - (nodo.y / 8) * size.height;
    return Offset(dx, dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.indigo.withValues(alpha: 0.5)
          ..strokeWidth = 2;
    for (final List<int> par in conexiones) {
      final Offset a = _proyectar(size, nodos[par[0]]);
      final Offset b = _proyectar(size, nodos[par[1]]);
      canvas.drawLine(a, b, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConexionesPainter oldDelegate) => false;
}

/// Árbol de decisiones: nodos como anotaciones y conectores dibujados con un
/// CustomPainter, siguiendo el mismo enfoque que la red bayesiana.
class _DecisionTreeDemo extends StatelessWidget {
  const _DecisionTreeDemo();

  static const List<_RedNodo> _nodos = <_RedNodo>[
    _RedNodo('¿Llueve?', 4, 9),
    _RedNodo('Llevar paraguas', 2, 6),
    _RedNodo('¿Hace sol?', 6, 6),
    _RedNodo('Gafas de sol', 5, 3),
    _RedNodo('Salir normal', 7, 3),
  ];

  static const List<List<int>> _conexiones = <List<int>>[
    <int>[0, 1],
    <int>[0, 2],
    <int>[2, 3],
    <int>[2, 4],
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: CustomPaint(
            painter: _ConexionesPainter(_nodos, _conexiones),
          ),
        ),
        SfCartesianChart(
          primaryXAxis: const NumericAxis(
            isVisible: false,
            minimum: 0,
            maximum: 10,
          ),
          primaryYAxis: const NumericAxis(
            isVisible: false,
            minimum: 0,
            maximum: 10,
          ),
          plotAreaBorderWidth: 0,
          annotations:
              _nodos.map((_RedNodo nodo) {
                return CartesianChartAnnotation(
                  x: nodo.x,
                  y: nodo.y,
                  coordinateUnit: CoordinateUnit.point,
                  widget: _NodoWidget(texto: nodo.nombre),
                );
              }).toList(),
          series: const <CartesianSeries<dynamic, dynamic>>[],
        ),
      ],
    );
  }
}

/// Streaming en tiempo real: agrega un punto nuevo cada segundo mediante
/// `ChartSeriesController.updateDataSource`, desplazando la ventana visible.
class _RealtimeStreamDemo extends StatefulWidget {
  const _RealtimeStreamDemo();

  @override
  State<_RealtimeStreamDemo> createState() => _RealtimeStreamDemoState();
}

class _RealtimeStreamDemoState extends State<_RealtimeStreamDemo> {
  final List<_ChartPoint> _datos = <_ChartPoint>[];
  final math.Random _random = math.Random();
  ChartSeriesController? _controller;
  Timer? _timer;
  int _tick = 0;
  static const int _maxPuntos = 20;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      _agregarPunto();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _agregarPunto();
    });
  }

  void _agregarPunto() {
    _tick++;
    final double valor = 50 + _random.nextInt(40).toDouble();
    setState(() {
      _datos.add(_ChartPoint('t$_tick', valor));
      if (_datos.length > _maxPuntos) {
        _datos.removeAt(0);
        _controller?.updateDataSource(
          addedDataIndex: _datos.length - 1,
          removedDataIndex: 0,
        );
      } else {
        _controller?.updateDataSource(addedDataIndex: _datos.length - 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Sensor en vivo'),
      primaryXAxis: const CategoryAxis(isVisible: false),
      primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Valor')),
      series: <CartesianSeries<_ChartPoint, String>>[
        LineSeries<_ChartPoint, String>(
          dataSource: _datos,
          xValueMapper: (_ChartPoint p, _) => p.x,
          yValueMapper: (_ChartPoint p, _) => p.y,
          name: 'Sensor',
          color: Colors.redAccent,
          animationDuration: 0,
          onRendererCreated: (ChartSeriesController controller) {
            _controller = controller;
          },
        ),
      ],
    );
  }
}
