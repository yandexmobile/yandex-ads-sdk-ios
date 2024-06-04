import XCTest

final class YandexFullscreenTest: BaseTest {
    let fullscreenPage = YandexFullscreenAdPage()
    func testInterstitial() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openInterstitial()
        fullscreenPage.tapLoadAd()
        try assertAdLoaded(stateLabel: fullscreenPage.stateLabel)
        fullscreenPage.tapPresentAd()
        fullscreenPage.assertAdDisplayed()
        tapAd()
        assertSafariOpened()
    }    
        
    func testRewarded() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openRewarded()
        fullscreenPage.tapLoadAd()
        try assertAdLoaded(stateLabel: fullscreenPage.stateLabel)
        fullscreenPage.tapPresentAd()
        fullscreenPage.assertAdDisplayed()
        tapAd()
        assertSafariOpened()
    }
    
    func tapAd() {
        step("Tap ad") {
            fullscreenPage.adView.buttons.allElementsBoundByIndex.max { $0.frame.maxY < $1.frame.maxY }!.tap()
        }
    }
}

