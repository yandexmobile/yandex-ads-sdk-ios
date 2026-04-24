# Step 3: Mechanical Renames

> **First, read [`../general_rules.md`](../general_rules.md).**

Run the script to apply all mechanical renames at once:

```bash
bash "$MIGRATION_PACK/scripts/apply_mechanical_renames.sh" /path/to/MyApp
```

Then **review** `.info` → `.adInfo.extraData` replacements and Step 3.11 manually.

> **IMPORTANT**: The `import YandexMobileAds` statement must NOT be modified. The script is crafted to avoid this.

## What the Script Does

The sections below describe each rename for reference. All are executed by `apply_mechanical_renames.sh`.

### 3.1 Rename `MobileAds` Class → `YandexAds`

| SDK 7                                      | SDK 8                                              |
|--------------------------------------------|---------------------------------------------------|
| `MobileAds.initialize()`                   | `YandexAds.initializeSDK(completionHandler: nil)` |
| `MobileAds.sdkVersion`                     | `YandexAds.sdkVersion.stringValue`                |
| `MobileAds.setLocationTrackingEnabled(…)`  | `YandexAds.setLocationTracking(…)`    |
| `MobileAds.setAgeRestrictedUser(…)`        | `YandexAds.setAgeRestricted(…)`       |
| `MobileAds.setUserConsent(…)`              | `YandexAds.setUserConsent(…)`         |
| `MobileAds.audioSessionManager()`          | `YandexAds.audioSessionManager`       |
| `MobileAds.*` (remaining, **unqualified**) | `YandexAds.*` (see rules below)       |
| `YMANativeAdView`                          | `NativeAdView`                        |
| `YMANativeMediaView`                       | `NativeMediaView`                     |

**Qualified `MobileAds` must stay untouched.** The script only replaces `MobileAds.` when it is **not** immediately preceded by `.` (Perl: `(?<!\.) \bMobileAds.`). That way names like `GoogleMobileAds.MobileAds.shared`, `Facebook…` or any `OtherModule.MobileAds.*` are **not** rewritten to `YandexAds`.

**Lines containing** `import YandexMobileAds` are skipped for the bulk `MobileAds.*` replacement so the import line is never corrupted.

**After migration**, use **`YandexAds.initializeSDK(completionHandler: nil)`** or with a completion handler, not `YandexAds.initializeSDK()`. The script also rewrites any stray `YandexAds.initializeSDK()` → `YandexAds.initializeSDK(completionHandler: nil)`.

### 3.2 Rename Targeting

| SDK 7              | SDK 8           |
|--------------------|-----------------|
| `AdTargetInfo`     | `AdTargeting`   |
| `.targetInfo`      | `.targeting`    |
| `kYMAGenderFemale` | `Gender.female` |
| `kYMAGenderMale`   | `Gender.male`   |

### 3.3 Rename `BannerAdSize` Factory Methods

| SDK 7                                           | SDK 8                                   |
|-------------------------------------------------|-----------------------------------------|
| `BannerAdSize.fixedSize(withWidth:…)`           | `BannerAdSize.fixed(width:…)`           |
| `BannerAdSize.inlineSize(withWidth:…)`          | `BannerAdSize.inline(width:…)`          |
| `BannerAdSize.stickySize(withContainerWidth:…)` | `BannerAdSize.sticky(containerWidth:…)` |

### 3.4 Rename `BidderTokenRequestConfiguration` → `BidderTokenRequest`

| SDK 7                                     | SDK 8                        |
|-------------------------------------------|------------------------------|
| `BidderTokenRequestConfiguration`         | `BidderTokenRequest`         |
| `loadBidderToken(requestConfiguration:…)` | `loadBidderToken(request:…)` |

> **Note**: After the rename, `BidderTokenRequest` uses factory methods instead of the old initializer. The old `BidderTokenRequestConfiguration(adType:)` + mutable properties pattern must be replaced with factory methods. This requires AI review — see Step 5 for details on `BidderTokenRequest.banner(size:targeting:parameters:)`, `.interstitial()`, `.rewarded()`, `.native()`, `.appOpenAd()`.

