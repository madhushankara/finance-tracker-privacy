import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/pressable_scale.dart';
import '../auth/providers/auth_providers.dart';
import '../auth/models/auth_state.dart';

final class UserAccountPage extends ConsumerWidget {
  const UserAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final isBusy = ref.watch(authControllerProvider).isLoading;

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.go(Routes.login);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: ListView(
          children: _buildLoggedInChildren(context, ref, auth, isBusy),
        ),
      ),
    );
  }

  List<Widget> _buildLoggedInChildren(
    BuildContext context,
    WidgetRef ref,
    AuthState auth,
    bool isBusy,
  ) {
    return <Widget>[
      const SizedBox(height: AppSpacing.s8),
      Text('Profile', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.s8),
      ListTile(
        leading: const Icon(Icons.badge_outlined),
        title: const Text('Name'),
        subtitle: Text(auth.displayName ?? 'Not set'),
        onTap: isBusy
            ? null
            : () async {
                final ctrl = TextEditingController(
                  text: auth.displayName ?? '',
                );
                final res = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Update name'),
                    content: TextField(
                      controller: ctrl,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      PressableScaleDecorator.forButton(
                        onPressed: () => Navigator.of(context).pop(ctrl.text),
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(ctrl.text),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                );
                if (res == null) return;
                await ref
                    .read(authControllerProvider.notifier)
                    .updateDisplayName(res);
              },
      ),
      const Divider(height: 1),
      ListTile(
        leading: const Icon(Icons.cake_outlined),
        title: const Text('Birthday'),
        subtitle: Text(
          auth.birthday == null ? 'Not set' : _dateText(auth.birthday!),
        ),
        onTap: isBusy
            ? null
            : () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialDate: auth.birthday ?? DateTime(2000, 1, 1),
                );
                if (picked == null) return;
                await ref
                    .read(authControllerProvider.notifier)
                    .updateBirthday(picked);
              },
        trailing: auth.birthday == null
            ? null
            : IconButton(
                tooltip: 'Clear',
                onPressed: isBusy
                    ? null
                    : () => ref
                          .read(authControllerProvider.notifier)
                          .updateBirthday(null),
                icon: const Icon(Icons.clear),
              ),
      ),
      const SizedBox(height: AppSpacing.s16),
      PressableScaleDecorator.forButton(
        onPressed: isBusy
            ? null
            : () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (!context.mounted) return;
                context.go(Routes.home);
              },
        child: FilledButton.tonal(
          onPressed: isBusy
              ? null
              : () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (!context.mounted) return;
                  context.go(Routes.home);
                },
          child: const Text('Log out'),
        ),
      ),
    ];
  }

  String _dateText(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }
}
