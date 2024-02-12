/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class AdFoxBannerViewController: UIViewController {
    var adView: YMAAdView!
    
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let adSize = YMABannerAdSize.inlineSize(withWidth: 320, maxHeight: 100)
        // Replace demo R-M-243655-8 with actual Ad Unit ID
        self.adView = YMAAdView(adUnitID: "R-M-243655-8", adSize: adSize)
        self.adView.delegate = self
        adView.accessibilityIdentifier = CommonAccessibility.bannerView
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
        stateLabel.accessibilityIdentifier = CommonAccessibility.stateLabel
    }

    @IBAction func loadAd() {
        self.adView.removeFromSuperview()
        var parameters = Dictionary<String, String>()
        parameters["adf_ownerid"] = "270901"
        parameters["adf_p1"] = "cafol"
        parameters["adf_p2"] = "fhma"
        parameters["adf_pfc"] = "bskug"
        parameters["adf_pfb"] = "flrlu"
        parameters["adf_pt"] = "b"
        let request = YMAMutableAdRequest()
        request.parameters = parameters

        self.adView.loadAd(with: request)
        
        stateLabel.text = nil
    }
}

extension AdFoxBannerViewController: YMAAdViewDelegate {
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }

    func adViewDidLoad(_ adView: YMAAdView) {
        self.adView.displayAtBottom(in: self.view)
        print("Ad loaded")        
        stateLabel.text = StateUtils.loaded()
    }

    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print("Ad failed loading. Error: \(error)")
        stateLabel.text = StateUtils.loadError(error)
    }

    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        print("Ad will leave application")
    }

    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        print("Ad will present screen")
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        print("Ad did dismiss screen")
    }

}
