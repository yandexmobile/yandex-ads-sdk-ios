/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

protocol PageObject {}

extension PageObject {
    var app: XCUIApplication { XCUIApplication() }
    
    func element(id: String, type: XCUIElement.ElementType = .any) -> XCUIElement {
        app.descendants(matching: type).matching(identifier: id).element
    }
}
