/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {

    var adView: YMAAdView?

    @IBAction func loadAd(_ sender: UIButton) {
        adView?.removeFromSuperview()

        let adSize = YMAAdSize.flexibleSize(withContainerWidth: self.containerWidth())
        // Replace demo R-M-DEMO-adaptive-sticky with actual Block ID
        let adView = YMAAdView(blockID: "R-M-DEMO-adaptive-sticky", adSize: adSize)
        self.adView = adView
        adView.delegate = self
        adView.displayAtBottom(in: self.view)
        adView.loadAd()
    }

    private func containerWidth() -> CGFloat {
        let containerWidth: CGFloat
        if #available(iOS 11.0, *) {
            containerWidth = view.frame.inset(by: view.safeAreaInsets).size.width
        } else {
            containerWidth = view.frame.size.width
        }
        return containerWidth
    }

}

// MARK: - YMAAdViewDelegate

extension ViewController: YMAAdViewDelegate {

    func adViewDidLoad(_ adView: YMAAdView) {
        print("Ad loaded")
    }

    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print("Ad failed loading. Error: \(error)")
    }

}
