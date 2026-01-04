part of '../app_database.dart';

@DataClassName('GoalRow')
class GoalsTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get currencyCode => text()();

  IntColumn get targetMinor => integer()();

  IntColumn get targetScale => integer()();

  IntColumn get savedMinor => integer().nullable()();

  IntColumn get savedScale => integer().nullable()();

  DateTimeColumn get targetDate => dateTime().nullable()();

  TextColumn get note => text().nullable()();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
