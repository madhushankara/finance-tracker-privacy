import 'package:drift/drift.dart';

import '../datasources/drift/app_database.dart';
import '../models/money.dart';
import '../models/transaction.dart';

final class TransactionMapper {
  const TransactionMapper();

  FinanceTransaction fromRow(TransactionRow row) {
    return FinanceTransaction(
      id: row.id,
      type: row.type,
      status: row.status,
      accountId: row.accountId,
      toAccountId: row.toAccountId,
      categoryId: row.categoryId,
      budgetId: row.budgetId,
      amount: Money(
        currencyCode: row.currencyCode,
        amountMinor: row.amountMinor,
        scale: row.amountScale,
      ),
      currencyCode: row.currencyCode,
      occurredAt: row.occurredAt,
      title: row.title,
      note: row.note,
      merchant: row.merchant,
      reference: row.reference,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      lastExecutedAt: row.lastExecutedAt,
      recurrenceType: row.recurrenceType,
      recurrenceInterval: row.recurrenceInterval,
      recurrenceEndAt: row.recurrenceEndAt,
    );
  }

  TransactionsTableCompanion toCompanion(FinanceTransaction tx) {
    return TransactionsTableCompanion(
      id: Value(tx.id),
      type: Value(tx.type),
      status: Value(tx.status),
      accountId: Value(tx.accountId),
      toAccountId: Value(tx.toAccountId),
      categoryId: Value(tx.categoryId),
      budgetId: Value(tx.budgetId),
      currencyCode: Value(tx.amount.currencyCode),
      amountMinor: Value(tx.amount.amountMinor),
      amountScale: Value(tx.amount.scale),
      occurredAt: Value(tx.occurredAt),
      title: Value(tx.title),
      note: Value(tx.note),
      merchant: Value(tx.merchant),
      reference: Value(tx.reference),
      createdAt: Value(tx.createdAt),
      updatedAt: Value(tx.updatedAt),
      lastExecutedAt: Value(tx.lastExecutedAt),
      recurrenceType: Value(tx.recurrenceType),
      recurrenceInterval: Value(tx.recurrenceInterval),
      recurrenceEndAt: Value(tx.recurrenceEndAt),
    );
  }
}
