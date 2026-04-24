import XCTest

struct SwiftUIFullscreenPage: PageObject {

    private var loadButton: XCUIElement { app.buttons[CommonAccessibility.loadButton] }
    private var presentButton: XCUIElement { app.buttons[CommonAccessibility.presentButton] }
    private var logsText: XCUIElement {
        let textView = app.textViews[CommonAccessibility.logsTextView]
        if textView.exists { return textView }
        return app.staticTexts[CommonAccessibility.logsTextView]
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
            guard !logsText.exists else { return }
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

    func waitPresentEnabled(timeout: TimeInterval = 10) {
        step("Wait Present button enabled") {
            XCTAssertTrue(
                presentButton.matches(
                    query: .equals(.enabled, "true", false),
                    timeout: timeout
                ),
                "Present button didn't become enabled after \(timeout)s"
            )
        }
    }

    func tapPresent() {
        step("Tap Present Ad") {
            XCTAssertTrue(presentButton.waitForExistence(timeout: 5), "Present button not found")
            presentButton.tap()
        }
    }

    func assertRewarded(timeout: TimeInterval = 15) {
        step("Assert reward received") {
            let rewardedQuery: Query = .contains(.label, "didReward") || .contains(.value, "didReward")
            XCTAssertTrue(
                logsText.matches(query: rewardedQuery, timeout: timeout),
                "Log does not contain 'didReward' after \(timeout)s"
            )
        }
    }
}
