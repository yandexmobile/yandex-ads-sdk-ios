# Change Log
All notable changes to this project will be documented in this file.

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
