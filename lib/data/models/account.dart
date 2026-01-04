import 'package:meta/meta.dart';

import 'enums.dart';
import 'money.dart';

@immutable
final class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.openingBalance,
    required this.createdAt,
    required this.updatedAt,
    this.institution,
    this.note,
    this.archived = false,
  });

  final String id;
  final String name;
  final AccountType type;

  /// Account's primary currency (supports crypto like BTC).
  final String currencyCode;

  /// Starting balance at creation time.
  final Money openingBalance;

  final String? institution;
  final String? note;

  final bool archived;

  final DateTime createdAt;
  final DateTime updatedAt;

  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    String? currencyCode,
    Money? openingBalance,
    String? institution,
    String? note,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencyCode: currencyCode ?? this.currencyCode,
      openingBalance: openingBalance ?? this.openingBalance,
      institution: institution ?? this.institution,
      note: note ?? this.note,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Account &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.currencyCode == currencyCode &&
        other.openingBalance == openingBalance &&
        other.institution == institution &&
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
        openingBalance,
        institution,
        note,
        archived,
        createdAt,
        updatedAt,
      );
}
