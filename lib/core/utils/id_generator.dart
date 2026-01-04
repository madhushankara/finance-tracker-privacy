import 'dart:math';

final class IdGenerator {
  IdGenerator._();

  static final Random _random = Random.secure();

  static String newId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final r1 = _random.nextInt(1 << 31);
    final r2 = _random.nextInt(1 << 31);
    return '$now-${r1.toRadixString(16)}${r2.toRadixString(16)}';
  }
}
