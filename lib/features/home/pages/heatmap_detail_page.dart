import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/chart_palettes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/enums.dart';
import '../../transactions/providers/transactions_providers.dart';

final class HeatmapDetailPage extends ConsumerWidget {
  const HeatmapDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Heat map')),
      body: txAsync.when(
        data: (txs) {
          final now = DateUtils.dateOnly(DateTime.now());

          // Build a 12-month window (including the current month).
          final currentMonthStart = DateTime(now.year, now.month);
          final months = List<DateTime>.generate(12, (i) {
            final m = currentMonthStart.month - (11 - i);
            return DateTime(currentMonthStart.year, m);
          }, growable: false);

          final start = months.first;
          final end = DateUtils.dateOnly(
            DateTime(currentMonthStart.year, currentMonthStart.month + 1, 0),
          );

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

          if (countsByDay.isEmpty) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'No activity',
                body: 'No posted transactions found for the last year.',
                padding: EdgeInsets.zero,
              ),
            );
          }

          final pageController = PageController(initialPage: months.length - 1);

          return Padding(
            padding: AppSpacing.pagePadding,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Transaction activity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: months.length,
                        itemBuilder: (context, index) {
                          final monthStart = months[index];
                          final monthEnd = DateUtils.dateOnly(
                            DateTime(monthStart.year, monthStart.month + 1, 0),
                          );

                          return _MonthHeatMap(
                            monthStart: monthStart,
                            monthEnd: monthEnd,
                            countsByDay: countsByDay,
                            maxCount: maxCount,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      'Swipe left or right to switch months. Darker squares mean more posted transactions on that day.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    _Legend(maxCount: maxCount),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Unable to load heat map',
            body: e.toString(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

final class _Legend extends StatelessWidget {
  const _Legend({required this.maxCount});

  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (final c in ChartPalettes.heatmapLevels) {
      items.add(
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }

    return Row(
      children: <Widget>[
        Text('Less', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: AppSpacing.s8),
        ...items.expand((w) sync* {
          yield w;
          yield const SizedBox(width: 4);
        }).toList()..removeLast(),
        const SizedBox(width: AppSpacing.s8),
        Text(
          'More${maxCount > 0 ? ' ($maxCount/day)' : ''}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

final class _MonthHeatMap extends StatelessWidget {
  const _MonthHeatMap({
    required this.monthStart,
    required this.monthEnd,
    required this.countsByDay,
    required this.maxCount,
  });

  final DateTime monthStart;
  final DateTime monthEnd;
  final Map<DateTime, int> countsByDay;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Align to Monday-start weeks.
    final gridStart = DateUtils.dateOnly(
      monthStart.subtract(Duration(days: monthStart.weekday - DateTime.monday)),
    );
    final gridEnd = DateUtils.dateOnly(
      monthEnd.add(Duration(days: DateTime.sunday - monthEnd.weekday)),
    );

    final totalDays = gridEnd.difference(gridStart).inDays + 1;
    final weeks = (totalDays / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          '${_monthName(monthStart.month)} ${monthStart.year}',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.s8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double w = constraints.maxWidth;
              final double h = constraints.maxHeight;

              // Responsive spacing: scales with width, clamped for consistency.
              final double gap = (w * 0.015).clamp(2.0, 6.0);

              // Fit the grid to the available space without scrolling.
              final double cellFromWidth = (w - (gap * (weeks - 1))) / weeks;
              final double cellFromHeight = (h - (gap * 6)) / 7;
              final double cell = math.min(cellFromWidth, cellFromHeight);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(weeks, (wIndex) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: wIndex == weeks - 1 ? 0 : gap,
                    ),
                    child: Column(
                      children: List<Widget>.generate(7, (d) {
                        final date = DateUtils.dateOnly(
                          gridStart.add(Duration(days: (wIndex * 7) + d)),
                        );

                        final inMonth =
                            date.month == monthStart.month &&
                            date.year == monthStart.year;
                        final count = inMonth ? (countsByDay[date] ?? 0) : 0;

                        final color = inMonth
                            ? ChartPalettes.heatmapColor(
                                count: count,
                                maxCount: maxCount,
                              )
                            : cs.surfaceContainerHighest.withValues(
                                alpha: 0.35,
                              );

                        return Padding(
                          padding: EdgeInsets.only(bottom: d == 6 ? 0 : gap),
                          child: Tooltip(
                            message:
                                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}: $count',
                            child: Container(
                              width: cell,
                              height: cell,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        );
                      }, growable: false),
                    ),
                  );
                }, growable: false),
              );
            },
          ),
        ),
      ],
    );
  }
}

String _monthName(int month) {
  const names = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return names[month - 1];
}
