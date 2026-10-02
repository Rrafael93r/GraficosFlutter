import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/chart_spec.dart';

class _ChartPoint {
  const _ChartPoint(this.x, this.y);

  final String x;
  final double y;
}

class _FunnelPoint {
  const _FunnelPoint(this.label, this.value);

  final String label;
  final double value;
}

class _BubblePoint {
  const _BubblePoint(this.x, this.y, this.size);

  final double x;
  final double y;
  final double size;
}

class _XyPoint {
  const _XyPoint(this.x, this.y);

  final double x;
  final double y;
}

final List<ChartSpec> syncBasicsPart3 = <ChartSpec>[
  ChartSpec(
    id: 'sync_b21',
    title: 'SfPyramidChart básico',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfPyramidChart(
          title: const ChartTitle(text: 'Etapas del proceso de venta'),
          legend: const Legend(isVisible: true),
          series: PyramidSeries<_FunnelPoint, String>(
            dataSource: const <_FunnelPoint>[
              _FunnelPoint('Visitas', 1000),
              _FunnelPoint('Interesados', 600),
              _FunnelPoint('Cotizaciones', 300),
              _FunnelPoint('Ventas', 120),
            ],
            xValueMapper: (_FunnelPoint p, _) => p.label,
            yValueMapper: (_FunnelPoint p, _) => p.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b22',
    title: 'SfFunnelChart básico',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfFunnelChart(
          title: const ChartTitle(text: 'Embudo de conversión'),
          legend: const Legend(isVisible: true),
          series: FunnelSeries<_FunnelPoint, String>(
            dataSource: const <_FunnelPoint>[
              _FunnelPoint('Registrados', 5000),
              _FunnelPoint('Activados', 3200),
              _FunnelPoint('Compradores', 1400),
              _FunnelPoint('Recurrentes', 600),
            ],
            xValueMapper: (_FunnelPoint p, _) => p.label,
            yValueMapper: (_FunnelPoint p, _) => p.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b23',
    title: 'ScatterSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Horas de estudio vs calificación'),
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Horas de estudio'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Calificación'),
          ),
          series: <CartesianSeries<_XyPoint, num>>[
            ScatterSeries<_XyPoint, num>(
              dataSource: const <_XyPoint>[
                _XyPoint(1, 55),
                _XyPoint(2, 60),
                _XyPoint(3, 68),
                _XyPoint(4, 72),
                _XyPoint(5, 78),
                _XyPoint(6, 82),
                _XyPoint(7, 88),
                _XyPoint(8, 90),
              ],
              xValueMapper: (_XyPoint p, _) => p.x,
              yValueMapper: (_XyPoint p, _) => p.y,
              name: 'Estudiantes',
              color: Colors.deepOrange,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b24',
    title: 'BubbleSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Producto: precio, ventas y margen'),
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Precio (USD)'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Unidades vendidas'),
          ),
          series: <CartesianSeries<_BubblePoint, num>>[
            BubbleSeries<_BubblePoint, num>(
              dataSource: const <_BubblePoint>[
                _BubblePoint(10, 200, 15),
                _BubblePoint(25, 150, 30),
                _BubblePoint(40, 90, 45),
                _BubblePoint(55, 60, 25),
                _BubblePoint(70, 30, 60),
              ],
              xValueMapper: (_BubblePoint p, _) => p.x,
              yValueMapper: (_BubblePoint p, _) => p.y,
              sizeValueMapper: (_BubblePoint p, _) => p.size,
              name: 'Productos',
              color: Colors.pinkAccent.withValues(alpha: 0.6),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b25',
    title: 'HistogramSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      final List<double> alturas = <double>[
        1.55, 1.60, 1.62, 1.65, 1.67, 1.68, 1.70, 1.70, 1.71, 1.72,
        1.73, 1.74, 1.75, 1.75, 1.76, 1.77, 1.78, 1.80, 1.82, 1.85,
        1.58, 1.63, 1.66, 1.69, 1.71, 1.73, 1.74, 1.76, 1.79, 1.83,
      ];
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Distribución de estaturas (histograma)'),
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Estatura (m)'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Frecuencia'),
          ),
          series: <CartesianSeries<double, double>>[
            HistogramSeries<double, double>(
              dataSource: alturas,
              yValueMapper: (double value, _) => value,
              name: 'Estaturas',
              color: Colors.blueGrey,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b26',
    title: 'ColumnSeries — con etiquetas de datos',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas por trimestre'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Trimestre'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ventas (miles)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            ColumnSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Q1', 45),
                _ChartPoint('Q2', 58),
                _ChartPoint('Q3', 63),
                _ChartPoint('Q4', 80),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Ventas',
              color: Colors.indigo,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b27',
    title: 'LineSeries — con marcadores',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Peso corporal (seguimiento)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Semana'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Peso (kg)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            LineSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('S1', 82),
                _ChartPoint('S2', 81),
                _ChartPoint('S3', 80.5),
                _ChartPoint('S4', 79),
                _ChartPoint('S5', 78.2),
                _ChartPoint('S6', 77.5),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Peso',
              color: Colors.green,
              markerSettings: const MarkerSettings(
                isVisible: true,
                shape: DataMarkerType.circle,
              ),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b28',
    title: 'ColumnSeries — eje logarítmico',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Crecimiento de usuarios (escala log)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Año'),
          ),
          primaryYAxis: const LogarithmicAxis(
            title: AxisTitle(text: 'Usuarios (log)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            ColumnSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('2019', 10),
                _ChartPoint('2020', 100),
                _ChartPoint('2021', 1000),
                _ChartPoint('2022', 8000),
                _ChartPoint('2023', 50000),
                _ChartPoint('2024', 300000),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Usuarios',
              color: Colors.deepPurple,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b29',
    title: 'LineSeries — con zoom y pan',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      final List<_ChartPoint> data = List<_ChartPoint>.generate(
        40,
        (int i) => _ChartPoint('D$i', 50 + 10 * (i % 5) - (i / 2)),
      );
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Serie diaria (zoom y pan)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Día'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Valor'),
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enablePanning: true,
            enableDoubleTapZooming: true,
            enableMouseWheelZooming: true,
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            LineSeries<_ChartPoint, String>(
              dataSource: data,
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Valor',
              color: Colors.blue,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b30',
    title: 'ColumnSeries — con trackball tooltip',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Pedidos diarios (trackball)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Día'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Pedidos'),
          ),
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            ColumnSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Lun', 120),
                _ChartPoint('Mar', 98),
                _ChartPoint('Mié', 140),
                _ChartPoint('Jue', 110),
                _ChartPoint('Vie', 160),
                _ChartPoint('Sáb', 180),
                _ChartPoint('Dom', 90),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Pedidos',
              color: Colors.orange,
            ),
          ],
        ),
      );
    },
  ),
];
