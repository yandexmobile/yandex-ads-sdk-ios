/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

enum Adapter: String {
    case appLovin = "AppLovin"
    case bigoAds = "BigoAds"
    case chartboost = "Chartboost"
    case adMob = "AdMob"
    case inMobi = "InMobi"
    case ironSource = "IronSource"
    case mintegral = "Mintegral"
    case myTarget = "MyTarget"
    case startApp = "StartApp"
    case unityAds = "UnityAds"
    case yandex = "Yandex"
}

struct MobileMediationAdPage: PageObject {
    var loadButton: XCUIElement { element(id: CommonAccessibility.loadButton, type: .button) }
    var presentButton: XCUIElement { element(id: CommonAccessibility.presentButton, type: .button) }
    var stateLabel: XCUIElement { element(id: CommonAccessibility.stateLabel, type: .staticText) }
    var picker: XCUIElement { app.pickerWheels.firstMatch }
    var adView: XCUIElement { element(id: CommonAccessibility.bannerView, type: .other) }
    
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
    
    func selectAdapter(_ adapter: Adapter) {
        step("Select adapter \(adapter.rawValue)") {
            picker.adjust(toPickerWheelValue: adapter.rawValue)
        }
    }
    
    func assertAdDisplayed() {
        step("Assert ad displayed") {
            XCTAssertTrue(adView.waitForExistence(timeout: 5))
        }
    }
}
