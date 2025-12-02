/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

final class GDPRTest: BaseTest {
    private let adsPage = UnifiedAdsPage()
    private let dialog = GDPRDialogPage()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testAccept() {
        launchApp(extraArgs: [LaunchArgument.gdprResetOnLaunch])
        dialog.waitAppeared()
        dialog.tapAccept()
        adsPage.assertLogContains("GDPR: consent = true", timeout: 5)
    }

    func testDecline() {
        launchApp(extraArgs: [LaunchArgument.gdprResetOnLaunch])
        dialog.waitAppeared()
        dialog.tapDecline()
        adsPage.assertLogContains("GDPR: consent = false", timeout: 5)
    }

    func testAboutOpensSafari() {
        launchApp(extraArgs: [LaunchArgument.gdprResetOnLaunch])
        dialog.waitAppeared()
        dialog.tapAbout()
        assertSafariOpened()
    }
}
