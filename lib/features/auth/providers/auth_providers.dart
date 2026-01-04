import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/app_settings.dart';
import '../../../data/providers/repository_providers.dart';
import '../../settings/providers/settings_providers.dart';
import '../models/auth_state.dart';
import 'auth_controller.dart';

final authStateProvider = Provider<AuthState>((ref) {
  final AppSettings s = ref.watch(appSettingsProvider);
  return AuthState(
    userId: s.authUserId,
    username: s.authUsername,
    displayName: s.authDisplayName,
    birthday: s.authBirthday,
    isDemo: s.authIsDemo,
  );
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoggedIn;
});

final authDisplayNameProvider = Provider<String?>((ref) {
  final s = ref.watch(authStateProvider);
  return s.displayName?.trim().isEmpty ?? true ? null : s.displayName!.trim();
});

final authUsernameProvider = Provider<String?>((ref) {
  final s = ref.watch(authStateProvider);
  return s.username?.trim().isEmpty ?? true ? null : s.username!.trim();
});

Future<AppSettings> _getSettings(Ref ref) {
  return ref.read(appSettingsRepositoryProvider).get();
}

final authSettingsFutureProvider = FutureProvider<AppSettings>((ref) {
  return _getSettings(ref);
});
