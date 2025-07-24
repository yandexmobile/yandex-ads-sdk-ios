/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

struct AdFoxPage: PageObject {
    var banner: XCUIElement { element(id: "Banner") }
    var interstitial: XCUIElement { element(id: "Interstitial") }
    var native: XCUIElement { element(id: "Native") }
    
    func openBanner() {
        step("Open banner") {
            banner.tap()
        }
    }
    
    func openInterstitial() {
        step("Open interstitial") {
            interstitial.tap()
        }
    }
    
    func openNative() {
        step("Open native") {
            native.tap()
        }
    }
}
