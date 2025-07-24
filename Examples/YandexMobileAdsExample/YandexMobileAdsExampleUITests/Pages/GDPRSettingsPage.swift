/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

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

