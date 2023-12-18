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
