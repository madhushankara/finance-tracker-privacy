import 'package:meta/meta.dart';

import 'money.dart';

@immutable
final class Budget {
  const Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.categoryIds,
    required this.createdAt,
    required this.updatedAt,
    this.archived = false,
  });

  final String id;
  final String name;

  /// Budget amount in a single currency for now.
  final Money amount;

  final DateTime startDate;
  final DateTime endDate;

  /// Expense categories included in this budget.
  final List<String> categoryIds;

  final bool archived;

  final DateTime createdAt;
  final DateTime updatedAt;

  Budget copyWith({
    String? id,
    String? name,
    Money? amount,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? categoryIds,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryIds: categoryIds ?? this.categoryIds,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Budget &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        _listEquals(other.categoryIds, categoryIds) &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        amount,
        startDate,
        endDate,
        Object.hashAll(categoryIds),
        archived,
        createdAt,
        updatedAt,
      );

  bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
