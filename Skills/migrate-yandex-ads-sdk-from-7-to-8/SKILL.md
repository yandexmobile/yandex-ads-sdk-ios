# Migration Skill: YandexMobileAds iOS SDK 7.x → 8.x

You are migrating an iOS project from YandexMobileAds SDK 7.x to 8.x

## Prerequisites

Before starting, verify the project meets these minimum requirements:

- **Xcode**: 26.0 or higher
- **AppMetricaCore**: 6.0.0 or higher
- **AppMetricaLibraryAdapter**: 6.0.0 or higher
- **AppMetricaAdSupport**: 6.0.0 or higher
- **AppMetricaIDSync**: 6.0.0 or higher

If the project does not meet these requirements, notify the user before proceeding.

## Before Every Step

**Read [`general_rules.md`](general_rules.md) before starting each step.** It contains critical rules about API naming, context management, and execution discipline that must be followed throughout the migration.

## Execution Order

| Step | File                                                         | Summary                                          |
|------|--------------------------------------------------------------|--------------------------------------------------|
| 1    | [`01_discovery.md`](steps/01_discovery.md)                   | Discover files to migrate                        |
| 2    | [`02_dependencies.md`](steps/02_dependencies.md)             | Update dependencies                              |
| 3    | [`03_mechanical_renames.md`](steps/03_mechanical_renames.md) | Mechanical renames via CLI commands              |
| 4    | [`04_adrequest.md`](steps/04_adrequest.md)                   | Migrate `AdRequest`                              |
| 5    | [`05_loaders.md`](steps/05_loaders.md)                       | Migrate ad loaders (delegate → completion/async) |
| 6    | [`06_banner.md`](steps/06_banner.md)                         | Migrate banner ads (`AdView` → `BannerAdView`)   |
| 7    | [`07_ad_delegates.md`](steps/07_ad_delegates.md)             | Migrate ad object delegates                      |
| 8    | [`08_native.md`](steps/08_native.md)                         | Migrate native ads                               |
| 9    | [`09_mainactor.md`](steps/09_mainactor.md)                   | Swift 6 / `@MainActor` compliance                |
| ✓    | [`final_verification.md`](final_verification.md)             | Final verification checklist                     |

## Scripts

Shell scripts in [`scripts/`](scripts/) automate mechanical renames and verification. Run from the **host app root** (directory with `Podfile` / `.xcodeproj`):

```bash
MIGRATION_PACK="../migrate-yandex-ads-sdk-from-7-to-8"

# Step 3: Apply all mechanical renames
bash "$MIGRATION_PACK/scripts/apply_mechanical_renames.sh" .

# Step 3 verification: Check mechanical renames
bash "$MIGRATION_PACK/scripts/verify_mechanical_renames.sh" .

# Final verification: Check all migration patterns
bash "$MIGRATION_PACK/scripts/run_final_verification.sh" .
```

## Step Execution Algorithm

For each step:

1. **Read** [`general_rules.md`](general_rules.md)
2. **Read** the step file (`steps/XX_name.md`)
3. **Identify** which files from the discovery list (Step 1) are affected
4. **If no files are affected** — report "Step N: no changes needed" and proceed
5. **For each affected file**:
   a. Read the file
   b. Apply all changes specified in the step
   c. Confirm the changes were applied correctly
6. **Run the step's Verification section** — fix any issues before proceeding
7. **Report completion**: "Step N complete. Files changed: [list]. Moving to Step N+1."

## State Tracking

Maintain a running status list throughout the migration:

```
## Migration Progress
- [x] Step 1: Discovery — found N files
- [x] Step 2: Dependencies — updated Podfile/Package.swift
- [-] Step 3: Simple renames — processing (M/N files done)
- [ ] Step 4: AdRequest
- [ ] Step 5: Loaders
- [ ] Step 6: Banner
- [ ] Step 7: Ad delegates
- [ ] Step 8: Native
- [ ] Step 9: @MainActor
- [ ] Final verification
```

## Completion

When all steps are complete, read [`final_verification.md`](final_verification.md) and run the final verification.

When all checks pass and the project compiles without errors, confirm to the user that the migration is complete. Warn the user that they must personally review and verify all changes made by the agent.
