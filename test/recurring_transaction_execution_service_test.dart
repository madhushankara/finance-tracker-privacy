import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/data/models/enums.dart';
import 'package:finance_tracker/data/models/money.dart';
import 'package:finance_tracker/data/models/transaction.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/services/recurring_transaction_execution_service.dart';

final class _FakeTransactionRepository implements TransactionRepository {
  _FakeTransactionRepository(this._items);

  List<FinanceTransaction> _items;

  @override
  Stream<List<FinanceTransaction>> watchAll() => Stream.value(_items);

  @override
  Stream<List<FinanceTransaction>> watchRecent({required int limit}) {
    return Stream.value(_items.take(limit).toList(growable: false));
  }

  @override
  Future<FinanceTransaction?> getById(String id) async {
    for (final tx in _items) {
      if (tx.id == id) return tx;
    }
    return null;
  }

  @override
  Future<void> upsert(FinanceTransaction transaction) async {
    final idx = _items.indexWhere((t) => t.id == transaction.id);
    if (idx >= 0) {
      _items = List<FinanceTransaction>.of(_items)..[idx] = transaction;
    } else {
      _items = List<FinanceTransaction>.of(_items)..add(transaction);
    }
  }

  @override
  Future<bool> insertIfAbsent(FinanceTransaction transaction) async {
    final exists = _items.any((t) => t.id == transaction.id);
    if (exists) return false;
    _items = List<FinanceTransaction>.of(_items)..add(transaction);
    return true;
  }

  @override
  Future<void> update(FinanceTransaction transaction) async {
    final idx = _items.indexWhere((t) => t.id == transaction.id);
    if (idx < 0) {
      throw StateError('Missing transaction ${transaction.id}');
    }
    _items = List<FinanceTransaction>.of(_items)..[idx] = transaction;
  }

  @override
  Future<void> delete(String id) async {
    _items = _items.where((t) => t.id != id).toList(growable: false);
  }

  @override
  Future<void> deleteById(String id) => delete(id);
}

FinanceTransaction _recurringTemplate({
  required String id,
  required DateTime start,
  required RecurrenceType recurrenceType,
  int interval = 1,
  DateTime? end,
  DateTime? lastExecutedAt,
}) {
  final created = DateTime(2026, 1, 1, 12);
  return FinanceTransaction(
    id: id,
    type: TransactionType.expense,
    status: TransactionStatus.posted,
    accountId: 'a1',
    categoryId: 'c1',
    amount: const Money(currencyCode: 'INR', amountMinor: 1000, scale: 2),
    currencyCode: 'INR',
    occurredAt: start,
    createdAt: created,
    updatedAt: created,
    lastExecutedAt: lastExecutedAt,
    recurrenceType: recurrenceType,
    recurrenceInterval: interval,
    recurrenceEndAt: end,
  );
}

String _occId(String templateId, DateTime dateOnly) {
  final d = DateUtils.dateOnly(dateOnly);
  final mm = d.month.toString().padLeft(2, '0');
  final dd = d.day.toString().padLeft(2, '0');
  return 'occ_${templateId}_${d.year}$mm$dd';
}

