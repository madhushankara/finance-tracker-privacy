import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';

enum AnalyticsRangePreset {
  thisMonth,
  lastMonth,
  custom,
}

final class AnalyticsDateRange {
  const AnalyticsDateRange({required this.startInclusive, required this.endInclusive});

  final DateTime startInclusive;
  final DateTime endInclusive;
}

final class CategoryExpenseBreakdown {
  const CategoryExpenseBreakdown({
    required this.categoryId,
    required this.amount,
    required this.percentageOfTotal,
  });

  final String? categoryId;
  final Money amount;
  final double percentageOfTotal;
}

final class AnalyticsSummary {
  const AnalyticsSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.net,
    required this.categoryBreakdown,
    required this.expenseSeries,
    required this.expenseSeriesBucket,
  });

  final Money totalIncome;
  final Money totalExpenses;
  final Money net;
  final List<CategoryExpenseBreakdown> categoryBreakdown;

  /// Ordered expense time series for the selected range.
  final List<ExpenseTimeSeriesPoint> expenseSeries;

  /// Whether [expenseSeries] is daily or monthly buckets.
  final ExpenseTimeSeriesBucket expenseSeriesBucket;
}

enum ExpenseTimeSeriesBucket {
  day,
  month,
}

final class ExpenseTimeSeriesPoint {
  const ExpenseTimeSeriesPoint({required this.bucketStart, required this.amount});

  /// Start of the bucket (date-only for day; first of month for month).
  final DateTime bucketStart;
  final Money amount;
}

final class AnalyticsCalculator {
  const AnalyticsCalculator();

  static DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  AnalyticsDateRange presetRange({
    required AnalyticsRangePreset preset,
    required DateTime now,
  }) {
    final today = dateOnly(now);

    switch (preset) {
      case AnalyticsRangePreset.thisMonth:
        return AnalyticsDateRange(
          startInclusive: DateTime(today.year, today.month, 1),
          endInclusive: today,
        );
      case AnalyticsRangePreset.lastMonth:
        final firstOfThisMonth = DateTime(today.year, today.month, 1);
        final lastMonthEnd = firstOfThisMonth.subtract(const Duration(days: 1));
        final lastMonthStart = DateTime(lastMonthEnd.year, lastMonthEnd.month, 1);
        return AnalyticsDateRange(
          startInclusive: lastMonthStart,
          endInclusive: lastMonthEnd,
        );
      case AnalyticsRangePreset.custom:
        throw StateError('Custom range must be provided explicitly');
    }
  }

  AnalyticsSummary compute({
    required List<FinanceTransaction> transactions,
    required AnalyticsDateRange range,
    required String currencyCode,
    int scale = 2,
  }) {
    final start = dateOnly(range.startInclusive);
    final end = dateOnly(range.endInclusive);
    if (end.isBefore(start)) {
      throw StateError('End date must be on/after start date');
    }

    final filtered = transactions.where((tx) {
      if (tx.status != TransactionStatus.posted) return false;
      if (tx.recurrenceType != null) return false; // templates
      if (tx.amount.currencyCode != currencyCode) return false;
      if (tx.amount.scale != scale) return false;
      final d = dateOnly(tx.occurredAt);
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList(growable: false);

    var incomeMinor = 0;
    var expenseMinor = 0;

    final Map<String?, int> expensesByCategoryMinor = <String?, int>{};
    final Map<DateTime, int> expenseByDayMinor = <DateTime, int>{};
    final Map<DateTime, int> expenseByMonthMinor = <DateTime, int>{};

    for (final tx in filtered) {
      switch (tx.type) {
        case TransactionType.income:
          incomeMinor += tx.amount.amountMinor;
        case TransactionType.expense:
          expenseMinor += tx.amount.amountMinor;
          final key = tx.categoryId;
          expensesByCategoryMinor[key] = (expensesByCategoryMinor[key] ?? 0) + tx.amount.amountMinor;

          final d = dateOnly(tx.occurredAt);
          expenseByDayMinor[d] = (expenseByDayMinor[d] ?? 0) + tx.amount.amountMinor;

          final m = DateTime(d.year, d.month, 1);
          expenseByMonthMinor[m] = (expenseByMonthMinor[m] ?? 0) + tx.amount.amountMinor;
        case TransactionType.transfer:
          // Ignore transfers in analytics.
          break;
      }
    }

    final totalExpensesMoney = Money(currencyCode: currencyCode, amountMinor: expenseMinor, scale: scale);
    final totalIncomeMoney = Money(currencyCode: currencyCode, amountMinor: incomeMinor, scale: scale);
    final netMoney = Money(currencyCode: currencyCode, amountMinor: incomeMinor - expenseMinor, scale: scale);

    final totalExpense = expenseMinor;
    final breakdown = expensesByCategoryMinor.entries
        .map((e) {
          final pct = totalExpense == 0 ? 0.0 : (e.value / totalExpense) * 100.0;
          return CategoryExpenseBreakdown(
            categoryId: e.key,
            amount: Money(currencyCode: currencyCode, amountMinor: e.value, scale: scale),
            percentageOfTotal: pct,
          );
        })
        .toList(growable: false)
      ..sort((a, b) => b.amount.amountMinor.compareTo(a.amount.amountMinor));

    return AnalyticsSummary(
      totalIncome: totalIncomeMoney,
      totalExpenses: totalExpensesMoney,
      net: netMoney,
      categoryBreakdown: breakdown,
      expenseSeries: _buildExpenseSeries(
        start: start,
        end: end,
        currencyCode: currencyCode,
        scale: scale,
        expenseByDayMinor: expenseByDayMinor,
        expenseByMonthMinor: expenseByMonthMinor,
      ),
      expenseSeriesBucket: _selectExpenseBucket(start: start, end: end),
    );
  }

  static ExpenseTimeSeriesBucket _selectExpenseBucket({required DateTime start, required DateTime end}) {
    final days = end.difference(start).inDays + 1;
    return days <= 31 ? ExpenseTimeSeriesBucket.day : ExpenseTimeSeriesBucket.month;
  }

  static List<ExpenseTimeSeriesPoint> _buildExpenseSeries({
    required DateTime start,
    required DateTime end,
    required String currencyCode,
    required int scale,
    required Map<DateTime, int> expenseByDayMinor,
    required Map<DateTime, int> expenseByMonthMinor,
  }) {
    final bucket = _selectExpenseBucket(start: start, end: end);

    switch (bucket) {
      case ExpenseTimeSeriesBucket.day:
        final points = <ExpenseTimeSeriesPoint>[];
        var cursor = start;
        while (!cursor.isAfter(end)) {
          final minor = expenseByDayMinor[cursor] ?? 0;
          points.add(
            ExpenseTimeSeriesPoint(
              bucketStart: cursor,
              amount: Money(currencyCode: currencyCode, amountMinor: minor, scale: scale),
            ),
          );
          cursor = cursor.add(const Duration(days: 1));
        }
        return points;
      case ExpenseTimeSeriesBucket.month:
        final points = <ExpenseTimeSeriesPoint>[];
        var cursor = DateTime(start.year, start.month, 1);
        final last = DateTime(end.year, end.month, 1);
        while (!cursor.isAfter(last)) {
          final minor = expenseByMonthMinor[cursor] ?? 0;
          points.add(
            ExpenseTimeSeriesPoint(
              bucketStart: cursor,
              amount: Money(currencyCode: currencyCode, amountMinor: minor, scale: scale),
            ),
          );
          cursor = DateTime(cursor.year, cursor.month + 1, 1);
        }
        return points;
    }
  }
}
