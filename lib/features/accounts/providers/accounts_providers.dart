import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/account.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';
import '../../../data/providers/repository_providers.dart';
import '../../transactions/providers/transactions_providers.dart';

final accountsListProvider = StreamProvider.autoDispose<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
});

final accountByIdProvider = FutureProvider.autoDispose.family<Account?, String>(
  (ref, id) {
    return ref.watch(accountRepositoryProvider).getById(id);
  },
);

final accountBalancesProvider =
    Provider.autoDispose<AsyncValue<Map<String, Money>>>((ref) {
      final accountsAsync = ref.watch(accountsListProvider);
      final txAsync = ref.watch(transactionsListProvider);

      if (accountsAsync.isLoading || txAsync.isLoading) {
        return const AsyncLoading();
      }

      final accountsErr = accountsAsync.error;
      if (accountsErr != null) {
        return AsyncError(
          accountsErr,
          accountsAsync.stackTrace ?? StackTrace.current,
        );
      }

      final txErr = txAsync.error;
      if (txErr != null) {
        return AsyncError(txErr, txAsync.stackTrace ?? StackTrace.current);
      }

      final accounts = accountsAsync.value ?? const <Account>[];
      final txs = txAsync.value ?? const <FinanceTransaction>[];

      final balances = <String, Money>{};
      for (final a in accounts) {
        balances[a.id] = _computeBalance(account: a, transactions: txs);
      }

      return AsyncData<Map<String, Money>>(balances);
    });

Money _computeBalance({
  required Account account,
  required List<FinanceTransaction> transactions,
}) {
  var runningMinor = account.openingBalance.amountMinor;
  final currency = account.openingBalance.currencyCode;
  final scale = account.openingBalance.scale;

  for (final tx in transactions) {
    if (tx.status != TransactionStatus.posted) continue;
    if (tx.recurrenceType != null) continue; // templates
    if (tx.amount.currencyCode != currency) continue;
    if (tx.amount.scale != scale) continue;

    final minor = tx.amount.amountMinor;

    switch (tx.type) {
      case TransactionType.expense:
        if (tx.accountId == account.id) runningMinor -= minor;
        break;
      case TransactionType.income:
        if (tx.accountId == account.id) runningMinor += minor;
        break;
      case TransactionType.transfer:
        if (tx.accountId == account.id) runningMinor -= minor;
        if (tx.toAccountId == account.id) runningMinor += minor;
        break;
    }
  }

  return Money(currencyCode: currency, amountMinor: runningMinor, scale: scale);
}
