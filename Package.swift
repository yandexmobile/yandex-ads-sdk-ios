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
            name: "YandexMobileAdsNativeOnly",
            targets: ["YandexMobileAdsNativeOnlyWrapper"]
        ),
        .library(
            name: "YandexMobileAdsInstream",
            targets: ["YandexMobileAdsInstreamWrapper"]
        ),
        .library(
            name: "YandexMobileAdsConsentManagement",
            targets: ["YandexMobileAdsConsentManagementWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMinor(from: "6.5.0")),
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
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "YandexMobileAdsNativeOnlyWrapper",
            dependencies: [
                .target(name: "YandexMobileAdsNativeOnly"),
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaIDSync", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
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
        .binaryTarget(
            name: "YandexMobileAds",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/8.3.0/spm/231325b0-75ef-4ea2-b071-e05e10b768e6.zip",
            checksum: "b75cf204e970e354705b90883a98130b4147c7572bcdce616a57c0e5a6353931"
        ),
        .binaryTarget(
            name: "YandexMobileAdsNativeOnly",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsNativeOnly/8.3.0/spm/b145864e-3156-484c-bec5-15aa614c5f85.zip",
            checksum: "0df548cac0e05e0b5138c14319e55fa90fcfd4f5c9625819aa7527877733dfd5"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsInstream/0.74.0/spm/69929577-6c94-47d7-ba74-cb48caae917d.zip",
            checksum: "d5bf7a6fc5e2dfb3654cbb7f2fa5ae95b4867329db4401917207e4d355b2c890"
        ),
        .binaryTarget(
            name: "YandexMobileAdsConsentManagement",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsConsentManagement/1.17.0/spm/80cfacbc-9d1a-420a-ab69-e90d07a41fc2.zip",
            checksum: "8b0ed0845778602f0a15f784cbf01dd8356c80bf5f014e930f1a08f6f1c77807"
        )
    ]
)
