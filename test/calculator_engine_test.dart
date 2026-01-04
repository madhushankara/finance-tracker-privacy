import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/core/utils/calculator_engine.dart';

void main() {
  group('CalculatorEngine', () {
    const engine = CalculatorEngine();

    test('respects operator precedence (10 + 2 * 3 = 16)', () {
      final minor = engine.evaluateToMinor('10+2*3', scale: 2);
      expect(minor, BigInt.from(1600));
    });

    test('handles chained operations with decimals', () {
      final minor = engine.evaluateToMinor('1.25+2.50-0.75', scale: 2);
      expect(minor, BigInt.from(300));
    });

    test('division rounds half-up at scale', () {
      final minor = engine.evaluateToMinor('10/3', scale: 2);
      expect(minor, BigInt.from(333));
    });

    test('supports higher scale for crypto-like precision', () {
      final minor = engine.evaluateToMinor('0.00000001*2', scale: 8);
      expect(minor, BigInt.from(2));
    });

    test('unary minus parses (result can be negative)', () {
      final minor = engine.evaluateToMinor('-5+2', scale: 2);
      expect(minor, BigInt.from(-300));
    });
  });
}
