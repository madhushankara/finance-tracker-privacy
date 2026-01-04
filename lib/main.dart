import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/app_settings.dart';
import 'data/providers/repository_providers.dart';
import 'features/settings/providers/settings_providers.dart';
import 'features/transactions/services/recurring_transaction_execution_service.dart';
import 'features/transactions/services/scheduled_transaction_execution_service.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

ThemeMode _toThemeMode(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.system:
      return ThemeMode.system;
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
  }
}

Color _toAccentColor(AppAccentColor accent) {
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

final routerProvider = Provider((ref) {
  return AppRouter(
    isOnboardingCompleted: () async {
      final settings = await ref.read(appSettingsRepositoryProvider).get();
      return settings.onboardingCompleted;
    },
  ).createRouter();
});

final class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

final class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  Future<void> _runExecutionPipeline() async {
    // Ensure scheduled runs before recurring.
    await ref.read(scheduledTransactionExecutionCoordinatorProvider).run();
    await ref.read(recurringTransactionExecutionCoordinatorProvider).run();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Trigger once on app launch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runExecutionPipeline();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Trigger only when app resumes (no timers/background services).
    if (state == AppLifecycleState.resumed) {
      _runExecutionPipeline();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final ThemeMode themeMode = _toThemeMode(settings.themeMode);
    final Color accent = _toAccentColor(settings.accentColor);
    final bool useMaterialYou = settings.useMaterialYouColors;

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final ColorScheme? dynamicLightScheme = useMaterialYou
            ? lightDynamic
            : null;
        final ColorScheme? dynamicDarkScheme = useMaterialYou
            ? darkDynamic
            : null;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Finance Tracker',
          routerConfig: ref.watch(routerProvider),
          themeMode: themeMode,
          theme: const AppTheme().light(
            accent: accent,
            dynamicScheme: dynamicLightScheme,
          ),
          darkTheme: const AppTheme().dark(
            accent: accent,
            dynamicScheme: dynamicDarkScheme,
          ),
        );
      },
    );
  }
}
