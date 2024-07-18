import XCTest

struct YandexNativeAdPage: PageObject {
    var loadButton: XCUIElement { element(id: CommonAccessibility.loadButton, type: .button) }
    var adView: XCUIElement { element(id: CommonAccessibility.bannerView, type: .other) }
    var adsView: XCUIElement { element(id: CommonAccessibility.bannerView, type: .table) }
    var adCellView: XCUIElement { element(id: CommonAccessibility.bannerCellView + "0", type: .cell) }
    var stateLabel: XCUIElement { element(id: CommonAccessibility.stateLabel, type: .staticText) }
    
    func tapLoadAd() {
        step("Tap load ad") {
            loadButton.tap()
        }
    }
    
    func tapAd() {
        step("Tap ad") {
            adView.tap()
        }
    }
    
    func assertAdDisplayed() {
        step("Assert ad displayed") {
            XCTAssertTrue(adView.waitForExistence(timeout: 5))
        }
    }
    
    func assertAdsDisplayed() {
        step("Assert ad displayed") {
            XCTAssertTrue(adsView.waitForExistence(timeout: 5))
        }
    }
    
    func tapBulkAd() {
        step("Tap ad") {
            adCellView.tap()
        }
    }
}
