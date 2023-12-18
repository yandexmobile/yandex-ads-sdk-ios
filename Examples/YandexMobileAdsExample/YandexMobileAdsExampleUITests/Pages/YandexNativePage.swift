import XCTest

struct YandexNativePage: PageObject {
    var custom: XCUIElement { element(id: YandexNativeAccessibility.custom, type: .cell) }
    var template: XCUIElement { element(id: YandexNativeAccessibility.template, type: .cell) }
    
    func openCustom() {
        step("Open custom") {
            custom.tap()
        }
    }
    
    func openTemplate() {
        step("Open template") {
            template.tap()
        }
    }
}
