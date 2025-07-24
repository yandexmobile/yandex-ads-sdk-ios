/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

struct YandexFullscreenAdPage: PageObject {
    var loadButton: XCUIElement { element(id: CommonAccessibility.loadButton, type: .button) }
    var presentButton: XCUIElement { element(id: CommonAccessibility.presentButton, type: .button) }
    var adView: XCUIElement { element(id: CommonAccessibility.bannerView, type: .other) }
    var stateLabel: XCUIElement { element(id: CommonAccessibility.stateLabel, type: .staticText) }
    
    func tapLoadAd() {
        step("Tap load ad") {
            loadButton.tap()
        }
    }
    
    func tapPresentAd() {
        step("Tap present ad") {
            presentButton.tap()
        }
    }
    
    func assertAdDisplayed() {
        step("Check displayed") {
            XCTAssertTrue(adView.waitForExistence(timeout: 5))
        }
    }        
}
