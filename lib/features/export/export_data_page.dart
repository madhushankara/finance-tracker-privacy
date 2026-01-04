import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/pressable_scale.dart';
import '../accounts/providers/accounts_providers.dart';
import '../budgets/providers/budgets_providers.dart';
import '../categories/providers/categories_providers.dart';
import '../settings/providers/settings_providers.dart';
import '../transactions/providers/transactions_providers.dart';
import 'services/data_export_service.dart';

final class ExportDataPage extends ConsumerStatefulWidget {
  const ExportDataPage({super.key});

  @override
  ConsumerState<ExportDataPage> createState() => _ExportDataPageState();
}

final class _ExportDataPageState extends ConsumerState<ExportDataPage> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export data')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Backup (CSV)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'Exports a ZIP containing CSV files for accounts, categories, budgets, and executed transactions.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.78),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    PressableScaleDecorator.forButton(
                      onPressed: _isExporting ? null : () => _export(),
                      child: FilledButton.icon(
                        onPressed: _isExporting ? null : () => _export(),
                        icon: _isExporting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.ios_share),
                        label: Text(
                          _isExporting
                              ? 'Preparing export…'
                              : 'Generate & share',
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      'Executed transactions only. Scheduled items and recurring templates are excluded.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            const Expanded(
              child: EmptyState(
                title: 'Tip',
                body: 'You can open the CSV files in Excel or Google Sheets.',
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export() async {
    setState(() => _isExporting = true);

    try {
      final settings = ref.read(appSettingsProvider);

      // Snapshot the current data.
      final accounts = await ref.read(accountsListProvider.future);
      final categories = await ref.read(categoriesListProvider.future);
      final budgets = await ref.read(budgetsListProvider.future);
      final transactions = await ref.read(transactionsListProvider.future);

      const service = DataExportService();
      final payload = service.buildPayload(
        accounts: accounts,
        categories: categories,
        budgets: budgets,
        transactions: transactions,
        settings: settings,
      );

      // Heavy CSV string building + zipping off the UI thread.
      final bundle = await Isolate.run(
        () => buildZipBundleFromPayload(payload),
      );

      final dir = await getTemporaryDirectory();
      final outFile = File('${dir.path}/${bundle.fileName}');
      await outFile.writeAsBytes(bundle.bytes, flush: true);

      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(outFile.path, mimeType: 'application/zip')],
          subject: 'Finance Tracker export',
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Export ready to share.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Export failed. This feature is under development.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}
