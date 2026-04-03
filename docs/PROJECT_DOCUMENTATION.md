# Finance Tracker: Complete Technical Documentation
Generated on: 2026-04-03
## Part 1: System Handbook
### 1. Project Overview
Finance Tracker is a local-first Flutter personal finance app. The app is designed for private, offline-capable transaction management with budgeting, analytics, recurring/scheduled execution, and portable data export.
Core product references:
- README.md
- BETA_NOTES.md
- docs/DEMO_SCRIPT.md
- docs/FINAL_AUDIT.md
- docs/RELEASE_CHECKLIST.md
### 2. Tech Stack
- Flutter + Dart
- Riverpod (state management)
- GoRouter (navigation)
- Drift + SQLite (local persistence)
- fl_chart (analytics visualizations)
- intl (formatting)
- archive + share_plus (ZIP export + share sheet)
- dynamic_color (Material You support)
Versioning and dependencies are defined in pubspec.yaml.
### 3. Architecture
Layered architecture:
1. Core layer (routing, theme, formatting, shared widgets/utilities) in lib/core
2. Data layer (models, repositories, datasource implementations, Drift schema) in lib/data
3. Feature layer (screen-level flows and controllers) in lib/features
4. Test layer in test
5. Product/release docs in docs
### 4. Boot and Lifecycle
Entrypoint: lib/main.dart
Startup behavior:
- App is wrapped in ProviderScope
- Router is created with onboarding completion redirect logic
- Theme and accent are read from app settings
- Execution pipeline runs in this sequence:
  1) scheduled transaction execution
  2) recurring transaction materialization
The execution pipeline triggers on:
- first app launch
- app resume
No background scheduler service is used.
### 5. Routing
Routing is centralized in:
- lib/core/router/routes.dart
- lib/core/router/app_router.dart
Main tab shell:
- Home (/)
- Transactions (/transactions)
- Analytics (/analytics)
- More (/more)
Additional routes include onboarding, auth, user hub, accounts/categories/budgets/goals/loans CRUD flows, settings sub-pages, export, add-method selector, and home detail charts.
### 6. Persistence and Schema
Database file and migrations:
- lib/data/datasources/drift/app_database.dart
- lib/data/datasources/drift/app_database.g.dart
Current schemaVersion: 14
Tables:
- accounts_table.dart
- categories_table.dart
- budgets_table.dart
- app_settings_table.dart
- goals_table.dart
- loans_table.dart
- transactions_table.dart
### 7. Domain Models
Primary models:
- Account
- Category
- Budget
- FinanceTransaction
- Goal
- Loan
- Money
- AppSettings
Key enum families:
- TransactionType, TransactionStatus, RecurrenceType
- AccountType, CategoryType, BudgetType, LoanType
- AppThemeMode, AppAccentColor, AppDateFormat, FirstDayOfWeek
### 8. Provider + Repository Pattern
- Features consume repository providers, not raw Drift APIs.
- Repository interfaces live in lib/data/repositories
- Implementations live in lib/data/repositories/impl
- Drift datasource adapters live in lib/data/datasources/drift/datasources
### 9. Feature Coverage
Implemented or mostly implemented flows:
- Accounts
- Categories
- Transactions (expense/income/transfer + scheduled/recurring setup)
- Budgets
- Analytics
- Home dashboard with configurable sections
- Goals (list/add/edit/delete UI flow)
- Loans (list/add/edit/delete UI flow)
- Export (ZIP of CSV files via share sheet)
- Local auth/profile hub flows
Under-development/placeholder areas:
- Photo receipt extraction
- Bank statement import parsing
- Bank account linking
- Cloud sync
- Certain settings-backed capabilities (notifications, biometric enforcement, full localization runtime)
- Backup/restore/sync actions in backups page
### 10. Export Semantics
Data export service:
- lib/features/export/services/data_export_service.dart
Outputs:
- ZIP bundle containing CSV files for accounts/categories/budgets/transactions
- UTF-8 CSV
- ISO date format in exports
- major-unit decimal amounts
Transaction export filtering:
- includes executed posted facts
- excludes scheduled pending records and recurring templates
### 11. Execution Engine Semantics
Scheduled execution service:
- converts due scheduled transactions to posted
- idempotent and safe on repeated runs
Recurring execution service:
- materializes occurrences from recurring templates
- deterministic occurrence IDs + insertIfAbsent for idempotency
- updates template lastExecutedAt after materialization
### 12. Testing Summary
Test files validate:
- analytics calculations
- calculator engine precision and precedence
- export filtering and CSV formatting
- greeting utilities
- scheduled execution idempotency
- recurring materialization edge cases
- date group label behavior per settings
- app boot + onboarding smoke path
### 13. Build/Platform Configuration
Android:
- android/app/build.gradle.kts
- Java/Kotlin target 17
- release signing config present
iOS:
- ios/Runner/Info.plist
- display name configured as Finance Tracker
Linting:
- analysis_options.yaml uses flutter_lints baseline
---
## Part 2: File-by-File Reference Appendix
Legend:
- role descriptions are based on filename, folder context, and verified usage in app architecture
- generated files are marked explicitly
### A. Root and Product Files
- analysis_options.yaml: Analyzer and lint configuration.
- BETA_NOTES.md: Beta limitations and tester guidance.
- index.html: Flutter web index host page.
- pubspec.yaml: Package manifest, dependencies, and app version metadata.
- README.md: Top-level project overview and setup guide.

