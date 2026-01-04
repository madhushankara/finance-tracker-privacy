import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/motion.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/providers/repository_providers.dart';

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, void>(OnboardingController.new);

final class OnboardingController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial work.
  }

  Future<void> markCompleted() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(appSettingsRepositoryProvider);
      final current = await repo.get();
      await repo.upsert(current.copyWith(onboardingCompleted: true));
    });
  }
}

typedef _OnboardingStep = ({IconData icon, String title, String body});

final class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

final class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _controller;
  int _index = 0;

  static const List<_OnboardingStep> _steps = <_OnboardingStep>[
    (
      icon: Icons.receipt_long_outlined,
      title: 'Track transactions',
      body:
          'Log expenses, income, and transfers\nso your totals stay accurate.',
    ),
    (
      icon: Icons.event_repeat_outlined,
      title: 'Plan ahead',
      body:
          'Use scheduled and recurring entries\nso you can see what\'s coming.',
    ),
    (
      icon: Icons.savings_outlined,
      title: 'Stay in control',
      body: 'Budgets provide soft warnings\nwithout interrupting your flow.',
    ),
    (
      icon: Icons.insights_outlined,
      title: 'Understand your money',
      body: 'Analytics and charts help you spot\npatterns over time.',
    ),
    (
      icon: Icons.lock_outline,
      title: 'Data ownership',
      body: 'Local-first by default, with export\nwhen you need a backup.',
    ),
  ];

  bool get _isLast => _index == _steps.length - 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeAndExit() async {
    await ref.read(onboardingControllerProvider.notifier).markCompleted();

    if (!mounted) return;
    context.go(Routes.login);
  }

  Future<void> _next() async {
    if (_isLast) {
      return _completeAndExit();
    }

    await _controller.nextPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Future<void> _back() async {
    if (_index <= 0) return;

    await _controller.previousPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(onboardingControllerProvider);
    final isBusy = controller.isLoading;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: <Widget>[
          TextButton(
            onPressed: isBusy ? null : _completeAndExit,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _steps.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final step = _steps[i];
                    if (i == 0) {
                      return _FirstOnboardingStepView(step: step);
                    }
                    return _OnboardingStepView(step: step);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  _steps.length,
                  (i) => Container(
                    width: i == _index ? 16 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: i == _index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.35,
                            ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (isBusy || _index == 0) ? null : _back,
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(
                          Size.fromHeight(48),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: FilledButton(
                      onPressed: isBusy ? null : _next,
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(
                          Size.fromHeight(48),
                        ),
                      ),
                      child: Text(_isLast ? 'Finish' : 'Next'),
                    ),
                  ),
                ],
              ),
              if (controller.hasError) ...<Widget>[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'Could not save onboarding state.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final class _FirstOnboardingStepView extends StatelessWidget {
  const _FirstOnboardingStepView({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s16),
                  child: _AnimatedWelcomeText(style: theme.textTheme),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(step.icon, size: 56, color: theme.colorScheme.primary),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    step.title,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    step.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AnimatedWelcomeText extends StatefulWidget {
  const _AnimatedWelcomeText({required this.style});

  final TextTheme style;

  @override
  State<_AnimatedWelcomeText> createState() => _AnimatedWelcomeTextState();
}

final class _AnimatedWelcomeTextState extends State<_AnimatedWelcomeText> {
  static const String _storageId = 'onboarding_welcome_hero_played';

  bool _played = false;
  bool _storageMarked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bucket = PageStorage.of(context);
    final stored = bucket.readState(context, identifier: _storageId);
    if (stored == true && !_played) {
      setState(() => _played = true);
    }
  }

  void _markPlayedInStorage() {
    if (_storageMarked) return;
    _storageMarked = true;
    PageStorage.of(context).writeState(context, true, identifier: _storageId);
  }

  Widget _finalText(BuildContext context) {
    final theme = Theme.of(context);
    final base = widget.style.displayLarge ?? widget.style.headlineLarge;
    final style = (base ?? const TextStyle(fontSize: 44)).copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
      height: 1.0,
    );

    return Text('Welcome!', style: style, textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduceMotion(context) || _played) {
      return _finalText(context);
    }

    // Mark as "played" as soon as we start (prevents excessive replay if the
    // PageView rebuilds or the user swipes away quickly).
    _markPlayedInStorage();

    final duration = Motion.duration(
      context,
      const Duration(milliseconds: 900),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      onEnd: () {
        if (mounted) setState(() => _played = true);
      },
      builder: (context, t, _) {
        final blurSigma = (1 - t) * 14;
        final opacity = 0.15 + (t * 0.85);
        final scale = 0.98 + (t * 0.02);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: _FragmentedTextSlices(
              text: 'Welcome!',
              textStyle:
                  (widget.style.displayLarge ?? widget.style.headlineLarge)
                      ?.copyWith(fontWeight: FontWeight.w800, height: 1.0) ??
                  const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
              blurSigma: blurSigma,
              progress: t,
            ),
          ),
        );
      },
    );
  }
}

final class _FragmentedTextSlices extends StatelessWidget {
  const _FragmentedTextSlices({
    required this.text,
    required this.textStyle,
    required this.blurSigma,
    required this.progress,
  });

  final String text;
  final TextStyle textStyle;
  final double blurSigma;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface;
    final style = textStyle.copyWith(color: color);

    // 10 slices gives a subtle "fragmented" resolve without heavy work.
    const slices = 10;
    final t = progress;

    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: List<Widget>.generate(slices, (i) {
          final ax = slices == 1 ? 0.0 : (-1 + (2 * i / (slices - 1)));

          // Deterministic tiny offsets per slice; converge to 0.
          final dir = (i.isEven ? -1.0 : 1.0);
          final dx = (1 - t) * (dir * (6 + (i % 3) * 3));
          final dy = (1 - t) * (((i % 4) - 1.5) * 2.5);

          return ClipRect(
            child: Align(
              alignment: Alignment(ax, 0),
              widthFactor: 1 / slices,
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: Text(text, style: style, textAlign: TextAlign.center),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

final class _OnboardingStepView extends StatelessWidget {
  const _OnboardingStepView({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(step.icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.s16),
            Text(
              step.title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              step.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
