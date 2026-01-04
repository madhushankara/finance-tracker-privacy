import 'package:meta/meta.dart';

import 'enums.dart';

@immutable
final class Category {
  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
    this.iconKey,
    this.colorHex,
    this.archived = false,
  });

  final String id;
  final String name;
  final CategoryType type;

  /// Parent category for hierarchy.
  final String? parentId;

  /// UI-facing identifiers stored as data (no Flutter dependency).
  final String? iconKey;
  final int? colorHex;

  final bool archived;

  final DateTime createdAt;
  final DateTime updatedAt;

  Category copyWith({
    String? id,
    String? name,
    CategoryType? type,
    String? parentId,
    String? iconKey,
    int? colorHex,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      iconKey: iconKey ?? this.iconKey,
      colorHex: colorHex ?? this.colorHex,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.parentId == parentId &&
        other.iconKey == iconKey &&
        other.colorHex == colorHex &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        type,
        parentId,
        iconKey,
        colorHex,
        archived,
        createdAt,
        updatedAt,
      );
}
