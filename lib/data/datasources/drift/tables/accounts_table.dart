part of '../app_database.dart';

@DataClassName('AccountRow')
class AccountsTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get type => intEnum<AccountType>()();

  TextColumn get currencyCode => text()();

  IntColumn get openingBalanceMinor => integer()();

  IntColumn get openingBalanceScale => integer()();

  TextColumn get institution => text().nullable()();

  TextColumn get note => text().nullable()();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
