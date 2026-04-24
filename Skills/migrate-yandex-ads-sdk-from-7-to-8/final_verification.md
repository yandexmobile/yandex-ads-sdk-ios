# Final Verification

> **First, read [`general_rules.md`](general_rules.md).**

After completing all steps, run the final verification script.

## Verification script

From the **app project root** (where `Podfile` / `.xcodeproj` live):

```bash
bash "$MIGRATION_PACK/scripts/run_final_verification.sh" .
```

- Exit code **0** — no forbidden patterns found.
- Exit code **1** — output lists remaining matches; fix and re-run.

## Must Be Correct

- [ ] **All required delegate methods** are implemented for `AppOpenAdDelegate`, `InterstitialAdDelegate`, `RewardedAdDelegate`, `NativeAdDelegate`, `SliderAdDelegate`, `BannerAdViewDelegate` — they are no longer optional
- [ ] **Dependency version** in `Podfile` or `Package.swift` is `8.0.0` or higher
- [ ] **`@MainActor` compliance (Step 9)** — completed in code

## CRITICAL: Iterative Compilation

**MANDATORY RULE:** After completing all migration steps, you **MUST** perform **iterative project compilation** until all compilation errors related to SDK migration are eliminated. To resolve issues refer to this migration documentation.

### Process:

1. **Build the project** (⌘+B in Xcode or `xcodebuild`)
2. **Analyze all compilation errors**
3. **Fix errors** one by one
4. **Repeat steps 1-3** until the project builds without errors related to SDK migration.

## Completion

When all checks pass:
1. Confirm to the user that the migration is complete.
2. Suggest building the project.
3. Warn the user that they must personally review and verify all changes made by the agent. 
