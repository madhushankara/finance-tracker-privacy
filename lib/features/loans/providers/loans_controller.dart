import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/loan.dart';
import '../../../data/models/money.dart';
import '../../../data/providers/repository_providers.dart';

final loansControllerProvider =
    AsyncNotifierProvider.autoDispose<LoansController, void>(
      LoansController.new,
    );

final class LoansController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createLoan({
    required String counterpartyName,
    required Money amount,
    required bool isLongTerm,
    required String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final name = counterpartyName.trim();
      if (name.isEmpty) {
        throw const FormatException('Counterparty name is required');
      }
      if (amount.amountMinor <= 0) {
        throw const FormatException('Amount must be > 0');
      }

      final now = DateTime.now();
      final loan = Loan(
        id: IdGenerator.newId(),
        name: name,
        type: LoanType.other,
        currencyCode: amount.currencyCode,
        principal: amount,
        interestAprBps: null,
        lender: null,
        startDate: null,
        termMonths: isLongTerm ? 12 : null,
        note: notes?.trim().isEmpty ?? true ? null : notes!.trim(),
        archived: false,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(loanRepositoryProvider).upsert(loan);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateLoan({
    required Loan existing,
    required String counterpartyName,
    required Money amount,
    required bool isLongTerm,
    required String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final name = counterpartyName.trim();
      if (name.isEmpty) {
        throw const FormatException('Counterparty name is required');
      }
      if (amount.amountMinor <= 0) {
        throw const FormatException('Amount must be > 0');
      }

      final updated = existing.copyWith(
        name: name,
        currencyCode: amount.currencyCode,
        principal: amount,
        termMonths: isLongTerm ? (existing.termMonths ?? 12) : null,
        note: notes?.trim().isEmpty ?? true ? null : notes!.trim(),
        updatedAt: DateTime.now(),
      );

      await ref.read(loanRepositoryProvider).upsert(updated);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteLoan({required String loanId}) async {
    state = const AsyncLoading();
    try {
      await ref.read(loanRepositoryProvider).deleteById(loanId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
