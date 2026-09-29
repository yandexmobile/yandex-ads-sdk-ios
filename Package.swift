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
            name: "YandexMobileAdsOfferwall",
            targets: ["YandexMobileAdsOfferwallWrapper"]
        ),
        .library(
            name: "YandexMobileAdsConsentManagement",
            targets: ["YandexMobileAdsConsentManagementWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMajor(from: "6.7.0")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-user-messaging-platform", .upToNextMinor(from: "3.1.0")),
        .package(url: "https://github.com/Tapjoy/swift-packages", .upToNextMinor(from: "14.8.0")),
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
            name: "YandexMobileAdsOfferwallWrapper",
            dependencies: [
                .target(name: "YandexMobileAdsOfferwall"),
                .target(name: "YandexMobileAdsWrapper"),
                .product(name: "Tapjoy", package: "swift-packages"),
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
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/8.6.0/spm/758902f4-6c68-4d3c-8f61-b3866cf27370.zip",
            checksum: "b7d11b81a53ff90677ad98808a2cce781eb850064c50e380d01825c7610e0892"
        ),
        .binaryTarget(
            name: "YandexMobileAdsNativeOnly",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsNativeOnly/8.6.0/spm/95a5dc6f-16f9-45b3-991b-8a588550166d.zip",
            checksum: "480b25e70bd14a7809ac7aed229e8769f95a78edabd7c2d0efcfc173a3bdc094"
        ),
        .binaryTarget(
            name: "YandexMobileAdsInstream",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsInstream/0.77.0/spm/c2fb0b73-9b9a-46f2-899a-9e616afbed19.zip",
            checksum: "8be5bb70c109187e02638d0084377ffa894abcd5fd6b01aa3f1c16c74a36259b"
        ),
        .binaryTarget(
            name: "YandexMobileAdsFeed",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsFeed/8.6.0/spm/d2912c2b-3de5-4923-baab-1e7cd4119f7d.zip",
            checksum: "abc3b5749a4c39ab3e341e6b477fe69ac99336710e493e4273cccbd9f2e856a8"
        ),
        .binaryTarget(
            name: "YandexMobileAdsOfferwall",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsOfferwall/8.6.0/spm/0aa611e5-875b-4d17-8be4-dd4bd9531f82.zip",
            checksum: "bcc554163cb729b77f3e2e67694af62666131c34e12a465babacdf960561c356"
        ),
        .binaryTarget(
            name: "YandexMobileAdsConsentManagement",
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAdsConsentManagement/1.20.0/spm/8f0b5264-831c-4da6-92a9-e8ca45812ade.zip",
            checksum: "a934242e12617c55b2054ab2c2e1c28994ade8748e1c07aaeb61b57eaaea5209"
        )
    ]
)
