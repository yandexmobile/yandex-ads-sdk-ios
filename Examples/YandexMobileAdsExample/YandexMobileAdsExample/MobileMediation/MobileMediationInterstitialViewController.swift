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
private let yandexAdUnitID = "demo-interstitial-yandex"

class MobileMediationInterstitialViewController: UIViewController {
    private let adUnitIDs = [
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "AppLovin", adUnitID: appLovinAdUnitID),
        (adapter: "IronSource", adUnitID: ironSourceAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "myTarget", adUnitID: myTargetAdUnitID),
        (adapter: "UnityAds", adUnitID: unityAdsAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]
    
    @IBOutlet private var showButton: UIButton!
    @IBOutlet private var pickerView: UIPickerView!

    private var interstitialAd: YMAInterstitialAd?

    @IBAction func loadAd(_ sender: UIButton) {
        self.showButton.isEnabled = false
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
        interstitialAd = YMAInterstitialAd(adUnitID: adUnitID)
        interstitialAd?.delegate = self
        interstitialAd?.load()
    }

    @IBAction func presentAd(_ sender: UIButton) {
        interstitialAd?.present(from: self)
    }
}

// MARK: - YMAInterstitialDelegate

extension MobileMediationInterstitialViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitial: YMAInterstitialAd) {
        self.showButton.isEnabled = true
        print("Interstitial did load ad")
    }

    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        print("Interstitial did fail to load ad with error: \(String(describing: error))")
    }

    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        print("Interstitial did fail to present ad with error: \(String(describing: error))")
    }

    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        print("interstitial will leave application")
    }

    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        print("interstitial ad will appear")
    }

    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        print("interstitial ad did appeard")
    }

    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("interstitital ad will disappear")
    }

    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("interstitial ad did disappear")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        print("interstitial ad will present screen")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("interstitial ad did track impression")
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
