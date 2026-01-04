import 'package:drift/drift.dart';

import '../../../mappers/loan_mapper.dart';
import '../../../models/loan.dart';
import '../app_database.dart';

final class DriftLoanDataSource {
  DriftLoanDataSource(this._db, {LoanMapper? mapper})
      : _mapper = mapper ?? const LoanMapper();

  final AppDatabase _db;
  final LoanMapper _mapper;

  Stream<List<Loan>> watchAll() {
    return (_db.select(_db.loansTable)
          ..orderBy(<OrderingTerm Function(LoansTable)>[
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_mapper.fromRow).toList(growable: false));
  }

  Future<Loan?> getById(String id) async {
    final row = await (_db.select(_db.loansTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapper.fromRow(row);
  }

  Future<void> upsert(Loan loan) async {
    await _db.into(_db.loansTable).insertOnConflictUpdate(
          _mapper.toCompanion(loan),
        );
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(_db.loansTable)..where((t) => t.id.equals(id))).go();
  }
}
