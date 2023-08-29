/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let adMobAdUnitID = "demo-rewarded-admob"
private let appLovinAdUnitID = "demo-rewarded-applovin"
private let ironSourceAdUnitID = "demo-rewarded-ironsource"
private let mintegralAdUnitID = "demo-rewarded-mintegral"
private let myTargetAdUnitID = "demo-rewarded-mytarget"
private let unityAdsAdUnitID = "demo-rewarded-unityads"
private let chartboostAdUnitID = "demo-rewarded-chartboost"
private let adColonyAdUnitID = "demo-rewarded-adcolony"
private let yandexAdUnitID = "demo-rewarded-yandex"

class MobileMediationRewardedViewController: UIViewController {
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
    private let rewardedAdLoader = YMARewardedAdLoader()

    @IBOutlet weak var showButton: UIButton!
    @IBOutlet private var pickerView: UIPickerView!
    
    private var rewardedAd: YMARewardedAd?
    
    @IBAction func loadAd() {
        self.showButton.isEnabled = false
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace adUnitID with actual Ad Unit ID.
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

        rewardedAdLoader.delegate = self
        rewardedAdLoader.loadAd(with: configuration)
    }
    
    @IBAction func presentAd() {
        rewardedAd?.delegate = self
        rewardedAd?.show(from: self)
        showButton.isEnabled = false
    }

    private func makeMessageDescription(_ rewarded: YMARewardedAd) -> String {
        "Rewarded Ad with Unit ID: \(String(describing: rewarded.adInfo?.adUnitId))"
    }
}

// MARK: - YMARewardedAdLoaderDelegate

extension MobileMediationRewardedViewController: YMARewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: YMARewardedAdLoader, didLoad rewardedAd: YMARewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) loaded")
        self.rewardedAd = rewardedAd
        self.showButton.isEnabled = true
    }

    func rewardedAdLoader(_ adLoader: YMARewardedAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
    }
}

// MARK: - YMARewardedAdDelegate

extension MobileMediationRewardedViewController: YMARewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        let message = "\(makeMessageDescription(rewardedAd)) did reward: \(reward.amount) \(reward.type)"
             let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
             self.presentedViewController?.present(alertController, animated: true, completion: nil)
             print(message)
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(rewardedAd)) failed to show. Error: \(error)")
    }

    func rewardedAdDidShow(_ rewardedAd: YMARewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did show")
    }

    func rewardedAdDidDismiss(_ rewardedAd: YMARewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did dismiss")
    }

    func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did click")
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("\(makeMessageDescription(rewardedAd)) did track impression")
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension MobileMediationRewardedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
