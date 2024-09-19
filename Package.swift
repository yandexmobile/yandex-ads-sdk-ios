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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", "5.0.0"..<"6.0.0"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", exact: "4.4.0")
    ],
    targets: [
        .target(
            name: "YandexMobileAdsWrapper",
            dependencies: [
                .target(name: "YandexMobileAds"),
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
                .product(name: "DivKitBinaryCompatibilityFacade", package: "divkit-ios-facade")
            ],
            resources: [
                .copy("Resources/MobileAdsBundle.bundle")
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
        .binaryTarget(
            name: "YandexMobileAds",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/7.5.1/spm/4a56589f-a349-4b97-8ad9-b55ca53d701a.zip",
            checksum: "fed3e215b5195b23c5efe51c9365e6d991134de46477cf56b99f9f73f8cf9ae5"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/YandexMobileAdsInstream/0.38.0/spm/853482e9-2c6c-4ead-bd74-a7de3fef28c6.zip",
            checksum: "21771a99edd363885ee4b7f02a2746c2bc717f6bba2118f69fcfd6117bb3bb45"
        )
    ]
)