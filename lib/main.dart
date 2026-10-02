import 'package:flutter/material.dart';

import 'community_charts_lib/community_home.dart';
import 'fl_chart_lib/fl_chart_home.dart';
import 'graphic_lib/graphic_home.dart';
import 'syncfusion_lib/syncfusion_home.dart';

void main() {
  runApp(const GraficosApp());
}

class GraficosApp extends StatelessWidget {
  const GraficosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gráficos Flutter',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LibraryHomeScreen(),
    );
  }
}

class LibraryHomeScreen extends StatelessWidget {
  const LibraryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taller de Gráficos en Flutter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LibraryCard(
            title: 'FL Chart',
            subtitle: '65 gráficos (40 básicos + 25 avanzados)',
            enabled: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FlChartHomeScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            title: 'Syncfusion Flutter Charts',
            subtitle: '65 gráficos (40 básicos + 25 avanzados)',
            enabled: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SyncfusionHomeScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            title: 'Graphic',
            subtitle: '65 gráficos (40 básicos + 25 avanzados)',
            enabled: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GraphicHomeScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            title: 'Community Charts for Flutter',
            subtitle: '65 gráficos (40 básicos + 25 avanzados)',
            enabled: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CommunityChartsHomeScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  const _LibraryCard({
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        enabled: enabled,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: enabled ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }
}
