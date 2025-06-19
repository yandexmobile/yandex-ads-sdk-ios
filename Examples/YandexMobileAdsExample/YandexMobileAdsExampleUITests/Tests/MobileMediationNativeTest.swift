import XCTest

final class MobileMediationNativeTest: BaseTest {
    let mobileMediationPage = MobileMediationPage()
    let adPage = MobileMediationAdPage()
    
    func testAdMobNative() throws {
        try test(adapter: .adMob)
    }
    
    func testMyTargetNative() throws {
        try test(adapter: .myTarget)
    }
    
    func testYandexNative() throws {
        try test(adapter: .yandex)
    }
    
    private func test(adapter: Adapter) throws {
        launchApp()
        rootPage.openMobileMediation()
        mobileMediationPage.openNative()
        adPage.selectAdapter(adapter)
        adPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: adPage.stateLabel) else { return }
        adPage.assertAdDisplayed()
    }
}
