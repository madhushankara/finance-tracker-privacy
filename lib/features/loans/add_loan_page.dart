import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/calculator_amount_input.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/account.dart';
import '../../data/models/money.dart';
import '../accounts/providers/accounts_providers.dart';
import 'providers/loans_controller.dart';

enum LoanTermKind { oneTime, longTerm }

final class AddLoanPage extends ConsumerStatefulWidget {
  const AddLoanPage({super.key});

  @override
  ConsumerState<AddLoanPage> createState() => _AddLoanPageState();
}

final class _AddLoanPageState extends ConsumerState<AddLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  LoanTermKind _termKind = LoanTermKind.oneTime;
  Money? _amount;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Money _defaultMoneyFromAccounts(List<Account> accounts) {
    final active = accounts.where((a) => !a.archived).toList(growable: false);
    if (active.isNotEmpty) {
      final m = active.first.openingBalance;
      return Money(
        currencyCode: m.currencyCode,
        amountMinor: 0,
        scale: m.scale,
      );
    }
    return const Money(currencyCode: 'INR', amountMinor: 0, scale: 2);
  }

  bool get _canSubmit {
    if (_nameController.text.trim().isEmpty) return false;
    if ((_amount?.amountMinor ?? 0) <= 0) return false;
    return true;
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    final amount = _amount;
    if (amount == null) return;

    try {
      await ref
          .read(loansControllerProvider.notifier)
          .createLoan(
            counterpartyName: _nameController.text,
            amount: amount,
            isLongTerm: _termKind == LoanTermKind.longTerm,
            notes: _notesController.text,
          );
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(loansControllerProvider).isLoading;
    final accountsAsync = ref.watch(accountsListProvider);

    return accountsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Add loan')),
        body: Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load accounts',
            body: error.toString(),
          ),
        ),
      ),
      data: (accounts) {
        final moneyZero = _defaultMoneyFromAccounts(accounts);
        final currencyCode = moneyZero.currencyCode;
        final scale = moneyZero.scale;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add loan'),
            actions: <Widget>[
              TextButton(
                onPressed: isSubmitting || !_canSubmit ? null : _submit,
                child: const Text('Save'),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.s16),
              children: <Widget>[
                SegmentedButton<LoanTermKind>(
                  segments: const <ButtonSegment<LoanTermKind>>[
                    ButtonSegment(
                      value: LoanTermKind.oneTime,
                      label: Text('One-time'),
                    ),
                    ButtonSegment(
                      value: LoanTermKind.longTerm,
                      label: Text('Long-term'),
                    ),
                  ],
                  selected: <LoanTermKind>{_termKind},
                  onSelectionChanged: isSubmitting
                      ? null
                      : (selection) {
                          setState(() => _termKind = selection.first);
                        },
                ),
                const SizedBox(height: AppSpacing.s16),
                TextFormField(
                  controller: _nameController,
                  enabled: !isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'Counterparty name',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Counterparty name is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.s16),
                FormField<Money>(
                  initialValue: _amount,
                  validator: (_) {
                    final minor = _amount?.amountMinor ?? 0;
                    if (minor <= 0) return 'Amount must be > 0';
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CalculatorAmountInput(
                          currencyCode: currencyCode,
                          scale: scale,
                          value: state.value,
                          enabled: !isSubmitting,
                          labelText: 'Amount',
                          onChanged: (money) {
                            state.didChange(money);
                            setState(() => _amount = money);
                          },
                        ),
                        if (state.hasError) ...<Widget>[
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            state.errorText ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                TextFormField(
                  controller: _notesController,
                  enabled: !isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  minLines: 2,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
