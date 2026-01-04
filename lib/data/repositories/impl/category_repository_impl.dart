import '../../datasources/drift/datasources/drift_category_datasource.dart';
import '../../models/category.dart';
import '../../seed/default_categories.dart';
import '../category_repository.dart';

final class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._dataSource);

  final DriftCategoryDataSource _dataSource;

  @override
  Stream<List<Category>> watchAll() => _dataSource.watchAll();

  @override
  Future<void> seedDefaultsIfEmpty() async {
    final count = await _dataSource.countAll();
    if (count == 0) {
      final now = DateTime.now();
      final defaults = buildDefaultCategories(now);
      for (final category in defaults) {
        await upsert(category);
      }
      return;
    }

    // Existing installs: backfill static colors for seeded defaults, but
    // do not override user-chosen colors.
    final now = DateTime.now();
    for (final entry in kDefaultCategoryColorHexById.entries) {
      final existing = await _dataSource.getById(entry.key);
      if (existing == null) continue;
      if (existing.colorHex != null) continue;

      await upsert(existing.copyWith(colorHex: entry.value, updatedAt: now));
    }
  }

  @override
  Future<int> countChildren(String parentId) =>
      _dataSource.countChildren(parentId);

  @override
  Future<Category?> getById(String id) => _dataSource.getById(id);

  @override
  Future<void> upsert(Category category) => _dataSource.upsert(category);

  @override
  Future<void> deleteById(String id) => _dataSource.deleteById(id);
}
