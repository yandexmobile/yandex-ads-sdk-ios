# Change Log

All notable changes to this project will be documented in this file.

## Version 0.73.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `8.2.1`

## Version 0.72.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `8.2.0`

## Version 0.71.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `8.1.0`

## Version 0.70.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `8.0.0`

## Version 0.69.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `8.0.0-beta.2`

## Version 0.68.0

### Added

- Added `InstreamAdLoader.loadInstreamAd(configuration:)` and `InstreamAdLoader.loadInroll(configuration:)` async methods.
- Added `InstreamAdLoadingFailureInfo` class for passing InStream ad loading failure information. The `reason` property contains the error description.

### Updated

- Updated minimum supported `YandexMobileAds` version to `8.0.0-beta.1`

### Breaking changes

- Method `InstreamAdLoader.loadInroll(configuration:)` was renamed to `InstreamAdLoader.loadInroll(configuration:completion:)`. The `completion` parameter was added replacing the delegate methods.
- Method `InstreamAdLoader.loadInstreamAd(configuration:)` was renamed to `InstreamAdLoader.loadInstreamAd(configuration:completion:)`. The `completion` parameter was added replacing the delegate methods.
- MobileInstreamAds was renamed to YandexInstreamAds.
- `InstreamAdBinderDelegate`, `InstreamAd` protocols are now MainActor-isolated.
- `InstreamAdLoaderDelegate` class has been removed.

## Version 0.65.0

### Added

- Added `InstreamAdBreak` protocol for controlling In-Roll and Pause-Roll ad break playback. Provides `prepare(with:)`, `play(with:)`, `pause()`, `resume()`, `invalidate()` methods and `adBreakData` property.
- Added `AdBreakData` protocol describing an ad break: `type`, `position`, `adsCount`, `requestData` properties.

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.18.4`

### Breaking changes

- Removed `Inroll`, `InrollQueue` protocols and `InrollQueueProvider` class. Use `InstreamAd.adBreaks` filtered by `InstreamAdBreakType.inroll` to get `InstreamAdBreak` instances.
- Removed `Pauseroll`, `PauserollQueue` protocols and `PauserollQueueProvider` class. Use `InstreamAd.adBreaks` filtered by `InstreamAdBreakType.pauseroll` to get `InstreamAdBreak` instances.

## Version 0.64.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.18.3`

## Version 0.63.0

### Added

- Added `InstreamAdBreakRequestData` class with `pageID` and `impID` properties.
- Added `requestData` property to `InstreamAdBreak` protocol.

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.18.1`

## Version 0.62.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.18.0`

## Version 0.61.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.17.1`

## Version 0.60.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.17.0`

## Version 0.59.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.16.2`

## Version 0.58.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.16.1`

## Version 0.57.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.16.0`

## Version 0.56.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.15.1`

## Version 0.55.0

### Added

- Added `adsCount` property to `InstreamAdBreak` protocol. `adsCount` describes the amount of ads in ad break.

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.15.0`

## Version 0.54.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.14.1`

## Version 0.53.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.14.0`

## Version 0.52.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.13.0`

## Version 0.51.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.12.3`

## Version 0.50.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.12.2`

## Version 0.49.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.12.0`

## Version 0.48.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.11.1`

## Version 0.47.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.11.0`

## Version 0.46.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.10.2`

## Version 0.45.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.10.1`

## Version 0.44.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.10.0`

## Version 0.43.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.9.0`

## Version 0.42.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.8.0`

## Version 0.41.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.7.0`

## Version 0.40.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.6.1`

## Version 0.39.0

### Added

- Added advertiser info to VideoAdInfo.
- Added information about bitrate, apiFramework and mediaType to MediaFile.

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.6.0`

### Deprecated

- VideoAd.adInfo is deprecated now. Use VideoAd.info.extensionInfo instead.

## Version 0.38.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.5.1`

## Version 0.37.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.5.0`

## Version 0.36.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.4.1`

## Version 0.35.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.4.0`

## Version 0.34.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.3.2`

## Version 0.33.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.3.1`

## Version 0.32.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.3.0`

## Version 0.31.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.2.0`

## Version 0.30.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.1.1`

## Version 0.29.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.1.0`

## Version 0.28.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.0.2`

## Version 0.27.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.0.1`

## Version 0.26.0

### Updated

- Updated minimum supported `YandexMobileAds` version to `7.0.0`
