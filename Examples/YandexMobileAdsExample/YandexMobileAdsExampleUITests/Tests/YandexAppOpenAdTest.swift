import XCTest

final class YandexAppOpenAdTest: BaseTest {
    private let adsPage = UnifiedAdsPage()

    func testAppOpenAd() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.appOpen)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        leaveApp()
        sleep(1)
        returnToApp()
        step("Wait for app open ad and tap") {
            let app = XCUIApplication()
            let adView = app.otherElements[CommonAccessibility.bannerView]
            XCTAssertTrue(adView.waitForExistence(timeout: 10), "App Open Ad not found")
            sleep(2)
            adView.tap()
        }
        assertSafariOpened()
    }
}
