import 'package:meta/meta.dart';

import 'enums.dart';
import 'money.dart';

@immutable
final class Loan {
  const Loan({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.principal,
    required this.createdAt,
    required this.updatedAt,
    this.lender,
    this.interestAprBps,
    this.startDate,
    this.termMonths,
    this.note,
    this.archived = false,
  });

  final String id;
  final String name;
  final LoanType type;

  final String currencyCode;
  final Money principal;

  /// Annual percentage rate in basis points (e.g. 12.5% => 1250).
  final int? interestAprBps;

  final String? lender;
  final DateTime? startDate;
  final int? termMonths;

  final String? note;
  final bool archived;

  final DateTime createdAt;
  final DateTime updatedAt;

  Loan copyWith({
    String? id,
    String? name,
    LoanType? type,
    String? currencyCode,
    Money? principal,
    int? interestAprBps,
    String? lender,
    DateTime? startDate,
    int? termMonths,
    String? note,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Loan(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      principal: principal ?? this.principal,
      interestAprBps: interestAprBps ?? this.interestAprBps,
      lender: lender ?? this.lender,
      startDate: startDate ?? this.startDate,
      termMonths: termMonths ?? this.termMonths,
      note: note ?? this.note,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Loan &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.currencyCode == currencyCode &&
        other.principal == principal &&
        other.interestAprBps == interestAprBps &&
        other.lender == lender &&
        other.startDate == startDate &&
        other.termMonths == termMonths &&
        other.note == note &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        type,
        currencyCode,
        principal,
        interestAprBps,
        lender,
        startDate,
        termMonths,
        note,
        archived,
        createdAt,
        updatedAt,
      );
}