### 3.5 Remove `mediationNetworkName` from `BidderTokenLoader`

`BidderTokenLoader(mediationNetworkName:…)` → `BidderTokenLoader()`

> **Note**: Adapter identification is now set globally via `AdapterIdentity` before SDK initialization. See Step 5 for the `AdapterIdentity` + `YandexAds.setAdapterIdentity()` + `YandexAds.initializeSDK(completionHandler: nil)` pattern.

### 3.6 Rename `AdInfo` and Ad Object Properties

| SDK 7                     | SDK 8                                                 |
|---------------------------|-------------------------------------------------------|
| `.adUnitId`               | `.adUnitID`                                           |
| `AdInfo.data`             | `AdInfo.extraData`                                    |
| `AdRequestError.adUnitId` | `AdRequestError.adUnitID`                             |
| `.adAttributes`           | `.adInfo.creatives`                                   |
| `.info`                   | `.adInfo.extraData` (context-sensitive — see warning) |

> **WARNING**: The `.info` → `.adInfo.extraData` replacement is context-sensitive. The script tries to skip common false positives, but **manual review is required** after running it. Check that only ad object `.info` properties were replaced (e.g., `nativeAd.info`, `interstitialAd.info`), not unrelated `.info` usages.

### 3.7 Rename Delegate Methods

| SDK 7                    | SDK 8                 |
|--------------------------|-----------------------|
| `didFailToShowWithError` | `didFailToShow`       |
| `didTrackImpressionWith` | `didTrackImpression`  |

### 3.8 Rename `Rating` API

| SDK 7                     | SDK 8                   |
|---------------------------|-------------------------|
| `Rating.setRating(value)` | `Rating.rating = value` |
| `Rating.rating()`         | `Rating.rating`         |

### 3.9 Rename `AdRequest` Classes

All old request configuration classes → `AdRequest` (longest names first to avoid partial matches):

- `MutableNativeAdRequestConfiguration` → `AdRequest`
- `MutableAdRequestConfiguration` → `AdRequest`
- `NativeAdRequestConfiguration` → `AdRequest`
- `AdRequestConfiguration` → `AdRequest`
- `MutableAdRequest` → `AdRequest`

### 3.10 Rename AdMob Extra Asset Constants

| SDK 7                                       | SDK 8                                        |
|---------------------------------------------|----------------------------------------------|
| `kYMAAdMobNativeAdAgeExtraAsset`            | `YandexAdMobNativeAdExtraAssets.age`         |
| `kYMAAdMobNativeAdFaviconExtraAsset`        | `YandexAdMobNativeAdExtraAssets.favicon`     |
| `kYMAAdMobNativeAdReviewCountExtraAsset`    | `YandexAdMobNativeAdExtraAssets.reviewCount` |
| `kYMAAdMobNativeAdWarningExtraAsset`        | `YandexAdMobNativeAdExtraAssets.warning`     |

### 3.11 Remove Deleted Constants and Types (manual)

The script prints occurrences but does not auto-remove. Search and manually remove lines containing these deleted constants and types (no direct replacement exists):

**Deleted error domain constants**:
- `kYMAAdsErrorDomain`
- `kYMANativeAdErrorDomain`
- `isYandexMobileAdsError` (extension on `Error`/`NSError`)
- `isYandexMobileNativeAdsError` (extension on `Error`/`NSError`)

**Deleted error code enums**:
- `AdErrorCode`
- `NativeErrorCode`

**Deleted Version properties**:
- `Version.prereleaseIdentifiers`
- `Version.buildMetadataIdentifiers`

## Verification

Run the verification script:

```bash
bash "$MIGRATION_PACK/scripts/verify_mechanical_renames.sh" .
```

- [ ] Script exits with code 0
- [ ] `import YandexMobileAds` statements are preserved
- [ ] Changes made by script do exactly what described in this step
- [ ] Spot-check a few files to ensure no false-positive replacements (especially `.info` → `.adInfo.extraData`)
