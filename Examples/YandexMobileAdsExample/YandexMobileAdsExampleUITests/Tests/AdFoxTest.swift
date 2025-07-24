/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import XCTest

final class AdFoxTest: BaseTest {
    let adFoxPage = AdFoxPage()
    let adPage = AdFoxAdPage()
    
    func testBanner() throws {
        launchApp()
        rootPage.openAdFox()
        adFoxPage.openBanner()
        adPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: adPage.stateLabel) else { return }
        adPage.assertAdDisplayed()
        adPage.tapAd()
        assertSafariOpened()
    }
    
    func testNative() throws {
        launchApp()
        rootPage.openAdFox()
        adFoxPage.openNative()
        adPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: adPage.stateLabel) else { return }
        adPage.assertAdDisplayed()
        adPage.tapAd()
        assertSafariOpened()
    }
    
    func testInterstitial() throws {
        launchApp()
        rootPage.openAdFox()
        adFoxPage.openInterstitial()
        adPage.tapLoadAd()
        guard assertAdLoaded(stateLabel: adPage.stateLabel) else { return }
        adPage.tapPresentAd()
        adPage.assertAdDisplayed()
        adPage.tapAd()
        assertSafariOpened()
    }
}
