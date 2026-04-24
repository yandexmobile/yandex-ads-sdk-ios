# Step 8: Migrate Native Ads

> **First, read [`../general_rules.md`](../general_rules.md).**

## 8.1 Warning Field Type Change

The `warning` field in `NativeAdAssets` changed from `String?` to `NativeAdWarning?`. Access the text value through `.value`:

```swift
// SDK 7
let warningText: String? = nativeAd.adAssets.warning
label.text = warningText

// SDK 8
let warning: NativeAdWarning? = nativeAd.adAssets.warning
label.text = warning?.value
```

`NativeAdWarning` also contains `minimumRequiredArea` — the minimum required portion of the ad area for the warning asset.

## 8.2 Video Detection

Use the new `hasVideo` property on `NativeAdMedia`:

```swift
// SDK 8
if let media = nativeAd.adAssets.media, media.hasVideo {
    // handle video content
}
```

## 8.3 Image Loading (`loadImages`)

`loadImages()` is renamed to `loadImages(completionHandler:)`. The `NativeAdImageLoadingObserver` protocol has been **removed**.

| SDK 7                                                    | SDK 8                                                                      |
|----------------------------------------------------------|----------------------------------------------------------------------------|
| `NativeAd.loadImages()` + `NativeAdImageLoadingObserver` | `NativeAd.loadImages(completionHandler:)` or async `NativeAd.loadImages()` |
| `SliderAd.loadImages()` + `NativeAdImageLoadingObserver` | `SliderAd.loadImages(completionHandler:)` or async `SliderAd.loadImages()` |

```swift
// SDK 7 — NativeAd
nativeAd.addImageLoadingObserver(self)
nativeAd.loadImages()

// SDK 8 — NativeAd (completion handler)
nativeAd.loadImages(completionHandler: { [weak self] in
    // images loaded
})

// SDK 8 — NativeAd (async/await)
await nativeAd.loadImages()

// SDK 7 — SliderAd
sliderAd.addImageLoadingObserver(self)
sliderAd.loadImages()

// SDK 8 — SliderAd (completion handler)
sliderAd.loadImages(completionHandler: { [weak self] in
    // images loaded
})

// SDK 8 — SliderAd (async/await)
await sliderAd.loadImages()
```

## 8.4 Rating Protocol Changes

**CRITICAL**: Step 3 CLI commands replace method **calls** only (e.g., `rating.setRating(value)`), NOT protocol **implementations**. If code implements `Rating` protocol, manually migrate to property.

```swift
// SDK 7 — Protocol implementation
extension StarRatingView: Rating {
    func setRating(_ rating: NSNumber?) {
        _rating = rating as? Int
        updateStarViews()
    }

    func rating() -> NSNumber? {
        guard let rating = _rating else { return nil }
        return NSNumber(value: rating)
    }
}

// SDK 8 — Protocol implementation
extension StarRatingView: Rating {
    var rating: NSNumber? {
        get {
            guard let rating = _rating else { return nil }
            return NSNumber(value: rating)
        }
        set {
            _rating = newValue as? Int
            updateStarViews()
        }
    }
}
```

| Removed                               | Added                               |
|---------------------------------------|-------------------------------------|
| `func setRating(_ rating: NSNumber?)` | `var rating: NSNumber? { get set }` |
| `func rating() -> NSNumber?`          |  removed                            |

## 8.5 Binding

`NativeAd.bind(toSliderView:)` has been removed. Use `SliderAd.bind(with:)` instead.
The `ad` property of `NativeAdView` is now **read-only**. You must use the `bind(with:)` method instead of direct assignment.

| SDK 7                                        | SDK 8                             |
|----------------------------------------------|-----------------------------------|
| `nativeAd.bindAd(toSliderView: sliderView)`  | `sliderAd.bind(with: sliderView)` |
| `sliderAd.bindAd(toSliderView: sliderView)`  | `sliderAd.bind(with: sliderView)` |

```swift
// SDK 7
try ad.bindAd(toSliderView: sliderView)

// SDK 8
try ad.bind(with: sliderView)
```

## 8.6 Removed APIs

| Removed                                                        | Notes                                         |
|----------------------------------------------------------------|-----------------------------------------------|
| `VideoController` / `VideoDelegate`                            | Removed entirely. Remove all references.      |
| `NativeTemplateAppearance` / `MutableNativeTemplateAppearance` | Removed. Use custom `NativeAdView` rendering. |
| `NativeBannerView`                                             | Removed. Use custom `NativeAdView` rendering. |
| `NativeVideoPlaybackProgressControl.reset`                     | Removed (no replacement).                     |
| All `*Appearance` / `*Offset` / `*SizeConstraint` classes      | Removed with native templates.                |

If the project uses native templates, notify the user that they must implement custom native ad rendering using `NativeAdView`.

## 8.7 Ad Object Property Changes

These changes apply to all ad objects (`NativeAd`, `SliderAd`, `AppOpenAd`, `InterstitialAd`, `RewardedAd`, `BannerAdView`):

| SDK 7             | SDK 8                                               |
|-------------------|-----------------------------------------------------|
| `*.info`          | `*.adInfo.extraData`                                |
| `*.adAttributes`  | `*.adInfo.creatives`                                |
| `*.creativeID`    | `*.adInfo.creatives[i].creativeID`                  |
| `*.campaignID`    | `*.adInfo.creatives[i].campaignID`                  |
| `*.adInfo.adSize` | Removed — use `BannerAdView.adSize` for banner size |

New properties added: `AdInfo.partnerText`, `Creative.placeID`, `Creative.offerID`.

```swift
// SDK 7
let attributes = nativeAd.adAttributes
let info = nativeAd.info

// SDK 8
let creatives = nativeAd.adInfo.creatives
let extraData = nativeAd.adInfo.extraData
```

## 8.8 AdMob Mediation: YandexAdMobCustomEventNativeAdView Protocol Changes

`YandexAdMobCustomEventNativeAdView` protocol requires two new methods to be implemented:

```swift
func nativeImageView() -> UIImageView?
func nativeFeedbackButton() -> UIButton?
```

Return nil for both of them.

## Verification

```bash
swift0() { find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0; }
swift0 | xargs -0 grep -sn "NativeAdImageLoadingObserver\|addImageLoadingObserver"
swift0 | xargs -0 grep -sn "bind(toSliderView"
swift0 | xargs -0 grep -sn "VideoController\|VideoDelegate"
swift0 | xargs -0 grep -sn "NativeTemplateAppearance\|NativeBannerView"
swift0 | xargs -0 grep -sn "NativeVideoPlaybackProgressControl\.reset"
swift0 | xargs -0 grep -sn "\.adAttributes"
swift0 | xargs -0 grep -sn "\.adInfo\.adSize"
swift0 | xargs -0 grep -sn "func setRating\|func rating()"
```

- [ ] No `NativeAdImageLoadingObserver` references remain
- [ ] No `addImageLoadingObserver` calls remain
- [ ] `loadImages` uses completion handler or async pattern
- [ ] `bind(toSliderView:)` replaced with `SliderAd.bind(with:)`
- [ ] No `VideoController` / `VideoDelegate` references remain
- [ ] No native template classes remain
- [ ] Warning field access uses `.value` property
- [ ] No `.adAttributes` references remain (use `.adInfo.creatives`)
- [ ] No `.adInfo.adSize` references remain (use `BannerAdView.adSize` for banner size)
- [ ] No direct `.creativeID` / `.campaignID` on ad objects (use `.adInfo.creatives[i]`)
- [ ] No `func setRating(_:)` or `func rating()` method implementations remain (use `var rating` property)
