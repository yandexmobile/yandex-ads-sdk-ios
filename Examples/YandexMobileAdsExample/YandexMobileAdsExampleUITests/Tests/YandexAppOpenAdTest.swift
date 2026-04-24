import XCTest

final class YandexAppOpenAdTest: BaseTest {
    private let adsPage = UnifiedAdsPage()

    func testYandexAppOpenAd() {
        runAppOpenTest(source: TestConstants.Source.yandex)
    }
    
    func testBigoAdsAppOpenAd() {
        runAppOpenTest(source: TestConstants.Source.bigoAds)
    }
    
    func testMintegralAppOpenAd() {
        runAppOpenTest(source: TestConstants.Source.mintegral)
    }
    
    func testPangleAppOpenAd() {
        runAppOpenTest(source: TestConstants.Source.pangle)
    }
    
    func testVungleAppOpenAd() {
        runAppOpenTest(source: TestConstants.Source.vungle)
    }
    
    // MARK: - Common logic
    
    private func runAppOpenTest(source: String) {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.appOpen)
        adsPage.selectSource(source)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        leaveApp()
        sleep(1)
        returnToApp()
    }
}
