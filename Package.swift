// swift-tools-version: 5.9;
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YandexMobileAdsPackage",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(
            name: "YandexMobileAds",
            targets: ["YandexMobileAdsWrapper"]
        ),
        .library(
            name: "YandexMobileAdsInstream",
            targets: ["YandexMobileAdsInstreamWrapper"]
        ),
        .library(
            name: "YandexMobileAdsConsentManagement",
            targets: ["YandexMobileAdsConsentManagementWrapper"]
        ),
        .library(
            name: "YandexMobileAdsAdMobAdapters",
            targets: ["YandexMobileAdsAdMobAdaptersWrapper"]
        ),
        .library(
            name: "GoogleYandexMobileAdsAdapters",
            targets: ["GoogleYandexMobileAdsAdaptersWrapper"]
        ),
        .library(
            name: "VungleYandexMobileAdsAdapters",
            targets: ["VungleYandexMobileAdsAdaptersWrapper"]
        ),
        .library(
            name: "AppLovinYandexMobileAdsAdapters",
            targets: ["AppLovinYandexMobileAdsAdaptersWrapper"]
        ),
        .library(
            name: "MyTargetYandexMobileAdsAdapters",
            targets: ["MyTargetYandexMobileAdsAdaptersWrapper"]
        ),
        .library(
            name: "MintegralYandexMobileAdsAdapters",
            targets: ["MintegralYandexMobileAdsAdaptersWrapper"]
        ),
        .library(
            name: "DigitalTurbineYandexMobileAdsAdapters",
            targets: ["DigitalTurbineYandexMobileAdsAdaptersWrapper"]
        ),
        .library(
            name: "YandexMobileAdsMediation",
            targets: [
                "YandexMobileAdsMediation",
                "GoogleYandexMobileAdsAdaptersWrapper",
                "VungleYandexMobileAdsAdaptersWrapper",
                "AppLovinYandexMobileAdsAdaptersWrapper",
                "MyTargetYandexMobileAdsAdaptersWrapper",
                "MintegralYandexMobileAdsAdaptersWrapper",
                "DigitalTurbineYandexMobileAdsAdaptersWrapper"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMinor(from: "6.0.0")),
        .package(url: "https://github.com/divkit/divkit-ios-facade", .upToNextMinor(from: "5.3.0")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", .upToNextMinor(from: "12.14.0")),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", .upToNextMinor(from: "7.7.0")),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", .upToNextMinor(from: "13.5.1")),
        .package(url: "https://github.com/myTargetSDK/mytarget-ios-spm", .upToNextMinor(from: "5.36.2")),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", .upToNextMinor(from: "8.0.7")),
        .package(url: "https://github.com/inner-active/DTExchangeSDK-iOS-SPM", .upToNextMinor(from: "8.4.4")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-user-messaging-platform", .upToNextMinor(from: "3.1.0")),
    ],
    targets: [
        .target(
            name: "YandexMobileAdsWrapper",
            dependencies: [
                .target(name: "YandexMobileAds"),
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaIDSync", package: "appmetrica-sdk-ios"),
                .product(name: "DivKitBinaryCompatibilityFacade", package: "divkit-ios-facade")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "YandexMobileAdsInstreamWrapper",
            dependencies: [
                .target(name: "YandexMobileAdsInstream"),
                .target(name: "YandexMobileAdsWrapper")
            ]
        ),
        .target(
            name: "YandexMobileAdsConsentManagementWrapper",
            dependencies: [
                .target(name: "YandexMobileAdsConsentManagement"),
                .target(name: "YandexMobileAdsWrapper"),
                .product(name: "GoogleUserMessagingPlatform", package: "swift-package-manager-google-user-messaging-platform"),
            ]
        ),
        .target(
            name: "YandexMobileAdsAdMobAdaptersWrapper",
            dependencies: [
                .target(name: "YandexMobileAdsAdMobAdapters"),
                .target(name: "YandexMobileAdsWrapper"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ]
        ),
        .target(
            name: "GoogleYandexMobileAdsAdaptersWrapper",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .target(name: "GoogleYandexMobileAdsAdapters"),
                .target(name: "YandexMobileAdsWrapper")
            ]
        ),
        .target(
            name: "VungleYandexMobileAdsAdaptersWrapper",
            dependencies: [
                .product(name: "VungleAdsSDK", package: "VungleAdsSDK-SwiftPackageManager"),
                .target(name: "VungleYandexMobileAdsAdapters"),
                .target(name: "YandexMobileAdsWrapper")
            ]
        ),
        .target(
            name: "AppLovinYandexMobileAdsAdaptersWrapper",
            dependencies: [
                .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package"),
                .target(name: "AppLovinYandexMobileAdsAdapters"),
                .target(name: "YandexMobileAdsWrapper")
            ]
        ),
        .target(
            name: "MyTargetYandexMobileAdsAdaptersWrapper",
            dependencies: [
                .product(name: "MyTargetSDK", package: "mytarget-ios-spm"),
                .target(name: "MyTargetYandexMobileAdsAdapters"),
                .target(name: "YandexMobileAdsWrapper")
            ]
        ),
        .target(
            name: "MintegralYandexMobileAdsAdaptersWrapper",
            dependencies: [
                .product(name: "MintegralAdSDK", package: "MintegralAdSDK-Swift-Package"),
                .target(name: "MintegralYandexMobileAdsAdapters"),
                .target(name: "YandexMobileAdsWrapper")
            ]
        ),
        .target(
            name: "DigitalTurbineYandexMobileAdsAdaptersWrapper",
            dependencies: [
                .product(name: "DTExchangeSDK", package: "DTExchangeSDK-iOS-SPM"),
                .target(name: "DigitalTurbineYandexMobileAdsAdapters"),
                .target(name: "YandexMobileAdsWrapper")
            ]
        ),
        .binaryTarget(
            name: "YandexMobileAds",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/8.0.0/spm/4db9e6d3-88e5-41cc-8e8d-fde2c442ef3b.zip",
            checksum: "217d43975aeed75df75ff006c721971a4feaf665cab4690e39e44c615f2ac1b7"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsInstream/0.70.0/spm/d4272285-3f5a-4f30-af9b-002857cfbee5.zip",
            checksum: "154671aa183554cd571d404de0986a611146a84520bab7e8a2a73541d29a721a"
        ),
        .binaryTarget(
            name: "YandexMobileAdsConsentManagement",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsConsentManagement/1.14.0/spm/a1db19a7-aed5-446a-ab27-bd59664b0da3.zip",
            checksum: "ab62f7cb3faf059bf75aae8a4e571983963d1f735f95b6be0e0ca96bb9ec7ad7"
        ),
        .binaryTarget(
            name: "YandexMobileAdsAdMobAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsAdMobAdapters/8.0.0.0/spm/c35985ba-96e6-4edc-9087-a7c5540f54c6.zip",
            checksum: "be2f9f56109e3eb8d8916ef32af34e511e6fc163ecbd1f106494ab5393071b0f"
        ),
        .binaryTarget(
            name: "GoogleYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/GoogleYandexMobileAdsAdapters/12.14.0.0/spm/5ce37a6b-432c-40d4-a1a4-c140627c6d46.zip",
            checksum: "82d66afd729ca91e340898e16c21ec86eccf57bd99dc3f7f6b0baa9c63c8f126"
        ),
        .binaryTarget(
            name: "VungleYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/VungleYandexMobileAdsAdapters/7.7.0.0/spm/a007f021-a945-40c8-a9c3-70e6ef0274c2.zip",
            checksum: "9f1ac52ad4bf96c39bc23528007f96be81d11abfece7a57c63f1d3e6f32cc57a"
        ),
        .binaryTarget(
            name: "AppLovinYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/AppLovinYandexMobileAdsAdapters/13.5.1.0/spm/d8940d1d-6abf-4198-953f-06d7d387c88c.zip",
            checksum: "9de021462166244093bccbda8c4f3029a009b8c9d4d1fd17a9cf45afa76478b5"
        ),
        .binaryTarget(
            name: "MyTargetYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/MyTargetYandexMobileAdsAdapters/5.36.2.0/spm/17610a6f-570a-4990-ae7b-d10c70319a06.zip",
            checksum: "13f1eba3a574c4b4d6e29a1c43936223bf762ad1d0da0d8afbf1f06231f1cca6"
        ),
        .binaryTarget(
            name: "MintegralYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/MintegralYandexMobileAdsAdapters/8.0.7.0/spm/7e440a44-8ff8-4447-8b62-d936b4c1c43f.zip",
            checksum: "61b06a52e239090cc874587ac7c9c5311925b9e3ba4e53e36559f250b2b250a7"
        ),
        .binaryTarget(
            name: "DigitalTurbineYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/DigitalTurbineYandexMobileAdsAdapters/8.4.4.0/spm/4aafdb52-6345-4875-beea-06c71802c454.zip",
            checksum: "e836a285cdf7f8ba57119a7cd6376c38014c2a4d1f00753f79e387f3498b4369"
        ),
        .binaryTarget(
            name: "YandexMobileAdsMediation",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsMediation/8.0.0/spm/1494c197-6bf2-487a-995d-c60aa3072a28.zip",
            checksum: "76d5da96c15cfda8e72463bbd0250213b603971d3346a5060b1db9f23fc104dd"
        )
    ]
)
