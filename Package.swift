// swift-tools-version: 5.9;
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YandexMobileAdsPackage",
    platforms: [
        .iOS("15.0")
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
            name: "YandexMobileAdsFeed",
            targets: ["YandexMobileAdsFeedWrapper"]
        ),
        .library(
            name: "YandexMobileAdsConsentManagement",
            targets: ["YandexMobileAdsConsentManagementWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMajor(from: "6.6.0")),
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
            name: "YandexMobileAdsFeedWrapper",
            dependencies: [
                .target(name: "YandexMobileAdsFeed"),
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
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/8.5.0/spm/cf32972a-801f-4ff5-85ab-79106e4828ff.zip",
            checksum: "d82ccf39c92b3aab3e2780be83705d260f2c8febc184e86294ab3ef0852c4d6c"
        ),
        .binaryTarget(
            name: "YandexMobileAdsNativeOnly",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsNativeOnly/8.5.0/spm/15131f93-5a96-4928-8cd5-fbab4748d878.zip",
            checksum: "56cc5c4a702a928d8426e8f7d399abd91d1c895cd2b25715116684d4c16eda80"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsInstream/0.76.0/spm/cde2a126-8c95-4780-a58f-13f7b479ea82.zip",
            checksum: "8adba0d5337783def00836464eb38589fbd00d0b9a6fe61b3b08ec63fdca0902"
        ),
        .binaryTarget(
            name: "YandexMobileAdsFeed",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsFeed/8.5.0/spm/6463a543-a2ce-48df-83ce-80f71632911a.zip",
            checksum: "955293b64d31c6cd6dab9d3116e15ed1bd5afd0c2503f8284b4966cb42c3d79f"
        ),
        .binaryTarget(
            name: "YandexMobileAdsConsentManagement",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsConsentManagement/1.19.0/spm/8908643d-491e-4694-93c9-de654d9225e6.zip",
            checksum: "013c3a23f20632955dd531514aad9c01be5708da42cdb1c244a32f4136769584"
        )
    ]
)
