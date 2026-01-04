import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/semantic_amount_text.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/enums.dart';
import '../../data/models/money.dart';
import '../settings/providers/settings_providers.dart';
import '../home/widgets/home_mini_visuals.dart';
import 'providers/analytics_providers.dart';
import 'services/analytics_calculator.dart';
import 'widgets/analytics_charts.dart';

final class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final vmAsync = ref.watch(analyticsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Add',
            onPressed: () => context.push(Routes.addMethodSelector),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: vmAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) =>
            EmptyState(title: 'Can\'t load analytics', body: err.toString()),
        data: (vm) {
          final preset = ref.watch(analyticsRangePresetProvider);
          final breakdown = vm.summary.categoryBreakdown;
          final hasAny =
              vm.summary.totalExpenses.amountMinor != 0 ||
              vm.summary.totalIncome.amountMinor != 0;

          if (!hasAny) {
            return Padding(
              padding: AppSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _RangeSelector(
                    preset: preset,
                    label: _rangeLabel(
                      context,
                      settings: settings,
                      range: vm.range,
                    ),
                    onPresetChanged: (p) =>
                        ref.read(analyticsRangePresetProvider.notifier).state =
                            p,
                    onPickCustom: () =>
                        _pickCustomRange(context, ref, initial: vm.range),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  const Expanded(
                    child: EmptyState(
                      title: 'No data',
                      body: 'No executed transactions in this range.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: AppSpacing.pagePadding,
            children: <Widget>[
              _RangeSelector(
                preset: preset,
                label: _rangeLabel(
                  context,
                  settings: settings,
                  range: vm.range,
                ),
                onPresetChanged: (p) =>
                    ref.read(analyticsRangePresetProvider.notifier).state = p,
                onPickCustom: () =>
                    _pickCustomRange(context, ref, initial: vm.range),
              ),
              const SizedBox(height: AppSpacing.s16),
              _TotalsCard(
                income: vm.formatMoneyText(
                  vm.summary.totalIncome,
                  settings: settings,
                ),
                expenses: vm.formatMoneyText(
                  vm.summary.totalExpenses,
                  settings: settings,
                ),
                net: vm.formatMoneyText(vm.summary.net, settings: settings),
              ),
              const SizedBox(height: AppSpacing.s16),
              ExpenseBreakdownDonutChart(
                breakdown: breakdown,
                settings: settings,
                locale: Localizations.localeOf(context).toString(),
                categoryNameFor: (categoryId) {
                  if (categoryId == null) return 'Uncategorized';
                  return vm.categoryNameById[categoryId] ?? 'Unknown';
                },
              ),
              const SizedBox(height: AppSpacing.s16),
              IncomeVsExpenseBarChart(
                income: vm.summary.totalIncome,
                expenses: vm.summary.totalExpenses,
                settings: settings,
                locale: Localizations.localeOf(context).toString(),
              ),
              const SizedBox(height: AppSpacing.s16),
              SpendingOverTimeLineChart(
                series: vm.summary.expenseSeries,
                bucket: vm.summary.expenseSeriesBucket,
                settings: settings,
                locale: Localizations.localeOf(context).toString(),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text('Heat map', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.s8),
              const HomeMiniHeatMap(weeks: 24),
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Category breakdown',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.s8),
              if (breakdown.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s8),
                  child: Text(
                    'No expense transactions in this range.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                )
              else
                ...breakdown.map((row) {
                  final name = row.categoryId == null
                      ? 'Uncategorized'
                      : (vm.categoryNameById[row.categoryId!] ?? 'Unknown');
                  final pct = row.percentageOfTotal;
                  final pctText = pct.isNaN
                      ? '0%'
                      : '${pct.toStringAsFixed(pct >= 10 ? 0 : 1)}%';
                  return _BreakdownRow(
                    title: name,
                    amount: row.amount,
                    settings: settings,
                    subtitle: pctText,
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  static String _rangeLabel(
    BuildContext context, {
    required AppSettings settings,
    required AnalyticsDateRange range,
  }) {
    final locale = Localizations.localeOf(context).toString();
    final start = AnalyticsCalculator.dateOnly(range.startInclusive);
    final end = AnalyticsCalculator.dateOnly(range.endInclusive);

    final fmt = switch (settings.dateFormat) {
      AppDateFormat.iso => DateFormat('yyyy-MM-dd', locale),
      AppDateFormat.localeBased => DateFormat.yMMMd(locale),
    };

    return '${fmt.format(start)} – ${fmt.format(end)}';
  }

  static Future<void> _pickCustomRange(
    BuildContext context,
    WidgetRef ref, {
    required AnalyticsDateRange initial,
  }) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: DateTimeRange(
        start: initial.startInclusive,
        end: initial.endInclusive,
      ),
    );

    if (picked == null) return;

    ref.read(analyticsCustomRangeProvider.notifier).state = AnalyticsDateRange(
      startInclusive: AnalyticsCalculator.dateOnly(picked.start),
      endInclusive: AnalyticsCalculator.dateOnly(picked.end),
    );
    ref.read(analyticsRangePresetProvider.notifier).state =
        AnalyticsRangePreset.custom;
  }
}

final class _RangeSelector extends StatelessWidget {
  const _RangeSelector({
    required this.preset,
    required this.label,
    required this.onPresetChanged,
    required this.onPickCustom,
  });

  final AnalyticsRangePreset preset;
  final String label;
  final ValueChanged<AnalyticsRangePreset> onPresetChanged;
  final VoidCallback onPickCustom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SegmentedButton<AnalyticsRangePreset>(
          segments: const <ButtonSegment<AnalyticsRangePreset>>[
            ButtonSegment(
              value: AnalyticsRangePreset.thisMonth,
              label: Text('This month'),
            ),
            ButtonSegment(
              value: AnalyticsRangePreset.lastMonth,
              label: Text('Last month'),
            ),
            ButtonSegment(
              value: AnalyticsRangePreset.custom,
              label: Text('Custom'),
            ),
          ],
          selected: <AnalyticsRangePreset>{preset},
          onSelectionChanged: (s) {
            final next = s.first;
            if (next == AnalyticsRangePreset.custom) {
              onPickCustom();
              return;
            }

            onPresetChanged(next);
          },
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

final class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.income,
    required this.expenses,
    required this.net,
  });

  final String income;
  final String expenses;
  final String net;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget row(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ),
            Text(value, style: theme.textTheme.titleLarge),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s8,
        ),
        child: Column(
          children: <Widget>[
            row('Income', income),
            Divider(height: 1, color: cs.outline.withValues(alpha: 0.35)),
            row('Expenses', expenses),
            Divider(height: 1, color: cs.outline.withValues(alpha: 0.35)),
            row('Net', net),
          ],
        ),
      ),
    );
  }
}

final class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.title,
    required this.amount,
    required this.settings,
    required this.subtitle,
  });

  final String title;
  final Money amount;
  final AppSettings settings;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SemanticAmountText(
            type: TransactionType.expense,
            amount: amount,
            includeCurrencyCode: true,
            textAlign: TextAlign.end,
            locale: locale,
            settings: settings,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