void main() {
  group('RecurringTransactionExecutionService', () {
    test('daily backfills from start through today and updates lastExecutedAt', () async {
      final templateId = 'tpl_daily';
      final repo = _FakeTransactionRepository(<FinanceTransaction>[
        _recurringTemplate(
          id: templateId,
          start: DateTime(2026, 1, 1, 9, 30),
          recurrenceType: RecurrenceType.daily,
        ),
      ]);

      final service = RecurringTransactionExecutionService(transactionRepository: repo);

      final result = await service.executeDueRecurringTemplates(now: DateTime(2026, 1, 4, 8));
      expect(result.inserted, 4);
      expect(result.templatesUpdated, 1);

      final template = await repo.getById(templateId);
      expect(DateUtils.dateOnly(template!.lastExecutedAt!), DateTime(2026, 1, 4));

      for (final day in <int>[1, 2, 3, 4]) {
        final id = _occId(templateId, DateTime(2026, 1, day));
        final occ = await repo.getById(id);
        expect(occ, isNotNull);
        expect(occ!.status, TransactionStatus.posted);
        expect(occ.recurrenceType, isNull);
        expect(DateUtils.dateOnly(occ.occurredAt), DateTime(2026, 1, day));
        expect(occ.occurredAt.hour, 9);
        expect(occ.occurredAt.minute, 30);
      }

      // Idempotent re-run.
      final result2 = await service.executeDueRecurringTemplates(now: DateTime(2026, 1, 4, 12));
      expect(result2.inserted, 0);
      expect(result2.templatesUpdated, 0);
    });

    test('weekly honors interval and backfills correctly', () async {
      final templateId = 'tpl_weekly';
      final repo = _FakeTransactionRepository(<FinanceTransaction>[
        _recurringTemplate(
          id: templateId,
          start: DateTime(2026, 1, 1, 10),
          recurrenceType: RecurrenceType.weekly,
          interval: 2,
        ),
      ]);

      final service = RecurringTransactionExecutionService(transactionRepository: repo);

      // 2026-01-29 is 4 weeks after 2026-01-01.
      final result = await service.executeDueRecurringTemplates(now: DateTime(2026, 1, 29, 8));
      expect(result.inserted, 3);

      final expectedDates = <DateTime>[DateTime(2026, 1, 1), DateTime(2026, 1, 15), DateTime(2026, 1, 29)];
      for (final d in expectedDates) {
        final id = _occId(templateId, d);
        expect(await repo.getById(id), isNotNull);
      }

      final template = await repo.getById(templateId);
      expect(DateUtils.dateOnly(template!.lastExecutedAt!), DateTime(2026, 1, 29));
    });

    test('monthly clamps day-of-month but keeps anchor (Jan 31 -> Feb 28 -> Mar 31)', () async {
      final templateId = 'tpl_monthly';
      final repo = _FakeTransactionRepository(<FinanceTransaction>[
        _recurringTemplate(
          id: templateId,
          start: DateTime(2026, 1, 31, 9),
          recurrenceType: RecurrenceType.monthly,
        ),
      ]);

      final service = RecurringTransactionExecutionService(transactionRepository: repo);

      final result = await service.executeDueRecurringTemplates(now: DateTime(2026, 3, 31, 8));
      expect(result.inserted, 3);

      expect(await repo.getById(_occId(templateId, DateTime(2026, 1, 31))), isNotNull);
      expect(await repo.getById(_occId(templateId, DateTime(2026, 2, 28))), isNotNull);
      expect(await repo.getById(_occId(templateId, DateTime(2026, 3, 31))), isNotNull);

      final template = await repo.getById(templateId);
      expect(DateUtils.dateOnly(template!.lastExecutedAt!), DateTime(2026, 3, 31));
    });

    test('yearly clamps invalid dates (Feb 29 -> Feb 28)', () async {
      final templateId = 'tpl_yearly';
      final repo = _FakeTransactionRepository(<FinanceTransaction>[
        _recurringTemplate(
          id: templateId,
          start: DateTime(2024, 2, 29, 9),
          recurrenceType: RecurrenceType.yearly,
        ),
      ]);

      final service = RecurringTransactionExecutionService(transactionRepository: repo);

      final result = await service.executeDueRecurringTemplates(now: DateTime(2025, 3, 1, 8));
      expect(result.inserted, 2);

      expect(await repo.getById(_occId(templateId, DateTime(2024, 2, 29))), isNotNull);
      expect(await repo.getById(_occId(templateId, DateTime(2025, 2, 28))), isNotNull);

      final template = await repo.getById(templateId);
      expect(DateUtils.dateOnly(template!.lastExecutedAt!), DateTime(2025, 2, 28));
    });

    test('respects recurrence end date and does not execute beyond it', () async {
      final templateId = 'tpl_end';
      final repo = _FakeTransactionRepository(<FinanceTransaction>[
        _recurringTemplate(
          id: templateId,
          start: DateTime(2026, 1, 1, 9),
          recurrenceType: RecurrenceType.daily,
          end: DateTime(2026, 1, 3, 0),
        ),
      ]);

      final service = RecurringTransactionExecutionService(transactionRepository: repo);

      final result = await service.executeDueRecurringTemplates(now: DateTime(2026, 1, 10, 8));
      expect(result.inserted, 3);

      expect(await repo.getById(_occId(templateId, DateTime(2026, 1, 1))), isNotNull);
      expect(await repo.getById(_occId(templateId, DateTime(2026, 1, 2))), isNotNull);
      expect(await repo.getById(_occId(templateId, DateTime(2026, 1, 3))), isNotNull);
      expect(await repo.getById(_occId(templateId, DateTime(2026, 1, 4))), isNull);

      final template = await repo.getById(templateId);
      expect(DateUtils.dateOnly(template!.lastExecutedAt!), DateTime(2026, 1, 3));
    });
  });
}
