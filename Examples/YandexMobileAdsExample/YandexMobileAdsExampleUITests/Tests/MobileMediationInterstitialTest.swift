/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

final class MobileMediationInterstitialTest: BaseTest {
    let mobileMediationPage = MobileMediationPage()
    let adPage = MobileMediationAdPage()
        
    func testAppLovinInterstitial() throws {
        try test(adapter: .appLovin)
    }
    
    func testBigoAdsInterstitial() throws {
        try test(adapter: .bigoAds)
    }
    
    func testChartboostInterstitial() throws {
        try test(adapter: .chartboost)
    }
    
    func testAdMobInterstitial() throws {
        try test(adapter: .adMob)
    }
    
    func testInMobiInterstitial() throws {
        try test(adapter: .inMobi)
    }
    
    func testIronSourceInterstitial() throws {
        try test(adapter: .ironSource)
    }
    
    func testMintegralInterstitial() throws {
        try test(adapter: .mintegral)
    }
    
    func testMyTargetInterstitial() throws {
        try test(adapter: .myTarget)
    }
    
    func testStartAppInterstitial() throws {
        try test(adapter: .startApp)
    }
    
    func testUnityAdsInterstitial() throws {
        try test(adapter: .unityAds)
    }
    
    func testYandexInterstitial() throws {
        try test(adapter: .yandex)
    }
        
    private func test(adapter: Adapter) throws {
        launchApp()
        rootPage.openMobileMediation()
        mobileMediationPage.openInterstitial()
        adPage.selectAdapter(adapter)
        adPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: adPage.stateLabel) else { return }
        adPage.tapPresentAd()
    }
}
