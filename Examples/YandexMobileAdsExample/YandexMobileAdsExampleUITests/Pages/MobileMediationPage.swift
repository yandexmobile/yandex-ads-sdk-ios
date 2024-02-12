import XCTest

struct MobileMediationPage: PageObject {
    var banner: XCUIElement { element(id: "Banner") }
    var interstitial: XCUIElement { element(id: "Interstitial") }
    var rewarded: XCUIElement { element(id: "Rewarded") }
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
    
    func openRewarded() {
        step("Open rewarded") {
            rewarded.tap()
        }
    }
    
    func openNative() {
        step("Open native") {
            native.tap()
        }
    }
}
