import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/models/account.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/providers/repository_providers.dart';

final accountsControllerProvider = AsyncNotifierProvider.autoDispose<AccountsController, void>(
  AccountsController.new,
);

final class AccountsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createAccount({
    required String name,
    required AccountType type,
    required String currencyCode,
    required Money openingBalance,
  }) async {
    state = const AsyncLoading();
    try {
      final now = DateTime.now();
      final id = IdGenerator.newId();

      final account = Account(
        id: id,
        name: name,
        type: type,
        currencyCode: currencyCode,
        openingBalance: openingBalance,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(accountRepositoryProvider).upsert(account);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateAccount({
    required Account existing,
    required String name,
    required AccountType type,
  }) async {
    state = const AsyncLoading();
    try {
      final updated = existing.copyWith(
        name: name,
        type: type,
        updatedAt: DateTime.now(),
      );
      await ref.read(accountRepositoryProvider).upsert(updated);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteAccount({required String accountId}) async {
    state = const AsyncLoading();
    try {
      await ref.read(accountRepositoryProvider).deleteById(accountId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
