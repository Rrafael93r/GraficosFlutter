import 'package:flutter/material.dart';

import 'chart_spec.dart';

class ChartDetailScreen extends StatelessWidget {
  final ChartSpec spec;

  const ChartDetailScreen({super.key, required this.spec});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(spec.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: spec.builder(context),
      ),
    );
  }
}
