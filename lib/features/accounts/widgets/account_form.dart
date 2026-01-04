import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';

final class AccountFormValues {
  const AccountFormValues({
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.openingBalance,
  });

  final String name;
  final AccountType type;
  final String currencyCode;
  final Money? openingBalance;
}

final class AccountForm extends StatefulWidget {
  const AccountForm({
    super.key,
    required this.initialName,
    required this.initialType,
    required this.initialCurrencyCode,
    required this.initialBalanceText,
    required this.allowCurrencyEdit,
    required this.showBalanceField,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final String initialName;
  final AccountType initialType;
  final String initialCurrencyCode;
  final String initialBalanceText;

  final bool allowCurrencyEdit;
  final bool showBalanceField;
  final bool isSubmitting;

  final Future<void> Function(AccountFormValues values) onSubmit;

  @override
  State<AccountForm> createState() => _AccountFormState();
}

final class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _currencyController;
  late final TextEditingController _balanceController;

  late AccountType _type;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _currencyController = TextEditingController(text: widget.initialCurrencyCode);
    _balanceController = TextEditingController(text: widget.initialBalanceText);
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    final name = _nameController.text.trim();
    final currencyCode = _currencyController.text.trim().toUpperCase();

    Money? openingBalance;
    if (widget.showBalanceField) {
      openingBalance = _parseMoney(
        currencyCode: currencyCode,
        input: _balanceController.text.trim(),
      );
      if (openingBalance == null) {
        // Should be unreachable due to validation, but keep it safe.
        return;
      }
    }

    await widget.onSubmit(
      AccountFormValues(
        name: name,
        type: _type,
        currencyCode: currencyCode,
        openingBalance: openingBalance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            enabled: !widget.isSubmitting,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Account name',
            ),
            validator: (value) {
              final v = (value ?? '').trim();
              if (v.isEmpty) return 'Name is required';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          FormField<AccountType>(
            initialValue: _type,
            validator: (value) {
              if (value == null) return 'Account type is required';
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownMenu<AccountType>(
                    initialSelection: state.value,
                    enabled: !widget.isSubmitting,
                    label: const Text('Account type'),
                    dropdownMenuEntries: AccountType.values
                        .map(
                          (t) => DropdownMenuEntry<AccountType>(
                            value: t,
                            label: _accountTypeLabel(t),
                          ),
                        )
                        .toList(growable: false),
                    onSelected: widget.isSubmitting
                        ? null
                        : (v) {
                            if (v == null) return;
                            state.didChange(v);
                            setState(() => _type = v);
                          },
                  ),
                  if (state.hasError) ...<Widget>[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      state.errorText ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          TextFormField(
            controller: _currencyController,
            enabled: !widget.isSubmitting && widget.allowCurrencyEdit,
            textInputAction: widget.showBalanceField ? TextInputAction.next : TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Currency code',
              helperText: widget.allowCurrencyEdit ? 'Example: USD, INR, BTC' : 'Currency can\'t be changed',
            ),
            validator: (value) {
              final v = (value ?? '').trim();
              if (v.isEmpty) return 'Currency is required';
              if (v.length < 2 || v.length > 8) return 'Enter a valid currency code';
              return null;
            },
          ),
          if (widget.showBalanceField) ...<Widget>[
            const SizedBox(height: AppSpacing.s16),
            TextFormField(
              controller: _balanceController,
              enabled: !widget.isSubmitting,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Initial balance',
                helperText: 'Must be \u2265 0',
              ),
              validator: (value) {
                final input = (value ?? '').trim();
                final parsed = _parseMoney(currencyCode: _currencyController.text.trim(), input: input);
                if (parsed == null) return 'Enter a valid amount';
                if (parsed.amountMinor < 0) return 'Balance must be \u2265 0';
                return null;
              },
            ),
          ],
          const SizedBox(height: AppSpacing.s24),
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: widget.isSubmitting ? null : _submit,
              child: widget.isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

String _accountTypeLabel(AccountType type) {
  return switch (type) {
    AccountType.cash => 'Cash',
    AccountType.bank => 'Bank',
    AccountType.credit => 'Credit',
    AccountType.crypto => 'Crypto',
  };
}

Money? _parseMoney({required String currencyCode, required String input}) {
  final code = currencyCode.trim().toUpperCase();
  if (code.isEmpty) return null;

  final normalized = input.replaceAll(',', '');
  if (normalized.isEmpty) return null;

  // Simple numeric parsing: fixed scale=2 (fiat-friendly). Crypto precision can be extended later.
  const scale = 2;

  final match = RegExp(r'^-?\d+(?:\.\d{0,2})?$').firstMatch(normalized);
  if (match == null) return null;

  final isNegative = normalized.startsWith('-');
  final raw = isNegative ? normalized.substring(1) : normalized;

  final parts = raw.split('.');
  final whole = int.tryParse(parts[0]) ?? 0;
  final frac = parts.length == 2 ? parts[1] : '';

  final fracPadded = frac.padRight(scale, '0');
  final fracMinor = int.tryParse(fracPadded) ?? 0;

  final minor = whole * 100 + fracMinor;

  return Money(
    currencyCode: code,
    amountMinor: isNegative ? -minor : minor,
    scale: scale,
  );
}
