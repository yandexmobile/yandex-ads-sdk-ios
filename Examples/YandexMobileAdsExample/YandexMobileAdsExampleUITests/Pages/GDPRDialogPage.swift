/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */
 
import XCTest

struct GDPRDialogPage: PageObject {
    private let app = XCUIApplication()
    var acceptButton: XCUIElement { app.buttons[GDPRAccessibility.acceptButton] }
    var declineButton: XCUIElement { app.buttons[GDPRAccessibility.declineButton] }
    var aboutButton: XCUIElement { app.buttons[GDPRAccessibility.aboutButton] }

    func waitAppeared(timeout: TimeInterval = 5) {
        XCTAssertTrue(acceptButton.waitForExistence(timeout: timeout) ||
                      declineButton.waitForExistence(timeout: timeout) ||
                      aboutButton.waitForExistence(timeout: timeout),
                      "GDPR dialog didn't appear")
    }
    
    func tapAccept() { acceptButton.tap() }
    func tapDecline() { declineButton.tap() }
    func tapAbout() { aboutButton.tap() }
}
