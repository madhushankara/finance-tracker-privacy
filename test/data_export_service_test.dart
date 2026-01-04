import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/data/models/app_settings.dart';
import 'package:finance_tracker/data/models/enums.dart';
import 'package:finance_tracker/data/models/money.dart';
import 'package:finance_tracker/data/models/transaction.dart';
import 'package:finance_tracker/features/export/services/data_export_service.dart';

void main() {
  group('DataExportService.buildTransactionsCsv', () {
    test('exports executed-only facts (excludes scheduled and recurring templates)', () {
      const service = DataExportService();
      final settings = AppSettings.defaults.copyWith(primaryCurrencyCode: 'USD');

      final baseDate = DateTime(2026, 1, 3);

      FinanceTransaction tx({
        required String id,
        required TransactionType type,
        required TransactionStatus status,
        RecurrenceType? recurrenceType,
        required int minor,
        int scale = 2,
        String? title,
      }) {
        return FinanceTransaction(
          id: id,
          type: type,
          status: status,
          accountId: 'acc_1',
          amount: Money(currencyCode: 'USD', amountMinor: minor, scale: scale),
          currencyCode: 'USD',
          occurredAt: baseDate,
          createdAt: baseDate,
          updatedAt: baseDate,
          title: title,
          recurrenceType: recurrenceType,
        );
      }

      final postedExpense = tx(
        id: 't1',
        type: TransactionType.expense,
        status: TransactionStatus.posted,
        minor: 1234,
        title: 'Coffee, beans',
      );
      final postedIncome = tx(
        id: 't2',
        type: TransactionType.income,
        status: TransactionStatus.posted,
        minor: 4500,
      );
      final scheduled = tx(
        id: 't3',
        type: TransactionType.expense,
        status: TransactionStatus.scheduled,
        minor: 999,
      );
      final recurringTemplate = tx(
        id: 't4',
        type: TransactionType.expense,
        status: TransactionStatus.posted,
        recurrenceType: RecurrenceType.monthly,
        minor: 2500,
      );

      final csv = service.buildTransactionsCsv(
        transactions: <FinanceTransaction>[postedExpense, postedIncome, scheduled, recurringTemplate],
        settings: settings,
      );

      // Header + 2 data rows only.
      final lines = csv.trim().split('\n');
      expect(lines.length, 3);

      expect(
        lines.first,
        'id,type,account_id,to_account_id,category_id,budget_id,amount,currency_code,primary_currency_code,occurred_at,title,merchant,reference,note,created_at,updated_at',
      );

      // Expense should be signed negative and title should be CSV-escaped due to comma.
      expect(lines[1], contains('t1,expense,acc_1,,,,-12.34,USD,USD,2026-01-03,"Coffee, beans"'));

      // Income should be positive.
      expect(lines[2], contains('t2,income,acc_1,,,,45.00,USD,USD,2026-01-03,'));

      // Ensure excluded IDs are not present.
      expect(csv.contains('t3,'), isFalse);
      expect(csv.contains('t4,'), isFalse);
    });
  });
}
