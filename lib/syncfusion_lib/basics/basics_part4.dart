import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/chart_spec.dart';

class _ChartPoint {
  const _ChartPoint(this.x, this.y);

  final String x;
  final double y;
}

class _DualPoint {
  const _DualPoint(this.x, this.ventas, this.temperatura);

  final String x;
  final double ventas;
  final double temperatura;
}

class _XyPoint {
  const _XyPoint(this.x, this.y);

  final double x;
  final double y;
}

class _SlicePoint {
  const _SlicePoint(this.label, this.value);

  final String label;
  final double value;
}

final List<ChartSpec> syncBasicsPart4 = <ChartSpec>[
  ChartSpec(
    id: 'sync_b31',
    title: 'LineSeries — con crosshair',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Precio de acción (crosshair)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Día'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Precio (USD)'),
          ),
          crosshairBehavior: CrosshairBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            LineSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Lun', 102),
                _ChartPoint('Mar', 105),
                _ChartPoint('Mié', 101),
                _ChartPoint('Jue', 108),
                _ChartPoint('Vie', 112),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Precio',
              color: Colors.blueAccent,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b32',
    title: 'ColumnSeries — ventas mensuales',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas mensuales del año'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ventas (miles)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            ColumnSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ene', 42),
                _ChartPoint('Feb', 48),
                _ChartPoint('Mar', 55),
                _ChartPoint('Abr', 51),
                _ChartPoint('May', 63),
                _ChartPoint('Jun', 70),
                _ChartPoint('Jul', 68),
                _ChartPoint('Ago', 74),
                _ChartPoint('Sep', 80),
                _ChartPoint('Oct', 77),
                _ChartPoint('Nov', 85),
                _ChartPoint('Dic', 95),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Ventas',
              color: Colors.indigo,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b33',
    title: 'BarSeries — ranking de productos',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ranking de productos más vendidos'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Producto'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Unidades vendidas'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            BarSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Auriculares', 320),
                _ChartPoint('Teclado', 210),
                _ChartPoint('Mouse', 180),
                _ChartPoint('Monitor', 150),
                _ChartPoint('Webcam', 95),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Unidades',
              color: Colors.deepOrange,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b34',
    title: 'DoughnutSeries — con KPI central',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCircularChart(
          title: const ChartTitle(text: 'Cumplimiento de meta anual'),
          annotations: const <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '78%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Meta anual'),
                ],
              ),
            ),
          ],
          series: <CircularSeries<_SlicePoint, String>>[
            DoughnutSeries<_SlicePoint, String>(
              dataSource: const <_SlicePoint>[
                _SlicePoint('Cumplido', 78),
                _SlicePoint('Pendiente', 22),
              ],
              xValueMapper: (_SlicePoint p, _) => p.label,
              yValueMapper: (_SlicePoint p, _) => p.value,
              pointColorMapper: (_SlicePoint p, int index) =>
                  index == 0 ? Colors.green : Colors.grey.shade300,
              innerRadius: '75%',
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b35',
    title: 'AreaSeries — ingresos acumulados',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ingresos acumulados del año'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ingresos acumulados (miles)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            AreaSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ene', 42),
                _ChartPoint('Feb', 90),
                _ChartPoint('Mar', 145),
                _ChartPoint('Abr', 196),
                _ChartPoint('May', 259),
                _ChartPoint('Jun', 329),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Acumulado',
              color: Colors.lightGreen.withValues(alpha: 0.6),
              borderColor: Colors.green.shade800,
              borderWidth: 2,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b36',
    title: 'ScatterSeries — correlación',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Inversión en marketing vs ingresos'),
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Marketing (miles USD)'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ingresos (miles USD)'),
          ),
          series: <CartesianSeries<_XyPoint, num>>[
            ScatterSeries<_XyPoint, num>(
              dataSource: const <_XyPoint>[
                _XyPoint(5, 48),
                _XyPoint(8, 60),
                _XyPoint(12, 75),
                _XyPoint(15, 85),
                _XyPoint(20, 110),
                _XyPoint(25, 120),
                _XyPoint(30, 140),
              ],
              xValueMapper: (_XyPoint p, _) => p.x,
              yValueMapper: (_XyPoint p, _) => p.y,
              name: 'Campañas',
              color: Colors.teal,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b37',
    title: 'ColumnSeries — eje secundario (dual axis)',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      const List<_DualPoint> data = <_DualPoint>[
        _DualPoint('Ene', 42, 18),
        _DualPoint('Feb', 48, 19),
        _DualPoint('Mar', 55, 22),
        _DualPoint('Abr', 51, 25),
        _DualPoint('May', 63, 27),
        _DualPoint('Jun', 70, 30),
      ];
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas vs temperatura (doble eje)'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ventas (miles)'),
          ),
          axes: const <ChartAxis>[
            NumericAxis(
              name: 'temperaturaAxis',
              title: AxisTitle(text: 'Temperatura (°C)'),
              opposedPosition: true,
            ),
          ],
          series: <CartesianSeries<_DualPoint, String>>[
            ColumnSeries<_DualPoint, String>(
              dataSource: data,
              xValueMapper: (_DualPoint p, _) => p.x,
              yValueMapper: (_DualPoint p, _) => p.ventas,
              name: 'Ventas',
              color: Colors.indigo,
            ),
            LineSeries<_DualPoint, String>(
              dataSource: data,
              xValueMapper: (_DualPoint p, _) => p.x,
              yValueMapper: (_DualPoint p, _) => p.temperatura,
              yAxisName: 'temperaturaAxis',
              name: 'Temperatura',
              color: Colors.red,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b38',
    title: 'LineSeries — temperatura por hora',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Temperatura por hora'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Hora'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Temperatura (°C)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            LineSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('00:00', 14),
                _ChartPoint('03:00', 12),
                _ChartPoint('06:00', 13),
                _ChartPoint('09:00', 18),
                _ChartPoint('12:00', 24),
                _ChartPoint('15:00', 27),
                _ChartPoint('18:00', 22),
                _ChartPoint('21:00', 17),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Temperatura',
              color: Colors.orangeAccent,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b39',
    title: 'PieSeries — con sector explotado',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCircularChart(
          title: const ChartTitle(text: 'Gastos del hogar (sector destacado)'),
          legend: const Legend(isVisible: true),
          series: <CircularSeries<_SlicePoint, String>>[
            PieSeries<_SlicePoint, String>(
              dataSource: const <_SlicePoint>[
                _SlicePoint('Vivienda', 38),
                _SlicePoint('Comida', 24),
                _SlicePoint('Transporte', 16),
                _SlicePoint('Ocio', 12),
                _SlicePoint('Otros', 10),
              ],
              xValueMapper: (_SlicePoint p, _) => p.label,
              yValueMapper: (_SlicePoint p, _) => p.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              explode: true,
              explodeIndex: 0,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b40',
    title: 'Combinado — ColumnSeries + LineSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      const List<_ChartPoint> ventas = <_ChartPoint>[
        _ChartPoint('Ene', 42),
        _ChartPoint('Feb', 48),
        _ChartPoint('Mar', 55),
        _ChartPoint('Abr', 51),
        _ChartPoint('May', 63),
        _ChartPoint('Jun', 70),
      ];
      const List<_ChartPoint> meta = <_ChartPoint>[
        _ChartPoint('Ene', 45),
        _ChartPoint('Feb', 45),
        _ChartPoint('Mar', 50),
        _ChartPoint('Abr', 50),
        _ChartPoint('May', 60),
        _ChartPoint('Jun', 60),
      ];
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas reales vs meta'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ventas (miles)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            ColumnSeries<_ChartPoint, String>(
              dataSource: ventas,
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Ventas reales',
              color: Colors.indigo,
            ),
            LineSeries<_ChartPoint, String>(
              dataSource: meta,
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Meta',
              color: Colors.red,
              width: 3,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
];
