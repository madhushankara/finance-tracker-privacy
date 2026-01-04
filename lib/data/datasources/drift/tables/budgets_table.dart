part of '../app_database.dart';

@DataClassName('BudgetRow')
class BudgetsTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get type => intEnum<BudgetType>()();

  IntColumn get amountMinor => integer()();

  IntColumn get amountScale => integer()();

  TextColumn get currencyCode => text()();

  TextColumn get categoryId => text()();

  /// Comma-separated category ids for multi-category budgets.
  ///
  /// Legacy rows may only have [categoryId] populated.
  TextColumn get categoryIdsCsv => text().withDefault(const Constant(''))();

  DateTimeColumn get startDate => dateTime().nullable()();

  DateTimeColumn get endDate => dateTime().nullable()();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
