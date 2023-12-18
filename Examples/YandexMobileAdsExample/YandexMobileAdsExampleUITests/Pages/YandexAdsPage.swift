import XCTest

struct YandexAdsPage: PageObject {
    typealias Keys = YandexAdsAccessibility
    
    var sticky: XCUIElement { element(id: Keys.sticky, type: .cell) }
    var inline: XCUIElement { element(id: Keys.inline, type: .cell) }
    var interstitial: XCUIElement { element(id: Keys.interstitial, type: .cell) }
    var rewarded: XCUIElement { element(id: Keys.rewarded, type: .cell) }
    var appOpenAd: XCUIElement { element(id: Keys.appOpenAd, type: .cell) }
    var native: XCUIElement { element(id: Keys.native, type: .cell) }
    var instream: XCUIElement { element(id: Keys.instream, type: .cell) }
    
    func openStickyBanner() {
        step("Open yandex sticky banner") {
            sticky.tap()
        }
    }
    
    func openInlineBanner() {
        step("Open yandex inline banner") {
            inline.tap()
        }
    }
    
    func openInterstitial() {
        step("Open yandex interstitial") {
            interstitial.tap()
        }
    }
    
    func openRewarded() {
        step("Open yandex rewarded") {
            rewarded.tap()
        }
    }
    
    func openNative() {
        step("Open yandex native") {
            native.tap()
        }
    }
    
    func openAppOpenAd() {
        step("Open yandex app open ad") {
            appOpenAd.tap()
        }
    }
    
    func openInstream() {
        step("Open instream") {
            instream.tap()
        }
    }
}
