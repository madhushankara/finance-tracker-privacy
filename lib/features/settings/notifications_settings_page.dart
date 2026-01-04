import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import 'providers/settings_controller.dart';
import 'providers/settings_providers.dart';

final class NotificationsSettingsPage extends ConsumerWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    final reminderEnabled = settings.transactionReminderEnabled;
    final reminderTime = _timeOfDayFromMinutes(
      settings.transactionReminderTimeMinutes,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          Card(
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
              ),
              title: const Text('Add transaction reminder'),
              subtitle: const Text(
                'Notifications will activate when supported.',
              ),
              value: reminderEnabled,
              onChanged: isSaving
                  ? null
                  : (v) {
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateSettings(
                            settings.copyWith(transactionReminderEnabled: v),
                          );
                    },
            ),
          ),
          if (reminderEnabled)
            Card(
              child: ListTile(
                leading: const Icon(Icons.event_note_outlined),
                title: const Text('Reminder type'),
                subtitle: const Text('If the app was not opened today'),
                trailing: const Icon(Icons.lock_outline),
              ),
            ),
          if (reminderEnabled)
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('Alert time'),
                subtitle: Text(reminderTime.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: isSaving
                    ? null
                    : () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: reminderTime,
                        );
                        if (picked == null) return;
                        final minutes = picked.hour * 60 + picked.minute;
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .updateSettings(
                              settings.copyWith(
                                transactionReminderTimeMinutes: minutes,
                              ),
                            );
                      },
              ),
            ),
          const SizedBox(height: AppSpacing.s16),
          Card(
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
              ),
              title: const Text('Upcoming transactions'),
              subtitle: const Text(
                'Notifications will activate when supported.',
              ),
              value: settings.upcomingTransactionsEnabled,
              onChanged: isSaving
                  ? null
                  : (v) {
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateSettings(
                            settings.copyWith(upcomingTransactionsEnabled: v),
                          );
                    },
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay _timeOfDayFromMinutes(int minutes) {
    final m = minutes.clamp(0, 23 * 60 + 59);
    return TimeOfDay(hour: m ~/ 60, minute: m % 60);
  }
}
