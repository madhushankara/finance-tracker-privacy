import '../models/transaction.dart';

abstract class TransactionRepository {
  Stream<List<FinanceTransaction>> watchAll();

  Stream<List<FinanceTransaction>> watchRecent({required int limit});

  Future<FinanceTransaction?> getById(String id);

  Future<void> upsert(FinanceTransaction transaction);

  /// Inserts a new transaction only if its primary key doesn't already exist.
  ///
  /// Used for idempotent materialization of recurring occurrences.
  Future<bool> insertIfAbsent(FinanceTransaction transaction);

  /// Updates an existing transaction.
  ///
  /// Implementations may delegate to [upsert], but callers should treat this as
  /// an update-only operation (i.e. the transaction must already exist).
  Future<void> update(FinanceTransaction transaction);

  Future<void> delete(String id);

  Future<void> deleteById(String id);
}
