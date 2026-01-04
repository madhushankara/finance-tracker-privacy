import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import 'pages/under_development_page.dart';

final class AddMethodSelectorPage extends StatelessWidget {
  const AddMethodSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          Text(
            'Choose a method',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Select how you want to add new data.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          _OptionCard(
            icon: Icons.edit_note_outlined,
            title: 'Add transaction manually',
            description: 'Enter amount, category, and date.',
            onTap: () => context.push(Routes.transactionsAdd),
          ),
          const SizedBox(height: AppSpacing.s16),
          _OptionCard(
            icon: Icons.upload_file_outlined,
            title: 'Import bank statement',
            description: 'CSV / PDF – AI parser (coming soon).',
            onTap: () => context.push(Routes.addBankStatement),
          ),
          const SizedBox(height: AppSpacing.s16),
          _OptionCard(
            icon: Icons.account_balance_outlined,
            title: 'Link bank account',
            description: 'Connect your bank for automatic updates.',
            onTap: () {
              context.push(
                Routes.underDevelopment,
                extra: const UnderDevelopmentArgs(
                  message:
                      'Bank account linking is currently under development.',
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          _OptionCard(
            icon: Icons.photo_camera_outlined,
            title: 'Photo',
            description: 'Upload or capture a receipt (coming soon).',
            onTap: () => context.push(Routes.addPhoto),
          ),
        ],
      ),
    );
  }
}

final class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: cs.primary),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
