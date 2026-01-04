import 'package:meta/meta.dart';

import 'enums.dart';
import 'money.dart';

@immutable
final class FinanceTransaction {
  const FinanceTransaction({
    required this.id,
    required this.type,
    required this.status,
    required this.accountId,
    required this.amount,
    required this.currencyCode,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastExecutedAt,
    this.recurrenceType,
    this.recurrenceInterval = 1,
    this.recurrenceEndAt,
    this.toAccountId,
    this.categoryId,
    this.budgetId,
    this.title,
    this.note,
    this.merchant,
    this.reference,
  });

  final String id;
  final TransactionType type;
  final TransactionStatus status;

  /// Source account.
  final String accountId;

  /// Destination account for transfers.
  final String? toAccountId;

  /// Category for expense/income.
  final String? categoryId;

  /// Optional budget attribution.
  final String? budgetId;

  /// Always positive; semantics are driven by [type].
  final Money amount;

  /// Redundant with [amount.currencyCode], but convenient for indexing/filtering.
  final String currencyCode;

  final DateTime occurredAt;

  final String? title;
  final String? note;

  /// Real-world bookkeeping metadata.
  final String? merchant;
  final String? reference;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// For recurring templates only, tracks the most recent materialized occurrence date.
  /// Null means nothing has been executed yet.
  final DateTime? lastExecutedAt;

  /// Optional recurrence rule metadata. When set, this transaction represents a template
  /// and should not be materialized into instances until an execution step.
  final RecurrenceType? recurrenceType;

  /// Every N units of [recurrenceType]. Default is 1.
  final int recurrenceInterval;

  /// Optional end date for the recurrence rule.
  final DateTime? recurrenceEndAt;

  FinanceTransaction copyWith({
    String? id,
    TransactionType? type,
    TransactionStatus? status,
    String? accountId,
    String? toAccountId,
    String? categoryId,
    String? budgetId,
    Money? amount,
    String? currencyCode,
    DateTime? occurredAt,
    String? title,
    String? note,
    String? merchant,
    String? reference,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastExecutedAt,
    RecurrenceType? recurrenceType,
    int? recurrenceInterval,
    DateTime? recurrenceEndAt,
  }) {
    return FinanceTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      occurredAt: occurredAt ?? this.occurredAt,
      title: title ?? this.title,
      note: note ?? this.note,
      merchant: merchant ?? this.merchant,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastExecutedAt: lastExecutedAt ?? this.lastExecutedAt,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceEndAt: recurrenceEndAt ?? this.recurrenceEndAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FinanceTransaction &&
        other.id == id &&
        other.type == type &&
        other.status == status &&
        other.accountId == accountId &&
        other.toAccountId == toAccountId &&
        other.categoryId == categoryId &&
        other.budgetId == budgetId &&
        other.amount == amount &&
        other.currencyCode == currencyCode &&
        other.occurredAt == occurredAt &&
        other.title == title &&
        other.note == note &&
        other.merchant == merchant &&
        other.reference == reference &&
        other.createdAt == createdAt &&
          other.updatedAt == updatedAt &&
          other.lastExecutedAt == lastExecutedAt &&
          other.recurrenceType == recurrenceType &&
          other.recurrenceInterval == recurrenceInterval &&
          other.recurrenceEndAt == recurrenceEndAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        type,
        status,
        accountId,
        toAccountId,
        categoryId,
        budgetId,
        amount,
        currencyCode,
        occurredAt,
        title,
        note,
        merchant,
        reference,
        createdAt,
        updatedAt,
        lastExecutedAt,
        recurrenceType,
        recurrenceInterval,
        recurrenceEndAt,
      );
}
