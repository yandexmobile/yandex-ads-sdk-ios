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
            name: "YandexMobileAdsMediation",
            targets: [
                "YandexMobileAdsMediation",
                "GoogleYandexMobileAdsAdaptersWrapper",
                "VungleYandexMobileAdsAdaptersWrapper",
                "AppLovinYandexMobileAdsAdaptersWrapper",
                "MyTargetYandexMobileAdsAdaptersWrapper",
                "MintegralYandexMobileAdsAdaptersWrapper"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMinor(from: "5.14.0")),
        .package(url: "https://github.com/divkit/divkit-ios-facade", .upToNextMinor(from: "5.2.1")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", .upToNextMinor(from: "12.2.0")),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", .upToNextMinor(from: "7.4.2")),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", .upToNextMinor(from: "13.3.1")),
        .package(url: "https://github.com/myTargetSDK/mytarget-ios-spm", .upToNextMinor(from: "5.28.0")),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", .upToNextMinor(from: "7.7.9"))
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
        .binaryTarget(
            name: "YandexMobileAds",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/7.18.2/spm/149ea65a-64e9-4d71-b6f8-95c67e14b7dd.zip",
            checksum: "94db7b5294c80219b8c5d3b0c0833ee6f63f718fe77bb86549675c7d78e23637"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsInstream/0.63.1/spm/4df8681a-7feb-4587-9d9e-7f5b2164e29e.zip",
            checksum: "fdc7a7b1faf8d3dd702cece7e96b281a1ac00a7a03050f58851ee3e2f56a1b79"
        ),
        .binaryTarget(
            name: "GoogleYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/GoogleYandexMobileAdsAdapters/12.2.0.9/spm/d4a877b2-c216-4d9c-929b-ae89af896552.zip",
            checksum: "716cb73305e9281e96229289941d25163494739a80ea094f62af325b1c9394f3"
        ),
        .binaryTarget(
            name: "VungleYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/VungleYandexMobileAdsAdapters/7.4.2.15/spm/12841e21-4a2f-4691-9883-6e85cee78929.zip",
            checksum: "7d9fcade278ac4758dd05712ffc5f11db1150ac79931838b49b0628d2812e5fd"
        ),
        .binaryTarget(
            name: "AppLovinYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/AppLovinYandexMobileAdsAdapters/13.3.1.4/spm/2d4a5f73-cd96-4a09-b5b8-d590592442d8.zip",
            checksum: "4825bc1bc921fa5152dba5277a2c4cc1c9ee9a77a97519e8a5caf9448cd0ef0d"
        ),
        .binaryTarget(
            name: "MyTargetYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/MyTargetYandexMobileAdsAdapters/5.28.0.9/spm/c96eb5a6-2221-426f-a512-1db1770686df.zip",
            checksum: "ea9fdad3230f864c9d093a7e15ef3bf5396f1740e97561c5d2201f7ef8f76a44"
        ),
        .binaryTarget(
            name: "MintegralYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/MintegralYandexMobileAdsAdapters/7.7.9.4/spm/e4c58f27-cc23-4c59-83e0-7ec717145edb.zip",
            checksum: "770f8a2d7e4bc2e64e8b3dac4cc3b5e9e08158fdfde3cfef6c35ac32d93264bc"
        ),
        .binaryTarget(
            name: "YandexMobileAdsMediation",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsMediation/7.18.2/spm/157acfe7-08f6-4bd9-aa14-89e17e5594de.zip",
            checksum: "825fc1995fed7fda5394813623539f6f43c338dfaf2b94012790a414ca1eeaaa"
        )
    ]
)
