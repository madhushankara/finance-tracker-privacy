import '../../datasources/drift/datasources/drift_transaction_datasource.dart';
import '../../models/transaction.dart';
import '../transaction_repository.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._dataSource);

  final DriftTransactionDataSource _dataSource;

  @override
  Stream<List<FinanceTransaction>> watchAll() => _dataSource.watchAll();

  @override
  Stream<List<FinanceTransaction>> watchRecent({required int limit}) {
    return _dataSource.watchRecent(limit: limit);
  }

  @override
  Future<FinanceTransaction?> getById(String id) => _dataSource.getById(id);

  @override
  Future<void> upsert(FinanceTransaction transaction) => _dataSource.upsert(transaction);

  @override
  Future<bool> insertIfAbsent(FinanceTransaction transaction) => _dataSource.insertIfAbsent(transaction);

  @override
  Future<void> update(FinanceTransaction transaction) => _dataSource.upsert(transaction);

  @override
  Future<void> delete(String id) => _dataSource.deleteById(id);

  @override
  Future<void> deleteById(String id) => _dataSource.deleteById(id);
}
