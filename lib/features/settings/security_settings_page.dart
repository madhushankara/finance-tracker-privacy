import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import 'providers/settings_controller.dart';
import 'providers/settings_providers.dart';

final class SecuritySettingsPage extends ConsumerWidget {
  const SecuritySettingsPage({super.key});

  bool _isBiometricSupported() {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    final supported = _isBiometricSupported();
    final subtitle = supported
        ? 'Persisted preference only. Authentication is under development.'
        : 'Biometric authentication is not supported on this device.';

    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          Card(
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
              ),
              title: const Text('Require biometric on app launch'),
              subtitle: Text(subtitle),
              value: supported ? settings.requireBiometricOnLaunch : false,
              onChanged: (isSaving || !supported)
                  ? null
                  : (v) async {
                      await ref
                          .read(settingsControllerProvider.notifier)
                          .updateSettings(
                            settings.copyWith(requireBiometricOnLaunch: v),
                          );
                    },
            ),
          ),
        ],
      ),
    );
  }
}
