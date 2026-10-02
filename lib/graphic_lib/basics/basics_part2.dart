import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../core/chart_spec.dart';

/// Graphic basics — part 2 (items 11-20).
///
/// Covers IntervalMark (bar variants) and PolarCoord recipes (pie, donut,
/// rose, radar).
final List<ChartSpec> graphicBasicsPart2 = [
  // 11. IntervalMark — barra vertical
  ChartSpec(
    id: 'gr_b11',
    title: 'IntervalMark — barra vertical',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'genero': 'Deportes', 'ventas': 275},
          {'genero': 'Estrategia', 'ventas': 115},
          {'genero': 'Acción', 'ventas': 120},
          {'genero': 'Disparos', 'ventas': 350},
          {'genero': 'Otros', 'ventas': 150},
        ],
        variables: {
          'genero': Variable(accessor: (Map map) => map['genero'] as String),
          'ventas': Variable(
            accessor: (Map map) => map['ventas'] as num,
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

  // 12. IntervalMark — barra horizontal (coord transpuesta)
  ChartSpec(
    id: 'gr_b12',
    title: 'IntervalMark — barra horizontal (coord transpuesta)',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'pais': 'México', 'poblacion': 128},
          {'pais': 'Colombia', 'poblacion': 51},
          {'pais': 'Argentina', 'poblacion': 45},
          {'pais': 'Chile', 'poblacion': 19},
          {'pais': 'Perú', 'poblacion': 33},
        ],
        variables: {
          'pais': Variable(accessor: (Map map) => map['pais'] as String),
          'poblacion': Variable(
            accessor: (Map map) => map['poblacion'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          IntervalMark(color: ColorEncode(value: Defaults.primaryColor)),
        ],
        coord: RectCoord(transposed: true),
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 13. IntervalMark — barra agrupada (dodge)
  ChartSpec(
    id: 'gr_b13',
    title: 'IntervalMark — barra agrupada (dodge)',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'trimestre': 'T1', 'valor': 10, 'producto': 'A'},
          {'trimestre': 'T1', 'valor': 15, 'producto': 'B'},
          {'trimestre': 'T2', 'valor': 20, 'producto': 'A'},
          {'trimestre': 'T2', 'valor': 12, 'producto': 'B'},
          {'trimestre': 'T3', 'valor': 8, 'producto': 'A'},
          {'trimestre': 'T3', 'valor': 18, 'producto': 'B'},
        ],
        variables: {
          'trimestre': Variable(
            accessor: (Map map) => map['trimestre'] as String,
          ),
          'valor': Variable(
            accessor: (Map map) => map['valor'] as num,
            scale: LinearScale(min: 0),
          ),
          'producto': Variable(
            accessor: (Map map) => map['producto'] as String,
          ),
        },
        marks: [
          IntervalMark(
            position:
                Varset('trimestre') * Varset('valor') / Varset('producto'),
            color: ColorEncode(
              variable: 'producto',
              values: Defaults.colors10,
            ),
            modifiers: [DodgeModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 14. IntervalMark — barra apilada (stack)
  ChartSpec(
    id: 'gr_b14',
    title: 'IntervalMark — barra apilada (stack)',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'trimestre': 'T1', 'valor': 10, 'producto': 'A'},
          {'trimestre': 'T1', 'valor': 15, 'producto': 'B'},
          {'trimestre': 'T2', 'valor': 20, 'producto': 'A'},
          {'trimestre': 'T2', 'valor': 12, 'producto': 'B'},
          {'trimestre': 'T3', 'valor': 8, 'producto': 'A'},
          {'trimestre': 'T3', 'valor': 18, 'producto': 'B'},
        ],
        variables: {
          'trimestre': Variable(
            accessor: (Map map) => map['trimestre'] as String,
          ),
          'valor': Variable(
            accessor: (Map map) => map['valor'] as num,
            scale: LinearScale(min: 0),
          ),
          'producto': Variable(
            accessor: (Map map) => map['producto'] as String,
          ),
        },
        marks: [
          IntervalMark(
            position:
                Varset('trimestre') * Varset('valor') / Varset('producto'),
            color: ColorEncode(
              variable: 'producto',
              values: Defaults.colors10,
            ),
            modifiers: [StackModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 15. IntervalMark — ancho variable
  ChartSpec(
    id: 'gr_b15',
    title: 'IntervalMark — ancho variable',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'categoria': 'A', 'valor': 30, 'importancia': 8},
          {'categoria': 'B', 'valor': 45, 'importancia': 20},
          {'categoria': 'C', 'valor': 25, 'importancia': 12},
          {'categoria': 'D', 'valor': 60, 'importancia': 36},
          {'categoria': 'E', 'valor': 40, 'importancia': 16},
        ],
        variables: {
          'categoria': Variable(
            accessor: (Map map) => map['categoria'] as String,
          ),
          'valor': Variable(
            accessor: (Map map) => map['valor'] as num,
            scale: LinearScale(min: 0),
          ),
          'importancia': Variable(
            accessor: (Map map) => map['importancia'] as num,
          ),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(value: Defaults.primaryColor),
            size: SizeEncode(variable: 'importancia', values: [8, 36]),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 16. IntervalMark — valores negativos
  ChartSpec(
    id: 'gr_b16',
    title: 'IntervalMark — valores negativos',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'balance': 25},
          {'mes': 'Feb', 'balance': -10},
          {'mes': 'Mar', 'balance': 15},
          {'mes': 'Abr', 'balance': -20},
          {'mes': 'May', 'balance': 30},
          {'mes': 'Jun', 'balance': -5},
        ],
        variables: {
          'mes': Variable(accessor: (Map map) => map['mes'] as String),
          'balance': Variable(
            accessor: (Map map) => map['balance'] as num,
            scale: LinearScale(),
          ),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(
              encoder: (tuple) => (tuple['balance'] as num) < 0
                  ? Colors.redAccent
                  : Defaults.primaryColor,
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 17. IntervalMark + PolarCoord — circular (pie)
  ChartSpec(
    id: 'gr_b17',
    title: 'IntervalMark + PolarCoord — circular (pie)',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'genero': 'Deportes', 'ventas': 275},
          {'genero': 'Estrategia', 'ventas': 115},
          {'genero': 'Acción', 'ventas': 120},
          {'genero': 'Disparos', 'ventas': 350},
          {'genero': 'Otros', 'ventas': 150},
        ],
        variables: {
          'genero': Variable(accessor: (Map map) => map['genero'] as String),
          'ventas': Variable(accessor: (Map map) => map['ventas'] as num),
        },
        transforms: [Proportion(variable: 'ventas', as: 'porcentaje')],
        marks: [
          IntervalMark(
            position: Varset('porcentaje') / Varset('genero'),
            color: ColorEncode(
              variable: 'genero',
              values: Defaults.colors10,
            ),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(transposed: true, dimCount: 1),
      ),
    ),
  ),

  // 18. IntervalMark + PolarCoord — dona
  ChartSpec(
    id: 'gr_b18',
    title: 'IntervalMark + PolarCoord — dona',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'genero': 'Deportes', 'ventas': 275},
          {'genero': 'Estrategia', 'ventas': 115},
          {'genero': 'Acción', 'ventas': 120},
          {'genero': 'Disparos', 'ventas': 350},
          {'genero': 'Otros', 'ventas': 150},
        ],
        variables: {
          'genero': Variable(accessor: (Map map) => map['genero'] as String),
          'ventas': Variable(accessor: (Map map) => map['ventas'] as num),
        },
        transforms: [Proportion(variable: 'ventas', as: 'porcentaje')],
        marks: [
          IntervalMark(
            position: Varset('porcentaje') / Varset('genero'),
            color: ColorEncode(
              variable: 'genero',
              values: Defaults.colors10,
            ),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(transposed: true, dimCount: 1, startRadius: 0.4),
      ),
    ),
  ),

  // 19. IntervalMark + PolarCoord — rose chart
  ChartSpec(
    id: 'gr_b19',
    title: 'IntervalMark + PolarCoord — rose chart',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'nombre': 'Lunes', 'valor': 30},
          {'nombre': 'Martes', 'valor': 45},
          {'nombre': 'Miércoles', 'valor': 38},
          {'nombre': 'Jueves', 'valor': 52},
          {'nombre': 'Viernes', 'valor': 60},
          {'nombre': 'Sábado', 'valor': 25},
          {'nombre': 'Domingo', 'valor': 15},
        ],
        variables: {
          'nombre': Variable(accessor: (Map map) => map['nombre'] as String),
          'valor': Variable(accessor: (Map map) => map['valor'] as num),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(
              variable: 'nombre',
              values: Defaults.colors10,
            ),
          ),
        ],
        coord: PolarCoord(startRadius: 0.15),
      ),
    ),
  ),

  // 20. LineMark + PolarCoord — radar
  ChartSpec(
    id: 'gr_b20',
    title: 'LineMark + PolarCoord — radar',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'metrica': 'Velocidad', 'valor': 80, 'modelo': 'Modelo A'},
          {'metrica': 'Potencia', 'valor': 65, 'modelo': 'Modelo A'},
          {'metrica': 'Manejo', 'valor': 70, 'modelo': 'Modelo A'},
          {'metrica': 'Frenado', 'valor': 85, 'modelo': 'Modelo A'},
          {'metrica': 'Confort', 'valor': 60, 'modelo': 'Modelo A'},
          {'metrica': 'Velocidad', 'valor': 55, 'modelo': 'Modelo B'},
          {'metrica': 'Potencia', 'valor': 90, 'modelo': 'Modelo B'},
          {'metrica': 'Manejo', 'valor': 50, 'modelo': 'Modelo B'},
          {'metrica': 'Frenado', 'valor': 60, 'modelo': 'Modelo B'},
          {'metrica': 'Confort', 'valor': 85, 'modelo': 'Modelo B'},
        ],
        variables: {
          'metrica': Variable(accessor: (Map map) => map['metrica'] as String),
          'valor': Variable(
            accessor: (Map map) => map['valor'] as num,
            scale: LinearScale(min: 0, max: 100),
          ),
          'modelo': Variable(accessor: (Map map) => map['modelo'] as String),
        },
        marks: [
          LineMark(
            position: Varset('metrica') * Varset('valor') / Varset('modelo'),
            shape: ShapeEncode(value: BasicLineShape(loop: true)),
            color: ColorEncode(variable: 'modelo', values: Defaults.colors10),
          ),
        ],
        coord: PolarCoord(),
        axes: [Defaults.circularAxis, Defaults.radialAxis],
      ),
    ),
  ),
];
