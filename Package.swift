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
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMajor(from: "7.0.0")),
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
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/8.7.0/spm/12b2c971-1eb7-4b7a-8305-165beb97398f.zip",
            checksum: "0c5e8768092aabd57fc9ede78d265050a142c21f646b46280163b3d7011601a4"
        ),
        .binaryTarget(
            name: "YandexMobileAdsNativeOnly",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsNativeOnly/8.7.0/spm/34a4ce9c-dd2c-482d-9b27-37c30032544f.zip",
            checksum: "117338f208f635ecfa7c1741accb5f97ee983b7ed14059b1c3689d22e8814caa"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsInstream/0.78.0/spm/86a6ea5d-d9b2-4a0b-ac15-bf86c8c0f4d0.zip",
            checksum: "693413bef1bd98893791c9315016a5a2a52b2628c5439b264aa1deaa5303d9f5"
        ),
        .binaryTarget(
            name: "YandexMobileAdsFeed",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsFeed/8.7.0/spm/e654d048-382f-4807-8c98-3e54fe96b5e1.zip",
            checksum: "10bf6cee42d1abb07e18266435d3b0ea9aa0d66199094ed85b6ee6bdf8753a79"
        ),
        .binaryTarget(
            name: "YandexMobileAdsConsentManagement",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsConsentManagement/1.21.0/spm/780a4f72-25e2-4567-a55d-b9f4fa482c87.zip",
            checksum: "95fe8a84c7907f75ba84c655f56ec0370009110cd1c13bee8afebfe582ea9d14"
        )
    ]
)
