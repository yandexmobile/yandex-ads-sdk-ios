# Yandex Advertising Network Mobile
This package contains Yandex Advertising Network Mobile SDK and source code of samples of SDK usage.

## Documentation
Documentation could be found at the [official website] [DOCUMENTATION]

## License
EULA is available at [EULA website] [LICENSE] 

## Quick start
1. Install [CocoaPods] to manage project dependencies, if you haven't done it yet.

2. Go to one of example projects:
  * /Examples/BannerExample
  * /Examples/InterstitialExample
  * /Examples/NativeExample
  * /Examples/VideoExample
  * /Examples/AdMobAdaptersExample
  * /Examples/MoPubAdaptersExample

3. Install dependencies:
```pod install```

4. Open project workspace.

5. Build and run.

## App Transport Security
Add the NSAppTransportSecurity exception to plist. NSAllowsArbitraryLoads exception should be added to plist in order ads to work correctly on devices with iOS 9:

![][ATS]

```xml
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

This is related to changes in security policies in iOS 9. Updates will be added in the near future that will allow advertising to work correctly without needing to add exceptions.

[DOCUMENTATION]: https://tech.yandex.ru/mobile-ads/
[LICENSE]: https://legal.yandex.com/partner_ch/
[CocoaPods]: http://cocoapods.org/
[ATS]: https://yastatic.net/doccenter/images/tech-ru/mobile-ads/freeze/daRJrLqeLaoxdf-o-qrr2wF-6LU.png