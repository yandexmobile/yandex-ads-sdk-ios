import XCTest

struct YandexInstreamListPage: PageObject {
    var singleInstream: XCUIElement { element(id: YandexInstreamListAccessibility.singleInstream, type: .cell) }
    var inroll: XCUIElement { element(id: YandexInstreamListAccessibility.inroll, type: .cell) }
    
    func openInroll() {
        step("Open inroll") {
            inroll.tap()
        }
    }
    
    func openSingleInstream() {
        step("Open single instream") {
            singleInstream.tap()
        }
    }
}
