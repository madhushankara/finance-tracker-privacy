import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/drift/datasources/drift_account_datasource.dart';
import '../datasources/drift/datasources/drift_app_settings_datasource.dart';
import '../datasources/drift/datasources/drift_budget_datasource.dart';
import '../datasources/drift/datasources/drift_category_datasource.dart';
import '../datasources/drift/datasources/drift_goal_datasource.dart';
import '../datasources/drift/datasources/drift_loan_datasource.dart';
import '../datasources/drift/datasources/drift_transaction_datasource.dart';
import 'database_provider.dart';

final driftAccountDataSourceProvider = Provider<DriftAccountDataSource>((ref) {
  return DriftAccountDataSource(ref.watch(appDatabaseProvider));
});

final driftTransactionDataSourceProvider =
    Provider<DriftTransactionDataSource>((ref) {
  return DriftTransactionDataSource(ref.watch(appDatabaseProvider));
});

final driftCategoryDataSourceProvider = Provider<DriftCategoryDataSource>((ref) {
  return DriftCategoryDataSource(ref.watch(appDatabaseProvider));
});

final driftBudgetDataSourceProvider = Provider<DriftBudgetDataSource>((ref) {
  return DriftBudgetDataSource(ref.watch(appDatabaseProvider));
});

final driftGoalDataSourceProvider = Provider<DriftGoalDataSource>((ref) {
  return DriftGoalDataSource(ref.watch(appDatabaseProvider));
});

final driftLoanDataSourceProvider = Provider<DriftLoanDataSource>((ref) {
  return DriftLoanDataSource(ref.watch(appDatabaseProvider));
});

final driftAppSettingsDataSourceProvider = Provider<DriftAppSettingsDataSource>((ref) {
  return DriftAppSettingsDataSource(ref.watch(appDatabaseProvider));
});
