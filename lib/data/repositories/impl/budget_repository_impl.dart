import '../../datasources/drift/datasources/drift_budget_datasource.dart';
import '../../models/budget.dart';
import '../budget_repository.dart';

final class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._dataSource);

  final DriftBudgetDataSource _dataSource;

  @override
  Stream<List<Budget>> watchAll() => _dataSource.watchAll();

  @override
  Future<Budget?> getById(String id) => _dataSource.getById(id);

  @override
  Future<void> upsert(Budget budget) => _dataSource.upsert(budget);

  @override
  Future<void> deleteById(String id) => _dataSource.deleteById(id);
}
