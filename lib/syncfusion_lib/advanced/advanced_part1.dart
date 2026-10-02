import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

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

/// 15 periodos (días) de datos simulados tipo acción bursátil.
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

class _StatPoint {
  const _StatPoint(this.label, this.valores);
  final String label;
  final List<num> valores;
}

final List<_StatPoint> _distribuciones = <_StatPoint>[
  _StatPoint('Lote A', <num>[12, 15, 14, 18, 20, 22, 10, 16, 13, 19]),
  _StatPoint('Lote B', <num>[22, 25, 19, 28, 30, 21, 24, 26, 23, 27]),
  _StatPoint('Lote C', <num>[8, 11, 9, 14, 7, 12, 10, 13, 6, 15]),
  _StatPoint('Lote D', <num>[30, 33, 29, 35, 31, 28, 34, 32, 36, 27]),
  _StatPoint('Lote E', <num>[17, 19, 16, 21, 18, 20, 15, 22, 19, 17]),
];

class _ErrorPoint {
  const _ErrorPoint(this.x, this.y, this.error);
  final String x;
  final double y;
  final double error;
}

final List<_ErrorPoint> _medicionesLab = <_ErrorPoint>[
  _ErrorPoint('Prueba 1', 45, 3.2),
  _ErrorPoint('Prueba 2', 52, 4.1),
  _ErrorPoint('Prueba 3', 48, 2.6),
  _ErrorPoint('Prueba 4', 60, 5.0),
  _ErrorPoint('Prueba 5', 55, 3.8),
  _ErrorPoint('Prueba 6', 63, 4.4),
  _ErrorPoint('Prueba 7', 58, 3.0),
  _ErrorPoint('Prueba 8', 66, 4.9),
];

class _WaterfallPoint {
  const _WaterfallPoint(
    this.x,
    this.y, {
    this.isIntermediateSum = false,
    this.isTotalSum = false,
  });
  final String x;
  final double y;
  final bool isIntermediateSum;
  final bool isTotalSum;
}

final List<_WaterfallPoint> _flujoCaja = <_WaterfallPoint>[
  _WaterfallPoint('Inicial', 1000),
  _WaterfallPoint('Ventas', 850),
  _WaterfallPoint('Servicios', 420),
  _WaterfallPoint('Subtotal', 0, isIntermediateSum: true),
  _WaterfallPoint('Nómina', -650),
  _WaterfallPoint('Alquiler', -300),
  _WaterfallPoint('Marketing', -180),
  _WaterfallPoint('Total', 0, isTotalSum: true),
];

class _RadialPoint {
  const _RadialPoint(this.x, this.y);
  final String x;
  final double y;
}

final List<_RadialPoint> _progresoObjetivos = <_RadialPoint>[
  _RadialPoint('Ventas', 92),
  _RadialPoint('Soporte', 78),
  _RadialPoint('Marketing', 65),
  _RadialPoint('Operaciones', 54),
];

class _TreemapPoint {
  const _TreemapPoint(this.region, this.categoria, this.valor);
  final String region;
  final String categoria;
  final double valor;
}

final List<_TreemapPoint> _ventasRegionales = <_TreemapPoint>[
  _TreemapPoint('Norte', 'Electrónica', 320),
  _TreemapPoint('Norte', 'Hogar', 180),
  _TreemapPoint('Norte', 'Ropa', 140),
  _TreemapPoint('Sur', 'Electrónica', 210),
  _TreemapPoint('Sur', 'Hogar', 260),
  _TreemapPoint('Sur', 'Ropa', 90),
  _TreemapPoint('Este', 'Electrónica', 150),
  _TreemapPoint('Este', 'Hogar', 95),
  _TreemapPoint('Este', 'Ropa', 220),
  _TreemapPoint('Oeste', 'Electrónica', 275),
  _TreemapPoint('Oeste', 'Hogar', 130),
  _TreemapPoint('Oeste', 'Ropa', 175),
];

