/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

final class BannerTest: BaseTest {
    private let adsPage = UnifiedAdsPage()

    func testBigoAdsBanner() {
        runBannerTest(source: TestConstants.Source.bigoAds)
    }

    func testChartboostBanner() {
        runBannerTest(source: TestConstants.Source.chartboost)
    }

    func testAdMobBanner() {
        runBannerTest(source: TestConstants.Source.adMob)
    }

    func testInMobiBanner() {
        runBannerTest(source: TestConstants.Source.inMobi)
    }

    func testIronSourceBanner() {
        runBannerTest(source: TestConstants.Source.ironSource)
    }

    func testMintegralBanner() {
        runBannerTest(source: TestConstants.Source.mintegral)
    }

    func testMyTargetBanner() {
        runBannerTest(source: TestConstants.Source.myTarget)
    }

    func testYandexBanner() {
        runBannerTest(source: TestConstants.Source.yandex)
    }

    // MARK: - Common logic

    private func runBannerTest(source: String) {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.banner)
        adsPage.selectSource(source)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill() else { return }
        adsPage.tapInlineAd()
    }
}
