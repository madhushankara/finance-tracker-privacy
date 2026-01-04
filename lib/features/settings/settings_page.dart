import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../data/models/app_settings.dart';
import 'providers/settings_controller.dart';
import 'providers/settings_providers.dart';

final class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showUnderDevelopment(BuildContext context) {
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

  Color _accentColor(AppAccentColor accent) {
    switch (accent) {
      case AppAccentColor.blue:
        return const Color(0xFF7DD3FC);
      case AppAccentColor.purple:
        return const Color(0xFFA78BFA);
      case AppAccentColor.green:
        return const Color(0xFF34D399);
      case AppAccentColor.orange:
        return const Color(0xFFF59E0B);
      case AppAccentColor.red:
        return const Color(0xFFF87171);
      case AppAccentColor.teal:
        return const Color(0xFF2DD4BF);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final controller = ref.watch(settingsControllerProvider);
    final isSaving = controller.isLoading;

    final currencyOptionsAsync = ref.watch(settingsCurrencyOptionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          // 1) Theme (keep existing controls)
          Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Theme mode',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  RadioGroup<AppThemeMode>(
                    groupValue: settings.themeMode,
                    onChanged: (v) {
                      if (isSaving) return;
                      if (v == null) return;
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateThemeMode(v);
                    },
                    child: const Column(
                      children: <Widget>[
                        RadioListTile<AppThemeMode>(
                          value: AppThemeMode.system,
                          title: Text('System'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<AppThemeMode>(
                          value: AppThemeMode.light,
                          title: Text('Light'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<AppThemeMode>(
                          value: AppThemeMode.dark,
                          title: Text('Dark'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    'Accent color',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Opacity(
                    opacity: settings.useMaterialYouColors ? 0.5 : 1,
                    child: IgnorePointer(
                      ignoring: settings.useMaterialYouColors || isSaving,
                      child: Wrap(
                        spacing: AppSpacing.s8,
                        runSpacing: AppSpacing.s8,
                        children: AppAccentColor.values
                            .map(
                              (a) => _AccentSwatch(
                                color: _accentColor(a),
                                selected: a == settings.accentColor,
                                onTap: () {
                                  ref
                                      .read(settingsControllerProvider.notifier)
                                      .updateAccentColor(a);
                                },
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Consumer(
                    builder: (context, ref, _) {
                      final support = ref.watch(materialYouSupportProvider);
                      final bool? isSupported = support.value;
                      final bool supported = isSupported ?? false;

                      final String subtitle = support.isLoading
                          ? 'Checking support…'
                          : supported
                          ? 'Use dynamic colors from your wallpaper.'
                          : 'Material You is not supported on this device.';

                      return SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Material You'),
                        subtitle: Text(subtitle),
                        value: supported && settings.useMaterialYouColors,
                        onChanged: (isSaving || support.isLoading || !supported)
                            ? null
                            : (value) {
                                ref
                                    .read(settingsControllerProvider.notifier)
                                    .updateUseMaterialYouColors(value);
                              },
                      );
                    },
                  ),
                  const Divider(height: AppSpacing.s24),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Highlight expenses in red'),
                    subtitle: const Text(
                      'Show debited transaction amounts in red for better visibility.',
                    ),
                    value: settings.showExpenseInRed,
                    onChanged: isSaving
                        ? null
                        : (value) {
                            ref
                                .read(settingsControllerProvider.notifier)
                                .updateShowExpenseInRed(value);
                          },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 2) Preferences
          Text('Preferences', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.dashboard_customize_outlined),
                    title: const Text('Edit homepage'),
                    subtitle: const Text('Show or hide sections on Home'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(Routes.editHomepage),
                  ),
                  const Divider(height: AppSpacing.s24),
                  Text(
                    'First day of week',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  RadioGroup<FirstDayOfWeek>(
                    groupValue: settings.firstDayOfWeek,
                    onChanged: (v) {
                      if (isSaving) return;
                      if (v == null) return;
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateFirstDayOfWeek(v);
                    },
                    child: const Column(
                      children: <Widget>[
                        RadioListTile<FirstDayOfWeek>(
                          value: FirstDayOfWeek.monday,
                          title: Text('Monday'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<FirstDayOfWeek>(
                          value: FirstDayOfWeek.sunday,
                          title: Text('Sunday'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    'Date format',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  RadioGroup<AppDateFormat>(
                    groupValue: settings.dateFormat,
                    onChanged: (v) {
                      if (isSaving) return;
                      if (v == null) return;
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateDateFormat(v);
                    },
                    child: const Column(
                      children: <Widget>[
                        RadioListTile<AppDateFormat>(
                          value: AppDateFormat.localeBased,
                          title: Text('Locale-based'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<AppDateFormat>(
                          value: AppDateFormat.iso,
                          title: Text('ISO (YYYY-MM-DD)'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    'Primary currency',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  currencyOptionsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text(e.toString()),
                    data: (options) {
                      final effective =
                          options.contains(settings.primaryCurrencyCode)
                          ? settings.primaryCurrencyCode
                          : (options.isNotEmpty
                                ? options.first
                                : settings.primaryCurrencyCode);

                      return DropdownButtonFormField<String>(
                        key: ValueKey<String>(effective),
                        initialValue: effective,
                        items: options
                            .map(
                              (c) => DropdownMenuItem<String>(
                                value: c,
                                child: Text(c),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: isSaving
                            ? null
                            : (v) {
                                if (v == null) return;
                                ref
                                    .read(settingsControllerProvider.notifier)
                                    .updatePrimaryCurrencyCode(v);
                              },
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 3) Navigation
          Text('Navigation', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Swipe between tabs'),
                subtitle: const Text(
                  'Allow swiping left/right to switch between main tabs.',
                ),
                value: settings.swipeBetweenTabsEnabled,
                onChanged: isSaving
                    ? null
                    : (value) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateSwipeBetweenTabsEnabled(value);
                      },
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 4) Notifications
          Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notification settings'),
              subtitle: const Text('Reminders and upcoming transactions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.notifications),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 5) Security
          Text('Security', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Biometric lock'),
              subtitle: const Text('Require biometric on app launch'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.security),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 6) Language
          Text('Language', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text('App language'),
              subtitle: Text(
                'Selected: ${settings.languageCode.toUpperCase()}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.language),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 7) Tools & Extras
          Text(
            'Tools & Extras',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Bill Splitter'),
              subtitle: const Text('Split a bill among people'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.billSplitter),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Onboarding walkthrough'),
              subtitle: const Text(
                'Revisit the quick overview of core concepts',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.onboarding),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 8) Import & Export
          Text(
            'Import & Export',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: const Text('Export CSV file'),
              subtitle: const Text(
                'CSV backup (ZIP) for accounts, budgets, and transactions',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.exportData),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.file_upload_outlined),
              title: const Text('Import CSV file'),
              subtitle: const Text('This feature is under development.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showUnderDevelopment(context),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Import Google Sheet'),
              subtitle: const Text('This feature is under development.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showUnderDevelopment(context),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),
          // 9) Backups
          Text('Backups', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('Backups & restore'),
              subtitle: const Text('Manage backups (under development)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.backups),
            ),
          ),
        ],
      ),
    );
  }
}

final class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selected ? Colors.white : outline.withValues(alpha: 0.6),
            width: selected ? 2 : 1,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 18, color: Colors.black)
            : null,
      ),
    );
  }
}
