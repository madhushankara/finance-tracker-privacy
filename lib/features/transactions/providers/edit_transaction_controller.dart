import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/providers/repository_providers.dart';

final editTransactionControllerProvider = AsyncNotifierProvider.autoDispose<EditTransactionController, void>(
	EditTransactionController.new,
);

final class EditTransactionController extends AutoDisposeAsyncNotifier<void> {
	@override
	Future<void> build() async {}

	DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

	Future<void> updateTransaction({
		required String transactionId,
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
			final repo = ref.read(transactionRepositoryProvider);

			final existing = await repo.getById(transactionId);
			if (existing == null) {
				throw StateError('Transaction not found');
			}

			if (existing.type != type) {
				throw StateError('Transaction type cannot be changed');
			}

			if (existing.currencyCode != amount.currencyCode || existing.amount.scale != amount.scale) {
				throw StateError('Currency cannot be changed');
			}

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
			} else {
				recurrenceInterval = 1;
				recurrenceEndAt = null;
			}

			final nextStatus = scheduleForLater ? TransactionStatus.scheduled : TransactionStatus.posted;

			final updated = existing.copyWith(
				accountId: accountId,
				status: nextStatus,
				toAccountId: type == TransactionType.transfer ? toAccountId : null,
				categoryId: type == TransactionType.transfer ? null : categoryId,
				amount: amount,
				currencyCode: existing.currencyCode,
				occurredAt: occurredAt,
				title: title,
				recurrenceType: recurrenceType,
				recurrenceInterval: recurrenceInterval,
				recurrenceEndAt: recurrenceEndAt,
				updatedAt: DateTime.now(),
			);

			await repo.update(updated);
			state = const AsyncData(null);
		} catch (e, st) {
			state = AsyncError(e, st);
			rethrow;
		}
	}

	Future<void> deleteTransaction({required String transactionId}) async {
		state = const AsyncLoading();
		try {
			final repo = ref.read(transactionRepositoryProvider);

			final existing = await repo.getById(transactionId);
			if (existing == null) {
				throw StateError('Transaction not found');
			}

			await repo.delete(transactionId);
			state = const AsyncData(null);
		} catch (e, st) {
			state = AsyncError(e, st);
			rethrow;
		}
	}
}


