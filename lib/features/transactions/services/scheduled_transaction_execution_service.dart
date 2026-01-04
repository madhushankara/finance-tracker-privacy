import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/providers/repository_providers.dart';
import '../../../data/repositories/transaction_repository.dart';

/// Executes one-time scheduled transactions by converting them into normal posted transactions
/// when their scheduled date is reached.
///
/// Scope:
/// - Scheduled only (status == scheduled)
/// - Due if occurredAt (date-only) <= today
/// - Never executes recurring templates (recurrenceType != null)
/// - Idempotent (safe to run multiple times)
/// - Updates existing rows only (no inserts)
final class ScheduledTransactionExecutionService {
  ScheduledTransactionExecutionService({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;

  final TransactionRepository _transactionRepository;

  Future<int> executeDueScheduledTransactions({DateTime? now}) async {
    final runNow = now ?? DateTime.now();
    final today = DateUtils.dateOnly(runNow);

    final all = await _transactionRepository.watchAll().first;

    final due = all.where((tx) {
      if (tx.status != TransactionStatus.scheduled) return false;
      if (tx.recurrenceType != null) return false;
      final scheduledDate = DateUtils.dateOnly(tx.occurredAt);
      return !scheduledDate.isAfter(today);
    }).toList(growable: false);

    var updated = 0;
    for (final tx in due) {
      // Idempotency: if status is already not scheduled, skip.
      if (tx.status != TransactionStatus.scheduled) continue;
      await _transactionRepository.update(
        tx.copyWith(status: TransactionStatus.posted),
      );
      updated++;
    }

    return updated;
  }
}

final scheduledTransactionExecutionServiceProvider = Provider<ScheduledTransactionExecutionService>((ref) {
  return ScheduledTransactionExecutionService(
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

/// A small coordinator to avoid overlapping runs (e.g., launch + resume back-to-back).
final class ScheduledTransactionExecutionCoordinator {
  ScheduledTransactionExecutionCoordinator(this._service);

  final ScheduledTransactionExecutionService _service;
  Future<int>? _inFlight;

  Future<int> run({DateTime? now}) {
    final existing = _inFlight;
    if (existing != null) return existing;

    final f = _service.executeDueScheduledTransactions(now: now).whenComplete(() {
      _inFlight = null;
    });
    _inFlight = f;
    return f;
  }
}

final scheduledTransactionExecutionCoordinatorProvider = Provider<ScheduledTransactionExecutionCoordinator>((ref) {
  return ScheduledTransactionExecutionCoordinator(
    ref.watch(scheduledTransactionExecutionServiceProvider),
  );
});
