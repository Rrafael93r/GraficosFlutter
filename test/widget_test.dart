import 'package:flutter_test/flutter_test.dart';

import 'package:graficos_flutter/main.dart';

void main() {
  testWidgets('La app muestra las 3 librerías de gráficos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GraficosApp());

    expect(find.text('FL Chart'), findsOneWidget);
    expect(find.text('Syncfusion Flutter Charts'), findsOneWidget);
    expect(find.text('Graphic'), findsOneWidget);
  });
}
