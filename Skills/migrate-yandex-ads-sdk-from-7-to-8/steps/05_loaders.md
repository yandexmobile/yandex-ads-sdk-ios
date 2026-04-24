# Step 5: Migrate Ad Loaders (Delegate → Completion / Async)

> **First, read [`../general_rules.md`](../general_rules.md).**

**CRITICAL**: All loader delegates have been **removed**. Loading results are now delivered via a `completion` handler (using `Result`) or `async/await`.

## Choosing Between Completion Handler and async/await

**Default: use completion handler.** It is the safest choice that works in all contexts.

Use async/await ONLY when:
1. The file is Swift (not Objective-C)
2. The method containing the `loadAd` call is already marked `async`, OR the call site is already inside a `Task { }`

If unsure, use completion handler. Do NOT introduce `Task { }` wrappers just to use async/await.

**CRITICAL**: Be consistent within a single file. Do not mix completion and async styles for different loaders in the same file.

## Deleted Loader Delegates

Remove all conformances and implementations of:

| Deleted Protocol               |
|--------------------------------|
| `AppOpenAdLoaderDelegate`      |
| `InterstitialAdLoaderDelegate` |
| `RewardedAdLoaderDelegate`     |
| `NativeAdLoaderDelegate`       |
| `NativeBulkAdLoaderDelegate`   |
| `SliderAdLoaderDelegate`       |

## New Method Signatures

| SDK 7                                        | SDK 8 (completion)                           | SDK 8 (async)                     |
|----------------------------------------------|----------------------------------------------|-----------------------------------|
| `AppOpenAdLoader.loadAd(with:)`              | `loadAd(with:completion:)`                   | `loadAd(with:)`                   |
| `InterstitialAdLoader.loadAd(with:)`         | `loadAd(with:completion:)`                   | `loadAd(with:)`                   |
| `RewardedAdLoader.loadAd(with:)`             | `loadAd(with:completion:)`                   | `loadAd(with:)`                   |
| `NativeAdLoader.loadAd(with:)`               | `loadAd(with:options:completion:)`           | `loadAd(with:options:)`           |
| `NativeBulkAdLoader.loadAds(with:adsCount:)` | `loadAds(with:adsCount:options:completion:)` | `loadAds(with:adsCount:options:)` |
| `SliderAdLoader.loadAd(with:)`               | `loadAd(with:options:completion:)`           | `loadAd(with:options:)`           |

## Migration Steps

1. Remove `loader.delegate = self` assignments
2. Remove `loader.delegate = nil` cleanup assignments (delegates no longer exist)
3. Remove delegate protocol conformance declarations from the class
4. Remove delegate method implementations (`didLoad`, `didFailToLoadWithError`, etc.)
5. Replace `loadAd(with:)` calls with the completion handler or async version
6. Move logic from deleted delegate methods into the completion handler or async call site

**CRITICAL**: Since loader delegates have been removed, any code that sets `loader.delegate = nil` (typically in cleanup/teardown methods) must also be removed. The loader no longer has a `delegate` property.

## Example: Interstitial

```swift
// SDK 7
class ViewController: UIViewController, InterstitialAdLoaderDelegate {
    let loader = InterstitialAdLoader()

    func loadAd() {
        let configuration = AdRequestConfiguration(adUnitID: "R-M-XXXXX-YY")
        loader.delegate = self
        loader.loadAd(with: configuration)
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad ad: InterstitialAd) {
        // ad loaded
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        // error
    }
}

// SDK 8 (completion handler)
class ViewController: UIViewController {
    let loader = InterstitialAdLoader()

    func loadAd() {
        let request = AdRequest(adUnitID: "R-M-XXXXX-YY")
        loader.loadAd(with: request) { [weak self] result in
            switch result {
            case .success(let ad):
                // ad loaded
            case .failure(let error):
                // error
            }
        }
    }
}

// SDK 8 (async/await)
class ViewController: UIViewController {
    let loader = InterstitialAdLoader()

    func loadAd() async throws {
        let request = AdRequest(adUnitID: "R-M-XXXXX-YY")
        let ad = try await loader.loadAd(with: request)
    }
}
```

