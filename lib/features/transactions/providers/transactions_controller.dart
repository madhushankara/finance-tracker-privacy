import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';
import '../../../data/providers/repository_providers.dart';

final transactionsControllerProvider = AsyncNotifierProvider.autoDispose<TransactionsController, void>(
  TransactionsController.new,
);

final class TransactionsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  Future<void> createTransaction({
    required TransactionType type,
    required String accountId,
    required Money amount,
    required DateTime occurredAt,
    required bool scheduleForLater,
    RecurrenceType? recurrenceType,
    int recurrenceInterval = 1,
    DateTime? recurrenceEndAt,
    String? toAccountId,
    String? categoryId,
    String? title,
  }) async {
    state = const AsyncLoading();
    try {
      final today = _dateOnly(DateTime.now());
      final d = _dateOnly(occurredAt);
      final isRecurring = recurrenceType != null;
      final isValidDate = scheduleForLater ? d.isAfter(today) : (isRecurring ? true : !d.isAfter(today));
      if (!isValidDate) {
        throw StateError(
          scheduleForLater
              ? 'Scheduled transactions must be dated after today.'
              : 'Non-scheduled transactions cannot be dated in the future.',
        );
      }

      final now = DateTime.now();
      final id = IdGenerator.newId();

      final status = scheduleForLater ? TransactionStatus.scheduled : TransactionStatus.posted;

      if (recurrenceType != null) {
        if (recurrenceInterval < 1) {
          throw StateError('Interval must be at least 1');
        }
        if (recurrenceEndAt != null) {
          final end = _dateOnly(recurrenceEndAt);
          if (!end.isAfter(d)) {
            throw StateError('End date must be after start date');
          }
        }
      }

      final tx = FinanceTransaction(
        id: id,
        type: type,
        status: status,
        accountId: accountId,
        toAccountId: toAccountId,
        categoryId: categoryId,
        budgetId: null,
        amount: amount,
        currencyCode: amount.currencyCode,
        occurredAt: occurredAt,
        title: title,
        note: null,
        merchant: null,
        reference: null,
        createdAt: now,
        updatedAt: now,
        lastExecutedAt: null,
        recurrenceType: recurrenceType,
        recurrenceInterval: recurrenceInterval,
        recurrenceEndAt: recurrenceEndAt,
      );

      await ref.read(transactionRepositoryProvider).upsert(tx);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
