import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/providers/auth_providers.dart';

final class UserDataPage extends ConsumerWidget {
  const UserDataPage({super.key});

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

    return Scaffold(
      appBar: AppBar(title: const Text('User Data')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: AppSpacing.s8),
            Text('Data tools', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s8),
            ListTile(
              leading: const Icon(Icons.upload_file_outlined),
              title: const Text('Export data'),
              subtitle: const Text('Download your data as JSON'),
              onTap: () => context.push(Routes.exportData),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Encryption'),
              subtitle: const Text('Under development'),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Under development'),
                    content: const Text(
                      'Advanced security features are coming soon.',
                    ),
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
