/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAdsInstream

class InstreamAdBinderToastDelegate {
    private let toastLabel: UILabel

    init(toastLabel: UILabel) {
        self.toastLabel = toastLabel
    }
}

// MARK: - InstreamAdBinderDelegate

extension InstreamAdBinderToastDelegate: InstreamAdBinderDelegate {
    func instreamAdBinder(_ binder: InstreamAdBinder, didComplete instreamAd: InstreamAd) {
        displayToast(with: "ad didComplete")
    }

    func instreamAdBinder(_ binder: InstreamAdBinder, didPrepare instreamAd: InstreamAd) {
        displayToast(with: "ad didPrepare")
    }

    func instreamAdBinder(_ binder: InstreamAdBinder, didFailToPlay instreamAd: InstreamAd, with error: Error) {
        displayToast(with: "ad didFailToPlay")
    }

    // MARK: - Private

    private func displayToast(with message: String, delay: TimeInterval = 3) {
        toastLabel.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.toastLabel.text = ""
        }
    }
}
