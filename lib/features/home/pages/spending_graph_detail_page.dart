import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../analytics/providers/analytics_providers.dart';
import '../../analytics/widgets/analytics_charts.dart';
import '../../../core/widgets/empty_state.dart';
import '../../settings/providers/settings_providers.dart';

final class SpendingGraphDetailPage extends ConsumerWidget {
  const SpendingGraphDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmAsync = ref.watch(analyticsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Spending graph')),
      body: vmAsync.when(
        data: (vm) {
          final settings = ref.watch(appSettingsProvider);
          return ListView(
            padding: AppSpacing.pagePadding,
            children: <Widget>[
              SpendingOverTimeLineChart(
                series: vm.summary.expenseSeries,
                bucket: vm.summary.expenseSeriesBucket,
                settings: settings,
                locale: Localizations.localeOf(context).toString(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Unable to load spending graph',
            body: e.toString(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
