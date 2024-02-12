import XCTest

final class MobileMediationRewardedTest: BaseTest {
    let mobileMediationPage = MobileMediationPage()
    let adPage = MobileMediationAdPage()
    
    func testAdColonyRewarded() throws {
        try test(adapter: .adColony)
    }
    
    func testAppLovinRewarded() throws {
        try test(adapter: .appLovin)
    }
    
    func testBigoAdsRewarded() throws {
        try test(adapter: .bigoAds)
    }
    
    func testChartboostRewarded() throws {
        try test(adapter: .chartboost)
    }
    
    func testAdMobRewarded() throws {
        try test(adapter: .adMob)
    }
    
    func testInMobiRewarded() throws {
        try test(adapter: .inMobi)
    }
    
    func testIronSourceRewarded() throws {
        try test(adapter: .ironSource)
    }
    
//    func testMintegralRewarded() throws {
//        try test(adapter: .mintegral)
//     }
    
    func testMyTargetRewarded() throws {
        try test(adapter: .myTarget)
    }
    
    func testStartAppRewarded() throws {
        try test(adapter: .startApp)
    }
    
    func testUnityAdsRewarded() throws {
        try test(adapter: .unityAds)
    }
    
    func testYandexRewarded() throws {
        try test(adapter: .yandex)
    }
    
    private func test(adapter: Adapter) throws {
        launchApp()
        rootPage.openMobileMediation()
        mobileMediationPage.openRewarded()
        adPage.selectAdapter(adapter)
        adPage.tapLoadAd()
        try assertAdLoaded(stateLabel: adPage.stateLabel)
        adPage.tapPresentAd()
    }
}
