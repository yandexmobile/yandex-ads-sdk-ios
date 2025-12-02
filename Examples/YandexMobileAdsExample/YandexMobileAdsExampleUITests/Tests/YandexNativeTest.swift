import XCTest

final class YandexNativeTest: BaseTest {
    let adsPage = UnifiedAdsPage()

    func testYandexNativeTemplate() {
        runNativeInline(formatTitle: TestConstants.Format.nativeTemplate)
    }

    func testYandexNativeCustom() {
        runNativeInline(formatTitle: TestConstants.Format.nativeCustom)
    }

    func testYandexNativeBulk() {
        runNativeBulk()
    }

    private func runNativeInline(formatTitle: String) {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(formatTitle)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        step("Tap inline native ad") {
            let inline = XCUIApplication().otherElements[CommonAccessibility.bannerView]
            XCTAssertTrue(inline.waitForExistence(timeout: 3), "Inline native view not found")
            inline.tap()
        }
        assertSafariOpened()
    }

    private func runNativeBulk() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.nativeBulk)
        adsPage.selectSource(TestConstants.Source.yandex)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        step("Tap first bulk native ad") {
            let app = XCUIApplication()
            let table = app.tables[CommonAccessibility.bulkTable]
            XCTAssertTrue(table.waitForExistence(timeout: 5), "Bulk table not found")
            let firstCell = table.cells.firstMatch
            XCTAssertTrue(firstCell.waitForExistence(timeout: 3), "No bulk cells")
            firstCell.tap()
        }
        assertSafariOpened()
    }
}
