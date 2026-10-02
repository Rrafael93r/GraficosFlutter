import 'package:flutter/material.dart';

import '../core/chart_spec.dart';
import 'syncfusion_catalog.dart';

class SyncfusionHomeScreen extends StatelessWidget {
  const SyncfusionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final basics = syncfusionCatalog
        .where((c) => c.category == ChartCategory.basic)
        .toList();
    final advanced = syncfusionCatalog
        .where((c) => c.category == ChartCategory.advanced)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Syncfusion Flutter Charts')),
      body: ListView(
        children: [
          _SectionHeader('Básicos (${basics.length})'),
          ...basics.map((c) => _ChartCard(spec: c)),
          _SectionHeader('Avanzados (${advanced.length})'),
          ...advanced.map((c) => _ChartCard(spec: c)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final ChartSpec spec;

  const _ChartCard({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spec.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Builder(builder: spec.builder),
          ],
        ),
      ),
    );
  }
}
