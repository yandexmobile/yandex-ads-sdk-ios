/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAds

final class GDPRUserConsentManager {
    private let gdprUserConsentKey = "gdpr_user_consent"
    private let gdprShouldShowDialogKey = "gdpr_show_dialog"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func initializeUserDefaults() {
        if userDefaults.object(forKey: gdprShouldShowDialogKey) == nil {
            userDefaults.set(true, forKey: gdprShouldShowDialogKey)
        }
        setUserConsent(userConsent)
    }

    var userConsent : Bool {
        get {
            return userDefaults.bool(forKey: gdprUserConsentKey)
        }
        set {
            userDefaults.set(newValue, forKey: gdprUserConsentKey)
            setUserConsent(newValue)
        }
    }

    var showDialog : Bool {
        get {
            return userDefaults.bool(forKey: gdprShouldShowDialogKey)
        }
        set {
            userDefaults.set(newValue, forKey: gdprShouldShowDialogKey)
        }
    }

    private func setUserConsent(_ consent: Bool) {
        MobileAds.setUserConsent(consent)
    }
}
