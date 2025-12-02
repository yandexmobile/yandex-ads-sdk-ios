import XCTest

final class RewardedTest: BaseTest {
    let adsPage = UnifiedAdsPage()

    // MARK: - Network Tests

    func testBigoAdsRewarded() {
        runRewardedTest(source: TestConstants.Source.bigoAds)
    }

    func testChartboostRewarded() {
        runRewardedTest(source: TestConstants.Source.chartboost)
    }

    func testAdMobRewarded() {
        runRewardedTest(source: TestConstants.Source.adMob)
    }

    func testInMobiRewarded() {
        runRewardedTest(source: TestConstants.Source.inMobi)
    }

    func testIronSourceRewarded() {
        runRewardedTest(source: TestConstants.Source.ironSource)
    }

    func testMintegralRewarded() {
        runRewardedTest(source: TestConstants.Source.mintegral)
    }

    func testMyTargetRewarded() {
        runRewardedTest(source: TestConstants.Source.myTarget)
    }

    func testStartAppRewarded() {
        runRewardedTest(source: TestConstants.Source.startApp)
    }

    func testUnityAdsRewarded() {
        runRewardedTest(source: TestConstants.Source.unityAds)
    }

    // MARK: - Common logic

    private func runRewardedTest(source: String) {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.rewarded)
        adsPage.selectSource(source)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitPresentEnabled(timeout: 10)
        adsPage.tapPresent()
        step("Tap rewarded ad") {
            let app = XCUIApplication()
            XCTAssertTrue(app.waitForExistence(timeout: 5), "App not ready for fullscreen ad tap")
            sleep(2)
            let center = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.55))
            center.tap()
        }
    }
}
