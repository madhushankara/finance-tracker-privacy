import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/formatting/money_format.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/chart_palettes.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/money.dart';
import '../services/analytics_calculator.dart';

final class ExpenseBreakdownDonutChart extends StatelessWidget {
  const ExpenseBreakdownDonutChart({
    super.key,
    required this.breakdown,
    required this.categoryNameFor,
    required this.settings,
    required this.locale,
  });

  final List<CategoryExpenseBreakdown> breakdown;
  final String Function(String? categoryId) categoryNameFor;
  final AppSettings settings;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (breakdown.isEmpty) {
      return _CardShell(
        child: Text(
          'No expense data for this range.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.75),
          ),
        ),
      );
    }

    final sections = <PieChartSectionData>[];

    for (var i = 0; i < breakdown.length; i++) {
      final row = breakdown[i];
      final key = row.categoryId ?? 'uncategorized';
      final c = ChartPalettes.categoricalColorForKey(
        key,
      ).withValues(alpha: 0.90);
      final value = row.amount.amountMinor.toDouble();
      if (value <= 0) continue;

      sections.add(
        PieChartSectionData(value: value, color: c, radius: 26, title: ''),
      );
    }

    // All zeros.
    if (sections.isEmpty) {
      return _CardShell(
        child: Text(
          'No expense data for this range.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.75),
          ),
        ),
      );
    }

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Expense breakdown', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 44,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var i = 0; i < breakdown.length; i++)
                      _LegendRow(
                        color: ChartPalettes.categoricalColorForKey(
                          breakdown[i].categoryId ?? 'uncategorized',
                        ).withValues(alpha: 0.90),
                        label: categoryNameFor(breakdown[i].categoryId),
                        value: _pctText(breakdown[i].percentageOfTotal),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _pctText(double pct) {
    if (pct.isNaN || pct.isInfinite) return '0%';
    return '${pct.toStringAsFixed(pct >= 10 ? 0 : 1)}%';
  }
}

final class IncomeVsExpenseBarChart extends StatelessWidget {
  const IncomeVsExpenseBarChart({
    super.key,
    required this.income,
    required this.expenses,
    required this.settings,
    required this.locale,
  });

  final Money income;
  final Money expenses;
  final AppSettings settings;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final maxMinor = math
        .max(income.amountMinor, expenses.amountMinor)
        .toDouble();
    final maxY = maxMinor <= 0 ? 1.0 : maxMinor;

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Income vs Expenses', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s8),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 3,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: maxY / 2,
                      getTitlesWidget: (value, meta) => Text(
                        _formatMinorAsCompact(value, scale: income.scale),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final label = switch (value.toInt()) {
                          0 => 'Income',
                          1 => 'Expenses',
                          _ => '',
                        };
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(label, style: theme.textTheme.bodySmall),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: <BarChartGroupData>[
                  BarChartGroupData(
                    x: 0,
                    barRods: <BarChartRodData>[
                      BarChartRodData(
                        toY: income.amountMinor.toDouble(),
                        color: ChartPalettes.income.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                        width: 18,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: <BarChartRodData>[
                      BarChartRodData(
                        toY: expenses.amountMinor.toDouble(),
                        color: ChartPalettes.expense.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                        width: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Income: ${formatMoney(income, includeCurrencyCode: true, settings: settings, locale: locale)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
          Text(
            'Expenses: ${formatMoney(expenses, includeCurrencyCode: true, settings: settings, locale: locale)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatMinorAsCompact(double minor, {required int scale}) {
    final v = minor / math.pow(10, scale);
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    if (v >= 100) return v.toStringAsFixed(0);
    if (v >= 10) return v.toStringAsFixed(0);
    return v.toStringAsFixed(0);
  }
}

final class SpendingOverTimeLineChart extends StatelessWidget {
  const SpendingOverTimeLineChart({
    super.key,
    required this.series,
    required this.bucket,
    required this.settings,
    required this.locale,
  });

  final List<ExpenseTimeSeriesPoint> series;
  final ExpenseTimeSeriesBucket bucket;
  final AppSettings settings;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (series.isEmpty) {
      return _CardShell(
        child: Text(
          'No expense data for this range.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.75),
          ),
        ),
      );
    }

    final spots = <FlSpot>[];
    var maxMinor = 0;
    for (var i = 0; i < series.length; i++) {
      final minor = series[i].amount.amountMinor;
      if (minor > maxMinor) maxMinor = minor;
      spots.add(FlSpot(i.toDouble(), minor.toDouble()));
    }

    final maxY = maxMinor <= 0 ? 1.0 : maxMinor.toDouble();

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Spending over time', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s8),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 3,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: maxY / 2,
                      getTitlesWidget: (value, meta) => Text(
                        IncomeVsExpenseBarChart._formatMinorAsCompact(
                          value,
                          scale: series.first.amount.scale,
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _bottomInterval(series.length),
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= series.length) {
                          return const SizedBox.shrink();
                        }
                        final dt = series[idx].bucketStart;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _formatBucket(
                              dt,
                              bucket: bucket,
                              settings: settings,
                              locale: locale,
                            ),
                            style: theme.textTheme.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: ChartPalettes.line.withValues(alpha: 0.85),
                    barWidth: 2,
                    dotData: FlDotData(show: series.length <= 31),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static double _bottomInterval(int count) {
    if (count <= 1) return 1;
    if (count <= 7) return 1;
    if (count <= 31) return 5;
    return 1;
  }

  static String _formatBucket(
    DateTime dt, {
    required ExpenseTimeSeriesBucket bucket,
    required AppSettings settings,
    required String locale,
  }) {
    switch (settings.dateFormat) {
      case AppDateFormat.iso:
        return switch (bucket) {
          ExpenseTimeSeriesBucket.day => DateFormat('MM-dd', locale).format(dt),
          ExpenseTimeSeriesBucket.month => DateFormat(
            'yyyy-MM',
            locale,
          ).format(dt),
        };
      case AppDateFormat.localeBased:
        return switch (bucket) {
          ExpenseTimeSeriesBucket.day => DateFormat('d MMM', locale).format(dt),
          ExpenseTimeSeriesBucket.month => DateFormat(
            'MMM yy',
            locale,
          ).format(dt),
        };
    }
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
              border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

final class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyMedium ?? const TextStyle(),
          child: child,
        ),
      ),
    );
  }
}
