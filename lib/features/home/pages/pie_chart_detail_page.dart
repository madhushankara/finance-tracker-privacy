import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/chart_palettes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../analytics/providers/analytics_providers.dart';

final class PieChartDetailPage extends ConsumerWidget {
  const PieChartDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmAsync = ref.watch(analyticsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Spending breakdown')),
      body: vmAsync.when(
        data: (vm) {
          final breakdown = vm.summary.categoryBreakdown;
          if (breakdown.isEmpty) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'No data',
                body: 'No expense data for this range.',
                padding: EdgeInsets.zero,
              ),
            );
          }

          final sections = <PieChartSectionData>[];
          for (var i = 0; i < breakdown.length; i++) {
            final row = breakdown[i];
            final value = row.amount.amountMinor.toDouble();
            if (value <= 0) continue;
            sections.add(
              PieChartSectionData(
                value: value,
                color: ChartPalettes.categoricalColorForKey(
                  row.categoryId ?? 'uncategorized',
                ).withValues(alpha: 0.95),
                radius: 52,
                title: '',
              ),
            );
          }

          if (sections.isEmpty) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'No data',
                body: 'No expense data for this range.',
                padding: EdgeInsets.zero,
              ),
            );
          }

          final takeLegend = math.min(12, breakdown.length);

          return ListView(
            padding: AppSpacing.pagePadding,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 240,
                  width: 240,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 68,
                      sectionsSpace: 2,
                      startDegreeOffset: -90,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              for (var i = 0; i < takeLegend; i++)
                _LegendRow(
                  color: ChartPalettes.categoricalColorForKey(
                    breakdown[i].categoryId ?? 'uncategorized',
                  ).withValues(alpha: 0.95),
                  label:
                      vm.categoryNameById[breakdown[i].categoryId] ??
                      'Uncategorized',
                  value:
                      '${breakdown[i].percentageOfTotal.toStringAsFixed(breakdown[i].percentageOfTotal >= 10 ? 0 : 1)}%',
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Unable to load breakdown',
            body: e.toString(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

final class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        children: <Widget>[
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
