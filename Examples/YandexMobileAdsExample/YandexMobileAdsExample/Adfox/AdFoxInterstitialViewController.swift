/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class AdFoxInterstitialViewController: UIViewController {
    @IBOutlet weak var showButton: UIButton!
    var interstitialAd: YMAInterstitialAd!

    @IBAction func loadInterstitial() {
        self.showButton.isEnabled = false
        // Replace demo R-M-243655-9 with actual Block ID
        self.interstitialAd = YMAInterstitialAd(blockID: "R-M-243655-9")
        self.interstitialAd.delegate = self;

        var parameters = Dictionary<String, String>()
        parameters["adf_ownerid"] = "270901"
        parameters["adf_p1"] = "caboi"
        parameters["adf_p2"] = "fkbc"
        parameters["adf_pfc"] = "bskug"
        parameters["adf_pfb"] = "fkjam"
        parameters["adf_pt"] = "b"
        let request = YMAMutableAdRequest()
        request.parameters = parameters

        self.interstitialAd.load(with: request)
    }

    @IBAction func presentInterstitial() {
        self.interstitialAd.present(from: self)
    }

}

extension AdFoxInterstitialViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        self.showButton.isEnabled = true
        print("Ad loaded")
    }

    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        print("Loading failed. Error: \(error)")
    }

    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        print("Will leave application")
    }

    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        print("Failed to present interstitial. Error: \(error)")
    }

    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will appear")
    }

    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did appear")
    }

    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will disappear")
    }

    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did disappear")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        print("Interstitial ad will present screen")
    }
}
