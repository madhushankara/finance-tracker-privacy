part of '../app_database.dart';

@DataClassName('TransactionRow')
class TransactionsTable extends Table {
  TextColumn get id => text()();

  IntColumn get type => intEnum<TransactionType>()();

  IntColumn get status => intEnum<TransactionStatus>()();

  TextColumn get accountId => text()();

  TextColumn get toAccountId => text().nullable()();

  TextColumn get categoryId => text().nullable()();

  TextColumn get budgetId => text().nullable()();

  TextColumn get currencyCode => text()();

  IntColumn get amountMinor => integer()();

  IntColumn get amountScale => integer()();

  DateTimeColumn get occurredAt => dateTime()();

  TextColumn get title => text().nullable()();

  TextColumn get note => text().nullable()();

  TextColumn get merchant => text().nullable()();

  TextColumn get reference => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get lastExecutedAt => dateTime().nullable()();

  IntColumn get recurrenceType => intEnum<RecurrenceType>().nullable()();

  IntColumn get recurrenceInterval => integer().withDefault(const Constant(1))();

  DateTimeColumn get recurrenceEndAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
