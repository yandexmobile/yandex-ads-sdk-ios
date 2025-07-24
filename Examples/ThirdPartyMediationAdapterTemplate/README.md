# Third-party mediation adapter template

## Description

The code template found in this folder can be used to create an adapter for embedding the [Yandex Advertising Network](https://yandex.ru/support2/mobile-ads/en) into Third-Party Mediation. The template contains two files:

* The [MediationAPI](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/MediationAPI.swift) file contains stub interfaces and classes that describes an API of your Mediation SDK. This file is just an example and your actual API may be different from this one.
* The [YandexAdapters](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/YandexAdapters.swift) file contains classes that implements [MediationAPI](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/MediationAPI.swift) to integrate [Yandex Advertising Network](https://yandex.ru/support2/mobile-ads/en) into your Mediation.

> Here is a quick start for writing an adapter. Full documentation for Yandex Mobile Ads SDK can be found on the [official website](https://yandex.ru/support2/mobile-ads/en/dev/ios).

## Getting started

### 1. App requirements

* Use Xcode 16.2 or later.
* Use iOS 13 or higher.

### 2. Yandex Mobile Ads SDK dependency

> You can check the latest Yandex Mobile SDK version [here](https://yandex.ru/support2/mobile-ads/en/dev/platforms). Add the YandexMobileAds library to the Podfile.

```CocoaPods
pod 'YandexMobileAds', '$YANDEX_SDK_VERSION'
```

See [also](https://yandex.ru/support2/mobile-ads/en/dev/ios/quick-start#app).

### 3. Implement adapter

Copy [YandexAdapters](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/YandexAdapters.swift) file content and change stub API to your actual API.
This way you will get a separate adapter class for each of the ad formats. If your API requires a single class for all formats, you can merge classes.

* Mediation parameters must be set for each request as shown in the [template](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/YandexAdapters.swift#L82):
  * `"adapter_network_name"` represents your ad network name in lowercase.
  * `"adapter_version"` represents Yandex adapter version. Construct this version by adding one more number to the Yandex SDK version. For example, `6.3.0.0` if the Yandex SDK version is `6.3.0`. If you need to update an adapter without changing the Yandex SDK version, increment the fourth number like `6.3.0.1`.
  * `"adapter_network_sdk_version"` represents your ad network SDK version.

* `Interstitial`, `Rewarded`, `AppOpen` formats provide loader classes. A loader object can be [created](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/YandexAdapters.swift#L165) once and can be reused. This speeds up loading and can be helpful to implement preloading logic, if your network supports it.

* `Native` format includes both the required and optional [assets](https://yandex.ru/support2/mobile-ads/en/dev/ios/components). The way to provide custom assets for binding strongly depends on the API of your ads SDK. The [template]((./ThirdPartyMediationAdapterTemplate/AdapterTemplate/YandexAdapters.swift#L503)) shows how these assets are passed to adapter during the ad request by providing a map of `string identifier` to `asset view identifier` on the publisher side.

### 4. Test integration

It is recommended to use test ads to check your adapter. These special demo ad unit identifiers guarantee successful ad response for each request:

* AppOpen format: `demo-appopenad-yandex`
* Banner format: `demo-banner-yandex`
* Interstitial format: `demo-interstitial-yandex`
* Rewarded format: `demo-rewarded-yandex`
* Native format: `demo-native-content-yandex`, `demo-native-app-yandex`, `demo-native-video-yandex`

## Additional info

### Initialization

Successfully initializing the Yandex Mobile Ads SDK is an important condition for correctly integrating the library. By default, SDK initialization happens automatically before ads load, but manual initialization will speed up how quickly the first ad loads and therefore increase revenue from monetization.

Manual initialization of the SDK can be used like this (this method is safety and can be reinvoked if SDK already initialized):

```swift
MobileAds.initializeSDK()
```

### Privacy policies

Privacy policies can be configured like this:

```swift
MobileAds.setLocationTrackingEnabled(locationTracking)
MobileAds.setUserConsent(userConsent)
```

> You should configure policies every time when it changed.

See also: [GDPR](https://ads.yandex.com/helpcenter/en/dev/ios/gdpr).

### S2S bidding integration

As shown in the [template](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/YandexAdapters.swift#L42), the bidder token can be obtained as follows:

```swift
let bidderTokenLoader = BidderTokenLoader(mediationNetworkName: "MEDIATION_NETWORK_NAME")
bidderTokenLoader.loadBidderToken(requestConfiguration: requestConfiguraton) { token in
    completion(token)
 }
```

You need to load a bidder token for each new ad request. Token request can be created as follows (also shown in [template](./ThirdPartyMediationAdapterTemplate/AdapterTemplate/YandexAdapters.swift#L27)):

```swift
let requestConfiguraton = BidderTokenRequestConfiguration(adType: adType)
if adType == .banner {
    requestConfiguraton.bannerAdSize = bannerAdSize
}
```
