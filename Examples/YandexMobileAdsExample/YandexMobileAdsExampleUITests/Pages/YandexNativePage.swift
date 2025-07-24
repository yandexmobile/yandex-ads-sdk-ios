/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

struct YandexNativePage: PageObject {
    var custom: XCUIElement { element(id: YandexNativeAccessibility.custom, type: .cell) }
    var template: XCUIElement { element(id: YandexNativeAccessibility.template, type: .cell) }
    var bulk: XCUIElement { element(id: YandexNativeAccessibility.bulk, type: .cell) }
    
    func openCustom() {
        step("Open custom") {
            custom.tap()
        }
    }
    
    func openTemplate() {
        step("Open template") {
            template.tap()
        }
    }
    
    func openBulk() {
        step("Open bulk") {
            bulk.tap()
        }
    }
}
