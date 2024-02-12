import XCTest

final class GDPRTest: BaseTest {
    let examplePage = GDPRExamplePage()
    let settingsPage = GDPRSettingsPage()
    let dialogPage = GDPRDialogPage()
    
    func testDecline() {
        launchApp()
        rootPage.openGDPR()
        examplePage.tapSettings()
        settingsPage.tapReset()
        goBack()
        examplePage.tapLoadAd()
        dialogPage.tapAccept()
        examplePage.tapSettings()
        XCTAssertTrue(settingsPage.consentSwitch.switchValue, "Switch should be on")
    }
    
    func testAccept() {
        launchApp()
        rootPage.openGDPR()
        examplePage.tapSettings()
        settingsPage.tapReset()
        goBack()
        examplePage.tapLoadAd()
        dialogPage.tapDecline()
        examplePage.tapSettings()
        XCTAssertFalse(settingsPage.consentSwitch.switchValue, "Switch should be off")
    }
    
    func testAbout() {
        launchApp()
        rootPage.openGDPR()
        examplePage.tapSettings()
        settingsPage.tapReset()
        goBack()
        examplePage.tapLoadAd()
        dialogPage.tapAbout()
        assertSafariOpened()
    }
}
