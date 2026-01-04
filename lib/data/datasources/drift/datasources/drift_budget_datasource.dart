import 'package:drift/drift.dart';

import '../../../mappers/budget_mapper.dart';
import '../../../models/budget.dart';
import '../app_database.dart';

final class DriftBudgetDataSource {
  DriftBudgetDataSource(this._db, {BudgetMapper? mapper})
      : _mapper = mapper ?? const BudgetMapper();

  final AppDatabase _db;
  final BudgetMapper _mapper;

  Stream<List<Budget>> watchAll() {
    return (_db.select(_db.budgetsTable)
          ..orderBy(<OrderingTerm Function(BudgetsTable)>[
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_mapper.fromRow).toList(growable: false));
  }

  Future<Budget?> getById(String id) async {
    final row = await (_db.select(_db.budgetsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapper.fromRow(row);
  }

  Future<void> upsert(Budget budget) async {
    await _db.into(_db.budgetsTable).insertOnConflictUpdate(
          _mapper.toCompanion(budget),
        );
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(_db.budgetsTable)..where((t) => t.id.equals(id))).go();
  }
}
