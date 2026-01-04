import 'dart:convert';

enum GoalKind { savings, expense }

typedef GoalColorKey = String;

final class GoalMeta {
  const GoalMeta({required this.kind, required this.colorKey});

  final GoalKind kind;
  final GoalColorKey colorKey;

  static const _prefix = 'meta:';

  static GoalMeta parse(String? note) {
    if (note == null) {
      return const GoalMeta(kind: GoalKind.savings, colorKey: 'primary');
    }

    final trimmed = note.trim();
    if (!trimmed.startsWith(_prefix)) {
      return const GoalMeta(kind: GoalKind.savings, colorKey: 'primary');
    }

    try {
      final raw = trimmed.substring(_prefix.length);
      final map = jsonDecode(raw);
      if (map is! Map) {
        return const GoalMeta(kind: GoalKind.savings, colorKey: 'primary');
      }

      final kindRaw = map['kind'];
      final colorRaw = map['color'];

      final kind = switch (kindRaw) {
        'expense' => GoalKind.expense,
        _ => GoalKind.savings,
      };

      final color = (colorRaw is String && colorRaw.trim().isNotEmpty)
          ? colorRaw.trim()
          : 'primary';

      return GoalMeta(kind: kind, colorKey: color);
    } catch (_) {
      return const GoalMeta(kind: GoalKind.savings, colorKey: 'primary');
    }
  }

  static String encode({
    required GoalKind kind,
    required GoalColorKey colorKey,
  }) {
    final payload = <String, Object?>{
      'kind': kind == GoalKind.expense ? 'expense' : 'savings',
      'color': colorKey,
    };
    return '$_prefix${jsonEncode(payload)}';
  }
}
