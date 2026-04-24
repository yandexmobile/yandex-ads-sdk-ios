import XCTest

struct SwiftUIBannerPage: PageObject {

    private var loadButton: XCUIElement { app.buttons[CommonAccessibility.loadButton] }
    private var bannerView: XCUIElement { app.otherElements[CommonAccessibility.bannerView] }
    private var logsText: XCUIElement {
        let textView = app.textViews[CommonAccessibility.logsTextView]
        if textView.exists { return textView }
        return app.staticTexts[CommonAccessibility.logsTextView]
    }

    func selectSize(_ size: String) {
        step("Select banner size: \(size)") {
            let segment = app.segmentedControls.firstMatch.buttons[size]
            XCTAssertTrue(segment.waitForExistence(timeout: 5), "Segment '\(size)' not found")
            segment.tap()
        }
    }

    func tapLoad() {
        step("Tap Load") {
            XCTAssertTrue(loadButton.waitForExistence(timeout: 5), "Load button not found")
            loadButton.tap()
        }
    }

    func expandLogs() {
        step("Expand logs") {
            let toggle = app.buttons["logs_toggle"]
            XCTAssertTrue(toggle.waitForExistence(timeout: 5), "logs_toggle button not found")
            toggle.tap()
            _ = logsText.waitForExistence(timeout: 2)
        }
    }

    @discardableResult
    func assertLoadedOrNoFill(timeout: TimeInterval = 10) -> Bool {
        step("Check ad loaded or no fill") {
            expandLogs()
            let noAdsError = "Ad request completed successfully, but there are no ads available"
            let noFillQuery: Query = (
                (.contains(.label, "didFailToLoad") && .contains(.label, noAdsError))
            )
            let successQuery: Query = .contains(.label, "didLoad")
            let query: Query = successQuery || noFillQuery
            if logsText.matches(query: query, timeout: timeout) {
                return !logsText.matches(query: noFillQuery)
            } else {
                XCTFail("Log does not contain 'didLoad' or no-fill error after \(timeout)s")
                return false
            }
        }
    }

    func waitBannerVisible(timeout: TimeInterval = 10) {
        step("Wait for banner to be visible") {
            XCTAssertTrue(
                bannerView.waitForExistence(timeout: timeout),
                "Banner view ('\(CommonAccessibility.bannerView)') not visible after \(timeout)s"
            )
        }
    }

    func tapBannerAndOpenSafari() {
        step("Tap banner and expect Safari to open") {
            XCTAssertTrue(bannerView.waitForExistence(timeout: 10), "Banner view not found")
            bannerView.tap()
            XCTAssertTrue(
                XCUIApplication.safari.wait(for: .runningForeground, timeout: 30),
                "Safari did not open after tapping banner"
            )
        }
    }
}
