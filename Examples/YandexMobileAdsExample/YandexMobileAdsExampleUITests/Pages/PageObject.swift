import XCTest

protocol PageObject {}

extension PageObject {
    var app: XCUIApplication { XCUIApplication() }
    
    func element(id: String, type: XCUIElement.ElementType = .any) -> XCUIElement {
        app.descendants(matching: type).matching(identifier: id).element
    }
}
