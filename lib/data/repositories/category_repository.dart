import '../models/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchAll();

  /// Inserts a set of default categories once, if the table is empty.
  Future<void> seedDefaultsIfEmpty();

  /// Returns how many direct subcategories a category has.
  Future<int> countChildren(String parentId);

  Future<Category?> getById(String id);

  Future<void> upsert(Category category);

  Future<void> deleteById(String id);
}
