import XCTest

final class InterstitialTest: BaseTest {
    private let adsPage = UnifiedAdsPage()

    func testBigoAdsInterstitial() {
        runFullscreenTest(source: TestConstants.Source.bigoAds)
    }

    func testChartboostInterstitial() {
        runFullscreenTest(source: TestConstants.Source.chartboost)
    }

    func testAdMobInterstitial() {
        runFullscreenTest(source: TestConstants.Source.adMob)
    }

    func testInMobiInterstitial() {
        runFullscreenTest(source: TestConstants.Source.inMobi)
    }

    func testIronSourceInterstitial() {
        runFullscreenTest(source: TestConstants.Source.ironSource)
    }

    func testMintegralInterstitial() {
        runFullscreenTest(source: TestConstants.Source.mintegral)
    }

    func testMyTargetInterstitial() {
        runFullscreenTest(source: TestConstants.Source.myTarget)
    }

    func testStartAppInterstitial() {
        runFullscreenTest(source: TestConstants.Source.startApp)
    }

    func testUnityAdsInterstitial() {
        runFullscreenTest(source: TestConstants.Source.unityAds)
    }

    // MARK: - Common logic

    private func runFullscreenTest(source: String) {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.interstitial)
        adsPage.selectSource(source)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitPresentEnabled(timeout: 10)
        adsPage.tapPresent()
        step("Tap fullscreen ad") {
            let app = XCUIApplication()
            XCTAssertTrue(app.waitForExistence(timeout: 5), "App not ready for fullscreen ad tap")
            sleep(10)
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}
