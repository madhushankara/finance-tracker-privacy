import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/data/models/enums.dart';
import 'package:finance_tracker/data/models/money.dart';
import 'package:finance_tracker/data/models/transaction.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/services/scheduled_transaction_execution_service.dart';

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

FinanceTransaction _tx({
  required String id,
  required TransactionStatus status,
  required DateTime occurredAt,
  RecurrenceType? recurrenceType,
}) {
  final now = DateTime(2026, 1, 1, 12);
  return FinanceTransaction(
    id: id,
    type: TransactionType.expense,
    status: status,
    accountId: 'a1',
    amount: const Money(currencyCode: 'INR', amountMinor: 1234, scale: 2),
    currencyCode: 'INR',
    occurredAt: occurredAt,
    createdAt: now,
    updatedAt: now,
    lastExecutedAt: null,
    categoryId: 'c1',
    recurrenceType: recurrenceType,
  );
}

void main() {
  group('ScheduledTransactionExecutionService', () {
    test('executes due scheduled transactions exactly once (idempotent)', () async {
      final repo = _FakeTransactionRepository(<FinanceTransaction>[
        _tx(
          id: 'due1',
          status: TransactionStatus.scheduled,
          occurredAt: DateTime(2026, 1, 2, 9),
        ),
        _tx(
          id: 'future1',
          status: TransactionStatus.scheduled,
          occurredAt: DateTime(2026, 1, 4, 9),
        ),
        _tx(
          id: 'posted1',
          status: TransactionStatus.posted,
          occurredAt: DateTime(2026, 1, 2, 9),
        ),
        _tx(
          id: 'recurringTemplate',
          status: TransactionStatus.scheduled,
          occurredAt: DateTime(2026, 1, 2, 9),
          recurrenceType: RecurrenceType.monthly,
        ),
      ]);

      final service = ScheduledTransactionExecutionService(transactionRepository: repo);

      final updated1 = await service.executeDueScheduledTransactions(now: DateTime(2026, 1, 3, 8));
      expect(updated1, 1);

      final due1 = await repo.getById('due1');
      expect(due1?.status, TransactionStatus.posted);

      final future1 = await repo.getById('future1');
      expect(future1?.status, TransactionStatus.scheduled);

      final recurring = await repo.getById('recurringTemplate');
      expect(recurring?.status, TransactionStatus.scheduled);

      // Run again; should do nothing.
      final updated2 = await service.executeDueScheduledTransactions(now: DateTime(2026, 1, 3, 12));
      expect(updated2, 0);

      final due1Again = await repo.getById('due1');
      expect(due1Again?.status, TransactionStatus.posted);
    });
  });
}
