import XCTest

struct GDPRDialogPage: PageObject {
    var acceptButton: XCUIElement { element(id: GDPRAccessibility.acceptButton, type: .button) }
    var declineButton: XCUIElement { element(id: GDPRAccessibility.declineButton, type: .button) }
    var aboutButton: XCUIElement { element(id: GDPRAccessibility.aboutButton, type: .button) }
    
    func tapAbout() {
        step("Tap about") {
            aboutButton.tap()
        }
    }
    
    func tapAccept() {
        step("Tap accept") {
            acceptButton.tap()
        }
    }
    
    func tapDecline() {
        step("Tap decline") {
            declineButton.tap()
        }
    }
}

extension XCUIElement {
    var switchValue: Bool {
        stringValue == "1"
    }
    
    private var stringValue: String? {
        value as? String
    }
}
