import 'package:drift/drift.dart';

import '../../../mappers/goal_mapper.dart';
import '../../../models/goal.dart';
import '../app_database.dart';

final class DriftGoalDataSource {
  DriftGoalDataSource(this._db, {GoalMapper? mapper})
      : _mapper = mapper ?? const GoalMapper();

  final AppDatabase _db;
  final GoalMapper _mapper;

  Stream<List<Goal>> watchAll() {
    return (_db.select(_db.goalsTable)
          ..orderBy(<OrderingTerm Function(GoalsTable)>[
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_mapper.fromRow).toList(growable: false));
  }

  Future<Goal?> getById(String id) async {
    final row = await (_db.select(_db.goalsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _mapper.fromRow(row);
  }

  Future<void> upsert(Goal goal) async {
    await _db.into(_db.goalsTable).insertOnConflictUpdate(
          _mapper.toCompanion(goal),
        );
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(_db.goalsTable)..where((t) => t.id.equals(id))).go();
  }
}
