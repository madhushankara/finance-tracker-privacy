import '../models/goal.dart';

abstract class GoalRepository {
  Stream<List<Goal>> watchAll();

  Future<Goal?> getById(String id);

  Future<void> upsert(Goal goal);

  Future<void> deleteById(String id);
}
