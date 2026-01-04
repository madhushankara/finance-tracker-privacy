import 'package:drift/drift.dart';

import '../../../mappers/transaction_mapper.dart';
import '../../../models/transaction.dart';
import '../app_database.dart';

final class DriftTransactionDataSource {
  DriftTransactionDataSource(this._db, {TransactionMapper? mapper})
      : _mapper = mapper ?? const TransactionMapper();

  final AppDatabase _db;
  final TransactionMapper _mapper;

  Stream<List<FinanceTransaction>> watchAll() {
    return (_db.select(_db.transactionsTable)
          ..orderBy(<OrderingTerm Function(TransactionsTable)>[
            (t) => OrderingTerm.desc(t.occurredAt),
          ]))
        .watch()
        .map((rows) => rows.map(_mapper.fromRow).toList(growable: false));
  }

  Stream<List<FinanceTransaction>> watchRecent({required int limit}) {
    return (_db.select(_db.transactionsTable)
          ..orderBy(<OrderingTerm Function(TransactionsTable)>[
            (t) => OrderingTerm.desc(t.occurredAt),
          ])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_mapper.fromRow).toList(growable: false));
  }

  Future<FinanceTransaction?> getById(String id) async {
    final row = await (_db.select(_db.transactionsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapper.fromRow(row);
  }

  Future<void> upsert(FinanceTransaction tx) async {
    await _db.into(_db.transactionsTable).insertOnConflictUpdate(
          _mapper.toCompanion(tx),
        );
  }

  Future<bool> insertIfAbsent(FinanceTransaction tx) async {
    final rowId = await _db.into(_db.transactionsTable).insert(
          _mapper.toCompanion(tx),
          mode: InsertMode.insertOrIgnore,
        );
    return rowId != 0;
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(_db.transactionsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
