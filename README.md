# Finance Tracker

Local-first personal finance tracker built with Flutter.

Finance Tracker helps you record transactions, monitor budgets, understand spending patterns, and export your data in a portable format — with a calm, dark-first UI and no forced sign-in.

## Key Features

- Transactions: expense, income, and transfer flows
- Scheduling: scheduled and recurring transactions, with an on-launch/on-resume execution pipeline
- Budgets: category-based budgets with soft warnings
- Analytics: charts and rollups to understand trends
- Local-first storage: SQLite via Drift
- Data export: CSV backup bundled as a ZIP and shared via the system share sheet
- Onboarding: minimal, skippable walkthrough shown only on first launch (re-openable from Settings)

## Screenshots (Placeholders)

- Home overview: `docs/screenshots/home.png`
- Add transaction: `docs/screenshots/add-transaction.png`
- Budgets: `docs/screenshots/budgets.png`
- Analytics: `docs/screenshots/analytics.png`
- Export data: `docs/screenshots/export.png`

## Architecture Overview

The app is structured as a local-first Flutter app with clear separation between UI, feature orchestration, and persistence.

- **UI / Features**: `lib/features/**`
	- Pages and widgets for Accounts, Transactions, Budgets, Analytics, Settings, Export, and Onboarding.
- **Routing**: GoRouter (`lib/core/router/**`)
	- Shell navigation for Home / Transactions / Budgets / More.
	- Onboarding is isolated on its own route and shown via a one-time redirect.
- **State management**: Riverpod
	- Feature pages read repositories via providers (no direct Drift usage in UI).
- **Data layer**: repositories + Drift datasources
	- Repositories: `lib/data/repositories/**`
	- Drift datasource layer: `lib/data/datasources/drift/**`
	- SQLite file stored in the app documents directory.

### Execution Engine (Scheduled + Recurring)

On app launch and when the app resumes, the execution pipeline runs:

1. Execute due scheduled transactions
2. Execute due recurring transactions

This is intentionally lightweight: no background jobs, timers, or notifications.

### Analytics

Analytics uses local aggregations and visualizations (charts) to summarize spending over time.

### Export

Export is read-only. The export service builds CSVs (UTF‑8, headers, ISO dates, major-unit amounts) and bundles them into a ZIP for sharing.

## Tech Stack

- Flutter / Dart
- Material 3 (dark-first theme)
- Riverpod (state management)
- GoRouter (navigation)
- Drift + SQLite (`sqlite3_flutter_libs`) for persistence
- `fl_chart` for charts
- `intl` for formatting
- `archive` for ZIP
- `share_plus` for system share sheet

## Development

### Setup

1. Install Flutter SDK
2. Get dependencies:

	 `flutter pub get`

3. Generate code (Drift / Riverpod):

	 `dart run build_runner build --delete-conflicting-outputs`

### Run

`flutter run`

### Validate

- Static analysis: `flutter analyze`
- Tests: `flutter test`

## Known Limitations / Future Improvements

Intentionally not included in this project (by design):

- Cloud sync, accounts/login, or cross-device sync
- Push notifications and background execution
- CSV import (export only)
- Advanced reporting (custom dashboards, tagging, rules)
- Attachments/receipt scanning

For interview/demo flow, see [docs/DEMO_SCRIPT.md](docs/DEMO_SCRIPT.md).

Project wrap-up artifacts:

- Final audit checklist: [docs/FINAL_AUDIT.md](docs/FINAL_AUDIT.md)
- Release readiness checklist: [docs/RELEASE_CHECKLIST.md](docs/RELEASE_CHECKLIST.md)
