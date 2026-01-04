import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/calculator_amount_input.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/account.dart';
import '../../data/models/loan.dart';
import '../../data/models/money.dart';
import '../accounts/providers/accounts_providers.dart';
import 'providers/loans_controller.dart';
import 'providers/loans_providers.dart';

enum LoanTermKind { oneTime, longTerm }

final class EditLoanPage extends ConsumerStatefulWidget {
  const EditLoanPage({super.key, required this.loanId});

  final String loanId;

  @override
  ConsumerState<EditLoanPage> createState() => _EditLoanPageState();
}

final class _EditLoanPageState extends ConsumerState<EditLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  LoanTermKind _termKind = LoanTermKind.oneTime;
  Money? _amount;

  bool _initialized = false;

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

  void _initFromLoan(Loan loan) {
    if (_initialized) return;
    _initialized = true;

    _nameController.text = loan.name;
    _notesController.text = loan.note ?? '';
    _amount = loan.principal;
    _termKind = (loan.termMonths != null && loan.termMonths! > 0)
        ? LoanTermKind.longTerm
        : LoanTermKind.oneTime;
  }

  bool get _canSubmit {
    if (_nameController.text.trim().isEmpty) return false;
    if ((_amount?.amountMinor ?? 0) <= 0) return false;
    return true;
  }

  Future<void> _submit({required Loan existing}) async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final amount = _amount;
    if (amount == null) return;

    try {
      await ref
          .read(loansControllerProvider.notifier)
          .updateLoan(
            existing: existing,
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

  Future<void> _confirmAndDelete({required Loan existing}) async {
    final isSubmitting = ref.read(loansControllerProvider).isLoading;
    if (isSubmitting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete loan?'),
          content: Text('Delete "${existing.name}"? This can\'t be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(loansControllerProvider.notifier)
          .deleteLoan(loanId: existing.id);
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
    final loanAsync = ref.watch(loanByIdProvider(widget.loanId));
    final accountsAsync = ref.watch(accountsListProvider);
    final isSubmitting = ref.watch(loansControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit loan')),
      body: loanAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load loan',
            body: error.toString(),
          ),
        ),
        data: (loan) {
          if (loan == null) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'Loan not found',
                body: 'This loan may have been deleted.',
              ),
            );
          }

          _initFromLoan(loan);

          return accountsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (error, _) => Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'Couldn\'t load accounts',
                body: error.toString(),
              ),
            ),
            data: (accounts) {
              final moneyZero = _defaultMoneyFromAccounts(accounts);
              final currencyCode = moneyZero.currencyCode;
              final scale = moneyZero.scale;

              return Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        key: _formKey,
                        onChanged: () => setState(() {}),
                        child: ListView(
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
                                      setState(
                                        () => _termKind = selection.first,
                                      );
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.error,
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
                            const SizedBox(height: AppSpacing.s16),
                            SizedBox(
                              height: 48,
                              child: FilledButton(
                                onPressed: isSubmitting || !_canSubmit
                                    ? null
                                    : () => _submit(existing: loan),
                                child: const Text('Save changes'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: isSubmitting
                            ? null
                            : () => _confirmAndDelete(existing: loan),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete loan'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
