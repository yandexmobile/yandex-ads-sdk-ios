/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class CMPViewController: UIViewController {

    @IBOutlet private var resetButton: UIButton!
    @IBOutlet private var requestButton: UIButton!

    private var isRequesting: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        setupCMP()
        resetButton.addAction(UIAction { [weak self] _ in
            self?.resetConsentStatus()
        }, for: .primaryActionTriggered)
        requestButton.addAction(UIAction { [weak self] _ in
            self?.requestConsent()
        }, for: .primaryActionTriggered)
    }

    private func setupCMP() {
        MobileAds.consentManagementPlatform.setConsentFormPresentation(enabled: true)
        // This method simulates geolocation for testing purposes, allowing the Consent Management Form to be presented.
        // WARNING: Use only for debugging, not in production.
        MobileAds.consentManagementPlatform.setDebugParameters(.init(geography: .eea))
    }

    private func requestConsent() {
        guard !isRequesting else { return }
        isRequesting = true
        MobileAds.consentManagementPlatform.presentConsentFormIfRequired { [weak self] result in
            self?.handlePresentationResult(result)
            self?.isRequesting = false
        }
    }

    private func resetConsentStatus() {
        MobileAds.consentManagementPlatform.resetConsentStatus()
        presentAlert(title: "Reset", body: "Consent status successfully reset")
    }

    private func handlePresentationResult(_ result: YandexMobileAds.ConsentManagementPresentationResult) {
        let (title, message) = switch result {
        case .success:
            ("Success", "CMP form has been presented")
        case .notRequired:
            ("Consent not required", "User consent is either not required or has already been collected")
        case .presentationDisabled:
            ("Presentation disabled", "Consent form presentation is disabled")
        case .failure(let error):
            ("Error", "Consent form presentation failed with error: \(error.localizedDescription)")
        default:
            ("Error", "Something went wrong")
        }
        presentAlert(title: title, body: message)
    }

    private func presentAlert(title: String, body: String) {
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
}
