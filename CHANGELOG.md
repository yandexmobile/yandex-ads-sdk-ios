# Change Log
All notable changes to this project will be documented in this file.

# Version 2.11.0

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/212922/YandexMobileAds-2.11.0-ios-ea6f0b6f-f4b3-415c-bf58-22806e8c94b4.zip)

#### Added

* Added support for rewarded ad
* Added support for GDPR to obtain and manage consent from users from GDPR region to serve personalized ads.
* Added `YMANativeMediaView` and video support in native ad

#### Deprecated
* Deprecated `imageView` property on `YMANativeAppInstallAdView`, `YMANativeContentAdView` and `YMANativeImageAdView` in favor of `mediaView`

# Version 2.10.0

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/212922/YandexMobileAds-2.10.0-ios-10ea4e26-01a4-4e57-b87a-68ab28f757f2.zip)

#### Added

* Added `YMAVideoDelegate` delegate to notify app when ad video completed

## Version 2.9.1

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/332493/YandexMobileAds-2.9.1-ios-c5e820ac-aa24-480e-bdb6-063c54c7ac74.zip)

#### Updated

* Dropped iOS 7 support
* Updated minimum compatible AppMetrica version to 3.1.2

## Version 2.9.0

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/212922/YandexMobileAds-2.9.0-ios-0129a28d-75a4-45d8-b68f-67c781795283.zip)

#### Added

* Added ability to specify age and gender in `YMAAdRequest`
* Added feedback asset

#### Updated

* Updated module map

## Version 2.8.4

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/212922/YandexMobileAds-2.8.4-ios-17d00d31-6812-4e33-9a15-7d8cced3da6f.zip)

#### Fixed

* Fixed missing bitcode in dynamic framework

## Version 2.8.3

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/224062/YandexMobileAds-2.8.3-ios-4be41012-a86a-40df-a84a-a2bdf773c574.zip)

#### Updated

* Added minor improvements

## Version 2.8.2

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/223308/YandexMobileAds-2.8.2-ios-88890a59-302f-404c-8171-0c115dabb5aa.zip)

#### Fixed

* Fixed missing bitcode in dynamic framework

## Version 2.8.1

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/212922/YandexMobileAds-2.8.1-ios-09dc1dad-3c91-4046-8b89-0d8604638fd6.zip)

#### Added

* Added native ad mediation 

#### Fixed

* Fixed visibility error indicator main thread checker warnings and crashes when native ad is deallocated on background thread
* Fixed memory usage in video interstitial

## Version 2.8.0

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/212922/YandexMobileAds-2.8.0-ios-d916f1ab-36ce-4eba-9e76-de687ab43d76.zip)

#### Added

* Added view visibility error indicator which should help to detect SDK integration problems while testing the application

#### Updated
* Updated minimum compatible AppMetrica version to 2.9.4
* Updated license

#### Fixed

* Fixed main thread checker warnings
* Fixed rotation issues when interstitial was shown, specifically, crashes during attempts to use AppDelegate
* Fixed Xcode 9 compilation warnings

## Version 2.7.2

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/332493/YandexMobileAds-2.7.2-ios-5fe88a8e-1236-4abe-8ea6-c20e48dce004.zip)

#### Added

* Added video interstitial support
* Added ability to use SDK without AppMetrica activation

## Version 2.7.1

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/212922/YandexMobileAds-2.7.1-ios-da45a528-4c70-486c-a901-4fde43406994.zip)

#### Added

* Added HTML banners and interstitials mediation 

## Version 2.7.0

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/224062/YandexMobileAds-2.7.0-ios-9802b1ba-ef4b-4a5b-8ea3-ab5557810aa0.zip)

#### Updated
* Updated MoPub adapters distribution: replaced source code with framework
* Updated minimum compatible AppMetrica version to 2.8.0

#### Fixed
* Fixed crash after attempt to display `YMAAdView` in nil `UIView`

## Version 2.6.1

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/205984/YandexMobileAds-2.6.1-ios-5289620b-82e6-4306-aa52-cc43ea1ba6e3.zip)

#### Fixed
* Fixed incorrect behavior of media HTML banners and interstitials on iOS 10.3

## Version 2.6.0

SDK archive: [**download**](https://storage.mds.yandex.net/get-ads-mobile-sdk/205984/YandexMobileAds-2.6.0-ios-1c419d7d-9152-4f99-b907-aa3176718964.zip)

#### Added
* Added dynamic framework
* Added ability to disable automatic location tracking

#### Updated
* Dropped iOS 6 support
* Updated distribution: replaced static library on GitHub with zip archive containing static and dynamic frameworks
* Updated minimum compatible AppMetrica version to 2.7.0

## Version 2.5.0

#### Added
* Added native image ad type

## Version 2.4.0

#### Updated
* Added minor improvements and fixes

## Version 2.3.1

#### Updated
* Added minor improvements and fixes

## Version 2.3.0

#### Updated
* Updated compatible AppMetrica versions range

#### Added
* Added minor improvements 

## Version 2.2.2

#### Added
* Added minor improvements 

## Version 2.2.1

#### Fixed
* Fixed misaligned views in native templates

## Version 2.2.0

#### Added
* Added ability to load native ad images manually
* Added loaded image sizes configuration for native ads
* Added ability to get native ad asset values

#### Updated
* Updated maximum compatible AppMetrica version to 2.5.0

#### Fixed
* Fixed imports in YMANativeAdDelegate

## Version 2.1.2

#### Updated
* Updated compatible AppMetrica version to 2.4.1

#### Fixed
* Fixed links opening on OS versions lower than iOS 9

## Version 2.1.1

#### Added
* Added minor improvements 

## Version 2.1.0

#### Added
* Added native ads template view

#### Fixed
* Fixed ad clicks on devices with force touch

## Version 2.0.2

#### Updated
* Updated maximum compatible AppMetrica version to 2.3.1

#### Fixed
* Fixed URL opening bug in native ads bound to reusable views

## Version 2.0.1

#### Added
* Added native assets highlighting

#### Fixed
* Fixed errors handling

## Version 2.0.0

#### Added
* Added flexible banner sizes

#### Updated
* Updated maximum compatible AppMetrica version to 2.3.0

#### Deprecated
* Deprecated `[YMAAdView initWithBlockID:size:delegate]` in favor of `[YMAAdView initWithBlockID:adSize:delegate]`
* Deprecated `[YMALog enableLogging]` in favor of `[YMAMobileAds enableLogging]`

## Version 1.9.2

#### Added
* Supported bitcode

#### Removed
* Removed SLColorArt and TOWebViewController dependencies

#### Fixed
* Fixed errors
* Fixed HTML escaped symbols in native ads texts

## Version 1.9.1

#### Added
* Added 300x300, 300x250 and 320x100 ad sizes
* Improved impression tracking

## Version 1.9.0

#### Added
* Added App Install native ad type
* Added ability to open web links in application or browser
* Supported iOS 9

#### Updated
* Updated AppMetrica to 2.0.0

#### Breaking changes
* Changed AdUnitID to BlockID in public API
* Moved context parameters to ad request class
