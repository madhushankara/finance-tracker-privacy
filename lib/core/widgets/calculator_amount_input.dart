import 'package:flutter/material.dart';

import '../formatting/money_format.dart';
import '../theme/app_spacing.dart';
import '../utils/calculator_engine.dart';
import '../../data/models/money.dart';

final class CalculatorAmountInput extends StatelessWidget {
  const CalculatorAmountInput({
    super.key,
    required this.currencyCode,
    required this.scale,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.labelText = 'Amount',
  });

  final String currencyCode;
  final int scale;
  final Money? value;
  final bool enabled;
  final ValueChanged<Money?> onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final displayMoney =
        value ??
        Money(currencyCode: currencyCode, amountMinor: 0, scale: scale);
    final amountText = formatMoney(displayMoney, includeCurrencyCode: false);

    return InkWell(
      onTap: enabled
          ? () async {
              final result = await showModalBottomSheet<Money>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) {
                  return _CalculatorSheet(
                    currencyCode: currencyCode,
                    scale: scale,
                    initialValue: value,
                  );
                },
              );
              if (result != null) onChanged(result);
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          enabled: enabled,
          suffixText: currencyCode,
        ),
        child: Text(
          amountText,
          style: theme.textTheme.titleLarge?.copyWith(
            color: enabled ? cs.onSurface : cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

final class _CalculatorSheet extends StatefulWidget {
  const _CalculatorSheet({
    required this.currencyCode,
    required this.scale,
    required this.initialValue,
  });

  final String currencyCode;
  final int scale;
  final Money? initialValue;

  @override
  State<_CalculatorSheet> createState() => _CalculatorSheetState();
}

final class _CalculatorSheetState extends State<_CalculatorSheet> {
  static const _engine = CalculatorEngine();

  late String _expression;
  String? _error;

  @override
  void initState() {
    super.initState();
    _expression = widget.initialValue == null
        ? ''
        : CalculatorEngine.formatMinor(
            BigInt.from(widget.initialValue!.amountMinor),
            scale: widget.initialValue!.scale,
          );
  }

  BigInt? _tryEvalMinor() {
    final res = _engine.tryEvaluate(_expression, scale: widget.scale);
    return res.minor;
  }

  bool _endsWithOperator() {
    if (_expression.isEmpty) return false;
    final last = _expression[_expression.length - 1];
    return last == '+' || last == '-' || last == '*' || last == '/';
  }

  String _currentNumberSegment() {
    if (_expression.isEmpty) return '';
    var i = _expression.length - 1;
    while (i >= 0) {
      final ch = _expression[i];
      if (ch == '+' || ch == '-' || ch == '*' || ch == '/') break;
      i--;
    }
    return _expression.substring(i + 1);
  }

  int _decimalsInCurrentNumber() {
    final seg = _currentNumberSegment();
    final dot = seg.indexOf('.');
    if (dot < 0) return 0;
    return seg.length - dot - 1;
  }

  bool _currentNumberHasDot() {
    return _currentNumberSegment().contains('.');
  }

  void _appendDigit(String digit) {
    setState(() {
      _error = null;

      if (_currentNumberHasDot() &&
          _decimalsInCurrentNumber() >= widget.scale) {
        return;
      }
      _expression += digit;
    });
  }

  void _appendDot() {
    if (widget.scale == 0) return;
    setState(() {
      _error = null;
      if (_expression.isEmpty) {
        _expression = '0.';
        return;
      }
      if (_endsWithOperator()) {
        _expression += '0.';
        return;
      }
      if (_currentNumberHasDot()) return;
      _expression += '.';
    });
  }

  void _appendOperator(String op) {
    setState(() {
      _error = null;
      if (_expression.isEmpty) {
        if (op == '-') {
          _expression = '-';
        }
        return;
      }

      if (_endsWithOperator()) {
        _expression = _expression.substring(0, _expression.length - 1) + op;
        return;
      }

      if (_expression.endsWith('.')) {
        _expression = _expression.substring(0, _expression.length - 1);
      }

      _expression += op;
    });
  }

  void _backspace() {
    setState(() {
      _error = null;
      if (_expression.isEmpty) return;
      _expression = _expression.substring(0, _expression.length - 1);
    });
  }

  void _clear() {
    setState(() {
      _error = null;
      _expression = '';
    });
  }

  void _equals() {
    final minor = _tryEvalMinor();
    if (minor == null) {
      setState(() => _error = 'Invalid expression');
      return;
    }

    if (minor <= BigInt.zero) {
      setState(() => _error = 'Amount must be > 0');
      return;
    }

    final money = Money(
      currencyCode: widget.currencyCode,
      amountMinor: minor.toInt(),
      scale: widget.scale,
    );

    Navigator.of(context).pop(money);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final minor = _tryEvalMinor();
    final amountText = minor == null
        ? (_expression.isEmpty ? '0' : _expression)
        : CalculatorEngine.formatMinor(minor, scale: widget.scale);

    final isNegative = minor != null && minor.isNegative;
    final displayColor = isNegative ? cs.error : cs.onSurface;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.s16,
          right: AppSpacing.s16,
          top: AppSpacing.s16,
          bottom: AppSpacing.s16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        amountText,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: displayColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        widget.currencyCode,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      if (_error != null || isNegative) ...<Widget>[
                        const SizedBox(height: AppSpacing.s8),
                        Text(
                          _error ?? 'Amount must be > 0',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            _KeyRow(
              children: <Widget>[
                _CalcKey(label: 'C', onPressed: _clear),
                _CalcKey(
                  label: '',
                  icon: Icons.backspace_outlined,
                  onPressed: _backspace,
                ),
                _CalcKey(label: '÷', onPressed: () => _appendOperator('/')),
                _CalcKey(label: '×', onPressed: () => _appendOperator('*')),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            _KeyRow(
              children: <Widget>[
                _CalcKey(label: '7', onPressed: () => _appendDigit('7')),
                _CalcKey(label: '8', onPressed: () => _appendDigit('8')),
                _CalcKey(label: '9', onPressed: () => _appendDigit('9')),
                _CalcKey(label: '−', onPressed: () => _appendOperator('-')),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            _KeyRow(
              children: <Widget>[
                _CalcKey(label: '4', onPressed: () => _appendDigit('4')),
                _CalcKey(label: '5', onPressed: () => _appendDigit('5')),
                _CalcKey(label: '6', onPressed: () => _appendDigit('6')),
                _CalcKey(label: '+', onPressed: () => _appendOperator('+')),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            _KeyRow(
              children: <Widget>[
                _CalcKey(label: '1', onPressed: () => _appendDigit('1')),
                _CalcKey(label: '2', onPressed: () => _appendDigit('2')),
                _CalcKey(label: '3', onPressed: () => _appendDigit('3')),
                _CalcKey(label: '✓', onPressed: _equals, filled: true),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: _CalcKey(
                    label: '0',
                    onPressed: () => _appendDigit('0'),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: _CalcKey(label: '.', onPressed: _appendDot),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: _CalcKey(label: '', onPressed: null, enabled: false),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: _CalcKey(label: '', onPressed: null, enabled: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (var i = 0; i < children.length; i++) ...<Widget>[
          Expanded(child: children[i]),
          if (i != children.length - 1) const SizedBox(width: AppSpacing.s8),
        ],
      ],
    );
  }
}

final class _CalcKey extends StatelessWidget {
  const _CalcKey({
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = false,
    this.enabled = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveOnPressed = enabled ? onPressed : null;

    final child = icon != null
        ? Icon(icon)
        : Text(label, style: theme.textTheme.titleLarge);

    final button = filled
        ? FilledButton(onPressed: effectiveOnPressed, child: child)
        : OutlinedButton(onPressed: effectiveOnPressed, child: child);

    return SizedBox(height: 56, child: button);
  }
}
