import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/providers/auth_providers.dart';

final class UserHubPage extends ConsumerWidget {
  const UserHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.go(Routes.login);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final title = (auth.displayName?.trim().isNotEmpty ?? false)
        ? auth.displayName!.trim()
        : (auth.username ?? 'User');

    return Scaffold(
      appBar: AppBar(title: const Text('User Hub')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: ListView(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      auth.isLoggedIn
                          ? 'Local profile • @${auth.username ?? ''}'
                          : 'Log in or sign up to personalize your experience.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            ListTile(
              leading: const Icon(Icons.data_usage_outlined),
              title: const Text('User Data'),
              subtitle: const Text('Export and manage your data'),
              onTap: () => context.push(Routes.userData),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Account'),
              subtitle: const Text('Profile and login'),
              onTap: () => context.push(Routes.userAccount),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('Cloud sync'),
              subtitle: const Text('Under development'),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Coming soon'),
                    content: const Text('Cloud sync is under development.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
