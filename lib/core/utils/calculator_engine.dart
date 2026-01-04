final class CalculatorEngine {
  const CalculatorEngine();

  CalculatorEvalResult tryEvaluate(String expression, {required int scale}) {
    try {
      final minor = evaluateToMinor(expression, scale: scale);
      return CalculatorEvalResult.ok(minor);
    } catch (e) {
      return CalculatorEvalResult.error(e.toString());
    }
  }

  BigInt evaluateToMinor(String expression, {required int scale}) {
    final tokens = _tokenize(expression);
    if (tokens.isEmpty) {
      throw const CalculatorException('Empty expression');
    }

    final rpn = _toRpn(tokens);
    return _evalRpn(rpn, scale: scale);
  }

  static String formatMinor(BigInt minor, {required int scale}) {
    final isNegative = minor.isNegative;
    final absMinor = minor.abs();

    if (scale == 0) {
      final s = absMinor.toString();
      return isNegative ? '-$s' : s;
    }

    final digits = absMinor.toString().padLeft(scale + 1, '0');
    final intPart = digits.substring(0, digits.length - scale);
    final fracPart = digits.substring(digits.length - scale);

    final trimmedFrac = fracPart.replaceFirst(RegExp(r'0+$'), '');
    final base = trimmedFrac.isEmpty ? intPart : '$intPart.$trimmedFrac';
    return isNegative ? '-$base' : base;
  }
}

final class CalculatorEvalResult {
  const CalculatorEvalResult._({required this.minor, required this.error});

  factory CalculatorEvalResult.ok(BigInt minor) => CalculatorEvalResult._(minor: minor, error: null);

  factory CalculatorEvalResult.error(String message) => CalculatorEvalResult._(minor: null, error: message);

  final BigInt? minor;
  final String? error;

  bool get isOk => minor != null;
}

final class CalculatorException implements Exception {
  const CalculatorException(this.message);
  final String message;
  @override
  String toString() => message;
}

enum _TokenType { number, op, unaryMinus }

final class _Token {
  const _Token.number(this.value)
      : type = _TokenType.number,
        op = null;
  const _Token.op(this.op)
      : type = _TokenType.op,
        value = null;
  const _Token.unaryMinus()
      : type = _TokenType.unaryMinus,
        value = null,
        op = null;

  final _TokenType type;
  final String? value;
  final String? op;
}

List<_Token> _tokenize(String raw) {
  final expression = raw.replaceAll(' ', '');
  if (expression.isEmpty) return const <_Token>[];

  final tokens = <_Token>[];
  var i = 0;

  bool isUnaryPosition() {
    if (tokens.isEmpty) return true;
    final prev = tokens.last;
    return prev.type == _TokenType.op || prev.type == _TokenType.unaryMinus;
  }

  while (i < expression.length) {
    final ch = expression[i];

    if (ch == '+' || ch == '-' || ch == '×' || ch == '÷' || ch == '*' || ch == '/') {
      final normalized = switch (ch) {
        '×' => '*',
        '÷' => '/',
        _ => ch,
      };

      if (normalized == '-' && isUnaryPosition()) {
        tokens.add(const _Token.unaryMinus());
        i++;
        continue;
      }

      tokens.add(_Token.op(normalized));
      i++;
      continue;
    }

    if (_isDigit(ch) || ch == '.') {
      final start = i;
      var dotCount = 0;
      while (i < expression.length) {
        final c = expression[i];
        if (_isDigit(c)) {
          i++;
          continue;
        }
        if (c == '.') {
          dotCount++;
          if (dotCount > 1) {
            throw const CalculatorException('Invalid number');
          }
          i++;
          continue;
        }
        break;
      }
      final numText = expression.substring(start, i);
      if (numText == '.' || numText.isEmpty) {
        throw const CalculatorException('Invalid number');
      }
      tokens.add(_Token.number(numText));
      continue;
    }

    throw const CalculatorException('Invalid character');
  }

  return tokens;
}

bool _isDigit(String s) {
  final code = s.codeUnitAt(0);
  return code >= 48 && code <= 57;
}

int _precedence(_Token t) {
  if (t.type == _TokenType.unaryMinus) return 3;
  final op = t.op;
  if (op == '*' || op == '/') return 2;
  if (op == '+' || op == '-') return 1;
  return 0;
}

bool _isLeftAssociative(_Token t) {
  // Unary minus is right-associative.
  if (t.type == _TokenType.unaryMinus) return false;
  return true;
}

List<_Token> _toRpn(List<_Token> tokens) {
  final output = <_Token>[];
  final stack = <_Token>[];

  for (final token in tokens) {
    switch (token.type) {
      case _TokenType.number:
        output.add(token);
        break;
      case _TokenType.op:
      case _TokenType.unaryMinus:
        while (stack.isNotEmpty) {
          final top = stack.last;
          if (top.type == _TokenType.op || top.type == _TokenType.unaryMinus) {
            final p1 = _precedence(token);
            final p2 = _precedence(top);
            final shouldPop = _isLeftAssociative(token) ? (p1 <= p2) : (p1 < p2);
            if (shouldPop) {
              output.add(stack.removeLast());
              continue;
            }
          }
          break;
        }
        stack.add(token);
        break;
    }
  }

  while (stack.isNotEmpty) {
    output.add(stack.removeLast());
  }

  return output;
}

BigInt _parseNumberToMinor(String number, {required int scale}) {
  final parts = number.split('.');
  final wholeText = parts[0].isEmpty ? '0' : parts[0];
  final whole = BigInt.parse(wholeText);

  final fracText = parts.length == 2 ? parts[1] : '';
  if (fracText.length > scale) {
    throw const CalculatorException('Too many decimals');
  }

  final fracPadded = fracText.padRight(scale, '0');
  final frac = fracPadded.isEmpty ? BigInt.zero : BigInt.parse(fracPadded);

  final tenPow = BigInt.from(10).pow(scale);
  return whole * tenPow + frac;
}

BigInt _roundDiv(BigInt numerator, BigInt denominator) {
  if (denominator == BigInt.zero) {
    throw const CalculatorException('Division by zero');
  }

  final q = numerator ~/ denominator;
  final r = numerator.remainder(denominator).abs();
  final dAbs = denominator.abs();

  // Half-up rounding.
  final twiceR = r * BigInt.from(2);
  if (twiceR >= dAbs) {
    return numerator.isNegative == denominator.isNegative ? q + BigInt.one : q - BigInt.one;
  }
  return q;
}

BigInt _evalRpn(List<_Token> rpn, {required int scale}) {
  final stack = <BigInt>[];
  final tenPow = BigInt.from(10).pow(scale);

  for (final t in rpn) {
    switch (t.type) {
      case _TokenType.number:
        stack.add(_parseNumberToMinor(t.value!, scale: scale));
        break;
      case _TokenType.unaryMinus:
        if (stack.isEmpty) throw const CalculatorException('Invalid expression');
        final v = stack.removeLast();
        stack.add(-v);
        break;
      case _TokenType.op:
        if (stack.length < 2) throw const CalculatorException('Invalid expression');
        final b = stack.removeLast();
        final a = stack.removeLast();
        switch (t.op) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            // (a/10^s) * (b/10^s) => (a*b)/10^s
            stack.add(_roundDiv(a * b, tenPow));
            break;
          case '/':
            // (a/10^s) / (b/10^s) => (a*10^s)/b
            stack.add(_roundDiv(a * tenPow, b));
            break;
          default:
            throw const CalculatorException('Invalid operator');
        }
        break;
    }
  }

  if (stack.length != 1) throw const CalculatorException('Invalid expression');
  return stack.single;
}
