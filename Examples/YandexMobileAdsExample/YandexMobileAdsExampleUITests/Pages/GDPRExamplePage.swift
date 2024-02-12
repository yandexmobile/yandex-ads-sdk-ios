import XCTest

struct GDPRExamplePage: PageObject {
    var loadButton: XCUIElement { element(id: CommonAccessibility.loadButton, type: .button) }
    var settingsButton: XCUIElement { element(id: GDPRAccessibility.settingsButton) }
    
    func tapLoadAd() {
        step("Tap load ad") {
            loadButton.tap()
        }
    }
    
    func tapSettings() {
        step("Tap settings") {
            settingsButton.tap()
        }
    }
}

