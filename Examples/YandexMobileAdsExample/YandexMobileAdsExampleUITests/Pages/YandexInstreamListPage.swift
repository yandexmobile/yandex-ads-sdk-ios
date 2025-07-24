/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

struct YandexInstreamListPage: PageObject {
    var singleInstream: XCUIElement { element(id: YandexInstreamListAccessibility.singleInstream, type: .cell) }
    var inroll: XCUIElement { element(id: YandexInstreamListAccessibility.inroll, type: .cell) }
    
    func openInroll() {
        step("Open inroll") {
            inroll.tap()
        }
    }
    
    func openSingleInstream() {
        step("Open single instream") {
            singleInstream.tap()
        }
    }
}
