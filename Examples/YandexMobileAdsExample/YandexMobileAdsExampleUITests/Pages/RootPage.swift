/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

struct RootPage: PageObject {
    typealias Keys = RootAccessibility

    var yandex: XCUIElement { element(id: Keys.yandex, type: .cell) }
    var mobileMediation: XCUIElement { element(id: Keys.mobileMediation, type: .cell) }
    var gdpr: XCUIElement { element(id: Keys.gdpr, type: .cell) }
    var adFox: XCUIElement { element(id: Keys.adFox, type: .cell) }

    func openYandex() {
        step("Open Yandex") {
            yandex.tap()
        }
    }

    func openMobileMediation() {
        step("Open mobile mediation") {
            mobileMediation.tap()
        }
    }

    func openAdFox() {
        step("Open ad fox") {
            adFox.tap()
        }
    }

    func openGDPR() {
        step("Open GDPR") {
            gdpr.tap()
        }
    }
}
