
import Foundation
import FBAudienceNetwork

class MediationTestsConfigurator {
    static func enableTestMode() {
        STAStartAppSDK.sharedInstance().testAdsEnabled = true
        FBAdSettings.setAdvertiserTrackingEnabled(true)
    }
}
