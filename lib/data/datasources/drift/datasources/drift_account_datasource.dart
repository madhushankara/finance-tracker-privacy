import 'package:drift/drift.dart';

import '../../../mappers/account_mapper.dart';
import '../../../models/account.dart';
import '../app_database.dart';

final class DriftAccountDataSource {
  DriftAccountDataSource(this._db, {AccountMapper? mapper})
      : _mapper = mapper ?? const AccountMapper();

  final AppDatabase _db;
  final AccountMapper _mapper;

  Stream<List<Account>> watchAll() {
    return (_db.select(_db.accountsTable)
          ..orderBy(<OrderingTerm Function(AccountsTable)>[
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_mapper.fromRow).toList(growable: false));
  }

  Future<Account?> getById(String id) async {
    final row = await (_db.select(_db.accountsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapper.fromRow(row);
  }

  Future<void> upsert(Account account) async {
    await _db.into(_db.accountsTable).insertOnConflictUpdate(
          _mapper.toCompanion(account),
        );
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(_db.accountsTable)..where((t) => t.id.equals(id))).go();
  }
}
