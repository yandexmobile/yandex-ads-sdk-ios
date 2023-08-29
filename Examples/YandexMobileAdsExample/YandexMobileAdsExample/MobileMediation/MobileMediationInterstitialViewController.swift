/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let adMobAdUnitID = "demo-interstitial-admob"
private let appLovinAdUnitID = "demo-interstitial-applovin"
private let ironSourceAdUnitID = "demo-interstitial-ironsource"
private let mintegralAdUnitID = "demo-interstitial-mintegral"
private let myTargetAdUnitID = "demo-interstitial-mytarget"
private let unityAdsAdUnitID = "demo-interstitial-unityads"
private let chartboostAdUnitID = "demo-interstitial-chartboost"
private let adColonyAdUnitID = "demo-interstitial-adcolony"
private let yandexAdUnitID = "demo-interstitial-yandex"

class MobileMediationInterstitialViewController: UIViewController {
    private let adUnitIDs = [
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "AppLovin", adUnitID: appLovinAdUnitID),
        (adapter: "IronSource", adUnitID: ironSourceAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "MyTarget", adUnitID: myTargetAdUnitID),
        (adapter: "UnityAds", adUnitID: unityAdsAdUnitID),
        (adapter: "Chartboost", adUnitID: chartboostAdUnitID),
        (adapter: "AdColony", adUnitID: adColonyAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]
    private let interstitialAdLoader = YMAInterstitialAdLoader()
    
    @IBOutlet private var showButton: UIButton!
    @IBOutlet private var pickerView: UIPickerView!

    private var interstitialAd: YMAInterstitialAd?

    @IBAction func loadAd(_ sender: UIButton) {
        showButton.isEnabled = false
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace demo adUnitID with actual Ad Unit ID.
         Following demo ad unit ids may be used for testing:
         AdMob mediation: adMobAdUnitID
         AppLovin mediation: appLovinAdUnitID
         IronSource mediation: ironSourceAdUnitID
         MyTarget mediation: myTargetAdUnitID
         UnityAds mediation: unityAdsAdUnitID
         Yandex: yandexAdUnitID
         */
        let adUnitID = adUnitIDs[selectedIndex].adUnitID
        let configuration = YMAAdRequestConfiguration(adUnitID: adUnitID)

        interstitialAdLoader.delegate = self
        interstitialAdLoader.loadAd(with: configuration)
    }

    @IBAction func presentAd(_ sender: UIButton) {
        interstitialAd?.delegate = self
        interstitialAd?.show(from: self)
        showButton.isEnabled = false
    }

    private func makeMessageDescription(_ interstitial: YMAInterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(String(describing: interstitial.adInfo?.adUnitId))"
    }
}

// MARK: - YMAInterstitialAdLoaderDelegate

extension MobileMediationInterstitialViewController: YMAInterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didLoad interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) loaded")
        self.interstitialAd = interstitialAd
        self.showButton.isEnabled = true
    }

    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
    }
}

// MARK: - YMARewardedAdDelegate

extension MobileMediationInterstitialViewController: YMAInterstitialAdDelegate {
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

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension MobileMediationInterstitialViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return adUnitIDs.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return adUnitIDs[row].adapter
    }
}
