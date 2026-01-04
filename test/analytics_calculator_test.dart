import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/data/models/enums.dart';
import 'package:finance_tracker/data/models/money.dart';
import 'package:finance_tracker/data/models/transaction.dart';
import 'package:finance_tracker/features/analytics/services/analytics_calculator.dart';

FinanceTransaction _tx({
  required String id,
  required TransactionType type,
  required TransactionStatus status,
  required DateTime occurredAt,
  int amountMinor = 1000,
  String currencyCode = 'INR',
  int scale = 2,
  String? categoryId,
  RecurrenceType? recurrenceType,
}) {
  final now = DateTime(2026, 1, 1, 12);
  return FinanceTransaction(
    id: id,
    type: type,
    status: status,
    accountId: 'a1',
    toAccountId: null,
    categoryId: categoryId,
    budgetId: null,
    amount: Money(currencyCode: currencyCode, amountMinor: amountMinor, scale: scale),
    currencyCode: currencyCode,
    occurredAt: occurredAt,
    title: null,
    note: null,
    merchant: null,
    reference: null,
    createdAt: now,
    updatedAt: now,
    lastExecutedAt: null,
    recurrenceType: recurrenceType,
    recurrenceInterval: 1,
    recurrenceEndAt: null,
  );
}

void main() {
  group('AnalyticsCalculator', () {
    test('computes totals and category breakdown excluding scheduled and templates', () {
      final calc = AnalyticsCalculator();
      final txs = <FinanceTransaction>[
        // Included: posted income/expense in range
        _tx(
          id: 'income1',
          type: TransactionType.income,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 2, 10),
          amountMinor: 5000,
        ),
        _tx(
          id: 'expenseFood',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 2, 11),
          amountMinor: 2000,
          categoryId: 'food',
        ),
        _tx(
          id: 'expenseRent',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 3, 9),
          amountMinor: 3000,
          categoryId: 'rent',
        ),

        // Excluded: scheduled
        _tx(
          id: 'scheduledExpense',
          type: TransactionType.expense,
          status: TransactionStatus.scheduled,
          occurredAt: DateTime(2026, 1, 2, 9),
          amountMinor: 9999,
          categoryId: 'food',
        ),

        // Excluded: recurring template (recurrenceType != null)
        _tx(
          id: 'template',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 2, 9),
          amountMinor: 9999,
          categoryId: 'rent',
          recurrenceType: RecurrenceType.monthly,
        ),

        // Excluded: transfer
        _tx(
          id: 'transfer',
          type: TransactionType.transfer,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 2, 9),
          amountMinor: 7777,
        ),

        // Excluded: outside range
        _tx(
          id: 'oldExpense',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2025, 12, 31, 9),
          amountMinor: 1111,
          categoryId: 'food',
        ),
      ];

      final range = AnalyticsDateRange(
        startInclusive: DateTime(2026, 1, 1),
        endInclusive: DateTime(2026, 1, 3),
      );

      final summary = calc.compute(transactions: txs, range: range, currencyCode: 'INR', scale: 2);

      expect(summary.totalIncome.amountMinor, 5000);
      expect(summary.totalExpenses.amountMinor, 5000);
      expect(summary.net.amountMinor, 0);

      expect(summary.categoryBreakdown.length, 2);
      // Sorted highest spend first.
      expect(summary.categoryBreakdown[0].categoryId, 'rent');
      expect(summary.categoryBreakdown[0].amount.amountMinor, 3000);
      expect(summary.categoryBreakdown[1].categoryId, 'food');
      expect(summary.categoryBreakdown[1].amount.amountMinor, 2000);

      // Percentages
      expect(summary.categoryBreakdown[0].percentageOfTotal, closeTo(60.0, 0.0001));
      expect(summary.categoryBreakdown[1].percentageOfTotal, closeTo(40.0, 0.0001));
    });

    test('presetRange computes this month as month-to-date and last month as full previous month', () {
      final calc = AnalyticsCalculator();

      final thisMonth = calc.presetRange(preset: AnalyticsRangePreset.thisMonth, now: DateTime(2026, 1, 3, 12));
      expect(thisMonth.startInclusive, DateTime(2026, 1, 1));
      expect(thisMonth.endInclusive, DateTime(2026, 1, 3));

      final lastMonth = calc.presetRange(preset: AnalyticsRangePreset.lastMonth, now: DateTime(2026, 1, 3, 12));
      expect(lastMonth.startInclusive, DateTime(2025, 12, 1));
      expect(lastMonth.endInclusive, DateTime(2025, 12, 31));
    });

    test('builds daily expense time series for <=31 days (includes zero days)', () {
      final calc = AnalyticsCalculator();
      final txs = <FinanceTransaction>[
        _tx(
          id: 'e1',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 1, 10),
          amountMinor: 1000,
          categoryId: 'c1',
        ),
        _tx(
          id: 'e3',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 3, 10),
          amountMinor: 3000,
          categoryId: 'c1',
        ),
      ];

      final range = AnalyticsDateRange(startInclusive: DateTime(2026, 1, 1), endInclusive: DateTime(2026, 1, 3));
      final summary = calc.compute(transactions: txs, range: range, currencyCode: 'INR', scale: 2);

      expect(summary.expenseSeriesBucket, ExpenseTimeSeriesBucket.day);
      expect(summary.expenseSeries.length, 3);
      expect(summary.expenseSeries[0].bucketStart, DateTime(2026, 1, 1));
      expect(summary.expenseSeries[0].amount.amountMinor, 1000);
      expect(summary.expenseSeries[1].bucketStart, DateTime(2026, 1, 2));
      expect(summary.expenseSeries[1].amount.amountMinor, 0);
      expect(summary.expenseSeries[2].bucketStart, DateTime(2026, 1, 3));
      expect(summary.expenseSeries[2].amount.amountMinor, 3000);
    });

    test('builds monthly expense time series for >31 days', () {
      final calc = AnalyticsCalculator();
      final txs = <FinanceTransaction>[
        _tx(
          id: 'jan',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 15, 10),
          amountMinor: 2000,
          categoryId: 'c1',
        ),
        _tx(
          id: 'feb',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 2, 2, 10),
          amountMinor: 3000,
          categoryId: 'c1',
        ),
      ];

      final range = AnalyticsDateRange(startInclusive: DateTime(2026, 1, 1), endInclusive: DateTime(2026, 2, 15));
      final summary = calc.compute(transactions: txs, range: range, currencyCode: 'INR', scale: 2);

      expect(summary.expenseSeriesBucket, ExpenseTimeSeriesBucket.month);
      // Jan + Feb buckets.
      expect(summary.expenseSeries.length, 2);
      expect(summary.expenseSeries[0].bucketStart, DateTime(2026, 1, 1));
      expect(summary.expenseSeries[0].amount.amountMinor, 2000);
      expect(summary.expenseSeries[1].bucketStart, DateTime(2026, 2, 1));
      expect(summary.expenseSeries[1].amount.amountMinor, 3000);
    });
  });
}
