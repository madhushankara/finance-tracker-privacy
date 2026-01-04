import '../../datasources/drift/datasources/drift_account_datasource.dart';
import '../../models/account.dart';
import '../account_repository.dart';

final class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._dataSource);

  final DriftAccountDataSource _dataSource;

  @override
  Stream<List<Account>> watchAll() => _dataSource.watchAll();

  @override
  Future<Account?> getById(String id) => _dataSource.getById(id);

  @override
  Future<void> upsert(Account account) => _dataSource.upsert(account);

  @override
  Future<void> deleteById(String id) => _dataSource.deleteById(id);
}
