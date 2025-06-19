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
        guard assertAdLoaded(stateLabel: page.stateLabel) else { return }

        page.tapPrepareAd()
        page.tapPresentAd()

        let numberOfAds = 6

        for index in 0..<numberOfAds {
            step("Ad \(index)") {
                XCTAssertTrue(elementMatches(page.goButton, query: Query.exists, timeout: 60), "Go exists")
                page.tapGo()
                assertSafariOpened()
                returnToApp()
                XCTAssertTrue(elementMatches(page.skipButton, query: Query.exists, timeout: 30), "Skip exists")
                page.tapSkip()
                XCTAssertTrue(elementMatches(page.skipButton, query: Query.notExists), "Skip not exists")
            }
        }
    }
    
    func testInroll() throws {
        launchApp()
        rootPage.openYandex()
        yandexAdsPage.openInstream()
        list.openInroll()
        
        page.tapLoadAd()
        guard assertAdLoaded(stateLabel: page.stateLabel) else { return }
        
        page.tapStartPlayback()
        page.tapPlayInroll()
        XCTAssertTrue(elementMatches(page.goButton, query: .exists, timeout: 5), "Video appeared")
        page.tapPauseInroll()
        XCTAssertFalse(elementMatches(page.skipButton, query: .exists, timeout: 10), "Video paused")
        page.tapResumeInroll()
        XCTAssertTrue(elementMatches(page.skipButton, query: .notExists, timeout: 10), "Video resumed")
    }
}
