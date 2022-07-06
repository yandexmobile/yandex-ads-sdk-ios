
import Foundation

class MediationTestsConfigurator {
    static func enableTestMode() {
        STAStartAppSDK.sharedInstance().testAdsEnabled = true
    }
}
