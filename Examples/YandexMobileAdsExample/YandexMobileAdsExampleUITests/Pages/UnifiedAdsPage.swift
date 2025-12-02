import XCTest

struct UnifiedAdsPage: PageObject {
    private let app = XCUIApplication()
    
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
            XCTAssertTrue(XCUIApplication.safari.wait(for: .runningForeground, timeout: 10), "Safari did not open")
        }
    }
    
    func expandLogsIfNeeded() {
        step("Expand logs if needed") {
            if !logsText.exists {
                XCTAssertTrue(logsToggle.waitForExistence(timeout: 5), "Logs toggle not found")
                logsToggle.tap()
                XCTAssertTrue(logsText.waitForExistence(timeout: 5), "Logs text view still not found after expand")
            }
        }
    }
    
    // MARK: – Waiters
    
    func waitPresentEnabled(timeout: TimeInterval = 10) {
        step("Wait Present enabled") {
            XCTAssertTrue(presentButton.waitUntilEnabled(timeout: timeout), "Present button didn't become enabled")
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
            expandLogsIfNeeded()
            let predicate = NSPredicate(format: "value CONTAINS %@", token)
            let exp = XCTNSPredicateExpectation(predicate: predicate, object: logsText)
            let result = XCTWaiter.wait(for: [exp], timeout: timeout)
            XCTAssertEqual(result, .completed, "Log doesn't contain '\(token)'")
        }
    }
    
    @discardableResult
    func assertLoadedOrNoFill(timeout: TimeInterval = 10) -> Bool {
        step("Assert ad is either Loaded or No-Fill") {
            expandLogsIfNeeded()

            let tokenLoaded = StateUtils.loaded
            let tokenNoFill = "Ad request completed successfully, but there are no ads available"

            let deadline = Date().addingTimeInterval(timeout)
            var last = ""

            while Date() < deadline {
                last = (logsText.value as? String) ?? logsText.label

                if last.contains(tokenNoFill) {
                    XCTSkip("No fill — пропускаем дальнейшие шаги показа.")
                    return false
                }

                if last.contains(tokenLoaded) {
                    return true
                }

                RunLoop.current.run(until: Date().addingTimeInterval(0.2))
            }

            XCTFail("Ни Loaded, ни No-Fill за \(timeout)s. Последний лог: \(last)")
            return false
        }
    }
}

// MARK: – Helpers

private extension UnifiedAdsPage {
    func openMenu(on button: XCUIElement) {
        XCTAssertTrue(button.waitForExistence(timeout: 5), "Menu button not found")
        button.tap()
        if !anyMenuItemExistsWithin(1.0) {
            button.coordinate(withNormalizedOffset: .init(dx: 0.5, dy: 0.5)).tap()
        }
        XCTAssertTrue(anyMenuItemExistsWithin(3.0), "Menu didn't appear")
    }
    
    func tapMenuItem(titled title: String) {
        if tapFirstHittable(app.buttons[title]) { return }
        if tapFirstHittable(app.cells[title]) { return }
        if tapAncestorOfStaticText(with: title) { return }
        if tapFirstHittable(app.menuItems[title]) { return }
        XCTFail("Menu item '\(title)' not found or not tappable")
    }
    
    func tapFirstHittable(_ element: XCUIElement) -> Bool {
        if element.waitForExistence(timeout: 2), element.isHittable {
            element.tap()
            return true
        }
        return false
    }
    
    func tapAncestorOfStaticText(with title: String) -> Bool {
        let label = app.staticTexts[title]
        guard label.waitForExistence(timeout: 2) else { return false }
        if let tappableAncestor = label.firstTappableAncestor(in: [ .button, .cell ]) {
            tappableAncestor.tap()
            return true
        }
        if label.isHittable {
            label.tap()
            return true
        }
        return false
    }
    
    func anyMenuItemExistsWithin(_ timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if app.buttons.element(boundBy: 0).exists && app.buttons.element(boundBy: 0).isHittable { return true }
            if app.cells.element(boundBy: 0).exists && app.cells.element(boundBy: 0).isHittable { return true }
            if app.menuItems.element(boundBy: 0).exists && app.menuItems.element(boundBy: 0).isHittable { return true }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return false
    }
}

private extension XCUIElement {
    func waitUntilEnabled(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "isEnabled == true")
        let exp = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter.wait(for: [exp], timeout: timeout) == .completed
    }
    
    func firstTappableAncestor(in types: [XCUIElement.ElementType]) -> XCUIElement? {
        var el: XCUIElement? = self
        while let current = el {
            if types.contains(current.elementType), current.isHittable { return current }
            el = current.parent
        }
        return nil
    }
    
    var parent: XCUIElement? {
        guard exists else { return nil }
        let frame = self.frame
        let candidates = XCUIApplication().descendants(matching: .any)
            .matching(NSPredicate(format: "frame CONTAINS %@", NSValue(cgRect: frame)))
        return candidates.element(boundBy: 1).exists ? candidates.element(boundBy: 1) : nil
    }
}

extension UnifiedAdsPage {
    var gearButton: XCUIElement { XCUIApplication().buttons["gdpr_settings_button"] }
    
    func resetGDPRViaActionSheet() {
        step("Open gear and tap 'Reset GDPR'") {
            XCTAssertTrue(gearButton.waitForExistence(timeout: 5), "Gear button not found")
            gearButton.tap()
            let reset = XCUIApplication().buttons["Reset GDPR"]
            XCTAssertTrue(reset.waitForExistence(timeout: 3), "Reset GDPR action not found")
            reset.tap()
        }
    }
}
