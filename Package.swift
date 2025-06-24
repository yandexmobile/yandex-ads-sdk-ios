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
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", "5.11.0"..<"6.0.0"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", exact: "5.0.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", .upToNextMinor(from: "12.2.0")),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", .upToNextMinor(from: "7.4.2")),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", .upToNextMinor(from: "13.1.0")),
        .package(url: "https://github.com/myTargetSDK/mytarget-ios-spm", .upToNextMinor(from: "5.28.0")),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", .upToNextMinor(from: "7.7.7"))
    ],
    targets: [
        .target(
            name: "YandexMobileAdsWrapper",
            dependencies: [
                .target(name: "YandexMobileAds"),
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "DivKitBinaryCompatibilityFacade", package: "divkit-ios-facade")
            ],
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("AdSupport"),
                .linkedFramework("AppTrackingTransparency"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreImage"),
                .linkedFramework("CoreLocation"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("CoreText"),
                .linkedFramework("Foundation"),
                .linkedFramework("Network"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("StoreKit"),
                .linkedFramework("SwiftUI"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("UIKit"),
                .linkedFramework("WebKit")
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
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/7.14.2/spm/2f6af0c0-3b3e-4f26-aa10-ddf525273c10.zip",
            checksum: "a81009142a5e7129fc461215847044d052a35c404a8488d01691e0d0d848ec91"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/YandexMobileAdsInstream/0.54.1/spm/4075bc43-cb2c-4451-a6c5-6663132459b3.zip",
            checksum: "399681b31ad1b9b45864743e8c5104b7397e7a9df0be2b1c4be548f2751526b4"
        ),
        .binaryTarget(
            name: "GoogleYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/GoogleYandexMobileAdsAdapters/12.2.0.4/spm/65449c78-1ecc-48dd-ae84-51e94ae81eb9.zip",
            checksum: "ac95bd5e02eb2f8ec81241a097bd5e244bb7f21e86ab0f7a2cd50df6811b5381"
        ),
        .binaryTarget(
            name: "VungleYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/VungleYandexMobileAdsAdapters/7.4.2.10/spm/0ef6ce04-59e1-4f75-8e1e-422ecb9ea7c1.zip",
            checksum: "9572a61a3d37d306a71eeb53f85b12c2dffae71b07933722ff100dd96661525c"
        ),
        .binaryTarget(
            name: "AppLovinYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/AppLovinYandexMobileAdsAdapters/13.1.0.4/spm/c0a13c8f-0908-4701-ac70-b52ffb25092c.zip",
            checksum: "217b0567f5e4a93a4771c810796aa7fcd284235e27f07ff2493a851160f09de3"
        ),
        .binaryTarget(
            name: "MyTargetYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/MyTargetYandexMobileAdsAdapters/5.28.0.4/spm/8d9febce-9b7e-459f-8f83-f61dda373775.zip",
            checksum: "ef0a8921b6840ff168b23aa6ea633f650b90da33c8abebecff458725e57d3ec3"
        ),
        .binaryTarget(
            name: "MintegralYandexMobileAdsAdapters",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/MintegralYandexMobileAdsAdapters/7.7.7.4/spm/8cd832d1-0b91-416f-af8e-aeb9e28f6b56.zip",
            checksum: "e53080576f7e1f5b430928e787335adbbada11e17de55078d8054a9dfa1d0823"
        ),
        .binaryTarget(
            name: "YandexMobileAdsMediation",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsMediation/7.14.2/spm/289a76d1-03a5-465c-b81d-5b756c72bb26.zip",
            checksum: "39eec27e68cde283669413c45a3dea1162402e572f55d862b4b8c16aad69a7e6"
        )
    ]
)
