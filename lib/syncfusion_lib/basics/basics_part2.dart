import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/chart_spec.dart';

class _ChartPoint {
  const _ChartPoint(this.x, this.y);

  final String x;
  final double y;
}

class _RangePoint {
  const _RangePoint(this.x, this.low, this.high);

  final String x;
  final double low;
  final double high;
}

class _SlicePoint {
  const _SlicePoint(this.label, this.value);

  final String label;
  final double value;
}

final List<ChartSpec> syncBasicsPart2 = <ChartSpec>[
  ChartSpec(
    id: 'sync_b11',
    title: 'ColumnSeries (barra vertical)',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Ventas por categoría'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Categoría'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Ventas'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            ColumnSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Electrónica', 85),
                _ChartPoint('Ropa', 62),
                _ChartPoint('Hogar', 48),
                _ChartPoint('Deportes', 55),
                _ChartPoint('Juguetes', 33),
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
    id: 'sync_b12',
    title: 'BarSeries (barra horizontal)',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Empleados por departamento'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Departamento'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Empleados'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            BarSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ventas', 24),
                _ChartPoint('TI', 18),
                _ChartPoint('RRHH', 10),
                _ChartPoint('Finanzas', 14),
                _ChartPoint('Logística', 20),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Empleados',
              color: Colors.teal,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b13',
    title: 'StackedColumnSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Producción por línea'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Mes'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Unidades'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            StackedColumnSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ene', 30),
                _ChartPoint('Feb', 35),
                _ChartPoint('Mar', 32),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Línea A',
            ),
            StackedColumnSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Ene', 20),
                _ChartPoint('Feb', 25),
                _ChartPoint('Mar', 28),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Línea B',
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b14',
    title: 'StackedBarSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Horas de trabajo por proyecto'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Proyecto'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Horas'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            StackedBarSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Proyecto X', 40),
                _ChartPoint('Proyecto Y', 30),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Diseño',
            ),
            StackedBarSeries<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('Proyecto X', 60),
                _ChartPoint('Proyecto Y', 50),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Desarrollo',
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b15',
    title: 'StackedColumn100Series',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Distribución de votos (100%)'),
          legend: const Legend(isVisible: true),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Distrito'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Porcentaje'),
          ),
          series: <CartesianSeries<_ChartPoint, String>>[
            StackedColumn100Series<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('D1', 45),
                _ChartPoint('D2', 38),
                _ChartPoint('D3', 50),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Partido A',
            ),
            StackedColumn100Series<_ChartPoint, String>(
              dataSource: const <_ChartPoint>[
                _ChartPoint('D1', 55),
                _ChartPoint('D2', 62),
                _ChartPoint('D3', 50),
              ],
              xValueMapper: (_ChartPoint p, _) => p.x,
              yValueMapper: (_ChartPoint p, _) => p.y,
              name: 'Partido B',
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b16',
    title: 'RangeColumnSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Rango de temperatura diario'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Día'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Temperatura (°C)'),
          ),
          series: <CartesianSeries<_RangePoint, String>>[
            RangeColumnSeries<_RangePoint, String>(
              dataSource: const <_RangePoint>[
                _RangePoint('Lun', 12, 22),
                _RangePoint('Mar', 14, 24),
                _RangePoint('Mié', 11, 20),
                _RangePoint('Jue', 15, 26),
                _RangePoint('Vie', 16, 27),
              ],
              xValueMapper: (_RangePoint p, _) => p.x,
              lowValueMapper: (_RangePoint p, _) => p.low,
              highValueMapper: (_RangePoint p, _) => p.high,
              name: 'Rango',
              color: Colors.cyan,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b17',
    title: 'RangeAreaSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Rango de precios de acción'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Semana'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Precio (USD)'),
          ),
          series: <CartesianSeries<_RangePoint, String>>[
            RangeAreaSeries<_RangePoint, String>(
              dataSource: const <_RangePoint>[
                _RangePoint('S1', 100, 115),
                _RangePoint('S2', 105, 120),
                _RangePoint('S3', 98, 110),
                _RangePoint('S4', 108, 128),
                _RangePoint('S5', 112, 130),
              ],
              xValueMapper: (_RangePoint p, _) => p.x,
              lowValueMapper: (_RangePoint p, _) => p.low,
              highValueMapper: (_RangePoint p, _) => p.high,
              name: 'Rango de precio',
              color: Colors.purple.withValues(alpha: 0.4),
              borderColor: Colors.purple,
              borderWidth: 2,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b18',
    title: 'PieSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCircularChart(
          title: const ChartTitle(text: 'Participación de mercado'),
          legend: const Legend(isVisible: true),
          series: <CircularSeries<_SlicePoint, String>>[
            PieSeries<_SlicePoint, String>(
              dataSource: const <_SlicePoint>[
                _SlicePoint('Marca A', 35),
                _SlicePoint('Marca B', 25),
                _SlicePoint('Marca C', 20),
                _SlicePoint('Otros', 20),
              ],
              xValueMapper: (_SlicePoint p, _) => p.label,
              yValueMapper: (_SlicePoint p, _) => p.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b19',
    title: 'DoughnutSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCircularChart(
          title: const ChartTitle(text: 'Gasto por categoría'),
          legend: const Legend(isVisible: true),
          series: <CircularSeries<_SlicePoint, String>>[
            DoughnutSeries<_SlicePoint, String>(
              dataSource: const <_SlicePoint>[
                _SlicePoint('Vivienda', 40),
                _SlicePoint('Comida', 25),
                _SlicePoint('Transporte', 15),
                _SlicePoint('Ocio', 10),
                _SlicePoint('Ahorro', 10),
              ],
              xValueMapper: (_SlicePoint p, _) => p.label,
              yValueMapper: (_SlicePoint p, _) => p.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_b20',
    title: 'RadialBarSeries',
    category: ChartCategory.basic,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCircularChart(
          title: const ChartTitle(text: 'Cumplimiento de objetivos'),
          legend: const Legend(isVisible: true),
          series: <CircularSeries<_SlicePoint, String>>[
            RadialBarSeries<_SlicePoint, String>(
              dataSource: const <_SlicePoint>[
                _SlicePoint('Ventas', 85),
                _SlicePoint('Soporte', 72),
                _SlicePoint('Calidad', 90),
                _SlicePoint('Entregas', 65),
              ],
              xValueMapper: (_SlicePoint p, _) => p.label,
              yValueMapper: (_SlicePoint p, _) => p.value,
              maximumValue: 100,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
];
