# Step 2: Update Dependencies

> **First, read [`../general_rules.md`](../general_rules.md).**

## 2.1 CocoaPods

In the `Podfile`, find the line containing `pod 'YandexMobileAds'` and update the version to `8.0.0` or higher:

```ruby
# Before (SDK 7) — existing version may be in any format, e.g.:
pod 'YandexMobileAds', '7.0'

# After (SDK 8)
pod 'YandexMobileAds', '~> 8.0'
```

After updating the `Podfile`, instruct the user to run:

```bash
pod install --repo-update
```

## 2.2 Swift Package Manager

If the project uses SPM, update the `YandexMobileAds` package version requirement to `8.0.0` or higher.

In **Xcode**: File → Packages → Update to Latest Package Versions, or update the version in the package dependency settings.

In **Package.swift**, find the `YandexMobileAds` package entry and update the version (keep the existing package URL):

```swift
// Before
.package(url: "<YandexMobileAds-package-url>", from: "7.0.0")

// After
.package(url: "<YandexMobileAds-package-url>", from: "8.0.0")
```

Verify the following Build Settings are correct:
1. `-ObjC` is present in `OTHER_LDFLAGS`
2. The target is linked with `YandexMobileAdsPackage` (Build Phases → Link Binary With Libraries)

## Verification

Run the following command to confirm the version is updated:

```bash
# CocoaPods
grep -n "YandexMobileAds" Podfile

# SPM
grep -rn "YandexMobileAds" Package.swift 2>/dev/null
```

- [ ] `Podfile` or `Package.swift` references version `8.0.0` or higher
- [ ] No references to SDK 7.x versions remain
