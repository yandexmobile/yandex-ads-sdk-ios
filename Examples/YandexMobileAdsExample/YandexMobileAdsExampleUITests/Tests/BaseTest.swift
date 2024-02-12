import XCTest

class BaseTest: XCTestCase {
    let app = XCUIApplication()
    
    let rootPage = RootPage()
    let yandexAdsPage = YandexAdsPage()
    
    func launchApp() {
        step("Launch app") {
            app.launch()
        }
    }
    
    func assertSafariOpened() {
        step("Check safari app opened") {
            XCTAssertTrue(XCUIApplication.safari.wait(for: .runningForeground, timeout: 10))
        }
    }
    
    func leaveApp() {
        step("Leave app") {
            XCUIDevice.shared.press(.home)
        }
    }
    
    func returnToApp() {
        step("Return to app") {
            app.activate()
        }
    }
    
    func goBack() {
        step("Go to previous screen") {
            app.navigationBars.element.buttons.firstMatch.tap()
        }
    }
    
    func assertAdLoaded(stateLabel: XCUIElement) throws {
        try step("Check ad loaded") {
            let noAdsError = "Ad request completed successfully, but there are no ads available."
            let noAdsQueury: Query = .begins(.label, StateUtils.loadErrorPrefix) && .contains(.label, noAdsError)
            let query: Query = .begins(.label, StateUtils.loaded()) || noAdsQueury
            if elementMatches(stateLabel, query: query, timeout: 10) {
                if elementMatches(stateLabel, query: noAdsQueury) {
                    throw XCTSkip("No ads")
                }
            } else {
                XCTFail("\(stateLabel.label) does not match \(query.string)")
            }
        }
    }
        
    func elementMatches(_ element: XCUIElement, query: Query, timeout: TimeInterval) -> Bool {
        let predictate = query.predicate
        let expectation = expectation(for: predictate, evaluatedWith: element)
        let waiter = XCTWaiter()
        let result = waiter.wait(for: [expectation], timeout: timeout)
        switch result {
        case .completed:
            return true
        default:
            return false
        }
    }
    
    func elementMatches(_ element: XCUIElement, query: Query) -> Bool {
        let predictate = query.predicate
        return predictate.evaluate(with: element)
    }
}

extension XCUIApplication {
    static let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
}

@discardableResult
func step<T>(
    _ name: String,
    _ block: () throws -> T
) rethrows -> T {
    try XCTContext.runActivity(named: name) { _ in
        try block()
    }
}

enum Query {
    enum Operand {
        case label
        case exists
        
        var string: String {
            switch self {
            case .label:
                return "label"
            case .exists:
                return "exists"
            }
        }
    }
    
    case equals(Operand, String, Bool)
    case begins(Operand, String)
    case contains(Operand, String)
    indirect case and(Self, Self)
    indirect case or(Self, Self)
    
    static var exists: Self {
        .equals(.exists, "1", false)
    }
    
    static var notExists: Self {
        .equals(.exists, "0", false)
    }
    
    var string: String {
        switch self {
        case let .equals(operand, string, escape):
            let rhs = escape ? "'\(string)'" : "\(string)"
            return "(\(operand.string) == \(rhs))"
        case let .begins(operand, string):
            return "(\(operand.string) BEGINSWITH '\(string)')"
        case let .contains(operand, string):
            return "(\(operand.string) CONTAINS '\(string)')"
        case .and(let lhs, let rhs):
            return "(\(lhs.string) AND \(rhs.string))"
        case .or(let lhs, let rhs):
            return "(\(lhs.string) OR \(rhs.string))"
        }
    }
    
    var predicate: NSPredicate {
        .init(format: string)
    }
}

func ||(lhs: Query, rhs: Query) -> Query {
    .or(lhs, rhs)
}

func &&(lhs: Query, rhs: Query) -> Query {
    .and(lhs, rhs)
}
