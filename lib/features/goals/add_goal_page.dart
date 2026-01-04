import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/calculator_amount_input.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/account.dart';
import '../../data/models/money.dart';
import '../accounts/providers/accounts_providers.dart';
import 'providers/goals_controller.dart';
import 'widgets/goal_meta.dart';

final class AddGoalPage extends ConsumerStatefulWidget {
  const AddGoalPage({super.key});

  @override
  ConsumerState<AddGoalPage> createState() => _AddGoalPageState();
}

final class _AddGoalPageState extends ConsumerState<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  GoalKind _kind = GoalKind.savings;
  String _colorKey = 'primary';

  Money? _target;
  DateTime? _deadline;

  @override
  void dispose() {
    _nameController.dispose();
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

  Future<void> _pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: DateTime(now.year - 10, 1, 1),
      lastDate: DateTime(now.year + 50, 12, 31),
    );
    if (picked == null) return;
    setState(() => _deadline = DateUtils.dateOnly(picked));
  }

  bool get _canSubmit {
    if (_nameController.text.trim().isEmpty) return false;
    if ((_target?.amountMinor ?? 0) <= 0) return false;
    return true;
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final target = _target;
    if (target == null) return;

    try {
      final note = GoalMeta.encode(kind: _kind, colorKey: _colorKey);
      await ref
          .read(goalsControllerProvider.notifier)
          .createGoal(
            name: _nameController.text,
            target: target,
            targetDate: _deadline,
            note: note,
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
    final isSubmitting = ref.watch(goalsControllerProvider).isLoading;
    final accountsAsync = ref.watch(accountsListProvider);

    return accountsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Add goal')),
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
            title: const Text('Add goal'),
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
                SegmentedButton<GoalKind>(
                  segments: const <ButtonSegment<GoalKind>>[
                    ButtonSegment<GoalKind>(
                      value: GoalKind.savings,
                      label: Text('Savings'),
                    ),
                    ButtonSegment<GoalKind>(
                      value: GoalKind.expense,
                      label: Text('Expense'),
                    ),
                  ],
                  selected: <GoalKind>{_kind},
                  onSelectionChanged: isSubmitting
                      ? null
                      : (selection) {
                          setState(() => _kind = selection.first);
                        },
                ),
                const SizedBox(height: AppSpacing.s16),
                TextFormField(
                  controller: _nameController,
                  enabled: !isSubmitting,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.s16),
                DropdownButtonFormField<String>(
                  initialValue: _colorKey,
                  decoration: const InputDecoration(labelText: 'Color'),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: 'primary', child: Text('Primary')),
                    DropdownMenuItem(
                      value: 'secondary',
                      child: Text('Secondary'),
                    ),
                    DropdownMenuItem(
                      value: 'tertiary',
                      child: Text('Tertiary'),
                    ),
                    DropdownMenuItem(value: 'error', child: Text('Error')),
                  ],
                  onChanged: isSubmitting
                      ? null
                      : (v) {
                          if (v == null) return;
                          setState(() => _colorKey = v);
                        },
                ),
                const SizedBox(height: AppSpacing.s16),
                FormField<Money>(
                  initialValue: _target,
                  validator: (_) {
                    final minor = _target?.amountMinor ?? 0;
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
                          labelText: 'Target amount',
                          onChanged: (money) {
                            state.didChange(money);
                            setState(() => _target = money);
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Deadline'),
                  subtitle: Text(
                    _deadline == null
                        ? 'No deadline'
                        : MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(_deadline!),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: isSubmitting ? null : () => _pickDeadline(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
