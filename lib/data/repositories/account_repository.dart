import '../models/account.dart';

abstract class AccountRepository {
  Stream<List<Account>> watchAll();

  Future<Account?> getById(String id);

  Future<void> upsert(Account account);

  Future<void> deleteById(String id);
}
