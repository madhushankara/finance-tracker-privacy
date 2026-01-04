import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';

import '../repositories/account_repository.dart';
import '../repositories/app_settings_repository.dart';
import '../repositories/budget_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/demo_data_repository.dart';
import '../repositories/goal_repository.dart';
import '../repositories/impl/account_repository_impl.dart';
import '../repositories/impl/app_settings_repository_impl.dart';
import '../repositories/impl/budget_repository_impl.dart';
import '../repositories/impl/category_repository_impl.dart';
import '../repositories/impl/demo_data_repository_impl.dart';
import '../repositories/impl/goal_repository_impl.dart';
import '../repositories/impl/loan_repository_impl.dart';
import '../repositories/impl/transaction_repository_impl.dart';
import '../repositories/loan_repository.dart';
import '../repositories/transaction_repository.dart';
import 'drift_datasource_providers.dart';

/// Repository providers expose ONLY repository interfaces.
///
/// UI/features should depend on these interfaces, never Drift.
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(ref.watch(driftAccountDataSourceProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    ref.watch(driftTransactionDataSourceProvider),
  );
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final repo = CategoryRepositoryImpl(
    ref.watch(driftCategoryDataSourceProvider),
  );
  unawaited(repo.seedDefaultsIfEmpty());
  return repo;
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(driftBudgetDataSourceProvider));
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepositoryImpl(ref.watch(driftGoalDataSourceProvider));
});

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepositoryImpl(ref.watch(driftLoanDataSourceProvider));
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepositoryImpl(
    ref.watch(driftAppSettingsDataSourceProvider),
  );
});

final demoDataRepositoryProvider = Provider<DemoDataRepository>((ref) {
  return DemoDataRepositoryImpl(
    accounts: ref.watch(accountRepositoryProvider),
    categories: ref.watch(categoryRepositoryProvider),
    budgets: ref.watch(budgetRepositoryProvider),
    goals: ref.watch(goalRepositoryProvider),
    loans: ref.watch(loanRepositoryProvider),
    transactions: ref.watch(transactionRepositoryProvider),
    appSettings: ref.watch(appSettingsRepositoryProvider),
  );
});