### B. Documentation Files
- docs/DEMO_SCRIPT.md: Project documentation artifact.
- docs/FINAL_AUDIT.md: Project documentation artifact.
- docs/PROJECT_DOCUMENTATION.md: Project documentation artifact.
- docs/RELEASE_CHECKLIST.md: Project documentation artifact.

### C. Source Files (lib)
- lib/core/animations/motion.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/formatting/date_format.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/formatting/money_format.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/formatting/transaction_date_group_label.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/providers/README.md: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/router/app_router.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/router/routes.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/theme/app_shadows.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/theme/app_spacing.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/theme/app_text_theme.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/theme/app_theme.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/theme/material_you_support.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/utils/calculator_engine.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/utils/chart_palettes.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/utils/id_generator.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/calculator_amount_input.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/coming_soon_dialog.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/empty_state.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/implicit_animated_list.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/keyboard_back_dismiss_scope.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/non_shell_system_nav_padding.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/pressable_scale.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/core/widgets/semantic_amount_text.dart: Core shared infrastructure (theme, routing, formatting, widgets, utils, animations).
- lib/data/datasources/drift/app_database.dart: Drift database configuration and migrations.
- lib/data/datasources/drift/app_database.g.dart: Generated Drift database bindings (generated file).
- lib/data/datasources/drift/datasources/drift_account_datasource.dart: Drift datasource implementation.
- lib/data/datasources/drift/datasources/drift_app_settings_datasource.dart: Drift datasource implementation.
- lib/data/datasources/drift/datasources/drift_budget_datasource.dart: Drift datasource implementation.
- lib/data/datasources/drift/datasources/drift_category_datasource.dart: Drift datasource implementation.
- lib/data/datasources/drift/datasources/drift_goal_datasource.dart: Drift datasource implementation.
- lib/data/datasources/drift/datasources/drift_loan_datasource.dart: Drift datasource implementation.
- lib/data/datasources/drift/datasources/drift_transaction_datasource.dart: Drift datasource implementation.
- lib/data/datasources/drift/tables/accounts_table.dart: Drift table schema definition.
- lib/data/datasources/drift/tables/app_settings_table.dart: Drift table schema definition.
- lib/data/datasources/drift/tables/budgets_table.dart: Drift table schema definition.
- lib/data/datasources/drift/tables/categories_table.dart: Drift table schema definition.
- lib/data/datasources/drift/tables/goals_table.dart: Drift table schema definition.
- lib/data/datasources/drift/tables/loans_table.dart: Drift table schema definition.
- lib/data/datasources/drift/tables/transactions_table.dart: Drift table schema definition.
- lib/data/mappers/account_mapper.dart: Mapping between database rows and domain models.
- lib/data/mappers/budget_mapper.dart: Mapping between database rows and domain models.
- lib/data/mappers/category_mapper.dart: Mapping between database rows and domain models.
- lib/data/mappers/goal_mapper.dart: Mapping between database rows and domain models.
- lib/data/mappers/loan_mapper.dart: Mapping between database rows and domain models.
- lib/data/mappers/transaction_mapper.dart: Mapping between database rows and domain models.
- lib/data/models/account.dart: Domain model definition.
- lib/data/models/app_settings.dart: Domain model definition.
- lib/data/models/budget.dart: Domain model definition.
- lib/data/models/category.dart: Domain model definition.
- lib/data/models/enums.dart: Domain model definition.
- lib/data/models/goal.dart: Domain model definition.
- lib/data/models/loan.dart: Domain model definition.
- lib/data/models/money.dart: Domain model definition.
- lib/data/models/transaction.dart: Domain model definition.
- lib/data/providers/database_provider.dart: Dependency injection/provider wiring for data layer.
- lib/data/providers/drift_datasource_providers.dart: Dependency injection/provider wiring for data layer.
- lib/data/providers/repository_providers.dart: Dependency injection/provider wiring for data layer.
- lib/data/repositories/account_repository.dart: Repository interface/contract.
- lib/data/repositories/app_settings_repository.dart: Repository interface/contract.
- lib/data/repositories/budget_repository.dart: Repository interface/contract.
- lib/data/repositories/category_repository.dart: Repository interface/contract.
- lib/data/repositories/demo_data_repository.dart: Repository interface/contract.
- lib/data/repositories/goal_repository.dart: Repository interface/contract.
- lib/data/repositories/impl/account_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/impl/app_settings_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/impl/budget_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/impl/category_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/impl/demo_data_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/impl/goal_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/impl/loan_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/impl/transaction_repository_impl.dart: Concrete repository implementation.
- lib/data/repositories/loan_repository.dart: Repository interface/contract.
- lib/data/repositories/transaction_repository.dart: Repository interface/contract.
- lib/data/seed/default_categories.dart: Seed data definitions.
- lib/features/accounts/accounts_list_page.dart: Feature-layer UI/state/business flow file.
- lib/features/accounts/add_account_page.dart: Feature-layer UI/state/business flow file.
- lib/features/accounts/edit_account_page.dart: Feature-layer UI/state/business flow file.
- lib/features/accounts/providers/accounts_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/accounts/providers/accounts_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/accounts/widgets/account_form.dart: Feature-layer UI/state/business flow file.
- lib/features/accounts/widgets/account_type_icon.dart: Feature-layer UI/state/business flow file.
- lib/features/add/add_method_selector_page.dart: Feature-layer UI/state/business flow file.
- lib/features/add/pages/add_via_photo_page.dart: Feature-layer UI/state/business flow file.
- lib/features/add/pages/import_bank_statement_page.dart: Feature-layer UI/state/business flow file.
- lib/features/add/pages/under_development_page.dart: Feature-layer UI/state/business flow file.
- lib/features/add/providers/add_flow_prefill_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/ai_chat/ai_chat_page.dart: Feature-layer UI/state/business flow file.
- lib/features/ai_chat/models/ai_chat_message.dart: Feature-layer UI/state/business flow file.
- lib/features/ai_chat/providers/ai_chat_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/ai_chat/widgets/ai_chat_entry_button.dart: Feature-layer UI/state/business flow file.
- lib/features/ai_chat/widgets/ai_chat_panel.dart: Feature-layer UI/state/business flow file.
- lib/features/analytics/analytics_page.dart: Feature-layer UI/state/business flow file.
- lib/features/analytics/providers/analytics_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/analytics/services/analytics_calculator.dart: Feature-layer UI/state/business flow file.
- lib/features/analytics/widgets/analytics_charts.dart: Feature-layer UI/state/business flow file.
- lib/features/auth/login_page.dart: Feature-layer UI/state/business flow file.
- lib/features/auth/models/auth_state.dart: Feature-layer UI/state/business flow file.
- lib/features/auth/providers/auth_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/auth/providers/auth_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/auth/services/demo_data_seeder.dart: Feature-layer UI/state/business flow file.
- lib/features/auth/signup_page.dart: Feature-layer UI/state/business flow file.
- lib/features/budgets/add_budget_page.dart: Feature-layer UI/state/business flow file.
- lib/features/budgets/budget_detail_page.dart: Feature-layer UI/state/business flow file.
- lib/features/budgets/budgets_page.dart: Feature-layer UI/state/business flow file.
- lib/features/budgets/providers/add_budget_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/budgets/providers/budgets_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/budgets/services/budget_status_calculator.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/add_category_page.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/categories_list_page.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/categories_page.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/edit_category_page.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/providers/categories_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/providers/categories_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/widgets/category_form.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/widgets/category_icon.dart: Feature-layer UI/state/business flow file.
- lib/features/categories/widgets/category_pickers.dart: Feature-layer UI/state/business flow file.
- lib/features/export/export_data_page.dart: Feature-layer UI/state/business flow file.
- lib/features/export/services/data_export_service.dart: Feature-layer UI/state/business flow file.
- lib/features/goals/add_goal_page.dart: Feature-layer UI/state/business flow file.
- lib/features/goals/edit_goal_page.dart: Feature-layer UI/state/business flow file.
- lib/features/goals/goals_page.dart: Feature-layer UI/state/business flow file.
- lib/features/goals/providers/goals_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/goals/providers/goals_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/goals/widgets/goal_meta.dart: Feature-layer UI/state/business flow file.
- lib/features/home/home_page.dart: Feature-layer UI/state/business flow file.
- lib/features/home/pages/heatmap_detail_page.dart: Feature-layer UI/state/business flow file.
- lib/features/home/pages/pie_chart_detail_page.dart: Feature-layer UI/state/business flow file.
- lib/features/home/pages/spending_graph_detail_page.dart: Feature-layer UI/state/business flow file.
- lib/features/home/providers/home_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/home/utils/greeting_utils.dart: Feature-layer UI/state/business flow file.
- lib/features/home/widgets/home_mini_visuals.dart: Feature-layer UI/state/business flow file.
- lib/features/loans/add_loan_page.dart: Feature-layer UI/state/business flow file.
- lib/features/loans/edit_loan_page.dart: Feature-layer UI/state/business flow file.
- lib/features/loans/loans_page.dart: Feature-layer UI/state/business flow file.
- lib/features/loans/providers/loans_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/loans/providers/loans_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/more/calendar_day_transactions_page.dart: Feature-layer UI/state/business flow file.
- lib/features/more/calendar_page.dart: Feature-layer UI/state/business flow file.
- lib/features/more/more_hub_page.dart: Feature-layer UI/state/business flow file.
- lib/features/more/scheduled_overview_page.dart: Feature-layer UI/state/business flow file.
- lib/features/more/subscriptions_page.dart: Feature-layer UI/state/business flow file.
- lib/features/onboarding/onboarding_page.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/backups_page.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/edit_homepage_page.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/language_settings_page.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/notifications_settings_page.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/providers/settings_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/providers/settings_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/security_settings_page.dart: Feature-layer UI/state/business flow file.
- lib/features/settings/settings_page.dart: Feature-layer UI/state/business flow file.
- lib/features/tools/bill_splitter_page.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/add_transaction_page.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/edit_transaction_page.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/providers/edit_transaction_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/providers/transactions_controller.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/providers/transactions_providers.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/services/recurring_transaction_execution_service.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/services/scheduled_transaction_execution_service.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/transactions_page.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/utils/transaction_form_validators.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/utils/transaction_grouping.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/widgets/transaction_form.dart: Feature-layer UI/state/business flow file.
- lib/features/transactions/widgets/transaction_list_widgets.dart: Feature-layer UI/state/business flow file.
- lib/features/user_hub/user_account_page.dart: Feature-layer UI/state/business flow file.
- lib/features/user_hub/user_data_page.dart: Feature-layer UI/state/business flow file.
- lib/features/user_hub/user_hub_page.dart: Feature-layer UI/state/business flow file.
- lib/main.dart: Application entrypoint and app bootstrap wiring.

### D. Test Files (test)
- test/analytics_calculator_test.dart: Automated test specification.
- test/calculator_engine_test.dart: Automated test specification.
- test/data_export_service_test.dart: Automated test specification.
- test/greeting_utils_test.dart: Automated test specification.
- test/recurring_transaction_execution_service_test.dart: Automated test specification.
- test/scheduled_transaction_execution_service_test.dart: Automated test specification.
- test/transaction_date_group_label_settings_test.dart: Automated test specification.
- test/widget_test.dart: Automated test specification.

### E. Notes
- This appendix lists all source, test, and docs files present at generation time.
- For exact implementation semantics, see corresponding Part 1 sections and the linked source files.

