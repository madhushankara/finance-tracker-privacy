import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/category.dart';
import 'providers/categories_controller.dart';
import 'providers/categories_providers.dart';
import 'widgets/category_form.dart';

final class EditCategoryPage extends ConsumerWidget {
  const EditCategoryPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryByIdProvider(categoryId));
    final isSubmitting = ref.watch(categoriesControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit category')),
      body: category.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load category',
            body: error.toString(),
          ),
        ),
        data: (cat) {
          if (cat == null) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'Category not found',
                body: 'This category may have been deleted.',
              ),
            );
          }

          final availableParents = ref.watch(categoriesListProvider).maybeWhen(
                data: (items) => items.where((c) => c.parentId == null).toList(growable: false),
                orElse: () => const <Category>[],
              );

          return Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CategoryForm(
                  initialName: cat.name,
                  initialType: cat.type,
                  initialParentId: cat.parentId,
                  initialIconKey: cat.iconKey ?? 'other',
                  initialColorHex: cat.colorHex,
                  typeImmutable: true,
                  parentImmutable: true,
                  isSubmitting: isSubmitting,
                  availableParents: availableParents,
                  onSubmit: (values) async {
                    try {
                      await ref.read(categoriesControllerProvider.notifier).updateCategory(
                            existing: cat,
                            name: values.name,
                            iconKey: values.iconKey,
                            colorHex: values.colorHex,
                          );
                      if (context.mounted) context.pop();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete category?'),
                                  content: Text('Delete "${cat.name}"? This can\'t be undone.'),
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
                              await ref.read(categoriesControllerProvider.notifier).deleteCategory(category: cat);
                              if (!context.mounted) return;
                              context.pop();
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete category'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
