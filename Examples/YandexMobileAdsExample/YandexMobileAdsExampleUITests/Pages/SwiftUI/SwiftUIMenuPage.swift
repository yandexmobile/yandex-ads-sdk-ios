import XCTest

struct SwiftUIMenuPage: PageObject {

    func tapSwiftUIExamples() {
        step("Tap SwiftUI Examples button") {
            let button = app.buttons[CommonAccessibility.swiftUIExamplesButton]
            XCTAssertTrue(button.waitForExistence(timeout: 5), "SwiftUI Examples button not found")
            button.tap()
        }
    }

    func tapAdType(_ name: String) {
        step("Tap SwiftUI ad type: \(name)") {
            let item = app.staticTexts[name].firstMatch
            XCTAssertTrue(item.waitForExistence(timeout: 5), "'\(name)' row not found in SwiftUI menu")
            item.tap()
        }
    }
}
