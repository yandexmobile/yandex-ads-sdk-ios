import XCTest

struct RootPage: PageObject {
    typealias Keys = RootAccessibility

    var yandex: XCUIElement { element(id: Keys.yandex, type: .cell) }
    var mobileMediation: XCUIElement { element(id: Keys.mobileMediation, type: .cell) }
    var thirdPartyMediation: XCUIElement { element(id: Keys.thirdPartyMediation, type: .cell) }
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
