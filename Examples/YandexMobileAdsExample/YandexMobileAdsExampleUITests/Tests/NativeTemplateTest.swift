import XCTest

final class NativeTemplateTest: BaseTest {
    private let adsPage = UnifiedAdsPage()
    
    func testVungleNativeTemplate() {
        runNativeTemplateTest(source: TestConstants.Source.vungle)
    }
    
    func testMyTargetNativeTemplate() {
        runNativeTemplateTest(source: TestConstants.Source.myTarget)
    }
    
    func testMintegralNativeTemplate() {
        runNativeTemplateTest(source: TestConstants.Source.mintegral)
    }
    
    func testAdMobNativeTemplate() {
        runNativeTemplateTest(source: TestConstants.Source.adMob)
    }
    
    func testAdFoxNativeTemplate() {
        runNativeTemplateTest(source: TestConstants.Source.adFox)
    }
    
    private func runNativeTemplateTest(source: String) {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.nativeTemplate)
        adsPage.selectSource(source)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        step("Tap native ad (inline or first bulk cell)") {
            let app = XCUIApplication()
            let inline = app.otherElements[CommonAccessibility.bannerView]
            if inline.exists && inline.isHittable {
                inline.tap()
            } else {
                let table = app.tables[CommonAccessibility.bulkTable]
                if table.exists {
                    let firstCell = table.cells.firstMatch
                    if firstCell.waitForExistence(timeout: 2) && firstCell.isHittable {
                        firstCell.tap()
                    }
                }
            }
        }
    }
}
