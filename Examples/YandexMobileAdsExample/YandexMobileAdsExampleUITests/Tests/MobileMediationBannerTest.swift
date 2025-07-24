/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

final class MobileMediationBannerTest: BaseTest {
    let mobileMediationPage = MobileMediationPage()
    let adPage = MobileMediationAdPage()
            
    func testBigoAdsBanner() throws {
        try test(adapter: .bigoAds)
    }
    
    func testChartboostBanner() throws {
        try test(adapter: .chartboost)
    }
    
    func testAdMobBanner() throws {
        try test(adapter: .adMob)
    }
    
    func testInMobiBanner() throws {
        try test(adapter: .inMobi)
    }
    
    func testMintegralBanner() throws {
        try test(adapter: .mintegral)
    }
    
    func testMyTargetBanner() throws {
        try test(adapter: .myTarget)
    }
    
    func testIronSourceBanner() throws {
        try test(adapter: .ironSource)
    }
    
    func testStartAppBanner() throws {
        try test(adapter: .startApp)
    }
    
    func testYandexBanner() throws {
        try test(adapter: .yandex)
    }
    
    private func test(adapter: Adapter) throws {
        launchApp()
        rootPage.openMobileMediation()
        mobileMediationPage.openBanner()
        adPage.selectAdapter(adapter)
        adPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: adPage.stateLabel) else { return }
        adPage.assertAdDisplayed()
    }
}
