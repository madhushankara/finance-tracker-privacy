import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/account.dart';
import '../../../data/models/budget.dart';
import '../../../data/models/category.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';
import '../../../data/providers/repository_providers.dart';
import '../services/budget_status_calculator.dart';

final budgetsListProvider = StreamProvider.autoDispose<List<Budget>>((ref) {
  return ref.watch(budgetRepositoryProvider).watchAll();
});

final budgetCategoriesProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});

final budgetAccountsProvider = StreamProvider.autoDispose<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
});

final budgetTransactionsProvider = StreamProvider.autoDispose<List<FinanceTransaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

final budgetProgressListProvider = Provider.autoDispose<AsyncValue<List<BudgetWithProgress>>>((ref) {
  final budgets = ref.watch(budgetsListProvider);
  final transactions = ref.watch(budgetTransactionsProvider);
  const calc = BudgetStatusCalculator();

  return budgets.when(
    data: (budgetList) {
      return transactions.when(
        data: (txList) {
          final items = budgetList
              .where((b) => !b.archived)
              .map((b) => BudgetWithProgress(
                    budget: b,
                    status: calc.compute(budget: b, transactions: txList),
                  ))
              .toList(growable: false);
          return AsyncValue.data(items);
        },
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

final budgetWithProgressProvider = Provider.autoDispose.family<AsyncValue<BudgetWithProgress?>, String>((ref, budgetId) {
  final list = ref.watch(budgetProgressListProvider);
  return list.when(
    data: (items) {
      BudgetWithProgress? found;
      for (final item in items) {
        if (item.budget.id == budgetId) {
          found = item;
          break;
        }
      }
      return AsyncValue.data(found);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

final class BudgetWithProgress {
  const BudgetWithProgress({required this.budget, required this.status});

  final Budget budget;
  final BudgetStatus status;

  Money get remaining {
    return status.remaining;
  }

  double get progressFraction {
    final f = status.percentageUsed;
    if (f.isNaN || f.isInfinite) return 0;
    if (f < 0) return 0;
    if (f > 1) return 1;
    return f;
  }

  double get percentageUsed => status.percentageUsed;
  bool get isNearLimit => status.isNearLimit;
  bool get isExceeded => status.isExceeded;
  Money get spent => status.spent;
}
