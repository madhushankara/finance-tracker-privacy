import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/calculator_amount_input.dart';
import '../../data/models/account.dart';
import '../../data/models/enums.dart';
import '../../data/models/money.dart';
import 'providers/add_budget_controller.dart';
import 'providers/budgets_providers.dart';

final class AddBudgetPage extends ConsumerStatefulWidget {
  const AddBudgetPage({super.key});

  @override
  ConsumerState<AddBudgetPage> createState() => _AddBudgetPageState();
}

enum _BudgetWindowMode { monthly, custom }

final class _AddBudgetPageState extends ConsumerState<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  _BudgetWindowMode _windowMode = _BudgetWindowMode.monthly;

  DateTime _monthAnchor = DateTime.now();
  DateTime _customStart = DateTime.now();
  DateTime _customEnd = DateTime.now();

  Money? _amount;
  final Set<String> _selectedCategoryIds = <String>{};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  DateTime _monthStart(DateTime dt) => DateTime(dt.year, dt.month, 1);

  DateTime _monthEnd(DateTime dt) => DateTime(dt.year, dt.month + 1, 0);

  DateTime get _startDate {
    switch (_windowMode) {
      case _BudgetWindowMode.monthly:
        return _monthStart(_monthAnchor);
      case _BudgetWindowMode.custom:
        return _dateOnly(_customStart);
    }
  }

  DateTime get _endDate {
    switch (_windowMode) {
      case _BudgetWindowMode.monthly:
        return _monthEnd(_monthAnchor);
      case _BudgetWindowMode.custom:
        return _dateOnly(_customEnd);
    }
  }

  Money _defaultMoneyFromAccounts(List<Account> accounts) {
    final active = accounts.where((a) => !a.archived).toList(growable: false);
    if (active.isNotEmpty) {
      final m = active.first.openingBalance;
      return Money(currencyCode: m.currencyCode, amountMinor: 0, scale: m.scale);
    }
    return const Money(currencyCode: 'INR', amountMinor: 0, scale: 2);
  }

  bool get _datesValid => !_endDate.isBefore(_startDate);

  bool get _canSubmit {
    if (!_datesValid) return false;
    if ((_amount?.amountMinor ?? 0) <= 0) return false;
    if (_selectedCategoryIds.isEmpty) return false;
    if (_nameController.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _pickMonth(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _monthAnchor,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked == null) return;
    setState(() => _monthAnchor = picked);
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customStart,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked == null) return;
    setState(() {
      _customStart = picked;
      if (_customEnd.isBefore(picked)) _customEnd = picked;
    });
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customEnd,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked == null) return;
    setState(() => _customEnd = picked);
  }

  Future<void> _submit({required String currencyCode, required int scale}) async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final amount = _amount ?? Money(currencyCode: currencyCode, amountMinor: 0, scale: scale);

    try {
      await ref.read(addBudgetControllerProvider.notifier).createBudget(
            name: _nameController.text,
            amount: amount,
            startDate: _startDate,
            endDate: _endDate,
            categoryIds: _selectedCategoryIds.toList(growable: false),
          );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addBudgetControllerProvider);
    final isSubmitting = controller.isLoading;

    final accountsAsync = ref.watch(budgetAccountsProvider);
    final categoriesAsync = ref.watch(budgetCategoriesProvider);

    return accountsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (accounts) {
        final moneyZero = _defaultMoneyFromAccounts(accounts);
        final currencyCode = moneyZero.currencyCode;
        final scale = moneyZero.scale;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Budget'),
            actions: <Widget>[
              TextButton(
                onPressed: isSubmitting || !_canSubmit ? null : () => _submit(currencyCode: currencyCode, scale: scale),
                child: const Text('Save'),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            onChanged: () {
              // Re-evaluate save enabled state.
              setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.s16),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  enabled: !isSubmitting,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
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
                const SizedBox(height: AppSpacing.s24),
                Text('Time window', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.s8),
                RadioGroup<_BudgetWindowMode>(
                  groupValue: _windowMode,
                  onChanged: (v) {
                    if (isSubmitting) return;
                    if (v == null) return;
                    setState(() {
                      _windowMode = v;
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      const RadioListTile<_BudgetWindowMode>(
                        value: _BudgetWindowMode.monthly,
                        title: Text('Monthly'),
                      ),
                      if (_windowMode == _BudgetWindowMode.monthly)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Month'),
                          subtitle: Text(DateFormat('MMM yyyy').format(_monthAnchor)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: isSubmitting ? null : () => _pickMonth(context),
                        ),
                      const RadioListTile<_BudgetWindowMode>(
                        value: _BudgetWindowMode.custom,
                        title: Text('Custom'),
                      ),
                      if (_windowMode == _BudgetWindowMode.custom) ...<Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Start date'),
                          subtitle: Text(DateFormat('d MMM yyyy').format(_customStart)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: isSubmitting ? null : () => _pickStartDate(context),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('End date'),
                          subtitle: Text(DateFormat('d MMM yyyy').format(_customEnd)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: isSubmitting ? null : () => _pickEndDate(context),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!_datesValid) ...<Widget>[
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    'End date must be on or after start date',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: AppSpacing.s24),
                Text('Categories', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.s8),
                categoriesAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.s8),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text(e.toString()),
                  data: (categories) {
                    final expenseCats = categories
                        .where((c) => !c.archived)
                        .where((c) => c.type == CategoryType.expense)
                        .toList(growable: false);

                    if (expenseCats.isEmpty) {
                      return const Text('No expense categories available');
                    }

                    return Column(
                      children: <Widget>[
                        for (final c in expenseCats)
                          CheckboxListTile(
                            value: _selectedCategoryIds.contains(c.id),
                            onChanged: isSubmitting
                                ? null
                                : (v) {
                                    setState(() {
                                      if (v == true) {
                                        _selectedCategoryIds.add(c.id);
                                      } else {
                                        _selectedCategoryIds.remove(c.id);
                                      }
                                    });
                                  },
                            title: Text(c.name),
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        if (_selectedCategoryIds.isEmpty) ...<Widget>[
                          const SizedBox(height: AppSpacing.s4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Select at least one expense category',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s24),
              ],
            ),
          ),
        );
      },
    );
  }
}
