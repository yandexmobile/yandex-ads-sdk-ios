import XCTest

final class YandexNativeTest: BaseTest {
    let adsPage = UnifiedAdsPage()
    
    func testYandexNativeCustom() {
        runNativeСustom(formatTitle: TestConstants.Format.nativeCustom)
    }

    func testYandexNativeTemplate() {
        runNativeСustom(formatTitle: TestConstants.Format.nativeTemplate, source: TestConstants.Source.yandex)
    }

    func testYandexNativeBulk() {
        runNativeBulk()
    }
    
    private func runNativeСustom(formatTitle: String, source: String? = nil) {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(formatTitle)
        if let source {
            adsPage.selectSource(source)
        }
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        step("Tap inline native ad") {
            let inline = app.otherElements[CommonAccessibility.bannerView]
            XCTAssertTrue(inline.waitForExistence(timeout: 3), "Inline native view not found")
            inline.tap()
        }
        assertSafariOpened()
    }
    
    private func runNativeBulk() {
        launchApp(extraArgs: [LaunchArgument.gdprSuppressOnLaunch])
        adsPage.selectFormat(TestConstants.Format.nativeBulk)
        adsPage.tapLoad()
        guard adsPage.assertLoadedOrNoFill(timeout: 15) else { return }
        adsPage.waitInlineAdVisible(timeout: 10)
        step("Tap first bulk native ad") {
            let table = app.tables[CommonAccessibility.bulkTable]
            XCTAssertTrue(table.waitForExistence(timeout: 5), "Bulk table not found")
            let firstCell = table.cells.firstMatch
            XCTAssertTrue(firstCell.waitForExistence(timeout: 3), "No bulk cells")
            firstCell.tap()
        }
        assertSafariOpened()
    }
}
