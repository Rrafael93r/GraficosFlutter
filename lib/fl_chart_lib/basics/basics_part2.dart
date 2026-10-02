import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/chart_spec.dart';

// ---------------------------------------------------------------------------
// Shared helpers (kept file-local on purpose; each basics_partN.dart file is
// self-contained so these are small, private, and duplicated per file).
// ---------------------------------------------------------------------------

class _LegendItem {
  final String label;
  final Color color;

  const _LegendItem(this.label, this.color);
}

Widget _legendRow(List<_LegendItem> items) {
  return Wrap(
    alignment: WrapAlignment.center,
    spacing: 14,
    runSpacing: 4,
    children: items
        .map(
          (item) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(item.label, style: const TextStyle(fontSize: 11)),
            ],
          ),
        )
        .toList(),
  );
}

Widget _chartCard({required Widget chart, Widget? legend}) {
  return SizedBox(
    height: 320,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Expanded(child: chart),
          if (legend != null) ...[
            const SizedBox(height: 8),
            legend,
          ],
        ],
      ),
    ),
  );
}

AxisTitles _hiddenAxis() =>
    const AxisTitles(sideTitles: SideTitles(showTitles: false));

AxisTitles _bottomAxis(List<String> labels, {double reservedSize = 28}) {
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: reservedSize,
      interval: 1,
      getTitlesWidget: (value, meta) {
        final index = value.round();
        if (index < 0 || index >= labels.length) {
          return const SizedBox.shrink();
        }
        return SideTitleWidget(
          meta: meta,
          child: Text(labels[index], style: const TextStyle(fontSize: 10)),
        );
      },
    ),
  );
}

AxisTitles _leftAxis({double reservedSize = 36}) {
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: reservedSize,
      getTitlesWidget: (value, meta) => SideTitleWidget(
        meta: meta,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 10),
        ),
      ),
    ),
  );
}

FlTitlesData _basicTitles(List<String> bottomLabels) => FlTitlesData(
  topTitles: _hiddenAxis(),
  rightTitles: _hiddenAxis(),
  leftTitles: _leftAxis(),
  bottomTitles: _bottomAxis(bottomLabels),
);

// ---------------------------------------------------------------------------
// 11. Barras — horizontal (rotado)
// ---------------------------------------------------------------------------

