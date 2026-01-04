import '../models/budget.dart';

abstract class BudgetRepository {
  Stream<List<Budget>> watchAll();

  Future<Budget?> getById(String id);

  Future<void> upsert(Budget budget);

  Future<void> deleteById(String id);
}
