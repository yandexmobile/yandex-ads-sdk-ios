/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class AdFoxBannerViewController: UIViewController {
    var adView: AdView!
    
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let adSize = BannerAdSize.inlineSize(withWidth: 300, maxHeight: 300)
        // Replace demo demo-banner-adfox-image with actual Ad Unit ID
        self.adView = AdView(adUnitID: "demo-banner-adfox-image", adSize: adSize)
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
        let request = MutableAdRequest()
        request.parameters = parameters

        self.adView.loadAd(with: request)
        
        stateLabel.text = nil
    }
}

extension AdFoxBannerViewController: AdViewDelegate {
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }

    func adViewDidLoad(_ adView: AdView) {
        self.adView.displayAtBottom(in: self.view)
        print("Ad loaded")        
        stateLabel.text = StateUtils.loaded()
    }

    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        print("Ad failed loading. Error: \(error)")
        stateLabel.text = StateUtils.loadError(error)
    }

    func adViewWillLeaveApplication(_ adView: AdView) {
        print("Ad will leave application")
    }

    func adView(_ adView: AdView, willPresentScreen viewController: UIViewController?) {
        print("Ad will present screen")
    }

    func adView(_ adView: AdView, didDismissScreen viewController: UIViewController?) {
        print("Ad did dismiss screen")
    }

}
