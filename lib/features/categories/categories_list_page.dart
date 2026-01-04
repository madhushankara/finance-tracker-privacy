import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/category.dart';
import '../../data/models/enums.dart';
import 'providers/categories_providers.dart';
import 'widgets/category_icon.dart';

final class CategoriesListPage extends ConsumerWidget {
  const CategoriesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Add category',
            onPressed: () => context.push(Routes.categoriesAdd),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load categories',
            body: error.toString(),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'No categories yet',
                body: 'Add categories to organize spending and income.',
              ),
            );
          }

          final expense = items.where((c) => c.type == CategoryType.expense).toList(growable: false);
          final income = items.where((c) => c.type == CategoryType.income).toList(growable: false);

          return ListView(
            padding: AppSpacing.pagePadding,
            children: <Widget>[
              _CategoryGroup(
                title: 'Expense',
                items: expense,
              ),
              const SizedBox(height: AppSpacing.s24),
              _CategoryGroup(
                title: 'Income',
                items: income,
              ),
            ],
          );
        },
      ),
    );
  }
}

final class _CategoryGroup extends ConsumerWidget {
  const _CategoryGroup({required this.title, required this.items});

  final String title;
  final List<Category> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s8),
          Text('No $title categories', style: theme.textTheme.bodyMedium),
        ],
      );
    }

    final parents = items.where((c) => c.parentId == null).toList(growable: false);
    final children = items.where((c) => c.parentId != null).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.s8),
        ...parents.map((p) {
          final childCount = children.where((c) => c.parentId == p.id).length;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: _CategoryTile(
              category: p,
              subCount: childCount,
              indent: 0,
            ),
          );
        }),
        if (children.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.s8),
          ...children
              .where((c) => parents.every((p) => p.id != c.parentId))
              .map((orphan) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                    child: _CategoryTile(
                      category: orphan,
                      subCount: 0,
                      indent: 0,
                    ),
                  )),
        ],
      ],
    );
  }
}

final class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.subCount, required this.indent});

  final Category category;
  final int subCount;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: () => context.push(Routes.categoryEdit(category.id)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 48,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: CategoryIcon(
                      iconKey: category.iconKey,
                      colorHex: category.colorHex,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subCount > 0) ...<Widget>[
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        '$subCount subcategories',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
