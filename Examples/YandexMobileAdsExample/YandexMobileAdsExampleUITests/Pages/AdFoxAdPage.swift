import XCTest

struct AdFoxAdPage: PageObject {
    var loadButton: XCUIElement { element(id: CommonAccessibility.loadButton, type: .button) }
    var presentButton: XCUIElement { element(id: CommonAccessibility.presentButton, type: .button) }
    var stateLabel: XCUIElement { element(id: CommonAccessibility.stateLabel, type: .staticText) }
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
        
    func assertAdDisplayed() {
        step("Assert ad displayed") {
            XCTAssertTrue(adView.waitForExistence(timeout: 5))
        }
    }

    func tapAd() {
        step("Tap ad") {
            adView.tap()
        }
    }
}
