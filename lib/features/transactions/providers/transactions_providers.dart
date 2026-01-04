import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/account.dart';
import '../../../data/models/category.dart';
import '../../../data/models/transaction.dart';
import '../../../data/providers/repository_providers.dart';

final transactionsListProvider = StreamProvider.autoDispose<List<FinanceTransaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

final transactionByIdProvider = FutureProvider.autoDispose.family<FinanceTransaction?, String>((ref, id) {
  return ref.watch(transactionRepositoryProvider).getById(id);
});

final transactionAccountsProvider = StreamProvider.autoDispose<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
});

final transactionCategoriesProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});
