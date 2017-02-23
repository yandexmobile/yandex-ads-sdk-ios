# Change Log
All notable changes to this project will be documented in this file.

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
