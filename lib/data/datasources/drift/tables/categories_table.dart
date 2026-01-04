part of '../app_database.dart';

@DataClassName('CategoryRow')
class CategoriesTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get type => intEnum<CategoryType>()();

  TextColumn get parentId => text().nullable()();

  TextColumn get iconKey => text().nullable()();

  IntColumn get colorHex => integer().nullable()();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
