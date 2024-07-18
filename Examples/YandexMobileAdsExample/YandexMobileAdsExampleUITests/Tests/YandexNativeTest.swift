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
        try assertAdLoaded(stateLabel: nativePage.stateLabel)
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
        try assertAdLoaded(stateLabel: nativePage.stateLabel)
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
        try assertAdLoaded(stateLabel: nativePage.stateLabel)
        nativePage.assertAdsDisplayed()
        nativePage.tapBulkAd()
        assertSafariOpened()
    }
}
