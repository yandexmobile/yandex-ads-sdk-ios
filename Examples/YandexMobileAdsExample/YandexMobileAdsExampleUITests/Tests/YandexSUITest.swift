import XCTest

final class YandexSUITest: BaseTest {
    private let menuPage = SwiftUIMenuPage()
    private let bannerPage = SwiftUIBannerPage()
    private let fullscreenPage = SwiftUIFullscreenPage()
    private let appOpenPage = SwiftUIAppOpenPage()

    // MARK: - Banner

    func testBannerFixed() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        menuPage.tapSwiftUIExamples()
        menuPage.tapAdType("Banner")
        bannerPage.selectSize("Fixed")
        bannerPage.tapLoad()
        guard bannerPage.assertLoadedOrNoFill(timeout: 10) else { return }
        bannerPage.waitBannerVisible(timeout: 10)
        bannerPage.tapBannerAndOpenSafari()
    }

    func testBannerSticky() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        menuPage.tapSwiftUIExamples()
        menuPage.tapAdType("Banner")
        bannerPage.selectSize("Sticky")
        bannerPage.tapLoad()
        guard bannerPage.assertLoadedOrNoFill(timeout: 10) else { return }
        bannerPage.waitBannerVisible(timeout: 10)
        bannerPage.tapBannerAndOpenSafari()
    }

    func testBannerInline() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        menuPage.tapSwiftUIExamples()
        menuPage.tapAdType("Banner")
        bannerPage.selectSize("Inline")
        bannerPage.tapLoad()
        guard bannerPage.assertLoadedOrNoFill(timeout: 10) else { return }
        bannerPage.waitBannerVisible(timeout: 10)
        bannerPage.tapBannerAndOpenSafari()
    }

    // MARK: - Interstitial

    func testInterstitial() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        menuPage.tapSwiftUIExamples()
        menuPage.tapAdType("Interstitial")
        fullscreenPage.tapLoad()
        guard fullscreenPage.assertLoadedOrNoFill(timeout: 10) else { return }
        fullscreenPage.waitPresentEnabled(timeout: 10)
        fullscreenPage.tapPresent()
        step("Tap call-to-action button") {
            let cta = app.staticTexts["mac_call_to_action"]
            XCTAssertTrue(cta.waitForExistence(timeout: 5), "Call-to-action button not found")
            cta.tap()
        }
        assertStoreControllerOpened()
    }

    // MARK: - Rewarded

    func testRewarded() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        menuPage.tapSwiftUIExamples()
        menuPage.tapAdType("Rewarded")
        fullscreenPage.tapLoad()
        guard fullscreenPage.assertLoadedOrNoFill(timeout: 10) else { return }
        fullscreenPage.waitPresentEnabled(timeout: 10)
        fullscreenPage.tapPresent()
        step("Tap call-to-action button") {
            let cta = app.staticTexts["Подробнее ➔"]
            XCTAssertTrue(cta.waitForExistence(timeout: 5), "cta button not found")
            cta.tap()
        }
        assertSafariOpened()
    }

    // MARK: - App Open Ad

    func testAppOpenAd() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        menuPage.tapSwiftUIExamples()
        menuPage.tapAdType("App Open Ad")
        appOpenPage.expandLogs()
        appOpenPage.tapLoad()
        guard appOpenPage.assertLoadedOrNoFill(timeout: 10) else { return }
        leaveApp()
        returnToApp()
        step("Tap call-to-action button") {
            let cta = app.buttons["Подробнее"]
            XCTAssertTrue(cta.waitForExistence(timeout: 5), "cta button not found")
            cta.tap()
        }
        assertSafariOpened()
    }
}
