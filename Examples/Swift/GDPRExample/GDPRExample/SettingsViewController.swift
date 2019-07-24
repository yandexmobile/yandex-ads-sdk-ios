/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class SettingsViewController: UIViewController {
    @IBOutlet weak var userConsentSwitch: UISwitch!

    private let gdprManager: GDPRUserConsentManager

    init(gdprManager: GDPRUserConsentManager) {
        self.gdprManager = gdprManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userConsentSwitch.isOn = gdprManager.userConsent
    }

    @IBAction func userConsentDidChange(_ sender: UISwitch) {
       setUserConsent(sender.isOn)
    }

    @IBAction func resetUserConsent(_ sender: UIButton) {
        setUserConsent(false)
        userConsentSwitch.setOn(false, animated: true)
        gdprManager.showDialog = true
    }

    private func setUserConsent(_ consent : Bool) {
        gdprManager.userConsent = consent
    }
}
