/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let adMobBlockID = "adf-279013/975869"
private let appLovinBlockID = "adf-279013/1052107"
private let facebookBlockID = "adf-279013/975872"
private let ironSourceBlockID = "adf-279013/1052109"
private let moPubBlockID = "adf-279013/975870"
private let myTargetBlockID = "adf-279013/975871";
private let startAppBlockID = "adf-279013/1006406"
private let unityAdsBlockID = "adf-279013/1006439"
private let yandexBlockID = "adf-279013/975873"

class MobileMediationInterstitialViewController: UIViewController {
    private let blockIDs = [
        (adapter: "AdMob", blockID: adMobBlockID),
        (adapter: "AppLovin", blockID: appLovinBlockID),
        (adapter: "Facebook", blockID: facebookBlockID),
        (adapter: "IronSource", blockID: ironSourceBlockID),
        (adapter: "MoPub", blockID: moPubBlockID),
        (adapter: "myTarget", blockID: myTargetBlockID),
        (adapter: "StartApp", blockID: startAppBlockID),
        (adapter: "UnityAds", blockID: unityAdsBlockID),
        (adapter: "Yandex", blockID: yandexBlockID)
    ]
    
    @IBOutlet private var showButton: UIButton!
    @IBOutlet private var pickerView: UIPickerView!

    private var interstitialAd: YMAInterstitialAd?

    override func viewDidLoad() {
        MediationTestsConfigurator.enableTestMode()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        self.showButton.isEnabled = false
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace demo AdMobBlockID with actual Block ID.
         Following demo block ids may be used for testing:
         AdMob mediation: adMobBlockID
         AppLovin mediation: appLovinBlockID
         Facebook mediation: facebookBlockID
         IronSource mediation: ironSourceBlockID
         MoPub mediation: moPubBlockID
         MyTarget mediation: myTargetBlockID
         StartApp mediation: startAppBlockID
         UnityAds mediation: unityAdsBlockID
         Yandex: yandexBlockID
         */
        let blockID = blockIDs[selectedIndex].blockID
        interstitialAd = YMAInterstitialAd(blockID: blockID)
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
        return blockIDs.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return blockIDs[row].adapter
    }
}
