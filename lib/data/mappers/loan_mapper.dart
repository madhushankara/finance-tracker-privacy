import 'package:drift/drift.dart';

import '../datasources/drift/app_database.dart';
import '../models/loan.dart';
import '../models/money.dart';

final class LoanMapper {
  const LoanMapper();

  Loan fromRow(LoanRow row) {
    return Loan(
      id: row.id,
      name: row.name,
      type: row.type,
      currencyCode: row.currencyCode,
      principal: Money(
        currencyCode: row.currencyCode,
        amountMinor: row.principalMinor,
        scale: row.principalScale,
      ),
      interestAprBps: row.interestAprBps,
      lender: row.lender,
      startDate: row.startDate,
      termMonths: row.termMonths,
      note: row.note,
      archived: row.archived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  LoansTableCompanion toCompanion(Loan loan) {
    return LoansTableCompanion(
      id: Value(loan.id),
      name: Value(loan.name),
      type: Value(loan.type),
      currencyCode: Value(loan.currencyCode),
      principalMinor: Value(loan.principal.amountMinor),
      principalScale: Value(loan.principal.scale),
      interestAprBps: Value(loan.interestAprBps),
      lender: Value(loan.lender),
      startDate: Value(loan.startDate),
      termMonths: Value(loan.termMonths),
      note: Value(loan.note),
      archived: Value(loan.archived),
      createdAt: Value(loan.createdAt),
      updatedAt: Value(loan.updatedAt),
    );
  }
}
