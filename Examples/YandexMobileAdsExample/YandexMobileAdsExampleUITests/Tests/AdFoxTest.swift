/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

final class AdFoxTest: BaseTest {
    private let adsPage = UnifiedAdsPage()

    func testAdFoxBannerSticky() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.bannerSticky)
        adsPage.selectSource(TestConstants.Source.adFox)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        adsPage.tapInlineAdAndOpenSafari()
    }

    func testAdFoxNativeTemplate() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.nativeTemplate)
        adsPage.selectSource(TestConstants.Source.adFox)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        adsPage.tapInlineAdAndOpenSafari()
    }

    func testAdFoxInterstitial() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.interstitial)
        adsPage.selectSource(TestConstants.Source.adFox)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitPresentEnabled(timeout: 10)
        adsPage.tapPresent()
    }
}
