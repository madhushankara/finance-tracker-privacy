import 'package:meta/meta.dart';

import 'money.dart';

@immutable
final class Goal {
  const Goal({
    required this.id,
    required this.name,
    required this.target,
    required this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
    this.saved,
    this.targetDate,
    this.note,
    this.archived = false,
  });

  final String id;
  final String name;

  final String currencyCode;
  final Money target;

  /// Optional saved amount (can later be computed from goal transactions).
  final Money? saved;

  final DateTime? targetDate;
  final String? note;

  final bool archived;

  final DateTime createdAt;
  final DateTime updatedAt;

  Goal copyWith({
    String? id,
    String? name,
    Money? target,
    String? currencyCode,
    Money? saved,
    DateTime? targetDate,
    String? note,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      target: target ?? this.target,
      currencyCode: currencyCode ?? this.currencyCode,
      saved: saved ?? this.saved,
      targetDate: targetDate ?? this.targetDate,
      note: note ?? this.note,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Goal &&
        other.id == id &&
        other.name == name &&
        other.currencyCode == currencyCode &&
        other.target == target &&
        other.saved == saved &&
        other.targetDate == targetDate &&
        other.note == note &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        currencyCode,
        target,
        saved,
        targetDate,
        note,
        archived,
        createdAt,
        updatedAt,
      );
}
