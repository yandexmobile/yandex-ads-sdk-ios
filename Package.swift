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
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/8.4.0/spm/f5b71cd7-b790-4c34-af37-035aa0e4c976.zip",
            checksum: "1897c7ec529511e1f60c6f0f106a33c894207feee93608afa4330436984c681e"
        ),
        .binaryTarget(
            name: "YandexMobileAdsNativeOnly",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsNativeOnly/8.4.0/spm/94c1f381-88e5-4bbe-ab11-9d073ba8cf3a.zip",
            checksum: "3697a5f821a02c3908a1b6a1d7856acd279e46a340630234f45a26888e236912"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsInstream/0.75.0/spm/e1fd0f7d-4040-4eb5-92c7-49a4fd315906.zip",
            checksum: "2834ede0026d07442d4e9646e33966757d6b280449084cbc46e1058afb46671a"
        ),
        .binaryTarget(
            name: "YandexMobileAdsFeed",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsFeed/8.4.0/spm/83c26077-fc2c-48e2-a4a1-cb73c11422d0.zip",
            checksum: "300ea3b27c95207cfbfff1f74b430bd47cebfa0724f726d51e6f86f69c63b849"
        ),
        .binaryTarget(
            name: "YandexMobileAdsConsentManagement",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsConsentManagement/1.18.0/spm/b8fd7968-c6a7-4608-a4a8-c06686bf6e48.zip",
            checksum: "05eac3039a875f18a20119625d1210f7e3c30e0f5ab8aeee01baa9b44860dc1c"
        )
    ]
)
