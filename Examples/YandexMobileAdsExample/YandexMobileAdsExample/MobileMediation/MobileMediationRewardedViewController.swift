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
private let bigoAdsAdUnitID = "demo-rewarded-bigoads"
private let inMobiAdUnitID = "demo-rewarded-inmobi"
private let startAppAdUnitID = "demo-rewarded-startapp"
private let vungleAdUnitID = "demo-rewarded-vungle"
private let yandexAdUnitID = "demo-rewarded-yandex"

class MobileMediationRewardedViewController: UIViewController {
#if COCOAPODS
    private let adUnitIDs = [
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
#else
    private let adUnitIDs = [
        (adapter: "AppLovin", adUnitID: appLovinAdUnitID),
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "MyTarget", adUnitID: myTargetAdUnitID),
        (adapter: "Vungle", adUnitID: vungleAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]
#endif
    private let rewardedAdLoader = RewardedAdLoader()

    @IBOutlet private var showButton: UIButton!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!
    
    private var rewardedAd: RewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateLabel.accessibilityIdentifier = CommonAccessibility.stateLabel
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
        showButton.accessibilityIdentifier = CommonAccessibility.presentButton
    }
    
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
        let configuration = AdRequestConfiguration(adUnitID: adUnitID)

        rewardedAdLoader.delegate = self
        rewardedAdLoader.loadAd(with: configuration)
        
        stateLabel.text = nil
    }
    
    @IBAction func presentAd() {
        rewardedAd?.delegate = self
        rewardedAd?.show(from: self)
        showButton.isEnabled = false
    }

    private func makeMessageDescription(_ rewarded: RewardedAd) -> String {
        "Rewarded Ad with Unit ID: \(String(describing: rewarded.adInfo?.adUnitId))"
    }
}

// MARK: - YMARewardedAdLoaderDelegate

extension MobileMediationRewardedViewController: RewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didLoad rewardedAd: RewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) loaded")
        self.rewardedAd = rewardedAd
        self.showButton.isEnabled = true
        stateLabel.text = StateUtils.loaded()
    }

    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMARewardedAdDelegate

extension MobileMediationRewardedViewController: RewardedAdDelegate {
    func rewardedAd(_ rewardedAd: RewardedAd, didReward reward: Reward) {
        let message = "\(makeMessageDescription(rewardedAd)) did reward: \(reward.amount) \(reward.type)"
             let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
             self.presentedViewController?.present(alertController, animated: true, completion: nil)
             print(message)
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(rewardedAd)) failed to show. Error: \(error)")
    }

    func rewardedAdDidShow(_ rewardedAd: RewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did show")
    }

    func rewardedAdDidDismiss(_ rewardedAd: RewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did dismiss")
    }

    func rewardedAdDidClick(_ rewardedAd: RewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did click")
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpressionWith impressionData: ImpressionData?) {
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
