import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../core/chart_spec.dart';

/// Graphic basics — part 4 (items 31-40).
///
/// Covers distributions, stream graphs, overlapping areas, jitter and
/// combined bar + line charts.
final List<ChartSpec> graphicBasicsPart4 = [
  // 31. IntervalMark — distribución por edad
  ChartSpec(
    id: 'gr_b31',
    title: 'IntervalMark — distribución por edad',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'rango': '0-10', 'personas': 12},
          {'rango': '11-20', 'personas': 25},
          {'rango': '21-30', 'personas': 40},
          {'rango': '31-40', 'personas': 35},
          {'rango': '41-50', 'personas': 28},
          {'rango': '51-60', 'personas': 18},
          {'rango': '61+', 'personas': 10},
        ],
        variables: {
          'rango': Variable(accessor: (Map map) => map['rango'] as String),
          'personas': Variable(
            accessor: (Map map) => map['personas'] as num,
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

  // 32. AreaMark — stream graph
  ChartSpec(
    id: 'gr_b32',
    title: 'AreaMark — stream graph',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'valor': 12, 'tipo': 'Música'},
          {'mes': 'Feb', 'valor': 18, 'tipo': 'Música'},
          {'mes': 'Mar', 'valor': 15, 'tipo': 'Música'},
          {'mes': 'Abr', 'valor': 22, 'tipo': 'Música'},
          {'mes': 'Ene', 'valor': 8, 'tipo': 'Deportes'},
          {'mes': 'Feb', 'valor': 14, 'tipo': 'Deportes'},
          {'mes': 'Mar', 'valor': 20, 'tipo': 'Deportes'},
          {'mes': 'Abr', 'valor': 16, 'tipo': 'Deportes'},
          {'mes': 'Ene', 'valor': 20, 'tipo': 'Noticias'},
          {'mes': 'Feb', 'valor': 16, 'tipo': 'Noticias'},
          {'mes': 'Mar', 'valor': 10, 'tipo': 'Noticias'},
          {'mes': 'Abr', 'valor': 12, 'tipo': 'Noticias'},
        ],
        variables: {
          'mes': Variable(
            accessor: (Map map) => map['mes'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'valor': Variable(accessor: (Map map) => map['valor'] as num),
          'tipo': Variable(accessor: (Map map) => map['tipo'] as String),
        },
        marks: [
          AreaMark(
            position: Varset('mes') * Varset('valor') / Varset('tipo'),
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(variable: 'tipo', values: Defaults.colors10),
            modifiers: [StackModifier(), SymmetricModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis],
      ),
    ),
  ),

  // 33. LineMark — tendencia bursátil
  ChartSpec(
    id: 'gr_b33',
    title: 'LineMark — tendencia bursátil',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'dia': 'D1', 'precio': 102.5},
          {'dia': 'D2', 'precio': 104.1},
          {'dia': 'D3', 'precio': 101.8},
          {'dia': 'D4', 'precio': 106.4},
          {'dia': 'D5', 'precio': 110.2},
          {'dia': 'D6', 'precio': 108.7},
          {'dia': 'D7', 'precio': 113.5},
        ],
        variables: {
          'dia': Variable(
            accessor: (Map map) => map['dia'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'precio': Variable(
            accessor: (Map map) => map['precio'] as num,
            scale: LinearScale(),
          ),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            color: ColorEncode(value: Colors.green),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 34. IntervalMark — presupuesto por categoría
  ChartSpec(
    id: 'gr_b34',
    title: 'IntervalMark — presupuesto por categoría',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'categoria': 'Marketing', 'monto': 4500},
          {'categoria': 'I+D', 'monto': 7200},
          {'categoria': 'Operaciones', 'monto': 5600},
          {'categoria': 'RRHH', 'monto': 3000},
          {'categoria': 'TI', 'monto': 6100},
        ],
        variables: {
          'categoria': Variable(
            accessor: (Map map) => map['categoria'] as String,
          ),
          'monto': Variable(
            accessor: (Map map) => map['monto'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          IntervalMark(
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

  // 35. PointMark — nube de puntos categorizada
  ChartSpec(
    id: 'gr_b35',
    title: 'PointMark — nube de puntos categorizada',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'grupo': 'A', 'valor': 10, 'subgrupo': 'X'},
          {'grupo': 'A', 'valor': 12, 'subgrupo': 'Y'},
          {'grupo': 'A', 'valor': 9, 'subgrupo': 'X'},
          {'grupo': 'A', 'valor': 14, 'subgrupo': 'Y'},
          {'grupo': 'B', 'valor': 18, 'subgrupo': 'X'},
          {'grupo': 'B', 'valor': 20, 'subgrupo': 'Y'},
          {'grupo': 'B', 'valor': 16, 'subgrupo': 'X'},
          {'grupo': 'B', 'valor': 22, 'subgrupo': 'Y'},
          {'grupo': 'C', 'valor': 7, 'subgrupo': 'X'},
          {'grupo': 'C', 'valor': 11, 'subgrupo': 'Y'},
          {'grupo': 'C', 'valor': 6, 'subgrupo': 'X'},
          {'grupo': 'C', 'valor': 13, 'subgrupo': 'Y'},
        ],
        variables: {
          'grupo': Variable(accessor: (Map map) => map['grupo'] as String),
          'valor': Variable(
            accessor: (Map map) => map['valor'] as num,
            scale: LinearScale(min: 0),
          ),
          'subgrupo': Variable(
            accessor: (Map map) => map['subgrupo'] as String,
          ),
        },
        marks: [
          PointMark(
            color: ColorEncode(
              variable: 'subgrupo',
              values: Defaults.colors10,
            ),
            modifiers: [JitterModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 36. LineMark — comparación 3 series
  ChartSpec(
    id: 'gr_b36',
    title: 'LineMark — comparación 3 series',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'temp': 18, 'ciudad': 'Bogotá'},
          {'mes': 'Feb', 'temp': 19, 'ciudad': 'Bogotá'},
          {'mes': 'Mar', 'temp': 17, 'ciudad': 'Bogotá'},
          {'mes': 'Abr', 'temp': 18, 'ciudad': 'Bogotá'},
          {'mes': 'Ene', 'temp': 28, 'ciudad': 'Cali'},
          {'mes': 'Feb', 'temp': 29, 'ciudad': 'Cali'},
          {'mes': 'Mar', 'temp': 30, 'ciudad': 'Cali'},
          {'mes': 'Abr', 'temp': 29, 'ciudad': 'Cali'},
          {'mes': 'Ene', 'temp': 24, 'ciudad': 'Medellín'},
          {'mes': 'Feb', 'temp': 25, 'ciudad': 'Medellín'},
          {'mes': 'Mar', 'temp': 26, 'ciudad': 'Medellín'},
          {'mes': 'Abr', 'temp': 24, 'ciudad': 'Medellín'},
        ],
        variables: {
          'mes': Variable(
            accessor: (Map map) => map['mes'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'temp': Variable(
            accessor: (Map map) => map['temp'] as num,
            scale: LinearScale(),
          ),
          'ciudad': Variable(accessor: (Map map) => map['ciudad'] as String),
        },
        marks: [
          LineMark(
            position: Varset('mes') * Varset('temp') / Varset('ciudad'),
            color: ColorEncode(variable: 'ciudad', values: Defaults.colors10),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 37. IntervalMark — top productos
  ChartSpec(
    id: 'gr_b37',
    title: 'IntervalMark — top productos',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'producto': 'Laptop', 'ingresos': 8200},
          {'producto': 'Monitor', 'ingresos': 3400},
          {'producto': 'Teclado', 'ingresos': 1200},
          {'producto': 'Mouse', 'ingresos': 900},
          {'producto': 'Audífonos', 'ingresos': 2100},
        ],
        variables: {
          'producto': Variable(
            accessor: (Map map) => map['producto'] as String,
          ),
          'ingresos': Variable(
            accessor: (Map map) => map['ingresos'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        transforms: [
          Sort(
            compare: (a, b) =>
                (b['ingresos'] as num).compareTo(a['ingresos'] as num),
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

  // 38. AreaMark — dos áreas superpuestas
  ChartSpec(
    id: 'gr_b38',
    title: 'AreaMark — dos áreas superpuestas',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'actual': 30, 'anterior': 22},
          {'mes': 'Feb', 'actual': 40, 'anterior': 28},
          {'mes': 'Mar', 'actual': 35, 'anterior': 32},
          {'mes': 'Abr', 'actual': 50, 'anterior': 30},
          {'mes': 'May', 'actual': 45, 'anterior': 38},
          {'mes': 'Jun', 'actual': 60, 'anterior': 42},
        ],
        variables: {
          'mes': Variable(
            accessor: (Map map) => map['mes'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'actual': Variable(
            accessor: (Map map) => map['actual'] as num,
            scale: LinearScale(min: 0),
          ),
          'anterior': Variable(
            accessor: (Map map) => map['anterior'] as num,
          ),
        },
        marks: [
          AreaMark(
            position: Varset('mes') * Varset('anterior'),
            color: ColorEncode(value: Colors.orangeAccent.withAlpha(90)),
          ),
          AreaMark(
            position: Varset('mes') * Varset('actual'),
            color: ColorEncode(value: Defaults.primaryColor.withAlpha(90)),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 39. LineMark — interpolación spline
  ChartSpec(
    id: 'gr_b39',
    title: 'LineMark — interpolación spline',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'t': 'P0', 'senal': 2},
          {'t': 'P1', 'senal': 9},
          {'t': 'P2', 'senal': 4},
          {'t': 'P3', 'senal': 12},
          {'t': 'P4', 'senal': 6},
          {'t': 'P5', 'senal': 15},
          {'t': 'P6', 'senal': 8},
        ],
        variables: {
          't': Variable(
            accessor: (Map map) => map['t'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'senal': Variable(
            accessor: (Map map) => map['senal'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            color: ColorEncode(value: Colors.purple),
            size: SizeEncode(value: 2.5),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 40. IntervalMark — combinado barra + línea
  ChartSpec(
    id: 'gr_b40',
    title: 'IntervalMark — combinado barra + línea',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'valor': 30, 'meta': 35},
          {'mes': 'Feb', 'valor': 38, 'meta': 35},
          {'mes': 'Mar', 'valor': 32, 'meta': 35},
          {'mes': 'Abr', 'valor': 42, 'meta': 35},
          {'mes': 'May', 'valor': 48, 'meta': 40},
          {'mes': 'Jun', 'valor': 36, 'meta': 40},
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
          'meta': Variable(accessor: (Map map) => map['meta'] as num),
        },
        marks: [
          IntervalMark(
            position: Varset('mes') * Varset('valor'),
            color: ColorEncode(value: Defaults.primaryColor),
          ),
          LineMark(
            position: Varset('mes') * Varset('meta'),
            color: ColorEncode(value: Colors.redAccent),
            size: SizeEncode(value: 2.5),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),
];
