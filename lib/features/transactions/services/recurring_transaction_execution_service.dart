import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/transaction.dart';
import '../../../data/providers/repository_providers.dart';
import '../../../data/repositories/transaction_repository.dart';

final class RecurringExecutionResult {
  const RecurringExecutionResult({required this.inserted, required this.templatesUpdated});

  final int inserted;
  final int templatesUpdated;
}

/// Materializes occurrences for recurring templates.
///
/// Scope:
/// - Recurring templates only (recurrenceType != null)
/// - Inserts posted occurrences (recurrenceType null)
/// - Updates template.lastExecutedAt (date-only) when progress is made
/// - Idempotent (deterministic occurrence ids + insert-or-ignore)
/// - Triggered only via app launch/resume (no background services)
final class RecurringTransactionExecutionService {
  RecurringTransactionExecutionService({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;

  final TransactionRepository _transactionRepository;

  Future<RecurringExecutionResult> executeDueRecurringTemplates({DateTime? now}) async {
    final runNow = now ?? DateTime.now();
    final today = DateUtils.dateOnly(runNow);

    final all = await _transactionRepository.watchAll().first;
    final templates = all.where((t) => t.recurrenceType != null).toList(growable: false);

    var inserted = 0;
    var templatesUpdated = 0;

    for (final template in templates) {
      final type = template.recurrenceType;
      if (type == null) continue;

      final start = DateUtils.dateOnly(template.occurredAt);
      final end = template.recurrenceEndAt == null ? null : DateUtils.dateOnly(template.recurrenceEndAt!);

      final effectiveEnd = end == null || end.isAfter(today) ? today : end;
      if (start.isAfter(effectiveEnd)) {
        continue;
      }

      final interval = template.recurrenceInterval < 1 ? 1 : template.recurrenceInterval;

      final lastExecuted = template.lastExecutedAt == null ? null : DateUtils.dateOnly(template.lastExecutedAt!);
      DateTime next = lastExecuted == null
          ? start
          : _nextOccurrenceDate(type: type, start: start, current: lastExecuted, interval: interval);

      DateTime? latestExecuted;
      while (!next.isAfter(effectiveEnd)) {
        final occurrenceId = _occurrenceId(templateId: template.id, occurrenceDate: next);
        final occurredAt = _withTemplateTime(templateTime: template.occurredAt, dateOnly: next);

        final occurrence = FinanceTransaction(
          id: occurrenceId,
          type: template.type,
          status: TransactionStatus.posted,
          accountId: template.accountId,
          toAccountId: template.toAccountId,
          categoryId: template.categoryId,
          budgetId: template.budgetId,
          amount: template.amount,
          currencyCode: template.currencyCode,
          occurredAt: occurredAt,
          title: template.title,
          note: template.note,
          merchant: template.merchant,
          reference: template.reference,
          createdAt: runNow,
          updatedAt: runNow,
          lastExecutedAt: null,
          recurrenceType: null,
          recurrenceInterval: 1,
          recurrenceEndAt: null,
        );

        final didInsert = await _transactionRepository.insertIfAbsent(occurrence);
        if (didInsert) {
          inserted++;
        }

        latestExecuted = next;
        next = _nextOccurrenceDate(type: type, start: start, current: next, interval: interval);
      }

      if (latestExecuted != null) {
        final normalizedLatest = DateUtils.dateOnly(latestExecuted);
        final existingLatest = lastExecuted;
        final shouldUpdate = existingLatest == null || normalizedLatest.isAfter(existingLatest);

        if (shouldUpdate) {
          await _transactionRepository.update(
            template.copyWith(
              lastExecutedAt: normalizedLatest,
              updatedAt: runNow,
            ),
          );
          templatesUpdated++;
        }
      }
    }

    return RecurringExecutionResult(inserted: inserted, templatesUpdated: templatesUpdated);
  }

  static String _occurrenceId({required String templateId, required DateTime occurrenceDate}) {
    final d = DateUtils.dateOnly(occurrenceDate);
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return 'occ_${templateId}_${d.year}$mm$dd';
  }

  static DateTime _withTemplateTime({required DateTime templateTime, required DateTime dateOnly}) {
    return DateTime(
      dateOnly.year,
      dateOnly.month,
      dateOnly.day,
      templateTime.hour,
      templateTime.minute,
      templateTime.second,
      templateTime.millisecond,
      templateTime.microsecond,
    );
  }

  static DateTime _nextOccurrenceDate({
    required RecurrenceType type,
    required DateTime start,
    required DateTime current,
    required int interval,
  }) {
    final safeInterval = interval < 1 ? 1 : interval;

    switch (type) {
      case RecurrenceType.daily:
        return current.add(Duration(days: safeInterval));
      case RecurrenceType.weekly:
        return current.add(Duration(days: 7 * safeInterval));
      case RecurrenceType.monthly:
        final monthsDiff = (current.year - start.year) * 12 + (current.month - start.month);
        return _dateForMonthOffset(start: start, monthOffset: monthsDiff + safeInterval);
      case RecurrenceType.yearly:
        final yearsDiff = current.year - start.year;
        return _dateForYearOffset(start: start, yearOffset: yearsDiff + safeInterval);
    }
  }

  static DateTime _dateForMonthOffset({required DateTime start, required int monthOffset}) {
    final startMonthIndex = start.year * 12 + (start.month - 1);
    final targetMonthIndex = startMonthIndex + monthOffset;
    final year = targetMonthIndex ~/ 12;
    final month = (targetMonthIndex % 12) + 1;

    final lastDay = DateTime(year, month + 1, 0).day;
    final day = start.day > lastDay ? lastDay : start.day;
    return DateTime(year, month, day);
  }

  static DateTime _dateForYearOffset({required DateTime start, required int yearOffset}) {
    final year = start.year + yearOffset;
    final month = start.month;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = start.day > lastDay ? lastDay : start.day;
    return DateTime(year, month, day);
  }
}

final recurringTransactionExecutionServiceProvider = Provider<RecurringTransactionExecutionService>((ref) {
  return RecurringTransactionExecutionService(
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

/// A small coordinator to avoid overlapping runs (e.g., launch + resume back-to-back).
final class RecurringTransactionExecutionCoordinator {
  RecurringTransactionExecutionCoordinator(this._service);

  final RecurringTransactionExecutionService _service;
  Future<RecurringExecutionResult>? _inFlight;

  Future<RecurringExecutionResult> run({DateTime? now}) {
    final existing = _inFlight;
    if (existing != null) return existing;

    final f = _service.executeDueRecurringTemplates(now: now).whenComplete(() {
      _inFlight = null;
    });
    _inFlight = f;
    return f;
  }
}

final recurringTransactionExecutionCoordinatorProvider = Provider<RecurringTransactionExecutionCoordinator>((ref) {
  return RecurringTransactionExecutionCoordinator(
    ref.watch(recurringTransactionExecutionServiceProvider),
  );
});
