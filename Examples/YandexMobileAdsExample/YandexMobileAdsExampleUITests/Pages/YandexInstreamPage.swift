/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

struct YandexInstreamPage: PageObject {
    var loadButton: XCUIElement { element(id: CommonAccessibility.loadButton, type: .button) }
    var prepareButton: XCUIElement { element(id: YandexInstreamAccessibility.prepareButton, type: .button) }
    var presentButton: XCUIElement { element(id: CommonAccessibility.presentButton, type: .button) }
    var stateLabel: XCUIElement { element(id: CommonAccessibility.stateLabel, type: .staticText) }
    var startPlaybackButton: XCUIElement { element(id: YandexInstreamAccessibility.startPlaybackButton, type: .button) }
    var playInrollButton: XCUIElement { element(id: YandexInstreamAccessibility.playInrollButton, type: .button) }
    var pauseInrollButton: XCUIElement { element(id: YandexInstreamAccessibility.pauseInrollButton, type: .button) }
    var resumeInrollButton: XCUIElement { element(id: YandexInstreamAccessibility.resumeInrollButton, type: .button) }

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

    func tapLoadAd() {
        step("Tap load ad") {
            loadButton.tap()
        }
    }

    func tapPrepareAd() {
        step("Tap prepare ad") {
            prepareButton.tap()
        }
    }

    func tapPresentAd() {
        step("Tap present") {
            presentButton.tap()
        }
    }

    func tapGo() {
        step("Tap go") {
            goButton.tap()
        }
    }

    func tapSkip() {
        step("Tap skip") {
            skipButton.tap()
        }
    }

    func tapStartPlayback() {
        step("Tap start playback") {
            startPlaybackButton.tap()
        }
    }

    func tapPlayInroll() {
        step("Tap play inroll") {
            playInrollButton.tap()
        }
    }

    func tapPauseInroll() {
        step("Tap pause inroll") {
            pauseInrollButton.tap()
        }
    }

    func tapResumeInroll() {
        step("Tap resume inroll") {
            resumeInrollButton.tap()
        }
    }
}
