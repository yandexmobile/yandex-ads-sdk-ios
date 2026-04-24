# Step 7: Migrate Ad Object Delegates

> **First, read [`../general_rules.md`](../general_rules.md).**

**CRITICAL**: All delegate methods of `AppOpenAdDelegate`, `InterstitialAdDelegate`, `RewardedAdDelegate`, `NativeAdDelegate`, `SliderAdDelegate` are now **required** (non-optional). You must implement every method in the protocol.

This applies to:
- `AppOpenAdDelegate` (5 methods)
- `InterstitialAdDelegate` (5 methods)
- `RewardedAdDelegate` (6 methods)
- `NativeAdDelegate` (2 methods)
- `SliderAdDelegate` (2 methods)
- `BannerAdViewDelegate` (4 methods — see Step 6)

## Complete List of Required Methods

### AppOpenAdDelegate (5 methods)

```swift
func appOpenAd(_ appOpenAd: AppOpenAd, didFailToShow error: Error)
func appOpenAdDidShow(_ appOpenAd: AppOpenAd)
func appOpenAdDidDismiss(_ appOpenAd: AppOpenAd)
func appOpenAdDidClick(_ appOpenAd: AppOpenAd)
func appOpenAd(_ appOpenAd: AppOpenAd, didTrackImpression impressionData: ImpressionData?)
```

### InterstitialAdDelegate (5 methods)

```swift
func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShow error: Error)
func interstitialAdDidShow(_ interstitialAd: InterstitialAd)
func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd)
func interstitialAdDidClick(_ interstitialAd: InterstitialAd)
func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpression impressionData: ImpressionData?)
```

### RewardedAdDelegate (6 methods)

```swift
func rewardedAd(_ rewardedAd: RewardedAd, didReward reward: Reward)
func rewardedAd(_ rewardedAd: RewardedAd, didFailToShow error: Error)
func rewardedAdDidShow(_ rewardedAd: RewardedAd)
func rewardedAdDidDismiss(_ rewardedAd: RewardedAd)
func rewardedAdDidClick(_ rewardedAd: RewardedAd)
func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpression impressionData: ImpressionData?)
```

### NativeAdDelegate (2 methods)

```swift
func nativeAdDidClick(_ ad: NativeAd)
func nativeAd(_ ad: NativeAd, didTrackImpression impressionData: ImpressionData?)
```

### SliderAdDelegate (2 methods)

```swift
func sliderAdDidClick(_ ad: SliderAd)
func sliderAd(_ ad: SliderAd, didTrackImpression impressionData: ImpressionData?)
```

### BannerAdViewDelegate (4 methods)

```swift
func bannerAdViewDidLoad(_ bannerAdView: BannerAdView)
func bannerAdViewDidFailLoading(_ bannerAdView: BannerAdView, error: Error)
func bannerAdViewDidClick(_ bannerAdView: BannerAdView)
func bannerAdView(_ bannerAdView: BannerAdView, didTrackImpression impressionData: ImpressionData?)
```

## Renamed Delegate Methods

Note: The method names below do NOT include the "Delegate" suffix in actual code. The prefix is used here only to indicate which protocol they belong to.

| SDK 7                                       | SDK 8                                   |
|---------------------------------------------|-----------------------------------------|
| `appOpenAd(_:didFailToShowWithError:)`      | `appOpenAd(_:didFailToShow:)`           |
| `interstitialAd(_:didFailToShowWithError:)` | `interstitialAd(_:didFailToShow:)`      |
| `rewardedAd(_:didFailToShowWithError:)`     | `rewardedAd(_:didFailToShow:)`          |
| `appOpenAd(_:didTrackImpressionWith:)`      | `appOpenAd(_:didTrackImpression:)`      |
| `interstitialAd(_:didTrackImpressionWith:)` | `interstitialAd(_:didTrackImpression:)` |
| `rewardedAd(_:didTrackImpressionWith:)`     | `rewardedAd(_:didTrackImpression:)`     |
| `nativeAd(_:didTrackImpressionWith:)`       | `nativeAd(_:didTrackImpression:)`       |
| `sliderAd(_:didTrackImpressionWith:)`       | `sliderAd(_:didTrackImpression:)`       |

## Deleted Delegate Methods

Remove all implementations of:

| Deleted Method                                            |
|-----------------------------------------------------------|
| `NativeAdDelegate.close(_:)`                              |
| `NativeAdDelegate.viewControllerForPresentingModalView()` |
| `NativeAdDelegate.nativeAdWillLeaveApplication`           |
| `NativeAdDelegate.nativeAd(_:willPresentScreen:)`         |
| `NativeAdDelegate.nativeAd(_:didDismissScreen:)`          |
| `SliderAdDelegate.sliderAdDidClose(_:)`                   |
| `SliderAdDelegate.sliderAdWillLeaveApplication`           |
| `SliderAdDelegate.sliderAd(_:willPresentScreen:)`         |
| `SliderAdDelegate.sliderAd(_:didDismissScreen:)`          |

## Verification

```bash
swift0() { find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0; }
swift0 | xargs -0 grep -sn "didFailToShowWithError\|didTrackImpressionWith[^a-zA-Z]"
swift0 | xargs -0 grep -sn "nativeAdWillLeaveApplication\|sliderAdWillLeaveApplication\|sliderAdDidClose\|viewControllerForPresentingModalView"
```

- [ ] No old delegate method names remain (`didFailToShowWithError`, `didTrackImpressionWith`)
- [ ] All deleted delegate methods have been removed
- [ ] Every class conforming to a delegate protocol implements **all** required methods
- [ ] Method signatures match the SDK 8 signatures exactly (parameter labels, types)
