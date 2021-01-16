/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

protocol GDPRDialogDelegate: NSObject {
    func dialogDidDismiss(_ dialog: GDPRDialogViewController)
}

class GDPRDialogViewController: UIViewController {
    private let gdprManager: GDPRUserConsentManager

    weak private var delegate: GDPRDialogDelegate?

    init(delegate: GDPRDialogDelegate, gdprManager: GDPRUserConsentManager) {
        self.delegate = delegate
        self.gdprManager = gdprManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func about(_ sender: UIButton) {
        let url = URL(string: "https://yandex.com/legal/confidential/")!
        UIApplication.shared.openURL(url)
    }

    @IBAction func decline(_ sender: UIButton) {
        setUserConsent(false)
        dismiss()
    }

    @IBAction func accept(_ sender: UIButton) {
        setUserConsent(true)
        dismiss()
    }

    private func setUserConsent(_ consent: Bool) {
        //Make sure you store user consent value
        gdprManager.userConsent = consent
    }

    private func dismiss() {
        gdprManager.showDialog = false
        self.dismiss(animated: true) { [weak self] in
            if let self = self {
                self.delegate?.dialogDidDismiss(self)
            }
        }
    }
}
