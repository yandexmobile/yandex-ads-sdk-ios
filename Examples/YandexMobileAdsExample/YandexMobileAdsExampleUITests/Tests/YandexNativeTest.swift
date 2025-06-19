import XCTest

final class YandexNativeTest: BaseTest {
    let nativePage = YandexNativeAdPage()
    let nativeListPage = YandexNativePage()
    
    func testNativeCustom() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openNative()
        nativeListPage.openCustom()
        nativePage.tapLoadAd()
        guard assertAdLoaded(stateLabel: nativePage.stateLabel) else { return }
        nativePage.assertAdDisplayed()
        nativePage.tapAd()
        assertSafariOpened()
    }
    
    func testNativeTemplate() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openNative()
        nativeListPage.openTemplate()
        nativePage.tapLoadAd()
        guard assertAdLoaded(stateLabel: nativePage.stateLabel) else { return }
        nativePage.assertAdDisplayed()
        nativePage.tapAd()
        assertSafariOpened()
    }
    
    func testNativeBulkTemplate() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openNative()
        nativeListPage.openBulk()
        nativePage.tapLoadAd()
        guard assertAdLoaded(stateLabel: nativePage.stateLabel) else { return }
        nativePage.assertAdsDisplayed()
        nativePage.tapBulkAd()
        assertSafariOpened()
    }
}
