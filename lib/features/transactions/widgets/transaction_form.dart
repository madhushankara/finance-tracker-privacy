import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/animations/motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/id_generator.dart';
import '../../../core/widgets/calculator_amount_input.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../../data/models/account.dart';
import '../../../data/models/category.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/providers/repository_providers.dart';
import '../../categories/widgets/category_form.dart';
import '../utils/transaction_form_validators.dart';

final class TransactionFormResult {
  const TransactionFormResult({
    required this.type,
    required this.accountId,
    required this.amount,
    required this.occurredAt,
    required this.scheduleForLater,
    required this.repeat,
    required this.recurrenceType,
    required this.recurrenceInterval,
    required this.recurrenceEndAt,
    this.toAccountId,
    this.categoryId,
    this.title,
  });

  final TransactionType type;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final Money amount;
  final DateTime occurredAt;
  final bool scheduleForLater;
  final bool repeat;
  final RecurrenceType? recurrenceType;
  final int recurrenceInterval;
  final DateTime? recurrenceEndAt;
  final String? title;
}

typedef TransactionFormSubmit =
    Future<void> Function(TransactionFormResult result);

final class TransactionForm extends ConsumerStatefulWidget {
  const TransactionForm({
    super.key,
    required this.accounts,
    required this.categories,
    required this.isSubmitting,
    required this.initialType,
    required this.initialOccurredAt,
    required this.onSubmit,
    this.saveEnabled = true,
    this.typeImmutable = false,
    this.fixedCurrencyCode,
    this.fixedScale,
    this.initialAccountId,
    this.initialToAccountId,
    this.initialCategoryId,
    this.initialAmount,
    this.initialScheduleForLater = false,
    this.initialRepeat = false,
    this.initialRecurrenceType,
    this.initialRecurrenceInterval = 1,
    this.initialRecurrenceEndAt,
    this.initialTitle,
  });

  final List<Account> accounts;
  final List<Category> categories;
  final bool isSubmitting;

  final TransactionType initialType;
  final bool typeImmutable;

  /// If provided, account dropdowns are restricted to accounts with this currency code,
  /// and the calculator uses this currency.
  final String? fixedCurrencyCode;

  /// If provided, calculator uses this fixed scale.
  final int? fixedScale;

  final String? initialAccountId;
  final String? initialToAccountId;
  final String? initialCategoryId;
  final Money? initialAmount;
  final DateTime initialOccurredAt;
  final bool initialScheduleForLater;
  final bool initialRepeat;
  final RecurrenceType? initialRecurrenceType;
  final int initialRecurrenceInterval;
  final DateTime? initialRecurrenceEndAt;
  final String? initialTitle;

  final TransactionFormSubmit onSubmit;

  /// When false, the Save button is disabled (useful for read-only edit screens).
  final bool saveEnabled;

  @override
  ConsumerState<TransactionForm> createState() => _TransactionFormState();
}

final class _TransactionFormState extends ConsumerState<TransactionForm> {
  static const String _kAddNewCategoryId = '__add_new_category__';
  static const String _kOthersCategoryId = '__others__';

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _recurrenceIntervalController;

  late TransactionType _type;
  String? _accountId;
  String? _toAccountId;
  String? _categoryId;
  late DateTime _occurredAt;
  Money? _amount;
  late bool _scheduleForLater;
  late bool _repeat;
  RecurrenceType? _recurrenceType;
  DateTime? _recurrenceEndAt;

  bool _didInitDefaults = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _accountId = widget.initialAccountId;
    _toAccountId = widget.initialToAccountId;
    _categoryId = widget.initialCategoryId;
    _occurredAt = widget.initialOccurredAt;
    _amount = widget.initialAmount;
    _scheduleForLater = widget.initialScheduleForLater;
    _repeat = widget.initialRepeat;
    _recurrenceType = widget.initialRecurrenceType;
    _recurrenceEndAt = widget.initialRecurrenceEndAt;
    _titleController = TextEditingController(text: widget.initialTitle ?? '');

