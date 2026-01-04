import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/repository_providers.dart';
import '../../../data/repositories/app_settings_repository.dart';

final class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial work.
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final u = username.trim();
    final p = password;

    if (u != 'kingkong' || p != 'kavin') {
      throw StateError('Invalid username or password.');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Hidden demo credentials: seeds demo data once per install.
      // No demo UI is shown; this simply ensures the existing pre-seeded data
      // (transactions/categories/budgets/calendar/analytics) is available.
      await ref.read(demoDataRepositoryProvider).seedIfNeeded();

      final AppSettingsRepository repo = ref.read(
        appSettingsRepositoryProvider,
      );
      final current = await repo.get();

      await repo.upsert(
        current.copyWith(
          authUserId: 'local_kingkong',
          authUsername: 'kingkong',
          authDisplayName: 'King Kong',
          authIsDemo: false,
          // Keep existing birthday (if user set it previously).
          authBirthday: current.authBirthday,
        ),
      );
    });
  }

  Future<void> signup({
    required String username,
    required String displayName,
    DateTime? birthday,
  }) async {
    final u = username.trim();
    final d = displayName.trim();
    if (u.isEmpty || d.isEmpty) {
      throw StateError('Username and name are required.');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(appSettingsRepositoryProvider);
      final current = await repo.get();

      final DateTime? dateOnlyBirthday = birthday == null
          ? null
          : DateUtils.dateOnly(birthday);

      final updated = current.copyWith(
        authUserId: 'local_$u',
        authUsername: u,
        authDisplayName: d,
        authBirthday: dateOnlyBirthday,
        authIsDemo: false,
      );

      await repo.upsert(updated);
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(appSettingsRepositoryProvider);
      final current = await repo.get();

      await repo.upsert(
        current.copyWith(
          authUserId: null,
          authUsername: null,
          authDisplayName: null,
          authBirthday: null,
          authIsDemo: false,
        ),
      );
    });
  }

  Future<void> updateDisplayName(String displayName) async {
    final name = displayName.trim();
    if (name.isEmpty) return;
    final repo = ref.read(appSettingsRepositoryProvider);
    final current = await repo.get();
    await repo.upsert(current.copyWith(authDisplayName: name));
  }

  Future<void> updateBirthday(DateTime? birthday) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    final current = await repo.get();
    final dateOnly = birthday == null ? null : DateUtils.dateOnly(birthday);
    await repo.upsert(current.copyWith(authBirthday: dateOnly));
  }

  Future<void> markBirthdayCelebratedNow() async {
    final repo = ref.read(appSettingsRepositoryProvider);
    final current = await repo.get();
    final today = DateUtils.dateOnly(DateTime.now());

    await repo.upsert(current.copyWith(lastBirthdayCelebratedAt: today));
  }

  Future<void> dismissHomeCard(String id) async {
    final repo = ref.read(appSettingsRepositoryProvider);
    final current = await repo.get();

    final ids = current.homeFeatureCardsDismissedCsv
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();

    ids.add(id);

    await repo.upsert(
      current.copyWith(homeFeatureCardsDismissedCsv: ids.join(',')),
    );
  }
}
