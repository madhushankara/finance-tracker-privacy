import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/account.dart';
import '../../../data/models/transaction.dart';
import '../../../data/providers/repository_providers.dart';

final homeAccountsProvider = StreamProvider.autoDispose<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
});

final homeRecentTransactionsProvider = StreamProvider.autoDispose<List<FinanceTransaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchRecent(limit: 5);
});
