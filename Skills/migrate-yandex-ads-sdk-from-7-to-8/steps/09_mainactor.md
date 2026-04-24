# Step 9: Swift 6 / `@MainActor` Compliance

> **First, read [`../general_rules.md`](../general_rules.md).**

SDK 8 is built with Swift 6. Several classes and protocols are now isolated to `@MainActor`.

**MANDATORY:** You **must** complete this step before calling migration finished.

## `@MainActor`-Isolated Classes

- `AppOpenAd`
- `InterstitialAd`
- `RewardedAd`
- `AudioSessionManager`
- `NativeVideoPlaybackControls`

## `@MainActor`-Isolated Protocols

- `AppOpenAdDelegate`
- `InterstitialAdDelegate`
- `RewardedAdDelegate`
- `NativeAd`
- `NativeAdDelegate`
- `SliderAd`
- `SliderAdDelegate`
- `BannerAdViewDelegate`

## What to Do

When implementing these protocols or interacting with these classes, ensure the code runs on the main actor. If a conforming class is **not** marked `@MainActor`, either:

**Option 1** — Mark the conforming class with `@MainActor`:

```swift
@MainActor
class MyViewController: UIViewController, InterstitialAdDelegate {
    // all methods are implicitly @MainActor
}
```

**Option 2** — Mark each delegate method implementation with `@MainActor`:

```swift
class MyViewController: UIViewController, InterstitialAdDelegate {
    @MainActor
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShow error: Error) {
        // ...
    }

    @MainActor
    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        // ...
    }

    // ... mark all other delegate methods
}
```

> **Note**: `UIViewController` subclasses are typically already `@MainActor`-isolated. For non-UIViewController classes conforming to these protocols, Option 1 is recommended.

The `NativeAdImageLoadingObserver` protocol has been removed — image loading is handled through completion handler or async/await (see Step 8).

## Verification

```bash
swift0() { find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0; }

# Find classes conforming to SDK delegates that may need @MainActor
swift0 | xargs -0 grep -sn "AppOpenAdDelegate\|InterstitialAdDelegate\|RewardedAdDelegate\|NativeAdDelegate\|SliderAdDelegate\|BannerAdViewDelegate"
```

- [ ] All classes conforming to `@MainActor`-isolated protocols are either `@MainActor` themselves or have all delegate methods marked `@MainActor`
- [ ] No `NativeAdImageLoadingObserver` references remain
- [ ] Code interacting with `@MainActor`-isolated classes runs on the main actor
