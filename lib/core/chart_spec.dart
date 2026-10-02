import 'package:flutter/material.dart';

enum ChartCategory { basic, advanced }

class ChartSpec {
  final String id;
  final String title;
  final ChartCategory category;
  final WidgetBuilder builder;

  const ChartSpec({
    required this.id,
    required this.title,
    required this.category,
    required this.builder,
  });
}
