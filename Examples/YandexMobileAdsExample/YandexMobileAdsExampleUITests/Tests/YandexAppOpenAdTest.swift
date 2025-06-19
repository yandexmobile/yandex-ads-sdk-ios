import XCTest

final class YandexAppOpenAdTest: BaseTest {
    let page = YandexAppOpenAdPage()
    
    func testAppOpenAd() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openAppOpenAd()
        page.tapLoadAd()
        guard assertAdLoaded(stateLabel: page.stateLabel) else { return }
        leaveApp()
        returnToApp()
        page.assertAdDisplayed()
        page.tapAd()
        assertSafariOpened()
    }
}
