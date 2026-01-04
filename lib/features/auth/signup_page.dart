import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/coming_soon_dialog.dart';
import '../../core/widgets/pressable_scale.dart';
import 'providers/auth_providers.dart';

final class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

final class _SignupPageState extends ConsumerState<SignupPage> {
  final _usernameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  DateTime? _birthday;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
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
                'Create your profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.s16),
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
                controller: _nameCtrl,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              OutlinedButton(
                onPressed: isBusy
                    ? null
                    : () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          initialDate: _birthday ?? DateTime(2000, 1, 1),
                        );
                        if (picked == null) return;
                        setState(() => _birthday = picked);
                      },
                child: Text(
                  _birthday == null
                      ? 'Add birthday (optional)'
                      : 'Birthday: ${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}',
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
                      : const Text('Create account'),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => showComingSoonDialog(context),
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Sign up with Google'),
              ),
              const SizedBox(height: AppSpacing.s8),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => showComingSoonDialog(context),
                icon: const Icon(Icons.phone_iphone),
                label: const Text('Sign up with Phone number'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signup(
            username: _usernameCtrl.text,
            displayName: _nameCtrl.text,
            birthday: _birthday,
          );
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
