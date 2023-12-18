import XCTest

final class YandexAppOpenAdTest: BaseTest {
    let page = YandexAppOpenAdPage()
    
    func testAppOpenAd() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openAppOpenAd()
        page.tapLoadAd()
        try assertAdLoaded(stateLabel: page.stateLabel)
        leaveApp()
        returnToApp()
        page.assertAdDisplayed()
        page.tapAd()
        assertSafariOpened()
    }
}
