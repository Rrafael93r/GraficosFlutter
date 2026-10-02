import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../core/chart_spec.dart';

/// Graphic basics — part 3 (items 21-30).
///
/// Covers correlation scatter, histograms, sorted rankings, trend lines and
/// double-channel encodes.
final List<ChartSpec> graphicBasicsPart3 = [
  // 21. PointMark — correlación altura/peso
  ChartSpec(
    id: 'gr_b21',
    title: 'PointMark — correlación altura/peso',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'altura': 150, 'peso': 50},
          {'altura': 155, 'peso': 54},
          {'altura': 160, 'peso': 58},
          {'altura': 165, 'peso': 62},
          {'altura': 170, 'peso': 68},
          {'altura': 175, 'peso': 72},
          {'altura': 180, 'peso': 78},
          {'altura': 185, 'peso': 84},
          {'altura': 190, 'peso': 90},
        ],
        variables: {
          'altura': Variable(
            accessor: (Map map) => map['altura'] as num,
            scale: LinearScale(min: 140, max: 200),
          ),
          'peso': Variable(
            accessor: (Map map) => map['peso'] as num,
            scale: LinearScale(min: 40, max: 100),
          ),
        },
        marks: [
          PointMark(color: ColorEncode(value: Defaults.primaryColor)),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 22. IntervalMark — histograma
  ChartSpec(
    id: 'gr_b22',
    title: 'IntervalMark — histograma',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'centro': 5, 'frecuencia': 2},
          {'centro': 15, 'frecuencia': 7},
          {'centro': 25, 'frecuencia': 15},
          {'centro': 35, 'frecuencia': 22},
          {'centro': 45, 'frecuencia': 18},
          {'centro': 55, 'frecuencia': 10},
          {'centro': 65, 'frecuencia': 4},
        ],
        variables: {
          'centro': Variable(
            accessor: (Map map) => map['centro'] as num,
            scale: LinearScale(min: 0, max: 70),
          ),
          'frecuencia': Variable(
            accessor: (Map map) => map['frecuencia'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          IntervalMark(
            shape: ShapeEncode(value: RectShape(histogram: true)),
            color: ColorEncode(value: Defaults.primaryColor),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 23. LineMark — temperatura por hora
  ChartSpec(
    id: 'gr_b23',
    title: 'LineMark — temperatura por hora',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'hora': '00h', 'temp': 14},
          {'hora': '04h', 'temp': 12},
          {'hora': '08h', 'temp': 17},
          {'hora': '12h', 'temp': 24},
          {'hora': '16h', 'temp': 26},
          {'hora': '20h', 'temp': 19},
          {'hora': '23h', 'temp': 15},
        ],
        variables: {
          'hora': Variable(
            accessor: (Map map) => map['hora'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'temp': Variable(
            accessor: (Map map) => map['temp'] as num,
            scale: LinearScale(),
          ),
        },
        marks: [
          LineMark(color: ColorEncode(value: Colors.orangeAccent)),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 24. AreaMark — ingresos acumulados
  ChartSpec(
    id: 'gr_b24',
    title: 'AreaMark — ingresos acumulados',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'acumulado': 40},
          {'mes': 'Feb', 'acumulado': 95},
          {'mes': 'Mar', 'acumulado': 150},
          {'mes': 'Abr', 'acumulado': 230},
          {'mes': 'May', 'acumulado': 310},
          {'mes': 'Jun', 'acumulado': 420},
        ],
        variables: {
          'mes': Variable(
            accessor: (Map map) => map['mes'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'acumulado': Variable(
            accessor: (Map map) => map['acumulado'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(value: Defaults.primaryColor.withAlpha(90)),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 25. IntervalMark — ranking ordenado
  ChartSpec(
    id: 'gr_b25',
    title: 'IntervalMark — ranking ordenado',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'equipo': 'Águilas', 'puntos': 48},
          {'equipo': 'Leones', 'puntos': 61},
          {'equipo': 'Tigres', 'puntos': 55},
          {'equipo': 'Lobos', 'puntos': 70},
          {'equipo': 'Halcones', 'puntos': 39},
        ],
        variables: {
          'equipo': Variable(accessor: (Map map) => map['equipo'] as String),
          'puntos': Variable(
            accessor: (Map map) => map['puntos'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        transforms: [
          Sort(
            compare: (a, b) =>
                (b['puntos'] as num).compareTo(a['puntos'] as num),
          ),
        ],
        marks: [
          IntervalMark(color: ColorEncode(value: Defaults.primaryColor)),
        ],
        coord: RectCoord(transposed: true),
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 26. PointMark — dispersión con línea de tendencia
  ChartSpec(
    id: 'gr_b26',
    title: 'PointMark — dispersión con línea de tendencia',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'x': 1, 'y': 4, 'tendencia': 3},
          {'x': 2, 'y': 5, 'tendencia': 5},
          {'x': 3, 'y': 7, 'tendencia': 7},
          {'x': 4, 'y': 6, 'tendencia': 9},
          {'x': 5, 'y': 11, 'tendencia': 11},
          {'x': 6, 'y': 10, 'tendencia': 13},
          {'x': 7, 'y': 15, 'tendencia': 15},
          {'x': 8, 'y': 14, 'tendencia': 17},
        ],
        variables: {
          'x': Variable(
            accessor: (Map map) => map['x'] as num,
            scale: LinearScale(min: 0, marginMax: 0.1),
          ),
          'y': Variable(
            accessor: (Map map) => map['y'] as num,
            scale: LinearScale(min: 0, marginMax: 0.1),
          ),
          'tendencia': Variable(accessor: (Map map) => map['tendencia'] as num),
        },
        marks: [
          PointMark(
            position: Varset('x') * Varset('y'),
            color: ColorEncode(value: Defaults.primaryColor),
          ),
          LineMark(
            position: Varset('x') * Varset('tendencia'),
            color: ColorEncode(value: Colors.redAccent),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 27. LineMark — ventas mensuales
  ChartSpec(
    id: 'gr_b27',
    title: 'LineMark — ventas mensuales',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'ventas': 320},
          {'mes': 'Feb', 'ventas': 280},
          {'mes': 'Mar', 'ventas': 350},
          {'mes': 'Abr', 'ventas': 410},
          {'mes': 'May', 'ventas': 390},
          {'mes': 'Jun', 'ventas': 460},
          {'mes': 'Jul', 'ventas': 500},
        ],
        variables: {
          'mes': Variable(
            accessor: (Map map) => map['mes'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'ventas': Variable(
            accessor: (Map map) => map['ventas'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [LineMark()],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 28. IntervalMark — asistencia semanal
  ChartSpec(
    id: 'gr_b28',
    title: 'IntervalMark — asistencia semanal',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'dia': 'Lun', 'asistentes': 32},
          {'dia': 'Mar', 'asistentes': 28},
          {'dia': 'Mie', 'asistentes': 35},
          {'dia': 'Jue', 'asistentes': 30},
          {'dia': 'Vie', 'asistentes': 40},
          {'dia': 'Sab', 'asistentes': 12},
          {'dia': 'Dom', 'asistentes': 8},
        ],
        variables: {
          'dia': Variable(accessor: (Map map) => map['dia'] as String),
          'asistentes': Variable(
            accessor: (Map map) => map['asistentes'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          IntervalMark(color: ColorEncode(value: Defaults.primaryColor)),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 29. PointMark — bubble ponderado
  ChartSpec(
    id: 'gr_b29',
    title: 'PointMark — bubble ponderado',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'x': 5, 'y': 20, 'peso': 10, 'categoria': 'A'},
          {'x': 10, 'y': 35, 'peso': 25, 'categoria': 'A'},
          {'x': 15, 'y': 25, 'peso': 15, 'categoria': 'B'},
          {'x': 20, 'y': 45, 'peso': 35, 'categoria': 'B'},
          {'x': 25, 'y': 30, 'peso': 20, 'categoria': 'C'},
          {'x': 30, 'y': 50, 'peso': 40, 'categoria': 'C'},
        ],
        variables: {
          'x': Variable(
            accessor: (Map map) => map['x'] as num,
            scale: LinearScale(min: 0, marginMax: 0.15),
          ),
          'y': Variable(
            accessor: (Map map) => map['y'] as num,
            scale: LinearScale(min: 0, marginMax: 0.15),
          ),
          'peso': Variable(accessor: (Map map) => map['peso'] as num),
          'categoria': Variable(
            accessor: (Map map) => map['categoria'] as String,
          ),
        },
        marks: [
          PointMark(
            size: SizeEncode(variable: 'peso', values: [6, 30]),
            color: ColorEncode(
              variable: 'categoria',
              values: Defaults.colors10,
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 30. LineMark — doble canal (color + forma)
  ChartSpec(
    id: 'gr_b30',
    title: 'LineMark — doble canal (color + forma)',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'valor': 20, 'serie': 'Norte', 'estilo': 'Real', 'grupo': 'Norte-Real'},
          {'mes': 'Feb', 'valor': 28, 'serie': 'Norte', 'estilo': 'Real', 'grupo': 'Norte-Real'},
          {'mes': 'Mar', 'valor': 32, 'serie': 'Norte', 'estilo': 'Real', 'grupo': 'Norte-Real'},
          {'mes': 'Ene', 'valor': 22, 'serie': 'Norte', 'estilo': 'Proyectado', 'grupo': 'Norte-Proyectado'},
          {'mes': 'Feb', 'valor': 30, 'serie': 'Norte', 'estilo': 'Proyectado', 'grupo': 'Norte-Proyectado'},
          {'mes': 'Mar', 'valor': 38, 'serie': 'Norte', 'estilo': 'Proyectado', 'grupo': 'Norte-Proyectado'},
          {'mes': 'Ene', 'valor': 10, 'serie': 'Sur', 'estilo': 'Real', 'grupo': 'Sur-Real'},
          {'mes': 'Feb', 'valor': 15, 'serie': 'Sur', 'estilo': 'Real', 'grupo': 'Sur-Real'},
          {'mes': 'Mar', 'valor': 18, 'serie': 'Sur', 'estilo': 'Real', 'grupo': 'Sur-Real'},
          {'mes': 'Ene', 'valor': 12, 'serie': 'Sur', 'estilo': 'Proyectado', 'grupo': 'Sur-Proyectado'},
          {'mes': 'Feb', 'valor': 17, 'serie': 'Sur', 'estilo': 'Proyectado', 'grupo': 'Sur-Proyectado'},
          {'mes': 'Mar', 'valor': 21, 'serie': 'Sur', 'estilo': 'Proyectado', 'grupo': 'Sur-Proyectado'},
        ],
        variables: {
          'mes': Variable(
            accessor: (Map map) => map['mes'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'valor': Variable(
            accessor: (Map map) => map['valor'] as num,
            scale: LinearScale(min: 0),
          ),
          'serie': Variable(accessor: (Map map) => map['serie'] as String),
          'estilo': Variable(accessor: (Map map) => map['estilo'] as String),
          'grupo': Variable(accessor: (Map map) => map['grupo'] as String),
        },
        marks: [
          LineMark(
            position: Varset('mes') * Varset('valor') / Varset('grupo'),
            color: ColorEncode(variable: 'serie', values: Defaults.colors10),
            shape: ShapeEncode(
              variable: 'estilo',
              values: [
                BasicLineShape(),
                BasicLineShape(dash: [6, 3]),
              ],
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),
];
