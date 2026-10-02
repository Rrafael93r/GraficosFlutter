import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../core/chart_spec.dart';

/// Graphic basics — part 1 (items 1-10).
///
/// Covers PointMark, LineMark and AreaMark fundamentals.
final List<ChartSpec> graphicBasicsPart1 = [
  // 1. PointMark — scatter simple
  ChartSpec(
    id: 'gr_b01',
    title: 'PointMark — scatter simple',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'x': 2, 'y': 5},
          {'x': 3, 'y': 7},
          {'x': 5, 'y': 4},
          {'x': 6, 'y': 9},
          {'x': 7, 'y': 6},
          {'x': 9, 'y': 11},
          {'x': 10, 'y': 8},
          {'x': 12, 'y': 13},
          {'x': 13, 'y': 10},
          {'x': 15, 'y': 15},
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
        },
        marks: [PointMark()],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 2. PointMark — scatter coloreado por categoría
  ChartSpec(
    id: 'gr_b02',
    title: 'PointMark — scatter coloreado por categoría',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'x': 1, 'y': 3, 'categoria': 'A'},
          {'x': 2, 'y': 5, 'categoria': 'A'},
          {'x': 3, 'y': 4, 'categoria': 'A'},
          {'x': 4, 'y': 9, 'categoria': 'B'},
          {'x': 5, 'y': 8, 'categoria': 'B'},
          {'x': 6, 'y': 10, 'categoria': 'B'},
          {'x': 7, 'y': 2, 'categoria': 'C'},
          {'x': 8, 'y': 3, 'categoria': 'C'},
          {'x': 9, 'y': 1, 'categoria': 'C'},
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
          'categoria': Variable(
            accessor: (Map map) => map['categoria'] as String,
          ),
        },
        marks: [
          PointMark(
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

  // 3. PointMark — bubble (canal de tamaño)
  ChartSpec(
    id: 'gr_b03',
    title: 'PointMark — bubble (canal de tamaño)',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'ingreso': 10, 'satisfaccion': 6, 'habitantes': 120},
          {'ingreso': 18, 'satisfaccion': 7, 'habitantes': 300},
          {'ingreso': 25, 'satisfaccion': 5, 'habitantes': 450},
          {'ingreso': 32, 'satisfaccion': 8, 'habitantes': 900},
          {'ingreso': 40, 'satisfaccion': 6, 'habitantes': 220},
          {'ingreso': 48, 'satisfaccion': 9, 'habitantes': 1200},
          {'ingreso': 55, 'satisfaccion': 7, 'habitantes': 600},
        ],
        variables: {
          'ingreso': Variable(
            accessor: (Map map) => map['ingreso'] as num,
            scale: LinearScale(min: 0, marginMax: 0.15),
          ),
          'satisfaccion': Variable(
            accessor: (Map map) => map['satisfaccion'] as num,
            scale: LinearScale(min: 0, max: 10),
          ),
          'habitantes': Variable(
            accessor: (Map map) => map['habitantes'] as num,
          ),
        },
        marks: [
          PointMark(
            size: SizeEncode(variable: 'habitantes', values: [6, 28]),
            color: ColorEncode(value: Defaults.primaryColor.withAlpha(160)),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 4. LineMark — ventas
  ChartSpec(
    id: 'gr_b04',
    title: 'LineMark — ventas',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'ventas': 120},
          {'mes': 'Feb', 'ventas': 150},
          {'mes': 'Mar', 'ventas': 135},
          {'mes': 'Abr', 'ventas': 170},
          {'mes': 'May', 'ventas': 190},
          {'mes': 'Jun', 'ventas': 210},
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

  // 5. LineMark — curva suavizada
  ChartSpec(
    id: 'gr_b05',
    title: 'LineMark — curva suavizada',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'dia': 'Lun', 'visitas': 80},
          {'dia': 'Mar', 'visitas': 95},
          {'dia': 'Mie', 'visitas': 70},
          {'dia': 'Jue', 'visitas': 110},
          {'dia': 'Vie', 'visitas': 130},
          {'dia': 'Sab', 'visitas': 90},
          {'dia': 'Dom', 'visitas': 60},
        ],
        variables: {
          'dia': Variable(
            accessor: (Map map) => map['dia'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'visitas': Variable(
            accessor: (Map map) => map['visitas'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 2.5),
            color: ColorEncode(value: Defaults.primaryColor),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 6. LineMark — multi-serie comparativo
  ChartSpec(
    id: 'gr_b06',
    title: 'LineMark — multi-serie comparativo',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'valor': 30, 'region': 'Norte'},
          {'mes': 'Feb', 'valor': 45, 'region': 'Norte'},
          {'mes': 'Mar', 'valor': 40, 'region': 'Norte'},
          {'mes': 'Abr', 'valor': 55, 'region': 'Norte'},
          {'mes': 'Ene', 'valor': 20, 'region': 'Sur'},
          {'mes': 'Feb', 'valor': 25, 'region': 'Sur'},
          {'mes': 'Mar', 'valor': 35, 'region': 'Sur'},
          {'mes': 'Abr', 'valor': 30, 'region': 'Sur'},
          {'mes': 'Ene', 'valor': 10, 'region': 'Centro'},
          {'mes': 'Feb', 'valor': 18, 'region': 'Centro'},
          {'mes': 'Mar', 'valor': 22, 'region': 'Centro'},
          {'mes': 'Abr', 'valor': 28, 'region': 'Centro'},
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
          'region': Variable(
            accessor: (Map map) => map['region'] as String,
          ),
        },
        marks: [
          LineMark(
            position: Varset('mes') * Varset('valor') / Varset('region'),
            color: ColorEncode(variable: 'region', values: Defaults.colors10),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 7. LineMark — step
  ChartSpec(
    id: 'gr_b07',
    title: 'LineMark — step',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'dia': 'D1', 'inventario': 100},
          {'dia': 'D2', 'inventario': 100},
          {'dia': 'D3', 'inventario': 70},
          {'dia': 'D4', 'inventario': 70},
          {'dia': 'D5', 'inventario': 120},
          {'dia': 'D6', 'inventario': 120},
          {'dia': 'D7', 'inventario': 90},
        ],
        variables: {
          'dia': Variable(
            accessor: (Map map) => map['dia'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'inventario': Variable(
            accessor: (Map map) => map['inventario'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(stepped: true)),
            color: ColorEncode(value: Defaults.primaryColor),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 8. AreaMark — simple
  ChartSpec(
    id: 'gr_b08',
    title: 'AreaMark — simple',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'dia': 'Lun', 'visitas': 50},
          {'dia': 'Mar', 'visitas': 65},
          {'dia': 'Mie', 'visitas': 60},
          {'dia': 'Jue', 'visitas': 80},
          {'dia': 'Vie', 'visitas': 95},
          {'dia': 'Sab', 'visitas': 70},
          {'dia': 'Dom', 'visitas': 55},
        ],
        variables: {
          'dia': Variable(
            accessor: (Map map) => map['dia'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'visitas': Variable(
            accessor: (Map map) => map['visitas'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          AreaMark(
            color: ColorEncode(value: Defaults.primaryColor.withAlpha(80)),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 9. AreaMark — degradado
  ChartSpec(
    id: 'gr_b09',
    title: 'AreaMark — degradado',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'ingresos': 40},
          {'mes': 'Feb', 'ingresos': 55},
          {'mes': 'Mar', 'ingresos': 50},
          {'mes': 'Abr', 'ingresos': 70},
          {'mes': 'May', 'ingresos': 90},
          {'mes': 'Jun', 'ingresos': 85},
        ],
        variables: {
          'mes': Variable(
            accessor: (Map map) => map['mes'] as String,
            scale: OrdinalScale(inflate: true),
          ),
          'ingresos': Variable(
            accessor: (Map map) => map['ingresos'] as num,
            scale: LinearScale(min: 0),
          ),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            gradient: GradientEncode(
              value: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Defaults.primaryColor.withAlpha(200),
                  Defaults.primaryColor.withAlpha(10),
                ],
              ),
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),

  // 10. AreaMark — apilada (position stack)
  ChartSpec(
    id: 'gr_b10',
    title: 'AreaMark — apilada (position stack)',
    category: ChartCategory.basic,
    builder: (context) => SizedBox(
      height: 320,
      child: Chart(
        data: const [
          {'mes': 'Ene', 'valor': 20, 'fuente': 'Solar'},
          {'mes': 'Feb', 'valor': 25, 'fuente': 'Solar'},
          {'mes': 'Mar', 'valor': 30, 'fuente': 'Solar'},
          {'mes': 'Abr', 'valor': 35, 'fuente': 'Solar'},
          {'mes': 'Ene', 'valor': 15, 'fuente': 'Eólica'},
          {'mes': 'Feb', 'valor': 18, 'fuente': 'Eólica'},
          {'mes': 'Mar', 'valor': 22, 'fuente': 'Eólica'},
          {'mes': 'Abr', 'valor': 20, 'fuente': 'Eólica'},
          {'mes': 'Ene', 'valor': 40, 'fuente': 'Gas'},
          {'mes': 'Feb', 'valor': 38, 'fuente': 'Gas'},
          {'mes': 'Mar', 'valor': 35, 'fuente': 'Gas'},
          {'mes': 'Abr', 'valor': 32, 'fuente': 'Gas'},
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
          'fuente': Variable(
            accessor: (Map map) => map['fuente'] as String,
          ),
        },
        marks: [
          AreaMark(
            position: Varset('mes') * Varset('valor') / Varset('fuente'),
            color: ColorEncode(variable: 'fuente', values: Defaults.colors10),
            modifiers: [StackModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    ),
  ),
];
