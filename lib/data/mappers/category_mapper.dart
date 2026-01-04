import 'package:drift/drift.dart';

import '../datasources/drift/app_database.dart';
import '../models/category.dart';

final class CategoryMapper {
  const CategoryMapper();

  Category fromRow(CategoryRow row) {
    return Category(
      id: row.id,
      name: row.name,
      type: row.type,
      parentId: row.parentId,
      iconKey: row.iconKey,
      colorHex: row.colorHex,
      archived: row.archived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  CategoriesTableCompanion toCompanion(Category category) {
    return CategoriesTableCompanion(
      id: Value(category.id),
      name: Value(category.name),
      type: Value(category.type),
      parentId: Value(category.parentId),
      iconKey: Value(category.iconKey),
      colorHex: Value(category.colorHex),
      archived: Value(category.archived),
      createdAt: Value(category.createdAt),
      updatedAt: Value(category.updatedAt),
    );
  }
}
