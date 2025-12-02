import XCTest

final class YandexFullscreenTest: BaseTest {
    private let adsPage = UnifiedAdsPage()

    func testYandexInterstitial() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.interstitial)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        adsPage.waitPresentEnabled(timeout: 10)
        adsPage.tapPresent()
        step("Tap call-to-action button") {
            let app = XCUIApplication()
            sleep(2)
            let callToActionButton = app.staticTexts["mac_call_to_action"]
            XCTAssertTrue(callToActionButton.waitForExistence(timeout: 5), "Call-to-action button not found")
            callToActionButton.tap()
        }
        assertStoreControllerOpened()
    }

    func testYandexRewarded() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.rewarded)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        adsPage.waitPresentEnabled(timeout: 10)
        adsPage.tapPresent()
        step("Tap link button") {
            let app = XCUIApplication()
            sleep(2)
            let moreInfoButton = app.staticTexts["eda.yandex.ru"]
            XCTAssertTrue(moreInfoButton.waitForExistence(timeout: 5), "link button not found")
            moreInfoButton.tap()
        }
        assertSafariOpened()
    }
}
