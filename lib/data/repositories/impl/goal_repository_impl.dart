import '../../datasources/drift/datasources/drift_goal_datasource.dart';
import '../../models/goal.dart';
import '../goal_repository.dart';

final class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl(this._dataSource);

  final DriftGoalDataSource _dataSource;

  @override
  Stream<List<Goal>> watchAll() => _dataSource.watchAll();

  @override
  Future<Goal?> getById(String id) => _dataSource.getById(id);

  @override
  Future<void> upsert(Goal goal) => _dataSource.upsert(goal);

  @override
  Future<void> deleteById(String id) => _dataSource.deleteById(id);
}
