import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

final class BillSplitterPage extends StatefulWidget {
  const BillSplitterPage({super.key});

  @override
  State<BillSplitterPage> createState() => _BillSplitterPageState();
}

final class _BillSplitterPageState extends State<BillSplitterPage> {
  final _billCtrl = TextEditingController();
  final _namesCtrl = TextEditingController();

  @override
  void dispose() {
    _billCtrl.dispose();
    _namesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _parseAmount(_billCtrl.text);
    final names = _parseNames(_namesCtrl.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Splitter'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Info',
            onPressed: () => _showInfo(context),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Bill total',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  TextField(
                    controller: _billCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter amount (e.g. 1200)',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Names', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s8),
                  TextField(
                    controller: _namesCtrl,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'One per line or comma-separated',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    _buildSummary(total: total, names: names),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bill Splitter'),
        content: const Text(
          'This tool splits a bill you paid among people who shared the expense, helping you track who owes what.',
        ),
        actions: <Widget>[
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  double? _parseAmount(String raw) {
    final cleaned = raw.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    final v = double.tryParse(cleaned);
    if (v == null || v <= 0) return null;
    return v;
  }

  List<String> _parseNames(String raw) {
    final normalized = raw.replaceAll('\n', ',');
    final parts = normalized.split(',');
    return parts
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  String _buildSummary({required double? total, required List<String> names}) {
    if (total == null) return 'Enter a valid bill total.';
    if (names.isEmpty) return 'Add at least one name to split the bill.';

    final share = total / names.length;
    final lines = <String>[
      'Split equally (${names.length} people):',
      '',
      ...names.map((n) => '$n owes ${share.toStringAsFixed(2)}'),
    ];

    return lines.join('\n');
  }
}
