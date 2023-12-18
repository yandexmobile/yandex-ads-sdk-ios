import XCTest

final class YandexInstreamTest: BaseTest {
    let page = YandexInstreamPage()
    let list = YandexInstreamListPage()
    
    func testSingleInstream() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openInstream()
        list.openSingleInstream()
        
        page.tapLoadAd()
        try assertAdLoaded(stateLabel: page.stateLabel)
        
        page.tapPrepareAd()
        page.tapPresentAd()
            
        let skipButton = page.skipButton
        let numberOfAds = 5
        
        for index in 0..<numberOfAds {
            step("Ad \(index)") {
                XCTAssertTrue(elementMatches(skipButton, query: Query.exists, timeout: 60), "Skip exists")
                page.tapGo()
                assertSafariOpened()
                returnToApp()
                XCTAssertTrue(elementMatches(skipButton, query: Query.exists, timeout: 30), "Skip exists")
                page.tapSkip()
                XCTAssertTrue(elementMatches(skipButton, query: Query.notExists, timeout: 30), "Skip not exists")
            }
        }
    }
    
    func testInroll() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openInstream()
        list.openInroll()
        
        page.tapLoadAd()
        try assertAdLoaded(stateLabel: page.stateLabel)
        
        page.tapStartPlayback()
        page.tapPlayInroll()
        XCTAssertTrue(elementMatches(page.goButton, query: .exists, timeout: 5), "Video appeared")
        page.tapPauseInroll()
        XCTAssertFalse(elementMatches(page.skipButton, query: .exists, timeout: 10), "Video paused")
        page.tapResumeInroll()
        XCTAssertTrue(elementMatches(page.skipButton, query: .notExists, timeout: 10), "Video resumed")
    }
}
