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
private let bigoAdsAdUnitID = "demo-interstitial-bigoads"
private let inMobiAdUnitID = "demo-interstitial-inmobi"
private let startAppAdUnitID = "demo-interstitial-startapp"
private let vungleAdUnitID = "demo-interstitial-vungle"
private let yandexAdUnitID = "demo-interstitial-yandex"

class MobileMediationInterstitialViewController: UIViewController {
    private let adUnitIDs = [
        (adapter: "AdColony", adUnitID: adColonyAdUnitID),
        (adapter: "AppLovin", adUnitID: appLovinAdUnitID),
        (adapter: "BigoAds", adUnitID: bigoAdsAdUnitID),
        (adapter: "Chartboost", adUnitID: chartboostAdUnitID),
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "InMobi", adUnitID: inMobiAdUnitID),
        (adapter: "IronSource", adUnitID: ironSourceAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "MyTarget", adUnitID: myTargetAdUnitID),
        (adapter: "StartApp", adUnitID: startAppAdUnitID),
        (adapter: "UnityAds", adUnitID: unityAdsAdUnitID),
        (adapter: "Vungle", adUnitID: vungleAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]
    private let interstitialAdLoader = InterstitialAdLoader()
    
    @IBOutlet private var showButton: UIButton!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!

    private var adView: AdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateLabel.accessibilityIdentifier = CommonAccessibility.stateLabel
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
        showButton.accessibilityIdentifier = CommonAccessibility.presentButton
    }

    private var interstitialAd: InterstitialAd?

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
        let configuration = AdRequestConfiguration(adUnitID: adUnitID)

        interstitialAdLoader.delegate = self
        interstitialAdLoader.loadAd(with: configuration)
        
        stateLabel.text = nil
    }

    @IBAction func presentAd(_ sender: UIButton) {
        interstitialAd?.delegate = self
        interstitialAd?.show(from: self)
        showButton.isEnabled = false
    }

    private func makeMessageDescription(_ interstitial: InterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(String(describing: interstitial.adInfo?.adUnitId))"
    }
}

// MARK: - YMAInterstitialAdLoaderDelegate

extension MobileMediationInterstitialViewController: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) loaded")
        self.interstitialAd = interstitialAd
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

extension MobileMediationInterstitialViewController: InterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(interstitialAd)) failed to show. Error: \(error)")
    }

    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
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
