import XCTest

final class YandexBannersTest: BaseTest {
    private let adsPage = UnifiedAdsPage()

    override func setUp() {
        super.setUp()
    }

    // MARK: - Yandex Sticky Banner

    func testYandexBannerSticky() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.bannerSticky)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        adsPage.tapInlineAdAndOpenSafari()
    }

    // MARK: - Yandex Inline Banner

    func testYandexBannerInline() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.bannerInline)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        adsPage.tapInlineAdAndOpenSafari()
    }
}
