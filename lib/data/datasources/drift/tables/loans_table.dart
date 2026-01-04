part of '../app_database.dart';

@DataClassName('LoanRow')
class LoansTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get type => intEnum<LoanType>()();

  TextColumn get currencyCode => text()();

  IntColumn get principalMinor => integer()();

  IntColumn get principalScale => integer()();

  IntColumn get interestAprBps => integer().nullable()();

  TextColumn get lender => text().nullable()();

  DateTimeColumn get startDate => dateTime().nullable()();

  IntColumn get termMonths => integer().nullable()();

  TextColumn get note => text().nullable()();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
