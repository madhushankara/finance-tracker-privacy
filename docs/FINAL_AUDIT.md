# Final Audit Checklist

## 1) Architecture & Feature Audit

### Core features implemented

- Onboarding walkthrough (first launch only, skippable, re-openable)
- Accounts
  - Create / edit
  - Currency per account
- Categories
  - Create / edit
- Transactions
  - Expense / income / transfer
  - Edit existing transactions
  - Scheduled transactions
  - Recurring transactions
  - Execution pipeline on app launch + app resume
- Budgets
  - Create budgets
  - Budget detail view
  - Soft guidance / warnings (non-blocking)
- Analytics
  - Charts and summary views
- Settings
  - First day of week
  - Date format
  - Primary currency
- Data export
  - Read-only CSV export for key tables
  - ZIP bundling
  - Share via system share sheet

### Optional features intentionally skipped

- Auth / accounts / cloud sync
- Notifications
- Background processing / periodic jobs
- Import (export only)
- Multi-device sync and server-side analytics
- Advanced reporting features (rules, tags, custom dashboards)
- Attachments/receipts

### “Dead routes” / half-finished flows check

- Routes are centralized in `lib/core/router/routes.dart` and wired in `lib/core/router/app_router.dart`.
- All declared routes are registered.
- Missing-ID routes (edit pages) fail safely with an in-app error screen.
- Goals and Loans currently show an `EmptyState` placeholder page (intentional stub, not a broken route).

## 2) Code Hygiene Final Pass

### TODOs / FIXMEs

- No TODO / FIXME / HACK markers found in `lib/**`, `test/**`, `pubspec.yaml`.

### Commented dead code

- No commented-out code blocks found in a quick scan.
- One inline comment exists in the transaction form noting a case is “unused”; it’s not a commented-out block.

### Unused / leftover files (potential)

These do not appear to be referenced and may be safe to remove later (not changed as part of wrap-up):

- `lib/features/auth/` (empty folder)
- `lib/features/categories/categories_page.dart` (placeholder page; the app uses `CategoriesListPage`)
- `PlaceholderFeaturePage` in `lib/core/router/app_router.dart` (defined but not referenced)

## 3) Notes / Technical Debt (intentional)

- No background execution: scheduled/recurring execution runs only on launch/resume.
- Goals/Loans are stubs (UI placeholder only).
- Export is read-only by design.
