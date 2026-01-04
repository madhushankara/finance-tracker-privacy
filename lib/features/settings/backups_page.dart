import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/pressable_scale.dart';
import '../auth/providers/auth_providers.dart';

final class BackupsPage extends ConsumerWidget {
  const BackupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final isBusy = ref.watch(authControllerProvider).isLoading;

    final username = auth.username ?? (auth.isLoggedIn ? 'User' : 'Guest');

    return Scaffold(
      appBar: AppBar(title: const Text('Backups')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Username: $username'),
                  const SizedBox(height: AppSpacing.s8),
                  const Text('Email: Under development'),
                  const SizedBox(height: AppSpacing.s16),
                  SizedBox(
                    width: double.infinity,
                    child: PressableScaleDecorator.forButton(
                      onPressed: (!auth.isLoggedIn || isBusy)
                          ? null
                          : () async {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .logout();
                              if (!context.mounted) return;
                              context.go(Routes.home);
                            },
                      child: FilledButton.tonal(
                        onPressed: (!auth.isLoggedIn || isBusy)
                            ? null
                            : () async {
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .logout();
                                if (!context.mounted) return;
                                context.go(Routes.home);
                              },
                        child: const Text('Logout'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          _bigButton(
            context,
            label: 'Backup',
            icon: Icons.backup_outlined,
            onPressed: () => _underDev(context),
          ),
          const SizedBox(height: AppSpacing.s8),
          _bigButton(
            context,
            label: 'Restore',
            icon: Icons.restore_outlined,
            onPressed: () => _underDev(context),
          ),
          const SizedBox(height: AppSpacing.s8),
          _bigButton(
            context,
            label: 'Sync',
            icon: Icons.sync_outlined,
            onPressed: () => _underDev(context),
          ),
          const SizedBox(height: AppSpacing.s8),
          _bigButton(
            context,
            label: 'Backups',
            icon: Icons.folder_open_outlined,
            onPressed: () => _underDev(context),
          ),
        ],
      ),
    );
  }

  Widget _bigButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: PressableScaleDecorator.forButton(
        onPressed: onPressed,
        child: FilledButton.tonal(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon),
              const SizedBox(width: AppSpacing.s8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  void _underDev(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Under development'),
        content: const Text('This feature is under development.'),
        actions: <Widget>[
          PressableScaleDecorator.forButton(
            onPressed: () => Navigator.of(context).pop(),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
