import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/category.dart';
import '../../../data/models/enums.dart';
import 'category_pickers.dart';

final class CategoryFormValues {
  const CategoryFormValues({
    required this.name,
    required this.type,
    required this.parentId,
    required this.iconKey,
    required this.colorHex,
  });

  final String name;
  final CategoryType type;
  final String? parentId;
  final String? iconKey;
  final int? colorHex;
}

final class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    required this.initialName,
    required this.initialType,
    required this.initialParentId,
    required this.initialIconKey,
    required this.initialColorHex,
    required this.typeImmutable,
    required this.parentImmutable,
    required this.isSubmitting,
    required this.availableParents,
    required this.onSubmit,
  });

  final String initialName;
  final CategoryType initialType;
  final String? initialParentId;
  final String? initialIconKey;
  final int? initialColorHex;

  final bool typeImmutable;
  final bool parentImmutable;
  final bool isSubmitting;

  final List<Category> availableParents;
  final Future<void> Function(CategoryFormValues values) onSubmit;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

final class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  late CategoryType _type;
  String? _parentId;
  String? _iconKey;
  int? _colorHex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _type = widget.initialType;
    _parentId = widget.initialParentId;
    _iconKey = widget.initialIconKey;
    _colorHex = widget.initialColorHex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    final name = _nameController.text.trim();

    await widget.onSubmit(
      CategoryFormValues(
        name: name,
        type: _type,
        parentId: _parentId,
        iconKey: _iconKey,
        colorHex: _colorHex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final parentsForType = widget.availableParents.where((c) => c.type == _type).toList(growable: false);

    if (!widget.parentImmutable && _parentId != null) {
      final stillValid = parentsForType.any((c) => c.id == _parentId);
      if (!stillValid) {
        _parentId = null;
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            enabled: !widget.isSubmitting,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Category name'),
            validator: (value) {
              final v = (value ?? '').trim();
              if (v.isEmpty) return 'Name is required';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          FormField<CategoryType>(
            initialValue: _type,
            validator: (value) {
              if (value == null) return 'Category type is required';
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownMenu<CategoryType>(
                    initialSelection: state.value,
                    enabled: !widget.isSubmitting && !widget.typeImmutable,
                    label: const Text('Category type'),
                    dropdownMenuEntries: CategoryType.values
                        .map(
                          (t) => DropdownMenuEntry<CategoryType>(
                            value: t,
                            label: _typeLabel(t),
                          ),
                        )
                        .toList(growable: false),
                    onSelected: (widget.isSubmitting || widget.typeImmutable)
                        ? null
                        : (v) {
                            if (v == null) return;
                            state.didChange(v);
                            setState(() => _type = v);
                          },
                  ),
                  if (widget.typeImmutable) ...<Widget>[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      'Type can\'t be changed',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurface.withValues(alpha: 0.65)),
                    ),
                  ],
                  if (state.hasError) ...<Widget>[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      state.errorText ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.error),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          FormField<String?>(
            initialValue: _parentId,
            validator: (value) {
              if (widget.parentImmutable) return null;
              if (value == null) return null;
              final ok = parentsForType.any((c) => c.id == value);
              if (!ok) return 'Parent must match the same type';
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownMenu<String?>(
                    initialSelection: state.value,
                    enabled: !widget.isSubmitting && !widget.parentImmutable,
                    label: const Text('Parent category (optional)'),
                    dropdownMenuEntries: <DropdownMenuEntry<String?>>[
                      const DropdownMenuEntry<String?>(value: null, label: 'None'),
                      ...parentsForType.map(
                        (c) => DropdownMenuEntry<String?>(
                          value: c.id,
                          label: c.name,
                        ),
                      ),
                    ],
                    onSelected: (widget.isSubmitting || widget.parentImmutable)
                        ? null
                        : (v) {
                            state.didChange(v);
                            setState(() => _parentId = v);
                          },
                  ),
                  if (widget.parentImmutable) ...<Widget>[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      'Parent can\'t be changed yet',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurface.withValues(alpha: 0.65)),
                    ),
                  ],
                  if (state.hasError) ...<Widget>[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      state.errorText ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.error),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          Text('Icon', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s8),
          IconPickerGrid(
            selected: _iconKey,
            enabled: !widget.isSubmitting,
            onSelected: (key) => setState(() => _iconKey = key),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text('Color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s8),
          ColorPickerRow(
            selectedHex: _colorHex,
            enabled: !widget.isSubmitting,
            onSelected: (hex) => setState(() => _colorHex = hex),
          ),
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

String _typeLabel(CategoryType type) {
  return switch (type) {
    CategoryType.expense => 'Expense',
    CategoryType.income => 'Income',
  };
}
