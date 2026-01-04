# Release Readiness Checklist

This is a practical checklist for demo, portfolio, or store-ready prep.

## Build / Config

- [ ] Confirm `debugShowCheckedModeBanner: false` (already set)
- [ ] Confirm `flutter analyze` is clean
- [ ] Confirm `flutter test` passes
- [ ] Verify `pubspec.yaml` version (`version: 1.0.0+1`) is appropriate for the release target
- [ ] Confirm minimum SDK constraints match target platforms

## Branding

- [ ] App name: verify Android/iOS display names match “Finance Tracker”
- [ ] App icon: replace default icons (Android `mipmap-*`, iOS `AppIcon`)
- [ ] Splash/launch assets: verify launch screen is intentional

## Build Modes

- [ ] Debug run: `flutter run`
- [ ] Release build (Android): `flutter build apk --release` or `flutter build appbundle --release`
- [ ] Release build (iOS): `flutter build ios --release` (requires macOS/Xcode)
- [ ] Desktop builds if needed: `flutter build windows --release`

## QA Scenarios (quick)

- [ ] First launch: onboarding appears once, skip works, app remains usable
- [ ] Add/edit transaction: expense/income/transfer
- [ ] Scheduled transaction: created, then executes on next launch/resume when due
- [ ] Recurring transaction: created, then executes on next launch/resume when due
- [ ] Budgets: create budget, see progress/soft warning
- [ ] Analytics: charts render and match expected totals
- [ ] Export: generates ZIP, share sheet opens, exported CSVs look correct
- [ ] Settings: changing date format / first day of week / currency persists

## Data / Privacy

- [ ] Verify all data is local-first (no network calls required for core flows)
- [ ] Verify export is read-only (no import side effects)

## Portfolio / Demo Assets

- [ ] Record a short screen capture using the flow in `docs/DEMO_SCRIPT.md`
- [ ] Add screenshots into `docs/screenshots/` and update README links
- [ ] Optional: include a short architecture diagram
