import 'package:drift/drift.dart';

import '../../../mappers/category_mapper.dart';
import '../../../models/category.dart';
import '../app_database.dart';

final class DriftCategoryDataSource {
  DriftCategoryDataSource(this._db, {CategoryMapper? mapper})
    : _mapper = mapper ?? const CategoryMapper();

  final AppDatabase _db;
  final CategoryMapper _mapper;

  Stream<List<Category>> watchAll() {
    return (_db.select(_db.categoriesTable)
          ..orderBy(<OrderingTerm Function(CategoriesTable)>[
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_mapper.fromRow).toList(growable: false));
  }

  Future<int> countAll() async {
    final countExp = _db.categoriesTable.id.count();
    final query = _db.selectOnly(_db.categoriesTable)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<int> countChildren(String parentId) async {
    final countExp = _db.categoriesTable.id.count();
    final query = _db.selectOnly(_db.categoriesTable)
      ..addColumns([countExp])
      ..where(_db.categoriesTable.parentId.equals(parentId));

    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<Category?> getById(String id) async {
    final row = await (_db.select(
      _db.categoriesTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapper.fromRow(row);
  }

  Future<void> upsert(Category category) async {
    await _db
        .into(_db.categoriesTable)
        .insertOnConflictUpdate(_mapper.toCompanion(category));
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(_db.categoriesTable)..where((t) => t.id.equals(id))).go();
  }
}
