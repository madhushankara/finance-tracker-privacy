import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../data/models/enums.dart';
import 'providers/categories_controller.dart';
import 'providers/categories_providers.dart';
import 'widgets/category_form.dart';

final class AddCategoryPage extends ConsumerWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = ref.watch(categoriesControllerProvider).isLoading;
    final allCategoriesAsync = ref.watch(categoriesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add category')),
      body: allCategoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: Text(error.toString()),
        ),
        data: (items) {
          // Only allow selecting parents that are top-level categories.
          final availableParents = items.where((c) => c.parentId == null).toList(growable: false);

          return Padding(
            padding: AppSpacing.pagePadding,
            child: CategoryForm(
              initialName: '',
              initialType: CategoryType.expense,
              initialParentId: null,
              initialIconKey: 'other',
              initialColorHex: null,
              typeImmutable: false,
              parentImmutable: false,
              isSubmitting: isSubmitting,
              availableParents: availableParents,
              onSubmit: (values) async {
                try {
                  await ref.read(categoriesControllerProvider.notifier).createCategory(
                        name: values.name,
                        type: values.type,
                        parentId: values.parentId,
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
          );
        },
      ),
    );
  }
}
