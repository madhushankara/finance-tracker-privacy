import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/chart_palettes.dart';
import '../../../data/models/enums.dart';
import '../../analytics/providers/analytics_providers.dart';
import '../../transactions/providers/transactions_providers.dart';

final class HomeMiniSpendingGraph extends ConsumerWidget {
  const HomeMiniSpendingGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmAsync = ref.watch(analyticsViewModelProvider);
    return vmAsync.when(
      data: (vm) {
        final series = vm.summary.expenseSeries;
        if (series.isEmpty) {
          return const _MiniPlaceholder(icon: Icons.show_chart_outlined);
        }

        final spots = <FlSpot>[];
        var maxMinor = 0;
        for (var i = 0; i < series.length; i++) {
          final minor = series[i].amount.amountMinor;
          if (minor > maxMinor) maxMinor = minor;
          spots.add(FlSpot(i.toDouble(), minor.toDouble()));
        }

        final maxY = math.max(1.0, maxMinor.toDouble());

        return SizedBox(
          height: 56,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: <LineChartBarData>[
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: ChartPalettes.line.withValues(alpha: 0.85),
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: ChartPalettes.line.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const _MiniPlaceholder(icon: Icons.show_chart_outlined),
      error: (err, st) =>
          const _MiniPlaceholder(icon: Icons.show_chart_outlined),
    );
  }
}

final class HomeMiniPieChart extends ConsumerWidget {
  const HomeMiniPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmAsync = ref.watch(analyticsViewModelProvider);
    return vmAsync.when(
      data: (vm) {
        final breakdown = vm.summary.categoryBreakdown;
        if (breakdown.isEmpty) {
          return const _MiniPlaceholder(icon: Icons.pie_chart_outline);
        }

        final sections = <PieChartSectionData>[];
        final take = math.min(6, breakdown.length);
        for (var i = 0; i < take; i++) {
          final row = breakdown[i];
          final value = row.amount.amountMinor.toDouble();
          if (value <= 0) continue;
          sections.add(
            PieChartSectionData(
              value: value,
              color: ChartPalettes.categoricalColorForKey(
                row.categoryId ?? 'uncategorized',
              ).withValues(alpha: 0.95),
              radius: 12,
              title: '',
            ),
          );
        }

        if (sections.isEmpty) {
          return const _MiniPlaceholder(icon: Icons.pie_chart_outline);
        }

        return SizedBox(
          height: 56,
          width: 56,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 14,
              sectionsSpace: 1,
              startDegreeOffset: -90,
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
      loading: () => const _MiniPlaceholder(icon: Icons.pie_chart_outline),
      error: (err, st) => const _MiniPlaceholder(icon: Icons.pie_chart_outline),
    );
  }
}

final class HomeMiniHeatMap extends ConsumerWidget {
  const HomeMiniHeatMap({super.key, this.weeks = 12});

  final int weeks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsListProvider);

    return txAsync.when(
      data: (txs) {
        final now = DateUtils.dateOnly(DateTime.now());
        final end = now;
        final start = end.subtract(Duration(days: (weeks * 7) - 1));

        final countsByDay = <DateTime, int>{};
        for (final tx in txs) {
          if (tx.status != TransactionStatus.posted) continue;
          if (tx.recurrenceType != null) continue; // templates
          final d = DateUtils.dateOnly(tx.occurredAt);
          if (d.isBefore(start) || d.isAfter(end)) continue;
          countsByDay[d] = (countsByDay[d] ?? 0) + 1;
        }

        var maxCount = 0;
        for (final v in countsByDay.values) {
          if (v > maxCount) maxCount = v;
        }

        final cs = Theme.of(context).colorScheme;
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: _HeatMapGrid(
              start: start,
              weeks: weeks,
              countsByDay: countsByDay,
              maxCount: maxCount,
            ),
          ),
        );
      },
      loading: () => const _MiniPlaceholder(icon: Icons.grid_view_outlined),
      error: (err, st) =>
          const _MiniPlaceholder(icon: Icons.grid_view_outlined),
    );
  }
}

final class _HeatMapGrid extends StatelessWidget {
  const _HeatMapGrid({
    required this.start,
    required this.weeks,
    required this.countsByDay,
    required this.maxCount,
  });

  final DateTime start;
  final int weeks;
  final Map<DateTime, int> countsByDay;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final cell = 8.0;
    final gap = 3.0;

    final children = <Widget>[];
    for (var week = 0; week < weeks; week++) {
      for (var dow = 0; dow < 7; dow++) {
        final d = DateUtils.dateOnly(
          start.add(Duration(days: (week * 7) + dow)),
        );
        final c = countsByDay[d] ?? 0;
        children.add(
          Container(
            width: cell,
            height: cell,
            decoration: BoxDecoration(
              color: ChartPalettes.heatmapColor(count: c, maxCount: maxCount),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }
    }

    return Wrap(spacing: gap, runSpacing: gap, children: children);
  }
}

final class _MiniPlaceholder extends StatelessWidget {
  const _MiniPlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      child: Center(
        child: Icon(icon, color: cs.onSurface.withValues(alpha: 0.45)),
      ),
    );
  }
}
