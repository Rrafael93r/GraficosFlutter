import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/chart_spec.dart';

class _ChartPoint {
  const _ChartPoint(this.x, this.y);

  final String x;
  final double y;
}

const List<_ChartPoint> _ventasMensuales = <_ChartPoint>[
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
];

final List<ChartSpec> syncBasicsPart1 = <ChartSpec>[
  ChartSpec(
    id: 'sync_b01',
    title: 'LineSeries — ventas',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas mensuales'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ventas (miles)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            LineSeries<_ChartPoint, String>(
              dataSource: _ventasMensuales,
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
    id: 'sync_b02',
    title: 'SplineSeries — curva suave',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Temperatura promedio (curva suave)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Temperatura (°C)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            SplineSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ene', 18),
                _ChartPoint('Feb', 19),
                _ChartPoint('Mar', 21),
                _ChartPoint('Abr', 24),
                _ChartPoint('May', 27),
                _ChartPoint('Jun', 30),
                _ChartPoint('Jul', 31),
                _ChartPoint('Ago', 30),
                _ChartPoint('Sep', 27),
                _ChartPoint('Oct', 23),
                _ChartPoint('Nov', 20),
                _ChartPoint('Dic', 18),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Temperatura',
              color: Colors.orange,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b03',
    title: 'StepLineSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Nivel de inventario (escalonado)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Semana'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Unidades'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            StepLineSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('S1', 120),
                _ChartPoint('S2', 120),
                _ChartPoint('S3', 95),
                _ChartPoint('S4', 95),
                _ChartPoint('S5', 140),
                _ChartPoint('S6', 140),
                _ChartPoint('S7', 110),
                _ChartPoint('S8', 110),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Inventario',
              color: Colors.teal,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b04',
    title: 'FastLineSeries (datasets grandes)',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      final List<_ChartPoint> largeDataset = List<_ChartPoint>.generate(
        150,
        (int index) {
          final double value =
              50 + 20 * (index.isEven ? 1 : -1) * (index % 7) / 7 + index / 10;
          return _ChartPoint(index.toString(), value);
        },
      );
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Sensor en tiempo real (150 muestras)'),
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Muestra'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Valor'),
          ),
          series: <CartesianSeries<_ChartPoint, num>>[
            FastLineSeries<_ChartPoint, num>(
              dataSource: largeDataset,
              xValueMapper: (_ChartPoint p, int index) => index,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Lecturas',
              color: Colors.deepPurple,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b05',
    title: 'LineSeries múltiple — comparativo',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas: 2024 vs 2025'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ventas (miles)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            LineSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ene', 40),
                _ChartPoint('Feb', 45),
                _ChartPoint('Mar', 50),
                _ChartPoint('Abr', 48),
                _ChartPoint('May', 58),
                _ChartPoint('Jun', 62),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: '2024',
              color: Colors.blueGrey,
            ),
            LineSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ene', 42),
                _ChartPoint('Feb', 48),
                _ChartPoint('Mar', 55),
                _ChartPoint('Abr', 51),
                _ChartPoint('May', 63),
                _ChartPoint('Jun', 70),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: '2025',
              color: Colors.redAccent,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b06',
    title: 'AreaSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Tráfico web diario'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Día'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Visitas'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            AreaSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Lun', 320),
                _ChartPoint('Mar', 280),
                _ChartPoint('Mié', 350),
                _ChartPoint('Jue', 410),
                _ChartPoint('Vie', 460),
                _ChartPoint('Sáb', 300),
                _ChartPoint('Dom', 250),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Visitas',
              color: Colors.lightBlue.withValues(alpha: 0.6),
              borderColor: Colors.blue,
              borderWidth: 2,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b07',
    title: 'SplineAreaSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Consumo de energía (suavizado)'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Hora'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'kWh'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            SplineAreaSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('00h', 12),
                _ChartPoint('04h', 8),
                _ChartPoint('08h', 25),
                _ChartPoint('12h', 38),
                _ChartPoint('16h', 42),
                _ChartPoint('20h', 30),
                _ChartPoint('24h', 15),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Consumo',
              color: Colors.green.withValues(alpha: 0.5),
              borderColor: Colors.green,
              borderWidth: 2,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b08',
    title: 'StepAreaSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Capacidad de servidores'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Turno'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Carga (%)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            StepAreaSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('T1', 40),
                _ChartPoint('T2', 55),
                _ChartPoint('T3', 55),
                _ChartPoint('T4', 70),
                _ChartPoint('T5', 65),
                _ChartPoint('T6', 80),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Carga',
              color: Colors.amber.withValues(alpha: 0.6),
              borderColor: Colors.orange,
              borderWidth: 2,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b09',
    title: 'StackedAreaSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ingresos por región (apilado)'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Trimestre'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ingresos (miles)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            StackedAreaSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Q1', 20),
                _ChartPoint('Q2', 25),
                _ChartPoint('Q3', 30),
                _ChartPoint('Q4', 35),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Norte',
            ),
            StackedAreaSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Q1', 15),
                _ChartPoint('Q2', 18),
                _ChartPoint('Q3', 22),
                _ChartPoint('Q4', 20),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Sur',
            ),
            StackedAreaSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Q1', 10),
                _ChartPoint('Q2', 14),
                _ChartPoint('Q3', 12),
                _ChartPoint('Q4', 18),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Centro',
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b10',
    title: 'StackedArea100Series',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Participación de mercado (100%)'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Año'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Participación (%)'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            StackedArea100Series<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('2022', 30),
                _ChartPoint('2023', 35),
                _ChartPoint('2024', 28),
                _ChartPoint('2025', 32),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Producto A',
            ),
            StackedArea100Series<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('2022', 40),
                _ChartPoint('2023', 35),
                _ChartPoint('2024', 42),
                _ChartPoint('2025', 38),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Producto B',
            ),
            StackedArea100Series<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('2022', 30),
                _ChartPoint('2023', 30),
                _ChartPoint('2024', 30),
                _ChartPoint('2025', 30),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Producto C',
            ),
          ],
        ),
      );
    },
  ),
];