Widget _chart11(BuildContext context) {
  const labels = ['Lima', 'Bogotá', 'Santiago', 'Quito', 'Montevideo'];
  const values = [9.7, 7.9, 6.9, 2.8, 1.7];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 11,
        rotationQuarterTurns: 1,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: Colors.indigo,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 12. Barras — agrupadas (multi-serie)
// ---------------------------------------------------------------------------

Widget _chart12(BuildContext context) {
  const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
  const productoA = [18.0, 22.0, 20.0, 26.0];
  const productoB = [14.0, 16.0, 19.0, 21.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 30,
        barGroups: [
          for (var i = 0; i < labels.length; i++)
            BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: productoA[i],
                  color: Colors.blue,
                  width: 14,
                ),
                BarChartRodData(
                  toY: productoB[i],
                  color: Colors.amber,
                  width: 14,
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Producto A', Colors.blue),
      _LegendItem('Producto B', Colors.amber),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 13. Barras — apiladas
// ---------------------------------------------------------------------------

Widget _chart13(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr'];
  const vivienda = [8.0, 8.0, 9.0, 9.0];
  const comida = [5.0, 6.0, 5.0, 7.0];
  const transporte = [3.0, 2.0, 4.0, 3.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 22,
        barGroups: [
          for (var i = 0; i < labels.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: vivienda[i] + comida[i] + transporte[i],
                  width: 26,
                  rodStackItems: [
                    BarChartRodStackItem(0, vivienda[i], Colors.indigo),
                    BarChartRodStackItem(
                      vivienda[i],
                      vivienda[i] + comida[i],
                      Colors.teal,
                    ),
                    BarChartRodStackItem(
                      vivienda[i] + comida[i],
                      vivienda[i] + comida[i] + transporte[i],
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Vivienda', Colors.indigo),
      _LegendItem('Comida', Colors.teal),
      _LegendItem('Transporte', Colors.orange),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 14. Barras — bordes redondeados
// ---------------------------------------------------------------------------

Widget _chart14(BuildContext context) {
  const labels = ['Mate', 'Física', 'Química', 'Historia', 'Arte'];
  const values = [8.5, 7.2, 9.0, 6.8, 9.4];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 10,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: Colors.pinkAccent,
                  width: 22,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 15. Barras — valores negativos
// ---------------------------------------------------------------------------

Widget _chart15(BuildContext context) {
  const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  const values = [12.0, -8.0, 5.0, -15.0, 9.0, -3.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: -20,
        maxY: 20,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: values[i] >= 0 ? Colors.green : Colors.redAccent,
                  width: 20,
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
    legend: _legendRow(const [
      _LegendItem('Saldo positivo', Colors.green),
      _LegendItem('Saldo negativo', Colors.redAccent),
    ]),
  );
}

// ---------------------------------------------------------------------------
// 16. Barras — degradado de color
// ---------------------------------------------------------------------------

Widget _chart16(BuildContext context) {
  const labels = ['Norte', 'Sur', 'Este', 'Oeste', 'Centro'];
  const values = [42.0, 35.0, 28.0, 31.0, 50.0];

  return _chartCard(
    chart: BarChart(
      BarChartData(
        minY: 0,
        maxY: 58,
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 24,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.lightBlue, Colors.deepPurple],
                  ),
                ),
              ],
            ),
        ],
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: _basicTitles(labels),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 17. Circular — porcentajes simples
// ---------------------------------------------------------------------------

Widget _chart17(BuildContext context) {
  const data = [
    _LegendItem('Empresa A', Colors.indigo),
    _LegendItem('Empresa B', Colors.teal),
    _LegendItem('Empresa C', Colors.orange),
    _LegendItem('Empresa D', Colors.grey),
  ];
  const values = [40.0, 28.0, 20.0, 12.0];

  return _chartCard(
    chart: PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 0,
        sections: [
          for (var i = 0; i < values.length; i++)
            PieChartSectionData(
              value: values[i],
              color: data[i].color,
              title: '${values[i].toInt()}%',
              radius: 90,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    ),
    legend: _legendRow(data),
  );
}

// ---------------------------------------------------------------------------
// 18. Circular — sector explotado
// ---------------------------------------------------------------------------

Widget _chart18(BuildContext context) {
  const data = [
    _LegendItem('Candidato A', Colors.redAccent),
    _LegendItem('Candidato B', Colors.blueAccent),
    _LegendItem('Candidato C', Colors.green),
  ];
  const values = [52.0, 30.0, 18.0];
  const winnerIndex = 0;

  return _chartCard(
    chart: PieChart(
      PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 0,
        sections: [
          for (var i = 0; i < values.length; i++)
            PieChartSectionData(
              value: values[i],
              color: data[i].color,
              title: '${values[i].toInt()}%',
              radius: i == winnerIndex ? 105 : 85,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    ),
    legend: _legendRow(data),
  );
}

// ---------------------------------------------------------------------------
// 19. Dona (donut)
// ---------------------------------------------------------------------------

Widget _chart19(BuildContext context) {
  const data = [
    _LegendItem('Orgánico', Colors.green),
    _LegendItem('Redes sociales', Colors.blue),
    _LegendItem('Publicidad', Colors.orange),
    _LegendItem('Referidos', Colors.purple),
  ];
  const values = [35.0, 25.0, 22.0, 18.0];

  return _chartCard(
    chart: PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        sections: [
          for (var i = 0; i < values.length; i++)
            PieChartSectionData(
              value: values[i],
              color: data[i].color,
              title: '${values[i].toInt()}%',
              radius: 55,
              titleStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    ),
    legend: _legendRow(data),
  );
}

// ---------------------------------------------------------------------------
// 20. Dona — con texto central (KPI)
// ---------------------------------------------------------------------------

Widget _chart20(BuildContext context) {
  const data = [
    _LegendItem('Electrónica', Colors.indigo),
    _LegendItem('Ropa', Colors.pink),
    _LegendItem('Hogar', Colors.teal),
  ];
  const values = [520.0, 310.0, 210.0];
  final totalValue = values.fold<double>(0, (sum, v) => sum + v);

  return _chartCard(
    chart: Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 60,
            sections: [
              for (var i = 0; i < values.length; i++)
                PieChartSectionData(
                  value: values[i],
                  color: data[i].color,
                  showTitle: false,
                  radius: 45,
                ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${totalValue.toInt()}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Total ventas', style: TextStyle(fontSize: 11)),
          ],
        ),
      ],
    ),
    legend: _legendRow(data),
  );
}

// ---------------------------------------------------------------------------
// Catalog export
// ---------------------------------------------------------------------------

final List<ChartSpec> flBasicsPart2 = [
  ChartSpec(
    id: 'fl_b11',
    title: 'Barras — horizontal (rotado)',
    category: ChartCategory.basic,
    builder: _chart11,
  ),
  ChartSpec(
    id: 'fl_b12',
    title: 'Barras — agrupadas (multi-serie)',
    category: ChartCategory.basic,
    builder: _chart12,
  ),
  ChartSpec(
    id: 'fl_b13',
    title: 'Barras — apiladas',
    category: ChartCategory.basic,
    builder: _chart13,
  ),
  ChartSpec(
    id: 'fl_b14',
    title: 'Barras — bordes redondeados',
    category: ChartCategory.basic,
    builder: _chart14,
  ),
  ChartSpec(
    id: 'fl_b15',
    title: 'Barras — valores negativos',
    category: ChartCategory.basic,
    builder: _chart15,
  ),
  ChartSpec(
    id: 'fl_b16',
    title: 'Barras — degradado de color',
    category: ChartCategory.basic,
    builder: _chart16,
  ),
  ChartSpec(
    id: 'fl_b17',
    title: 'Circular — porcentajes simples',
    category: ChartCategory.basic,
    builder: _chart17,
  ),
  ChartSpec(
    id: 'fl_b18',
    title: 'Circular — sector explotado',
    category: ChartCategory.basic,
    builder: _chart18,
  ),
  ChartSpec(
    id: 'fl_b19',
    title: 'Dona (donut)',
    category: ChartCategory.basic,
    builder: _chart19,
  ),
  ChartSpec(
    id: 'fl_b20',
    title: 'Dona — con texto central (KPI)',
    category: ChartCategory.basic,
    builder: _chart20,
  ),
];
