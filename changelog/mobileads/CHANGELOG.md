# Change Log

All notable changes to this project will be documented in this file.

## Version 7.0.1

### Updated

- Updated minimum supported `AppMetricaCore` version to `5.2.0`
- Updated minimum supported `AppMetricaCrashes` version to `5.2.0`

## Version 7.0.0

### Added

- AdPod ads support
- Auto-preload support for full-screen ads
- EndCard support for video ads
- Privacy Manifest support
- SKOverlay support

### Updated

- Updated minimum swift version to 5.9

### Fixed

- Fixed leaks in all ad formats

### Breaking changes

- Delete method `loadBidderTokenWithCompletionHandler:` for generating an Open Bidding token. Use `loadBidderTokenWithRequestConfiguration:completionHandler:` instead.
- See [migration guide](https://ads.yandex.com/helpcenter/en/dev/ios/release/7-0-0-migration)

## Version 6.4.1

### Added

- Improvements and fixes

## Version 6.4.0

### Added

- Improvements and fixes
- New method `loadBidderTokenWithRequestConfiguration:completionHandler:` for generating an Open Bidding token

### Deprecated

- Deprecated `loadBidderTokenWithCompletionHandler:` method in `YMABidderTokenLoader`

## Version 6.3.0

### Added

- Improvements and fixes

## Version 6.2.0

### Added

- Improvements and fixes

## Version 6.1.0

### Added

- Ability to close rewarded ad before reward
- App Open Ad format
- Improvements and optimizations
- New ad formats in rewarded
- Updated minimum supported version to iOS 13

## Version 6.0.0

### Added

- App Open Ad format
- Improvements and optimizations
- Updated minimum supported version to iOS 13

### Breaking changes

- Interstitial ad loading and ad show API decomposition
- New banner ad size API
- Removed deprecated methods `setAnalyticsReportingEnabled:(BOOL)enabled` and `flexibleSizeWithCGSize:(CGSize)size`
- Rewarded ad loading and ad show API decomposition
- See [migration guide](https://yandex.ru/support2/mobile-ads/ru/dev/ios/release/6-0-0-migration)

## Version 5.9.1

### Added

- Added improvements and fixes

## Version 5.9.0

### Added

- Added improvements and fixes

## Version 5.8.0

### Added

- Added SKOverlay support
- Added improvements and fixes

## Version 5.7.0

### Added

- Added improvements and fixes
- Updated integration logs

## Version 5.6.0

### Added

- Added improvements and fixes

## Version 5.5.0

### Added

- Added improvements and fixes

## Version 5.4.0

### Added

- Added improvements and fixes

## Version 5.3.1

### Added

- Added improvements and fixes

## Version 5.3.0

### Added

- Added improvements and fixes
- Updated minimum supported version to iOS 12.

## Version 5.2.1

### Fixed

- Fixed high CPU consumption
- Fixed native templates presentation

## Version 5.2.0

### Added

- Added fixes
- Improved the speed of loading and displaying native ads
- Improved the speed of loading and displaying video ads

## Version 5.1.0

### Added

- Added improvements and fixes

### Deprecated

- Deprecated `fixedSizeWithCGSize` init in `YMABannerAdSize`

## Version 5.0.2

### Added

- Added improvements and fixes

## Version 5.0.1

### Added

- Added improvements and fixes

## Version 5.0.0

### Added

- Added improvements and fixes

## Version 5.0.0-alpha.2

### Added

- Added improvements and fixes

## Version 5.0.0-alpha.1

### Added

- Added M1 support
- Added click callback
- Migrated to XCFramework
- Renamed blockID to adUnitID
- Updated minimum supported AppMetrica SDK version to 4.0.0
- Updated minimum supported version to iOS 10.

### Breaking changes

- Removed old methods for setting banner ad size

## Version 4.4.3

### Added

- Added improvements and fixes

## Version 4.4.2

### Added

- Added improvements and fixes
- Added possibility to configure audio session

## Version 4.4.1

### Added

- Added improvements and fixes

## Version 4.4.0

### Added

- Added improvements and fixes
- Added improvements for fullscreen designs
- Added support for SKAdNetwork 3.0
- Added support for Xcode 13

## Version 4.3.1

### Added

- Added improvements and fixes

## Version 4.3.0

### Added

- Added improvements and fixes
- Added support for delayed close button in interstitial ads

## Version 4.2.0

### Added

- Added improvements and fixes

## Version 4.1.2

### Fixed

- Fixed support for SKAdNetwork

## Version 4.1.1

### Added

- Added improvements and fixes

## Version 4.1.0

### Added

- Added ad impression callbacks
- Added improvements and fixes

### Fixed

- Fixed ad impression report in mediation
- Fixed native bulk ad loading for mediation

## Version 4.0.0

### Added

- Added ability to load multiple native ads
- Added improvements and fixes
- Added improvements for interstitial design
- Added improvements for native video design
- Added support for SKAdNetwork
- Optimized loading of rewarded ads

### Updated

- Updated deployment target to iOS 9
- Updated minimum compatible AppMetrica version to 3.14.1

## Version 3.5.0

### Added

- Added improvements and fixes
- Added support for inrolls and pauserolls in In-Stream
- Added support for social ads in In-Stream

## Version 3.4.0

### Added

- Added improvements and fixes
- Added support for native video playback

## Version 3.3.0

### Added

- Added improvements and fixes
- Added support for In-Stream ads

## Version 3.2.0

### Added

- Added improvements and fixes

### Fixed

- Fixed crashes on wrapper ads loading in VAST

## Version 3.1.1

### Fixed

- Fixed Info.plist format in resources bundle

## Version 3.1.0

### Added

- Added improvements and fixes
- Optimized loading of interstitial ads

## Version 3.0.0

### Added

- Added ability to bind native ad with `YMANativeAdView`

### Updated

- Renamed `YMAInterstitialController` to `YMAInterstitialAd`
- Renamed delegate’s methods for native ad loader, native ads, interstitial, rewarded, and banner ads

### Breaking changes

- Removed ability to use imageView in native ads binding. Use mediaView instead
- Removed classes and protocols for native ad type specific loading and binding. Use `YMANativeAd` and `YMANativeAdView` instead
- Removed deprecated VAST API
- Removed deprecated method for enabling logging

## Version 2.20.0

### Added

- Added support for iOS 14

## Version 2.19.0

### Added

- Added improvements and fixes

## Version 2.18.0

### Added

- Optimized presenting of fullscreen ads

## Version 2.17.0

### Added

- Added improvements and fixes

## Version 2.16.0

### Added

- Added improvements and fixes

### Updated

- Optimized loading of multiple native ads

## Version 2.15.4

### Added

- Added improvements and fixes

## Version 2.15.3

### Added

- Added improvements and fixes

## Version 2.15.2

### Added

- Added improvements and fixes

## Version 2.15.1

### Added

- Added improvements and fixes

## Version 2.15.0

### Added

- Added improvements and fixes
- Added support for sticky banners

## Version 2.14.0

### Added

- Added improvements and fixes

### Updated

- Updated `YMANativeMediaView` to respect the aspect ratio of the content
- Updated minimum supported version to iOS 9. Deployment target is still iOS 8, but ads will only be shown on iOS 9 and above

## Version 2.13.3

### Added

- Added improvements and fixes
- Supported display of interstitial and rewarded ads on iOS 13

## Version 2.13.2

### Added

- Added improvements and fixes

## Version 2.13.1

### Added

- Added improvements and fixes

## Version 2.13.0

### Added

- Added support for VAST wrappers
- Added support for VMAP format

## Version 2.12.0

### Added

- Added minor improvements and fixes
- Added support for media view in native ad mediation

## Version 2.11.1

### Updated

- Added improvements and fixes

## Version 2.11.0

### Added

- Added `YMANativeMediaView` and video support in native ad
- Added support for GDPR to obtain and manage consent from users from GDPR region to serve personalized ads.
- Added support for rewarded ad

### Deprecated

- Deprecated `imageView` property on `YMANativeAppInstallAdView`, `YMANativeContentAdView` and `YMANativeImageAdView` in favor of `mediaView`

## Version 2.10.0

### Added

- Added `YMAVideoDelegate` delegate to notify app when ad video completed

## Version 2.9.1

### Updated

- Dropped iOS 7 support
- Updated minimum compatible AppMetrica version to 3.1.2

## Version 2.9.0

### Added

- Added ability to specify age and gender in `YMAAdRequest`
- Added feedback asset

### Updated

- Updated module map

## Version 2.8.4

### Fixed

- Fixed missing bitcode in dynamic framework

## Version 2.8.3

### Updated

- Added minor improvements

## Version 2.8.2

### Fixed

- Fixed missing bitcode in dynamic framework

## Version 2.8.1

### Added

- Added native ad mediation

### Fixed

- Fixed memory usage in video interstitial
- Fixed visibility error indicator main thread checker warnings and crashes when native ad is deallocated on background thread

## Version 2.8.0

### Added

- Added view visibility error indicator which should help to detect SDK integration problems while testing the application

### Updated

- Updated license
- Updated minimum compatible AppMetrica version to 2.9.4

### Fixed

- Fixed Xcode 9 compilation warnings
- Fixed main thread checker warnings
- Fixed rotation issues when interstitial was shown, specifically, crashes during attempts to use AppDelegate

## Version 2.7.2

### Added

- Added ability to use SDK without AppMetrica activation
- Added video interstitial support

## Version 2.7.1

### Added

- Added HTML banners and interstitials mediation

## Version 2.7.0

### Updated

- Updated MoPub adapters distribution: replaced source code with framework
- Updated minimum compatible AppMetrica version to 2.8.0

### Fixed

- Fixed crash after attempt to display `YMAAdView` in nil `UIView`

## Version 2.6.1

### Fixed

- Fixed incorrect behavior of media HTML banners and interstitials on iOS 10.3

## Version 2.6.0

### Added

- Added ability to disable automatic location tracking
- Added dynamic framework

### Updated

- Dropped iOS 6 support
- Updated distribution: replaced static library on GitHub with zip archive containing static and dynamic frameworks
- Updated minimum compatible AppMetrica version to 2.7.0

## Version 2.5.0

### Added

- Added native image ad type

## Version 2.4.0

### Updated

- Added minor improvements and fixes

## Version 2.3.1

### Updated

- Added minor improvements and fixes

## Version 2.3.0

### Added

- Added minor improvements

### Updated

- Updated compatible AppMetrica versions range

## Version 2.2.2

### Added

- Added minor improvements

## Version 2.2.1

### Fixed

- Fixed misaligned views in native templates

## Version 2.2.0

### Added

- Added ability to get native ad asset values
- Added ability to load native ad images manually
- Added loaded image sizes configuration for native ads

### Updated

- Updated maximum compatible AppMetrica version to 2.5.0

### Fixed

- Fixed imports in YMANativeAdDelegate

## Version 2.1.2

### Updated

- Updated compatible AppMetrica version to 2.4.1

### Fixed

- Fixed links opening on OS versions lower than iOS 9

## Version 2.1.1

### Added

- Added minor improvements

## Version 2.1.0

### Added

- Added native ads template view

### Fixed

- Fixed ad clicks on devices with force touch

## Version 2.0.2

### Updated

- Updated maximum compatible AppMetrica version to 2.3.1

### Fixed

- Fixed URL opening bug in native ads bound to reusable views

## Version 2.0.1

### Added

- Added native assets highlighting

### Fixed

- Fixed errors handling

## Version 2.0.0

### Added

- Added flexible banner sizes

### Updated

- Updated maximum compatible AppMetrica version to 2.3.0

### Deprecated

- Deprecated `[YMAAdView initWithBlockID:size:delegate]` in favor of `[YMAAdView initWithBlockID:adSize:delegate]`
- Deprecated `[YMALog enableLogging]` in favor of `[YMAMobileAds enableLogging]`

## Version 1.9.2

### Added

- Supported bitcode

### Fixed

- Fixed HTML escaped symbols in native ads texts
- Fixed errors

### Breaking changes

- Removed SLColorArt and TOWebViewController dependencies

## Version 1.9.1

### Added

- Added 300x300, 300x250 and 320x100 ad sizes
- Improved impression tracking

## Version 1.9.0

### Added

- Added App Install native ad type
- Added ability to open web links in application or browser
- Supported iOS 9

### Updated

- Updated AppMetrica to 2.0.0

### Breaking changes

- Changed AdUnitID to BlockID in public API
- Moved context parameters to ad request class
