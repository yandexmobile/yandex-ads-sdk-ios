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
