import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

final class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: const EmptyState(
        title: 'Categories',
        body: 'Create a clean hierarchy with icons and colors.',
      ),
    );
  }
}
