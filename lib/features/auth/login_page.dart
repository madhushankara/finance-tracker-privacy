import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/motion.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/coming_soon_dialog.dart';
import '../../core/widgets/pressable_scale.dart';
import 'providers/auth_providers.dart';

final class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
        actions: <Widget>[
          TextButton(
            onPressed: isBusy ? null : () => context.go(Routes.home),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'This app uses local-only login for now.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              TextField(
                controller: _usernameCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                onSubmitted: (_) => _submit(context),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              PressableScaleDecorator.forButton(
                onPressed: isBusy ? null : () => _submit(context),
                child: FilledButton(
                  onPressed: isBusy ? null : () => _submit(context),
                  child: isBusy
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Log in'),
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              PressableScaleDecorator.forButton(
                onPressed: isBusy ? null : () => context.push(Routes.signup),
                child: OutlinedButton(
                  onPressed: isBusy ? null : () => context.push(Routes.signup),
                  child: const Text('Create account'),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => showComingSoonDialog(context),
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Log in with Google'),
              ),
              const SizedBox(height: AppSpacing.s8),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => showComingSoonDialog(context),
                icon: const Icon(Icons.phone_iphone),
                label: const Text('Log in with Phone number'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!Motion.reduceMotion(context)) {
      HapticFeedback.lightImpact();
    }
    final u = _usernameCtrl.text;
    final p = _passwordCtrl.text;

    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(username: u, password: p);
      if (!context.mounted) return;
      context.go(Routes.home);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
