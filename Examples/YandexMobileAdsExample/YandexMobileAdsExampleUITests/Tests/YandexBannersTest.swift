import XCTest

final class YandexBannersTest: BaseTest {
    let bannerPage = YandexBannerPage()
    
    func testStickyBanner() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openStickyBanner()
        bannerPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: bannerPage.stateLabel) else { return }
        bannerPage.assertAdDisplayed()
        bannerPage.tapAd()
        assertSafariOpened()
    }
    
    func testInlineBanner() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openInlineBanner()
        bannerPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: bannerPage.stateLabel) else { return }
        bannerPage.assertAdDisplayed()
        bannerPage.tapAd()
        assertSafariOpened()
    }
}
