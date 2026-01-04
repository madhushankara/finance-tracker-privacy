import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import 'providers/settings_controller.dart';
import 'providers/settings_providers.dart';

final class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  static const _languages = <(String code, String label)>[
    ('en', 'English (English)'),
    ('hi', 'हिंदी (Hindi)'),
    ('ta', 'தமிழ் (Tamil)'),
    ('te', 'తెలుగు (Telugu)'),
    ('ml', 'മലയാളം (Malayalam)'),
    ('bn', 'বাংলা (Bengali)'),
    ('es', 'Español (Spanish)'),
    ('fr', 'Français (French)'),
    ('de', 'Deutsch (German)'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Text(
                'Translations will be added soon.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          RadioGroup<String>(
            groupValue: settings.languageCode,
            onChanged: (v) {
              if (isSaving) return;
              if (v == null) return;
              ref
                  .read(settingsControllerProvider.notifier)
                  .updateSettings(settings.copyWith(languageCode: v));
            },
            child: Column(
              children: _languages
                  .map(
                    (l) => Card(
                      child: RadioListTile<String>(
                        value: l.$1,
                        title: Text(l.$2),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}
