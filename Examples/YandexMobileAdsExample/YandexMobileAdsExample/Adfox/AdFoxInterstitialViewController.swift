/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class AdFoxInterstitialViewController: UIViewController {
    private let interstitialAdLoader = YMAInterstitialAdLoader()
    private var interstitialAd: YMAInterstitialAd?

    @IBOutlet private var showButton: UIButton!
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
        stateLabel.accessibilityIdentifier = CommonAccessibility.stateLabel
        showButton.accessibilityIdentifier = CommonAccessibility.presentButton
    }

    @IBAction func loadInterstitial() {
        self.showButton.isEnabled = false

        // Replace demo R-M-243655-9 with actual Ad Unit ID
        let requestConfiguration = YMAMutableAdRequestConfiguration(adUnitID: "R-M-243655-9")

        var parameters = Dictionary<String, String>()
        parameters["adf_ownerid"] = "270901"
        parameters["adf_p1"] = "caboi"
        parameters["adf_p2"] = "fkbc"
        parameters["adf_pfc"] = "bskug"
        parameters["adf_pfb"] = "fkjam"
        parameters["adf_pt"] = "b"

        requestConfiguration.parameters = parameters
        interstitialAdLoader.delegate = self
        interstitialAdLoader.loadAd(with: requestConfiguration)
    }

    @IBAction func presentInterstitial() {
        interstitialAd?.show(from: self)
        showButton.isEnabled = false
        presentedViewController?.view.accessibilityIdentifier = CommonAccessibility.bannerView
    }
    private func makeMessageDescription(_ interstitial: YMAInterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(String(describing: interstitial.adInfo?.adUnitId))"
    }
}

// MARK: - YMAInterstitialAdLoaderDelegate

extension AdFoxInterstitialViewController: YMAInterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didLoad interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) loaded")
        self.interstitialAd = interstitialAd
        self.showButton.isEnabled = true
        stateLabel.text = StateUtils.loaded()
    }

    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMARewardedAdDelegate

extension AdFoxInterstitialViewController: YMAInterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(interstitialAd)) failed to show. Error: \(error)")
    }

    func interstitialAdDidShow(_ interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did show")
    }

    func interstitialAdDidDismiss(_ interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did dismiss")
    }

    func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did click")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("\(makeMessageDescription(interstitialAd)) did track impression")
    }
}
