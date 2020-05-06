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

    override func viewDidLoad() {
        super.viewDidLoad()
        let adSize = YMAAdSize.flexibleSize(withContainerWidth: self.containerWidth())
        // Replace demo R-M-DEMO-adaptive-sticky with actual Block ID
        adView = YMAAdView(blockID: "R-M-DEMO-adaptive-sticky", adSize: adSize, delegate: self)
        self.addAdView()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        guard let adView = adView else { return }
        adView.isHidden = true
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

    private func addAdView() {
        guard let adView = adView else { return }
        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)
        let views = ["adView": adView]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[adView]|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[adView]-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        view.addConstraints(horizontal + vertical)
    }

}

// MARK: - YMAAdViewDelegate

extension ViewController: YMAAdViewDelegate {

    func adViewDidLoad(_ adView: YMAAdView!) {
        print("Ad loaded")
        adView.isHidden = false
    }

    func adViewDidFailLoading(_ adView: YMAAdView!, error: Error!) {
        print("Ad failed loading. Error: \(error!)")
    }

}
