import XCTest

final class YandexInstreamTest: BaseTest {
    private let adsPage = UnifiedAdsPage()
    private let instream = UnifiedInstreamPage()

    func testInstreamSingle() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.instreamSingle)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        instream.waitForPrepare()
        instream.tapPrepare()
        instream.waitForPresent()
        instream.tapPresent()
    }

    func testInrolls() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.instreamInroll)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 10) else { return }
        instream.waitForStartPlayback()
        instream.tapStartPlayback()
        instream.waitForPlayInroll()
        instream.tapPlayInroll()
        instream.waitForPauseInroll()
        instream.tapPauseInroll()
        instream.waitForResumeInroll()
        instream.tapResumeInroll()
    }
}
