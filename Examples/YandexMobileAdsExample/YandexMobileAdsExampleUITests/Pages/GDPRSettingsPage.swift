import XCTest

struct GDPRSettingsPage: PageObject {
    var consentSwitch: XCUIElement { element(id: GDPRAccessibility.userConsentSwitch, type: .switch) }
    var resetButton: XCUIElement { element(id: GDPRAccessibility.resetButton, type: .button) }
    
    func tapReset() {
        step("Tap reset") {
            resetButton.tap()
        }
    }
}

