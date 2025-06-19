import XCTest

final class YandexFullscreenTest: BaseTest {
    let fullscreenPage = YandexFullscreenAdPage()
    func testInterstitial() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openInterstitial()
        fullscreenPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: fullscreenPage.stateLabel) else { return }
        fullscreenPage.tapPresentAd()
        fullscreenPage.assertAdDisplayed()
        step("Tap ad") {
            fullscreenPage.adView.staticTexts["mac_call_to_action"].tap()
        }
        assertSafariOpened()
    }    
        
    func testRewarded() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openRewarded()
        fullscreenPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: fullscreenPage.stateLabel) else { return }
        fullscreenPage.tapPresentAd()
        fullscreenPage.assertAdDisplayed()
        step("Tap ad") {
            fullscreenPage.adView.staticTexts["Подробнее ➔"].tap()
        }
        assertSafariOpened()
    }
}
