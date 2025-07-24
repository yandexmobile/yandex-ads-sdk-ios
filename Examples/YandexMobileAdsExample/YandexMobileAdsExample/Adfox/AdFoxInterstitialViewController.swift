/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class AdFoxInterstitialViewController: UIViewController {
    private let interstitialAdLoader = InterstitialAdLoader()
    private var interstitialAd: InterstitialAd?

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

        // Replace demo demo-interstitial-adfox-image with actual Ad Unit ID
        let requestConfiguration = MutableAdRequestConfiguration(adUnitID: "demo-interstitial-adfox-image")

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
    }
    private func makeMessageDescription(_ interstitial: InterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(String(describing: interstitial.adInfo?.adUnitId))"
    }
}

// MARK: - YMAInterstitialAdLoaderDelegate

extension AdFoxInterstitialViewController: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) loaded")
        self.interstitialAd = interstitialAd
        interstitialAd.delegate = self
        self.showButton.isEnabled = true
        stateLabel.text = StateUtils.loaded()
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMARewardedAdDelegate

extension AdFoxInterstitialViewController: InterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(interstitialAd)) failed to show. Error: \(error)")
    }

    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        presentedViewController?.view.accessibilityIdentifier = CommonAccessibility.bannerView
        print("\(makeMessageDescription(interstitialAd)) did show")
    }

    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did dismiss")
    }

    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did click")
    }

    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("\(makeMessageDescription(interstitialAd)) did track impression")
    }
}
