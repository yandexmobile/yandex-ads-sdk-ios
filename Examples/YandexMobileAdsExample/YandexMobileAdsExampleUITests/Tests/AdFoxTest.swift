import XCTest

final class AdFoxTest: BaseTest {
    let adFoxPage = AdFoxPage()
    let adPage = AdFoxAdPage()
    
    func testBanner() throws {
        launchApp()
        rootPage.openAdFox()
        adFoxPage.openBanner()
        adPage.tapLoadAd()
        try assertAdLoaded(stateLabel: adPage.stateLabel)
        adPage.assertAdDisplayed()
        adPage.tapAd()
        assertSafariOpened()
    }
    
    func testNative() throws {
        launchApp()
        rootPage.openAdFox()
        adFoxPage.openNative()
        adPage.tapLoadAd()
        try assertAdLoaded(stateLabel: adPage.stateLabel)
        adPage.assertAdDisplayed()
        adPage.tapAd()
        assertSafariOpened()
    }
    
    func testInterstitial() throws {
        launchApp()
        rootPage.openAdFox()
        adFoxPage.openInterstitial()
        adPage.tapLoadAd()
        try assertAdLoaded(stateLabel: adPage.stateLabel)
        adPage.tapPresentAd()
        adPage.assertAdDisplayed()
        adPage.tapAd()
        assertSafariOpened()
    }
}
