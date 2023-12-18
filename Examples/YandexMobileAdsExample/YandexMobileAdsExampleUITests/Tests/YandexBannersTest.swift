import XCTest

final class YandexBannersTest: BaseTest {
    let bannerPage = YandexBannerPage()
    
    func testStickyBanner() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openStickyBanner()
        bannerPage.tapLoadAd()
        try assertAdLoaded(stateLabel: bannerPage.stateLabel)
        bannerPage.assertAdDisplayed()
        bannerPage.tapAd()
        assertSafariOpened()
    }
    
    func testInlineBanner() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openInlineBanner()
        bannerPage.tapLoadAd()
        try assertAdLoaded(stateLabel: bannerPage.stateLabel)
        bannerPage.assertAdDisplayed()
        bannerPage.tapAd()
        assertSafariOpened()
    }
}
