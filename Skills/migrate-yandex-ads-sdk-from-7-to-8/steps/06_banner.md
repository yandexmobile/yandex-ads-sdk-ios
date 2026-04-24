# Step 6: Migrate Banner Ads (`AdView` → `BannerAdView`)

> **First, read [`../general_rules.md`](../general_rules.md).**

**CRITICAL**: `AdView` is renamed to `BannerAdView`, `AdViewDelegate` to `BannerAdViewDelegate`.

## Rename Table

| SDK 7                             | SDK 8                                   |
|-----------------------------------|-----------------------------------------|
| `AdView`                          | `BannerAdView`                          |
| `AdViewDelegate`                  | `BannerAdViewDelegate`                  |
| `adViewDidLoad`                   | `bannerAdViewDidLoad`                   |
| `adViewDidFailLoading`            | `bannerAdViewDidFailLoading`            |
| `adViewDidClick`                  | `bannerAdViewDidClick`                  |
| `adView(_:didTrackImpression:)`   | `bannerAdView(_:didTrackImpression:)`   |
| `AdView(adUnitID:adSize:)`        | `BannerAdView(adSize:)`                 |
| `AdView.adUnitID`                 | `BannerAdView.adInfo?.adUnitID`         |
| `AdView.loadAd()` (no parameters) | Removed — use `loadAd(with:)`           |
| `AdView.loadAd(with: AdRequest?)` | `BannerAdView.loadAd(with: AdRequest)`  |

**Important**: `adUnitID` is no longer passed in the initializer. Pass it via `AdRequest`.

## Example

```swift
// SDK 7
let adView = AdView(adUnitID: "R-M-XXXXX-YY", adSize: adSize)
adView.delegate = self
adView.loadAd()

// SDK 8
let bannerAdView = BannerAdView(adSize: adSize)
bannerAdView.delegate = self
let request = AdRequest(adUnitID: "R-M-XXXXX-YY")
bannerAdView.loadAd(with: request)
```

## Deleted `AdViewDelegate` Methods

Remove all implementations of:

- `close(_:)`
- `viewControllerForPresentingModalView()`
- `adViewWillLeaveApplication`
- `adView(_:willPresentScreen:)`
- `adView(_:didDismissScreen:)`

## Verification

```bash
swift0() { find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0; }

# Check for old class names (be careful: "AdView" may appear as part of "BannerAdView")
swift0 | xargs -0 grep -sn "\bAdView\b" | grep -v "BannerAdView" | grep -v "import"
swift0 | xargs -0 grep -sn "\bAdViewDelegate\b" | grep -v "BannerAdViewDelegate"
swift0 | xargs -0 grep -sn "adViewDidLoad\|adViewDidFailLoading\|adViewDidClick" | grep -v "bannerAdView"
swift0 | xargs -0 grep -sn "adViewWillLeaveApplication\|willPresentScreen\|didDismissScreen"
```

- [ ] No standalone `AdView` references remain (only `BannerAdView`)
- [ ] No `AdViewDelegate` references remain (only `BannerAdViewDelegate`)
- [ ] Old delegate method names (`adViewDidLoad`, etc.) are replaced with `bannerAdView*` variants
- [ ] Deleted delegate methods are removed
- [ ] `adUnitID` is passed via `AdRequest`, not in the initializer
