# Yandex Advertising Network Mobile

This package contains Yandex Advertising Network Mobile SDK and source code of samples of SDK usage.

## Documentation

Documentation could be found at the [official website][DOCUMENTATION]

## License

EULA is available at [EULA website][LICENSE]

## Quick start

### Cocoapods

1. Install [CocoaPods] to manage project dependencies, if you haven't done it yet.

2. Go to [Examples/YandexMobileAdsExample](Examples/YandexMobileAdsExample)

3. Install dependencies: ```pod install --repo-update```

4. Open the [YandexMobileAdsExample.xcworkspace](Examples/YandexMobileAdsExample/YandexMobileAdsExample.xcworkspace) file with Xcode.

5. Build and run.

### Swift Package Manager

1. Add package to your project

2. Add `-ObjC` to OTHER_LDFLAGS

3. Ensure that your target is linked binary with `YandexMobileAdsPackge` (`Your target -> Build Phases -> Link Binary With Libraries`)

4. Add `MobileAdsBundle.bundle` from `YandexMobileAds` (`Package Dependencies -> YandexMobileAdsPackage -> Referenced Binaries -> YandexMobileAds`) to `Copy Bundle Resource phase` (`Your target -> Build Phases -> Copy Bundle Resource`)

5. Build and run.

[DOCUMENTATION]: https://tech.yandex.ru/mobile-ads/
[LICENSE]: https://yandex.com/legal/mobileads_sdk_agreement/
[CocoaPods]: http://cocoapods.org/

## SKAdNetwork

File with a list of SKAdNetwork [identifiers](./SKAdNetworkIds.xml)
