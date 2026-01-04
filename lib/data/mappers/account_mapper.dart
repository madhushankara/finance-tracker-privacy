import 'package:drift/drift.dart';

import '../datasources/drift/app_database.dart';
import '../models/account.dart';
import '../models/money.dart';

final class AccountMapper {
  const AccountMapper();

  Account fromRow(AccountRow row) {
    return Account(
      id: row.id,
      name: row.name,
      type: row.type,
      currencyCode: row.currencyCode,
      openingBalance: Money(
        currencyCode: row.currencyCode,
        amountMinor: row.openingBalanceMinor,
        scale: row.openingBalanceScale,
      ),
      institution: row.institution,
      note: row.note,
      archived: row.archived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  AccountsTableCompanion toCompanion(Account account) {
    return AccountsTableCompanion(
      id: Value(account.id),
      name: Value(account.name),
      type: Value(account.type),
      currencyCode: Value(account.currencyCode),
      openingBalanceMinor: Value(account.openingBalance.amountMinor),
      openingBalanceScale: Value(account.openingBalance.scale),
      institution: Value(account.institution),
      note: Value(account.note),
      archived: Value(account.archived),
      createdAt: Value(account.createdAt),
      updatedAt: Value(account.updatedAt),
    );
  }
}
