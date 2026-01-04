// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/core/router/app_router.dart';
import 'package:finance_tracker/data/models/app_settings.dart';
import 'package:finance_tracker/data/repositories/app_settings_repository.dart';
import 'package:finance_tracker/data/providers/repository_providers.dart';
import 'package:finance_tracker/main.dart';

final class _FakeAppSettingsRepository implements AppSettingsRepository {
  _FakeAppSettingsRepository([AppSettings? initial])
    : _current = initial ?? AppSettings.defaults;

  AppSettings _current;
  final _controller = StreamController<AppSettings>.broadcast();

  @override
  Stream<AppSettings> watch() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<AppSettings> get() async => _current;

  @override
  Future<void> upsert(AppSettings settings) async {
    _current = settings;
    _controller.add(_current);
  }
}

void main() {
  testWidgets('App boots to Home shell', (WidgetTester tester) async {
    final fakeSettingsRepo = _FakeAppSettingsRepository(
      AppSettings.defaults.copyWith(onboardingCompleted: false),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          appSettingsRepositoryProvider.overrideWithValue(fakeSettingsRepo),
          routerProvider.overrideWith((ref) {
            return AppRouter(
              isOnboardingCompleted: () async {
                final s = await ref.read(appSettingsRepositoryProvider).get();
                return s.onboardingCompleted;
              },
            ).createRouter();
          }),
        ],
        child: const App(),
      ),
    );

    Future<void> pumpUntilFound(Finder finder) async {
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (finder.evaluate().isNotEmpty) return;
      }
      fail('Timed out waiting for widget: $finder');
    }

    await tester.pump();
    await pumpUntilFound(find.text('Welcome'));

    // First launch should show onboarding.
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await pumpUntilFound(find.text('Log in'));

    expect(find.text('Log in'), findsWidgets);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