## Native Ads: Use `NativeAdOptions`

For native ad loaders, the new `NativeAdOptions` parameter configures loading options (including automatic image loading):

```swift
// SDK 8
let request = AdRequest(adUnitID: "R-M-XXXXX-YY")
let options = NativeAdOptions()
nativeAdLoader.loadAd(with: request, options: options) { result in
    switch result {
    case .success(let ad):
        // ad loaded
    case .failure(let error):
        // error
    }
}

// SDK 8 (async/await)
let ad = try await nativeAdLoader.loadAd(with: request, options: options)
```

## BidderTokenRequest Factory Methods (Mediation Adapters)

The old `BidderTokenRequestConfiguration(adType:)` initializer with mutable properties is replaced by factory methods on `BidderTokenRequest`. All parameters are optional.

| SDK 7                                                                                | SDK 8                                                    |
|--------------------------------------------------------------------------------------|----------------------------------------------------------|
| `BidderTokenRequestConfiguration(adType: .banner)` + `.bannerAdSize` + `.targetInfo` | `BidderTokenRequest.banner(size:targeting:parameters:)`  |
| `BidderTokenRequestConfiguration(adType: .interstitial)` + `.targetInfo`             | `BidderTokenRequest.interstitial(targeting:parameters:)` |
| `BidderTokenRequestConfiguration(adType: .rewarded)` + `.targetInfo`                 | `BidderTokenRequest.rewarded(targeting:parameters:)`     |
| `BidderTokenRequestConfiguration(adType: .native)` + `.targetInfo`                   | `BidderTokenRequest.native(targeting:parameters:)`       |
| `BidderTokenRequestConfiguration(adType: .appOpenAd)` + `.targetInfo`                | `BidderTokenRequest.appOpenAd(targeting:parameters:)`    |

```swift
// SDK 7
let config = BidderTokenRequestConfiguration(adType: .banner)
config.bannerAdSize = adSize
config.targetInfo = adTargetInfo
tokenLoader.loadBidderToken(requestConfiguration: config) { token in ... }

// SDK 8
let targeting = AdTargeting()
let request = BidderTokenRequest.banner(
    size: adSize,
    targeting: targeting,
    parameters: ["key": "value"]
)
tokenLoader.loadBidderToken(request: request) { token in ... }

// SDK 8 — other ad types (all parameters are optional)
let request = BidderTokenRequest.interstitial()
let request = BidderTokenRequest.rewarded()
let request = BidderTokenRequest.native()
let request = BidderTokenRequest.appOpenAd()
```

## AdapterIdentity (Mediation Adapters)

The `mediationNetworkName` parameter has been removed from `BidderTokenLoader`. Adapter identification is now set globally via `YandexAds.setAdapterIdentity(_:)` **before** SDK initialization.

```swift
// SDK 7
let tokenLoader = BidderTokenLoader(mediationNetworkName: "AdMob")

// SDK 8
let adapterIdentity = AdapterIdentity(
    adapterNetworkName: "AdMob",
    adapterVersion: "1.0.0",
    adapterNetworkVersion: "23.5.0"
)
YandexAds.setAdapterIdentity(adapterIdentity)
YandexAds.initializeSDK(completionHandler: nil)

let tokenLoader = BidderTokenLoader()
```

## Verification

```bash
swift0() { find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0; }
swift0 | xargs -0 grep -sn "AppOpenAdLoaderDelegate\|InterstitialAdLoaderDelegate\|RewardedAdLoaderDelegate\|NativeAdLoaderDelegate\|NativeBulkAdLoaderDelegate\|SliderAdLoaderDelegate"
swift0 | xargs -0 grep -sn "\.delegate\s*=" | grep -i "loader"
swift0 | xargs -0 grep -sn "Loader.*\.delegate"
```

- [ ] No loader delegate protocol conformances remain
- [ ] No `loader.delegate = self` assignments remain
- [ ] No `loader.delegate = nil` cleanup assignments remain
- [ ] No old delegate method implementations remain (`didLoad`, `didFailToLoadWithError`)
- [ ] All `loadAd` calls use the new completion handler or async signature
- [ ] Native ad loaders pass `NativeAdOptions` where needed
