import XCTest

struct SwiftUIMenuPage: PageObject {

    func tapSwiftUIExamples() {
        step("Tap SwiftUI tab") {
            let tab = app.tabBars.buttons["SwiftUI"]
            XCTAssertTrue(tab.waitForExistence(timeout: 5), "SwiftUI tab not found")
            tab.tap()
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