    _recurrenceIntervalController = TextEditingController(
      text:
          (widget.initialRecurrenceInterval <= 0
                  ? 1
                  : widget.initialRecurrenceInterval)
              .toString(),
    );
  }

  @override
  void didUpdateWidget(covariant TransactionForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the parent provides different initial values (e.g. after async load),
    // update once unless the user already started editing.
    if (!_didInitDefaults &&
        oldWidget.accounts.isEmpty &&
        widget.accounts.isNotEmpty) {
      _ensureDefaults(accounts: widget.accounts, categories: widget.categories);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _recurrenceIntervalController.dispose();
    super.dispose();
  }

  List<Account> _eligibleAccounts(List<Account> accounts) {
    final fixed = widget.fixedCurrencyCode;
    if (fixed == null) return accounts;
    return accounts
        .where((a) => a.currencyCode == fixed)
        .toList(growable: false);
  }

  void _ensureDefaults({
    required List<Account> accounts,
    required List<Category> categories,
  }) {
    if (_didInitDefaults) return;
    if (accounts.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _accountId ??= accounts.first.id;
        _didInitDefaults = true;

        if (_type == TransactionType.transfer &&
            _toAccountId == null &&
            accounts.length > 1) {
          _toAccountId = accounts.firstWhere((a) => a.id != _accountId).id;
        }

        _coerceSelections(accounts: accounts, categories: categories);
      });
    });
  }

  void _coerceSelections({
    required List<Account> accounts,
    required List<Category> categories,
  }) {
    if (_accountId != null && !accounts.any((a) => a.id == _accountId)) {
      _accountId = accounts.isEmpty ? null : accounts.first.id;
      _amount = null;
    }

    if (_toAccountId != null && !accounts.any((a) => a.id == _toAccountId)) {
      _toAccountId = null;
    }

    if (_type == TransactionType.transfer) {
      _categoryId = null;
      return;
    }

    if (_categoryId != null && !categories.any((c) => c.id == _categoryId)) {
      _categoryId = null;
    }

    if (_categoryId != null) {
      final selected = categories.firstWhere(
        (c) => c.id == _categoryId,
        orElse: () => categories.first,
      );
      final requiredType = _type == TransactionType.expense
          ? CategoryType.expense
          : CategoryType.income;
      if (selected.type != requiredType) _categoryId = null;
    }
  }

  DateTime _clampDate(
    DateTime value, {
    required DateTime min,
    required DateTime max,
  }) {
    if (value.isBefore(min)) return min;
    if (value.isAfter(max)) return max;
    return value;
  }

  bool _isValidScheduledDate({
    required DateTime occurredAt,
    required bool scheduleForLater,
  }) {
    final today = DateUtils.dateOnly(DateTime.now());
    final d = DateUtils.dateOnly(occurredAt);
    // If this is recurring and not explicitly scheduled, allow any start date.
    if (_repeat && !scheduleForLater) return true;
    return scheduleForLater ? d.isAfter(today) : !d.isAfter(today);
  }

  int _parsedRecurrenceInterval() {
    final raw = _recurrenceIntervalController.text.trim();
    final value = int.tryParse(raw);
    return value ?? 0;
  }

  bool _hasValidRecurrence({required DateTime startDate}) {
    if (!_repeat) return true;
    if (_recurrenceType == null) return false;

    final interval = _parsedRecurrenceInterval();
    if (interval < 1) return false;

    final endAt = _recurrenceEndAt;
    if (endAt == null) return true;

    final start = DateUtils.dateOnly(startDate);
    final end = DateUtils.dateOnly(endAt);
    return end.isAfter(start);
  }

  Future<void> _pickRecurrenceEndDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final start = DateUtils.dateOnly(_occurredAt);

    final firstDate = start.isAfter(today) ? start : today;
    final lastDate = firstDate.add(const Duration(days: 365 * 10));
    final initial = _recurrenceEndAt == null
        ? firstDate
        : _clampDate(
            DateUtils.dateOnly(_recurrenceEndAt!),
            min: firstDate,
            max: lastDate,
          );

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null) return;

    final now = DateTime.now();
    setState(() {
      _recurrenceEndAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        now.hour,
        now.minute,
      );
    });
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstDate = _scheduleForLater
        ? today.add(const Duration(days: 1))
        : DateTime(2000, 1, 1);
    final lastDate = _scheduleForLater
        ? today.add(const Duration(days: 365 * 5))
        : today;

    final initial = _clampDate(
      DateUtils.dateOnly(_occurredAt),
      min: firstDate,
      max: lastDate,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked == null) return;

    final now = DateTime.now();
    setState(() {
      _occurredAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        now.hour,
        now.minute,
      );
    });
  }

  String _typeLabel(TransactionType type) {
    return switch (type) {
      TransactionType.expense => 'Expense',
      TransactionType.income => 'Income',
      TransactionType.transfer => 'Transfer',
    };
  }

  CategoryType _categoryTypeForTx(TransactionType type) {
    return switch (type) {
      TransactionType.expense => CategoryType.expense,
      TransactionType.income => CategoryType.income,
      TransactionType.transfer => CategoryType.expense, // unused
    };
  }

  Future<String?> _showCreateCategorySheet({required CategoryType type}) async {
    final availableParents = widget.categories
        .where((c) => c.parentId == null)
        .toList(growable: false);

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        var isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.s16,
                right: AppSpacing.s16,
                top: AppSpacing.s8,
                bottom: bottomInset + AppSpacing.s16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Add category',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    CategoryForm(
                      initialName: '',
                      initialType: type,
                      initialParentId: null,
                      initialIconKey: 'other',
                      initialColorHex: null,
                      typeImmutable: true,
                      parentImmutable: false,
                      isSubmitting: isSubmitting,
                      availableParents: availableParents,
                      onSubmit: (values) async {
                        setSheetState(() => isSubmitting = true);
                        try {
                          final now = DateTime.now();
                          final id = IdGenerator.newId();
                          final category = Category(
                            id: id,
                            name: values.name,
                            type: values.type,
                            parentId: values.parentId,
                            iconKey: values.iconKey,
                            colorHex: values.colorHex,
                            createdAt: now,
                            updatedAt: now,
                          );

                          await ref
                              .read(categoryRepositoryProvider)
                              .upsert(category);
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop(id);
                          }
                        } catch (e) {
                          setSheetState(() => isSubmitting = false);
                          if (!sheetContext.mounted) return;
                          ScaffoldMessenger.of(
                            sheetContext,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final eligibleAccounts = _eligibleAccounts(widget.accounts)
      ..sort((a, b) => a.name.compareTo(b.name));
    final categories = widget.categories
      ..sort((a, b) => a.name.compareTo(b.name));

    _ensureDefaults(accounts: eligibleAccounts, categories: categories);
    _coerceSelections(accounts: eligibleAccounts, categories: categories);

    final accountsById = <String, Account>{
      for (final a in eligibleAccounts) a.id: a,
    };

    final currencyCode =
        widget.fixedCurrencyCode ?? accountsById[_accountId]?.currencyCode;
    final scale =
        widget.fixedScale ??
        accountsById[_accountId]?.openingBalance.scale ??
        2;

    final filteredCategories = _type == TransactionType.transfer
        ? const <Category>[]
        : categories
              .where((c) => c.type == _categoryTypeForTx(_type))
              .toList(growable: false);

    final dateText = DateFormat(
      'EEE, d MMM yyyy',
    ).format(DateUtils.dateOnly(_occurredAt));
    final hasValidAmount = _amount != null && _amount!.amountMinor > 0;
    final hasValidDate = _isValidScheduledDate(
      occurredAt: _occurredAt,
      scheduleForLater: _scheduleForLater,
    );
    final hasValidRecurrence = _hasValidRecurrence(startDate: _occurredAt);

    return ListView(
      padding: AppSpacing.pagePadding,
      children: <Widget>[
        SegmentedButton<TransactionType>(
          segments: TransactionType.values
              .map(
                (t) => ButtonSegment<TransactionType>(
                  value: t,
                  label: Text(_typeLabel(t)),
                ),
              )
              .toList(growable: false),
          selected: <TransactionType>{_type},
          onSelectionChanged: (widget.isSubmitting || widget.typeImmutable)
              ? null
              : (selection) {
                  final next = selection.first;
                  setState(() {
                    _type = next;
                    _amount = null;
                    if (_type == TransactionType.transfer) {
                      _categoryId = null;
                      if (_toAccountId == null && eligibleAccounts.length > 1) {
                        _toAccountId = eligibleAccounts
                            .firstWhere((a) => a.id != _accountId)
                            .id;
                      }
                    } else {
                      _toAccountId = null;
                      _categoryId = null;
                    }
                  });
                },
        ),
        const SizedBox(height: AppSpacing.s16),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FormField<Money>(
                key: ValueKey<String>(
                  'amount-$currencyCode-$scale-${_accountId ?? ''}',
                ),
                initialValue: _amount,
                validator: validateMoneyAmount,
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CalculatorAmountInput(
                        currencyCode: currencyCode ?? 'INR',
                        scale: scale,
                        value: state.value,
                        enabled: !widget.isSubmitting,
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
              DropdownButtonFormField<String>(
                key: ValueKey<String>(
                  'account-${_accountId ?? ''}-${_type.name}-${widget.fixedCurrencyCode ?? ''}',
                ),
                initialValue: _accountId,
                decoration: InputDecoration(
                  labelText: _type == TransactionType.transfer
                      ? 'From account'
                      : 'Account',
                ),
                items: eligibleAccounts
                    .map(
                      (a) => DropdownMenuItem<String>(
                        value: a.id,
                        child: Text('${a.name} • ${a.currencyCode}'),
                      ),
                    )
                    .toList(growable: false),
                onChanged: widget.isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _accountId = value;
                          _amount = null;
                          if (_type == TransactionType.transfer &&
                              _accountId == _toAccountId) {
                            _toAccountId = null;
                          }
                        });
                      },
                validator: (value) =>
                    validateRequiredId(value, 'Account is required'),
              ),
              if (_type == TransactionType.transfer) ...<Widget>[
                const SizedBox(height: AppSpacing.s16),
                DropdownButtonFormField<String>(
                  key: ValueKey<String>(
                    'toAccount-${_toAccountId ?? ''}-${_accountId ?? ''}',
                  ),
                  initialValue: _toAccountId,
                  decoration: const InputDecoration(labelText: 'To account'),
                  items: eligibleAccounts
                      .map(
                        (a) => DropdownMenuItem<String>(
                          value: a.id,
                          child: Text('${a.name} • ${a.currencyCode}'),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: widget.isSubmitting
                      ? null
                      : (value) => setState(() => _toAccountId = value),
                  validator: (_) => validateTransferAccounts(
                    fromAccountId: _accountId,
                    toAccountId: _toAccountId,
                  ),
                ),
              ],
              if (_type != TransactionType.transfer) ...<Widget>[
                const SizedBox(height: AppSpacing.s16),
                DropdownButtonFormField<String>(
                  key: ValueKey<String>(
                    'category-${_categoryId ?? ''}-${_type.name}',
                  ),
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: <DropdownMenuItem<String>>[
                    ...filteredCategories.map(
                      (c) => DropdownMenuItem<String>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                    ),
                    const DropdownMenuItem<String>(
                      value: _kAddNewCategoryId,
                      child: Text('+ Add new category'),
                    ),
                    const DropdownMenuItem<String>(
                      value: _kOthersCategoryId,
                      child: Text('Others'),
                    ),
                  ],
                  onChanged: widget.isSubmitting
                      ? null
                      : (value) async {
                          if (!mounted) return;
                          if (value == null) {
                            setState(() => _categoryId = null);
                            return;
                          }

                          if (value == _kAddNewCategoryId ||
                              value == _kOthersCategoryId) {
                            // Prevent the special sentinel from becoming the selected value.
                            setState(() => _categoryId = null);

                            final requiredType = _categoryTypeForTx(_type);
                            final createdId = await _showCreateCategorySheet(
                              type: requiredType,
                            );
                            if (!mounted) return;
                            if (createdId != null) {
                              setState(() => _categoryId = createdId);
                            }
                            return;
                          }

                          setState(() => _categoryId = value);
                        },
                  validator: (value) =>
                      validateRequiredId(value, 'Category is required'),
                ),
              ],
              const SizedBox(height: AppSpacing.s16),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _scheduleForLater,
                onChanged: widget.isSubmitting
                    ? null
                    : (value) {
                        final today = DateUtils.dateOnly(DateTime.now());
                        setState(() {
                          _scheduleForLater = value;

                          // Keep the selected date within the allowed range.
                          final isValid = _isValidScheduledDate(
                            occurredAt: _occurredAt,
                            scheduleForLater: _scheduleForLater,
                          );
                          if (!isValid) {
                            final now = DateTime.now();
                            final nextDate = _scheduleForLater
                                ? today.add(const Duration(days: 1))
                                : today;
                            _occurredAt = DateTime(
                              nextDate.year,
                              nextDate.month,
                              nextDate.day,
                              now.hour,
                              now.minute,
                            );
                          }
                        });
                      },
                title: const Text('Schedule for later'),
              ),
              const SizedBox(height: AppSpacing.s8),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _repeat,
                onChanged: widget.isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _repeat = value;
                          if (!_repeat) {
                            _recurrenceType = null;
                            _recurrenceIntervalController.text = '1';
                            _recurrenceEndAt = null;
                          } else {
                            _recurrenceType ??= RecurrenceType.monthly;
                            if (_parsedRecurrenceInterval() < 1) {
                              _recurrenceIntervalController.text = '1';
                            }
                          }
                        });
                      },
                title: const Text('Repeat'),
              ),
              AnimatedSize(
                duration: Motion.duration(context, MotionDurations.fast),
                curve: MotionCurves.standard,
                child: _repeat
                    ? Column(
                        key: const ValueKey<String>('repeat-on'),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: AppSpacing.s8),
                          DropdownButtonFormField<RecurrenceType>(
                            initialValue: _recurrenceType,
                            decoration: const InputDecoration(
                              labelText: 'Frequency',
                            ),
                            items: RecurrenceType.values
                                .map(
                                  (t) => DropdownMenuItem<RecurrenceType>(
                                    value: t,
                                    child: Text(switch (t) {
                                      RecurrenceType.daily => 'Daily',
                                      RecurrenceType.weekly => 'Weekly',
                                      RecurrenceType.monthly => 'Monthly',
                                      RecurrenceType.yearly => 'Yearly',
                                    }),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: widget.isSubmitting
                                ? null
                                : (value) =>
                                      setState(() => _recurrenceType = value),
                            validator: (value) => _repeat && value == null
                                ? 'Frequency is required'
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          TextFormField(
                            controller: _recurrenceIntervalController,
                            enabled: !widget.isSubmitting,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Interval',
                              helperText: 'Every N units (e.g. every 1 month).',
                            ),
                            validator: (_) {
                              if (!_repeat) return null;
                              final interval = _parsedRecurrenceInterval();
                              return interval >= 1
                                  ? null
                                  : 'Interval must be at least 1';
                            },
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          InkWell(
                            onTap: widget.isSubmitting
                                ? null
                                : _pickRecurrenceEndDate,
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'End date (optional)',
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    if (_recurrenceEndAt != null)
                                      IconButton(
                                        tooltip: 'Clear',
                                        onPressed: widget.isSubmitting
                                            ? null
                                            : () => setState(
                                                () => _recurrenceEndAt = null,
                                              ),
                                        icon: const Icon(Icons.close),
                                      ),
                                    const Icon(Icons.calendar_today_outlined),
                                  ],
                                ),
                              ),
                              child: Text(
                                _recurrenceEndAt == null
                                    ? 'No end date'
                                    : DateFormat('EEE, d MMM yyyy').format(
                                        DateUtils.dateOnly(_recurrenceEndAt!),
                                      ),
                              ),
                            ),
                          ),
                          if (!hasValidRecurrence) ...<Widget>[
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              'Recurrence rule is invalid. Check frequency, interval, and end date.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                        ],
                      )
                    : const SizedBox.shrink(
                        key: ValueKey<String>('repeat-off'),
                      ),
              ),
              const SizedBox(height: AppSpacing.s16),
              InkWell(
                onTap: widget.isSubmitting ? null : _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(dateText),
                ),
              ),
              if (!hasValidDate) ...<Widget>[
                const SizedBox(height: AppSpacing.s4),
                AnimatedSize(
                  duration: Motion.duration(context, MotionDurations.xFast),
                  curve: MotionCurves.standard,
                  child: Text(
                    _scheduleForLater
                        ? 'Scheduled transactions must be dated after today.'
                        : 'Non-scheduled transactions cannot be dated in the future.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _titleController,
                enabled: !widget.isSubmitting,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Title (optional)',
                  helperText:
                      'If left blank, category name will be used when available.',
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                height: 48,
                child: PressableScaleDecorator(
                  enabled: widget.saveEnabled && !widget.isSubmitting,
                  pressedScale: 0.97,
                  child: FilledButton(
                    onPressed:
                        (!widget.saveEnabled ||
                            widget.isSubmitting ||
                            !hasValidAmount ||
                            !hasValidDate ||
                            !hasValidRecurrence)
                        ? null
                        : () async {
                            final form = _formKey.currentState;
                            if (form == null) return;
                            if (!form.validate()) return;

                            final accountId = _accountId;
                            final money = _amount;
                            if (accountId == null || money == null) return;

                            final title = _titleController.text.trim();
                            await widget.onSubmit(
                              TransactionFormResult(
                                type: _type,
                                accountId: accountId,
                                toAccountId: _type == TransactionType.transfer
                                    ? _toAccountId
                                    : null,
                                categoryId: _type == TransactionType.transfer
                                    ? null
                                    : _categoryId,
                                amount: money,
                                occurredAt: _occurredAt,
                                scheduleForLater: _scheduleForLater,
                                repeat: _repeat,
                                recurrenceType: _repeat
                                    ? _recurrenceType
                                    : null,
                                recurrenceInterval: _repeat
                                    ? _parsedRecurrenceInterval()
                                    : 1,
                                recurrenceEndAt: _repeat
                                    ? _recurrenceEndAt
                                    : null,
                                title: title.isEmpty ? null : title,
                              ),
                            );
                          },
                    child: widget.isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
