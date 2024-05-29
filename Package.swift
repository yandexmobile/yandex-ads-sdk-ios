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
            name: "YandexMobileAdsPackage",
            targets: ["YandexMobileAdsTarget"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", "5.0.0"..<"6.0.0"),
        .package(url: "https://github.com/divkit/divkit-ios", exact: "28.13.0")
    ],
    targets: [
        .target(
            name: "YandexMobileAdsTarget",
            dependencies: [
                .target(name: "YandexMobileAdsInstream"),
                .target(name: "YandexMobileAds"),
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
                .product(name: "DivKit", package: "divkit-ios")
            ],
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("AdSupport"),
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
                .linkedFramework("WebKit"),
                .linkedFramework("WebKit")
            ]
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/YandexMobileAdsInstream/0.28.0/spm/fc6be323-67a6-4169-828f-f11bdfbe0bb1.zip",
            checksum: "533b6671f73b78dd890ae1552c5ece64d74074d26ef8e06dc31c77e49224eadb"
        ),
        .binaryTarget(
            name: "YandexMobileAds",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/7.0.2/spm/88d8696c-6770-4abf-bf65-fe3eec6bb64d.zip",
            checksum: "1f51a72707f535c7fdb732701322a7fbe86dd23a72e25e7989d6d835e4782113"
        )
    ]
)