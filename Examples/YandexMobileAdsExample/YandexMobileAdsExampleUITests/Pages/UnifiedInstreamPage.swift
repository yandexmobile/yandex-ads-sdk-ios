/*
* Version for iOS © 2015–2025 YANDEX
*
* You may not use this file except in compliance with the License.
* You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
*/

import XCTest

struct UnifiedInstreamPage: PageObject {
    private let app = XCUIApplication()
    
    var prepareButton: XCUIElement {
        app.buttons[YandexInstreamAccessibility.prepareButton]
    }
    var presentButton: XCUIElement {
        app.buttons[YandexInstreamAccessibility.presentButton]
    }
    var startPlaybackButton: XCUIElement {
        app.buttons[YandexInstreamAccessibility.startPlaybackButton]
    }
    var playInrollButton: XCUIElement {
        app.buttons[YandexInstreamAccessibility.playInrollButton]
    }
    var pauseInrollButton: XCUIElement {
        app.buttons[YandexInstreamAccessibility.pauseInrollButton]
    }
    var resumeInrollButton: XCUIElement {
        app.buttons[YandexInstreamAccessibility.resumeInrollButton]
    }
    
    var goButton: XCUIElement {
        app
            .descendants(matching: .button)
            .matching(Query.contains(.label, "Go").predicate)
            .firstMatch
    }
    
    var skipButton: XCUIElement {
        app
            .descendants(matching: .staticText)
            .matching(Query.contains(.label, "Skip").predicate)
            .firstMatch
    }
    
    func tapPrepare() {
        prepareButton.tap()
    }
    
    func tapPresent() {
        presentButton.tap()
    }
    
    func tapStartPlayback() {
        startPlaybackButton.tap()
    }
    
    func tapPlayInroll() {
        playInrollButton.tap()
    }
    
    func tapPauseInroll() {
        pauseInrollButton.tap()
    }
    
    func tapResumeInroll() {
        resumeInrollButton.tap()
    }
    
    func tapGo() {
        goButton.tap()
    }
    
    func tapSkip() {
        skipButton.tap()
    }
    
    func waitForPrepare(_ t: TimeInterval = 10) {
        XCTAssertTrue(prepareButton.waitForExistence(timeout: t), "prepare_button not found")
    }
    
    func waitForPresent(_ t: TimeInterval = 10) {
        XCTAssertTrue(presentButton.waitForExistence(timeout: t), "present_button not found")
    }
    
    func waitForStartPlayback(_ t: TimeInterval = 10) {
        XCTAssertTrue(startPlaybackButton.waitForExistence(timeout: t), "start_playback_button not found")
    }
    
    func waitForPlayInroll(_ t: TimeInterval = 10) {
        XCTAssertTrue(playInrollButton.waitForExistence(timeout: t), "play_inroll_button not found")
    }
    
    func waitForPauseInroll(_ t: TimeInterval = 10) {
        XCTAssertTrue(pauseInrollButton.waitForExistence(timeout: t), "pause_inroll_button not found")
    }
    
    func waitForResumeInroll(_ t: TimeInterval = 10) {
        XCTAssertTrue(resumeInrollButton.waitForExistence(timeout: t), "resume_inroll_button not found")
    }
}