final List<ChartSpec> syncAdvancedPart1 = <ChartSpec>[
  ChartSpec(
    id: 'sync_a41',
    title: 'CandleSeries — velas japonesas',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Cotización diaria (velas)'),
          primaryXAxis: const DateTimeAxis(
            title: AxisTitle(text: 'Fecha'),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Precio'),
          ),
          trackballBehavior: TrackballBehavior(enable: true),
          series: <CartesianSeries<_Ohlc, DateTime>>[
            CandleSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              lowValueMapper: (_Ohlc p, _) => p.low,
              highValueMapper: (_Ohlc p, _) => p.high,
              openValueMapper: (_Ohlc p, _) => p.open,
              closeValueMapper: (_Ohlc p, _) => p.close,
              name: 'Precio',
              bullColor: Colors.teal,
              bearColor: Colors.redAccent,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a42',
    title: 'HiloSeries — rango alto/bajo',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Rango diario (Hilo)'),
          primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Precio')),
          trackballBehavior: TrackballBehavior(enable: true),
          series: <CartesianSeries<_Ohlc, DateTime>>[
            HiloSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              lowValueMapper: (_Ohlc p, _) => p.low,
              highValueMapper: (_Ohlc p, _) => p.high,
              name: 'Rango',
              color: Colors.indigo,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a43',
    title: 'HiloOpenCloseSeries — apertura/cierre',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Apertura/cierre diario'),
          primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Precio')),
          trackballBehavior: TrackballBehavior(enable: true),
          series: <CartesianSeries<_Ohlc, DateTime>>[
            HiloOpenCloseSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              lowValueMapper: (_Ohlc p, _) => p.low,
              highValueMapper: (_Ohlc p, _) => p.high,
              openValueMapper: (_Ohlc p, _) => p.open,
              closeValueMapper: (_Ohlc p, _) => p.close,
              name: 'OHLC',
              bullColor: Colors.green,
              bearColor: Colors.deepOrange,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a44',
    title: 'BoxAndWhiskerSeries — caja y bigotes',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Distribución de medidas por lote'),
          primaryXAxis: const CategoryAxis(title: AxisTitle(text: 'Lote')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Valor')),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_StatPoint, String>>[
            BoxAndWhiskerSeries<_StatPoint, String>(
              dataSource: _distribuciones,
              xValueMapper: (_StatPoint p, _) => p.label,
              yValueMapper: (_StatPoint p, _) => p.valores,
              name: 'Medidas',
              boxPlotMode: BoxPlotMode.normal,
              showMean: true,
              color: Colors.deepPurple,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a45',
    title: 'ErrorBarSeries — barras de error',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Mediciones de laboratorio'),
          primaryXAxis: const CategoryAxis(title: AxisTitle(text: 'Prueba')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Valor')),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_ErrorPoint, String>>[
            ColumnSeries<_ErrorPoint, String>(
              dataSource: _medicionesLab,
              xValueMapper: (_ErrorPoint p, _) => p.x,
              yValueMapper: (_ErrorPoint p, _) => p.y,
              name: 'Medición',
              color: Colors.blueGrey.shade300,
            ),
            ErrorBarSeries<_ErrorPoint, String>(
              dataSource: _medicionesLab,
              xValueMapper: (_ErrorPoint p, _) => p.x,
              yValueMapper: (_ErrorPoint p, _) => p.y,
              name: 'Error',
              type: ErrorBarType.custom,
              direction: Direction.both,
              mode: RenderingMode.vertical,
              verticalPositiveErrorValue: 1,
              verticalNegativeErrorValue: 1,
              color: Colors.black87,
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a46',
    title: 'WaterfallSeries — flujo de caja',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Flujo de caja mensual'),
          primaryXAxis: const CategoryAxis(title: AxisTitle(text: 'Concepto')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Monto')),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_WaterfallPoint, String>>[
            WaterfallSeries<_WaterfallPoint, String>(
              dataSource: _flujoCaja,
              xValueMapper: (_WaterfallPoint p, _) => p.x,
              yValueMapper: (_WaterfallPoint p, _) => p.y,
              intermediateSumPredicate:
                  (_WaterfallPoint p, _) => p.isIntermediateSum,
              totalSumPredicate: (_WaterfallPoint p, _) => p.isTotalSum,
              name: 'Caja',
              negativePointsColor: Colors.redAccent,
              intermediateSumColor: Colors.amber,
              totalSumColor: Colors.indigo,
              connectorLineSettings: const WaterfallConnectorLineSettings(
                color: Colors.black45,
              ),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a47',
    title: 'RadialBarSeries — progreso multinivel',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCircularChart(
          title: const ChartTitle(text: 'Progreso por área (%)'),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CircularSeries<_RadialPoint, String>>[
            RadialBarSeries<_RadialPoint, String>(
              dataSource: _progresoObjetivos,
              xValueMapper: (_RadialPoint p, _) => p.x,
              yValueMapper: (_RadialPoint p, _) => p.y,
              maximumValue: 100,
              radius: '95%',
              innerRadius: '30%',
              gap: '3%',
              cornerStyle: CornerStyle.bothCurve,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a48',
    title: 'Trendline — regresión lineal',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Cierre con tendencia lineal'),
          primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Cierre')),
          legend: const Legend(isVisible: true),
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
                  name: 'Tendencia lineal',
                  forwardForecast: 2,
                ),
              ],
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a49',
    title: 'Trendline — regresión polinómica',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Cierre con tendencia polinómica'),
          primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Cierre')),
          legend: const Legend(isVisible: true),
          series: <CartesianSeries<_Ohlc, DateTime>>[
            LineSeries<_Ohlc, DateTime>(
              dataSource: _serieFinanciera,
              xValueMapper: (_Ohlc p, _) => p.date,
              yValueMapper: (_Ohlc p, _) => p.close,
              name: 'Cierre',
              color: Colors.blueGrey,
              trendlines: <Trendline>[
                Trendline(
                  type: TrendlineType.polynomial,
                  polynomialOrder: 3,
                  color: Colors.deepOrange,
                  name: 'Tendencia polinómica',
                ),
              ],
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a50',
    title: 'Zoom por pinch — ZoomPanBehavior',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'Pellizca (pinch) sobre el gráfico para hacer zoom en móvil.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Zoom interactivo'),
                primaryXAxis: const DateTimeAxis(
                  title: AxisTitle(text: 'Fecha'),
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Cierre'),
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  enableDoubleTapZooming: true,
                  zoomMode: ZoomMode.x,
                ),
                series: <CartesianSeries<_Ohlc, DateTime>>[
                  AreaSeries<_Ohlc, DateTime>(
                    dataSource: _serieFinanciera,
                    xValueMapper: (_Ohlc p, _) => p.date,
                    yValueMapper: (_Ohlc p, _) => p.close,
                    name: 'Cierre',
                    color: Colors.indigo.withValues(alpha: 0.35),
                    borderColor: Colors.indigo,
                    borderWidth: 2,
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
    id: 'sync_a51',
    title: 'Indicador técnico — media móvil (SMA)',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 320,
        child: SfCartesianChart(
          title: const ChartTitle(text: 'Cierre con media móvil simple'),
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
            ),
          ],
        ),
      );
    },
  ),
  ChartSpec(
    id: 'sync_a52',
    title: 'Selector de rango — filtro interactivo',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return const SizedBox(height: 380, child: _RangeSelectorDemo());
    },
  ),
  ChartSpec(
    id: 'sync_a53',
    title: 'SfTreemap — distribución jerárquica',
    category: ChartCategory.advanced,
    builder: (BuildContext context) {
      return SizedBox(
        height: 340,
        child: SfTreemap(
          dataCount: _ventasRegionales.length,
          weightValueMapper: (int index) => _ventasRegionales[index].valor,
          legend: const TreemapLegend(position: TreemapLegendPosition.bottom),
          levels: <TreemapLevel>[
            TreemapLevel(
              groupMapper: (int index) => _ventasRegionales[index].region,
              labelBuilder: (BuildContext context, TreemapTile tile) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    tile.group,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            TreemapLevel(
              groupMapper: (int index) => _ventasRegionales[index].categoria,
              color: Colors.black.withValues(alpha: 0.08),
              border: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 1),
              ),
              labelBuilder: (BuildContext context, TreemapTile tile) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    tile.group,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  ),
];

/// Selector de rango interactivo: como esta versión de
/// `syncfusion_flutter_charts` no expone un `RangeSelectorBehavior` para
/// `SfCartesianChart` (el widget `SfRangeSelector` pertenece al paquete de
/// sliders), se aproxima la funcionalidad con un `RangeSlider` que filtra el
/// `dataSource` mostrado en el gráfico.
class _RangeSelectorDemo extends StatefulWidget {
  const _RangeSelectorDemo();

  @override
  State<_RangeSelectorDemo> createState() => _RangeSelectorDemoState();
}

class _RangeSelectorDemoState extends State<_RangeSelectorDemo> {
  RangeValues _rango = const RangeValues(0, 14);

  @override
  Widget build(BuildContext context) {
    final int inicio = _rango.start.round();
    final int fin = _rango.end.round();
    final List<_Ohlc> visibles = _serieFinanciera.sublist(
      inicio,
      math.min(fin + 1, _serieFinanciera.length),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Rango: día ${inicio + 1} a día ${fin + 1}',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        RangeSlider(
          min: 0,
          max: (_serieFinanciera.length - 1).toDouble(),
          divisions: _serieFinanciera.length - 1,
          values: _rango,
          labels: RangeLabels('${inicio + 1}', '${fin + 1}'),
          onChanged: (RangeValues values) {
            setState(() => _rango = values);
          },
        ),
        Expanded(
          child: SfCartesianChart(
            title: const ChartTitle(text: 'Serie filtrada por rango'),
            primaryXAxis: const DateTimeAxis(title: AxisTitle(text: 'Fecha')),
            primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Cierre')),
            series: <CartesianSeries<_Ohlc, DateTime>>[
              LineSeries<_Ohlc, DateTime>(
                dataSource: visibles,
                xValueMapper: (_Ohlc p, _) => p.date,
                yValueMapper: (_Ohlc p, _) => p.close,
                name: 'Cierre',
                color: Colors.teal,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
