import XCTest

struct UnifiedAdsPage: PageObject {
    var loadButton: XCUIElement {
        app.buttons[CommonAccessibility.loadButton]
    }
    
    var presentButton: XCUIElement {
        app.buttons[CommonAccessibility.presentButton]
    }
    var bulkTable: XCUIElement {
        app.tables[CommonAccessibility.bulkTable]
    }
    
    var inlineBanner: XCUIElement {
        app.otherElements[CommonAccessibility.bannerView]
    }
    
    var logsText: XCUIElement {
        let textView = app.textViews[CommonAccessibility.logsTextView]
        if textView.exists { return textView }
        return app.staticTexts[CommonAccessibility.logsTextView]
    }
    
    var logsToggle: XCUIElement {
        app.buttons["logs_toggle"]
    }
    
    private var formatRowContainer: XCUIElement  { app.otherElements["format_row"] }
    private var sourceRowContainer: XCUIElement  { app.otherElements["source_row"] }
    private var formatButton: XCUIElement { formatRowContainer.buttons.element(boundBy: 0) }
    private var sourceButton: XCUIElement { sourceRowContainer.buttons.element(boundBy: 0) }
    
    private var currentFormatTitle: String {
        formatButton.label
    }
    
    private var currentSourceTitle: String {
        sourceButton.label
    }
    
    // MARK: – Actions
    
    func selectSource(_ title: String) {
        step("Select source: \(title)") {
            XCTAssertTrue(sourceRowContainer.waitForExistence(timeout: 5), "source_row container not found")
            
            if currentSourceTitle == title {
                XCTContext.runActivity(named: "Source already '\(title)', skipping selection") { _ in }
                return
            }
            
            openMenu(on: sourceButton)
            tapMenuItem(titled: title)
        }
    }
    
    func selectFormat(_ title: String) {
        step("Select format: \(title)") {
            XCTAssertTrue(formatRowContainer.waitForExistence(timeout: 5), "format_row container not found")
            
            if currentFormatTitle == title {
                XCTContext.runActivity(named: "Format already '\(title)', skipping selection") { _ in }
                return
            }
            
            openMenu(on: formatButton)
            tapMenuItem(titled: title)
        }
    }
    
    func tapLoad() {
        step("Tap Load") {
            XCTAssertTrue(loadButton.waitForExistence(timeout: 5), "Load button not found")
            loadButton.tap()
        }
    }
    
    func tapPresent() {
        step("Tap Present") {
            XCTAssertTrue(presentButton.waitForExistence(timeout: 5), "Present button not found")
            presentButton.tap()
        }
    }
    
    func tapInlineAd() {
        step("Tap inline ad") {
            XCTAssertTrue(inlineBanner.waitForExistence(timeout: 10), "Inline ad not visible")
            inlineBanner.tap()
        }
    }
    
    func tapInlineAdAndOpenSafari() {
        step("Tap inline ad and expect Safari") {
            XCTAssertTrue(inlineBanner.waitForExistence(timeout: 10), "Inline ad not visible")
            inlineBanner.tap()
            XCTAssertTrue(XCUIApplication.safari.wait(for: .runningForeground, timeout: 30), "Safari did not open")
        }
    }

    func expandLogs() {
        step("Expand logs") {
            logsToggle.tap()
        }
    }
    
    // MARK: – Waiters
    
    func waitPresentEnabled(timeout: TimeInterval = 10) {
        step("Wait Present enabled") {
            XCTAssertTrue(
                presentButton.matches(
                    query: .equals(.enabled, "true", false),
                    timeout: timeout
                ),
                "Present button didn't become enabled"
            )
        }
    }
    
    func waitInlineAdVisible(timeout: TimeInterval = 10) {
        step("Wait inline ad visible (banner/native)") {
            let candidate = inlineBanner.exists ? inlineBanner : bulkTable
            XCTAssertTrue(candidate.waitForExistence(timeout: timeout), "Inline ad view not found")
        }
    }
    
    // MARK: – Log Asserts
    
    func assertAdLoaded(timeout: TimeInterval = 10) {
        assertLogContains(StateUtils.loaded, timeout: timeout)
    }
    
    func assertAdShown(timeout: TimeInterval = 10) {
        assertLogContains(StateUtils.shown, timeout: timeout)
    }
    
    func assertAdImpression(timeout: TimeInterval = 10) {
        assertLogContains(StateUtils.impression, timeout: timeout)
    }
    
    func assertAdClicked(timeout: TimeInterval = 10) {
        assertLogContains(StateUtils.clicked, timeout: timeout)
    }
    
    func assertAdDismissed(timeout: TimeInterval = 10) {
        assertLogContains(StateUtils.dismissed, timeout: timeout)
    }
    
    func assertLogContains(_ token: String, timeout: TimeInterval = 5) {
        step("Assert logs contain '\(token)'") {
            expandLogs()
            let result = logsText.matches(query: Query.contains(.value, token), timeout: timeout)
            XCTAssertTrue(result, "Log doesn't contain '\(token)'")
        }
    }

    func assertLoadedOrNoFill(timeout: TimeInterval = 10) -> Bool {
         step("Check ad loaded") {
             expandLogs()
             let noAdsError = "Ad request completed successfully, but there are no ads available"
             let noAdsQueury: Query = .begins(.value, StateUtils.loadErrorPrefix) && .contains(.value, noAdsError)
             let query: Query = .contains(.value, StateUtils.loaded) || noAdsQueury
             if logsText.matches(query: query, timeout: timeout) {
                 return !logsText.matches(query: noAdsQueury)
             } else {
                 XCTFail("\(logsText.label) does not match \(query.string)")
                 return false
             }
         }
     }
}

extension XCUIElement {
    func matches(query: Query, timeout: TimeInterval) -> Bool {
        let predictate = query.predicate
        let expectation = XCTNSPredicateExpectation(predicate: predictate, object: self)
        let waiter = XCTWaiter()
        let result = waiter.wait(for: [expectation], timeout: timeout)
        switch result {
        case .completed:
            return true
        default:
            return false
        }
    }

    func matches(query: Query) -> Bool {
        let predictate = query.predicate
        return predictate.evaluate(with: self)
    }
}

// MARK: – Helpers

private extension UnifiedAdsPage {
    func openMenu(on button: XCUIElement) {
        button.tap()
    }
    
    func tapMenuItem(titled title: String) {
        let element = app.buttons[title]
        if !element.isHittable {
            app.collectionViews.firstMatch.swipeUp()
        }
        element.tap()
    }
}

extension UnifiedAdsPage {
    var gearButton: XCUIElement { app.buttons["gdpr_settings_button"] }

    func resetGDPRViaActionSheet() {
        step("Open gear and tap 'Reset GDPR'") {
            XCTAssertTrue(gearButton.waitForExistence(timeout: 5), "Gear button not found")
            gearButton.tap()
            let reset = app.buttons["Reset GDPR"]
            XCTAssertTrue(reset.waitForExistence(timeout: 3), "Reset GDPR action not found")
            reset.tap()
        }
    }
}
