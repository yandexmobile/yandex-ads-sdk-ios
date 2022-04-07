/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let adMobAdUnitID = "adf-279013/966332"
private let appLovinAdUnitID = "adf-279013/1052108"
private let facebookAdUnitID = "adf-279013/966335"
private let ironSourceAdUnitID = "adf-279013/1052110"
private let myTargetAdUnitID = "adf-279013/966334"
private let startAppAdUnitID = "adf-279013/1006617"
private let unityAdsAdUnitID = "adf-279013/1006614"
private let yandexAdUnitID = "adf-279013/967178"

class MobileMediationRewardedViewController: UIViewController {
    private let adUnitIDs = [
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "AppLovin", adUnitID: appLovinAdUnitID),
        (adapter: "Facebook", adUnitID: facebookAdUnitID),
        (adapter: "IronSource", adUnitID: ironSourceAdUnitID),
        (adapter: "myTarget", adUnitID: myTargetAdUnitID),
        (adapter: "StartApp", adUnitID: startAppAdUnitID),
        (adapter: "UnityAds", adUnitID: unityAdsAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]

    @IBOutlet weak var showButton: UIButton!
    @IBOutlet private var pickerView: UIPickerView!
    
    private var rewardedAd: YMARewardedAd?

    override func viewDidLoad() {
        MediationTestsConfigurator.enableTestMode()
    }
    
    @IBAction func loadAd() {
        self.showButton.isEnabled = false
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace adUnitID with actual Ad Unit ID.
         Following demo ad unit ids may be used for testing:
         AdMob mediation: adMobAdUnitID
         AppLovin mediation: appLovinAdUnitID
         Facebook mediation: facebookAdUnitID
         IronSource mediation: ironSourceAdUnitID
         MyTarget mediation: myTargetAdUnitID
         StartApp mediation: startAppAdUnitID
         UnityAds mediation: unityAdsAdUnitID
         Yandex: yandexAdUnitID
         */
        let adUnitID = adUnitIDs[selectedIndex].adUnitID
        rewardedAd = YMARewardedAd(adUnitID: adUnitID)
        rewardedAd?.delegate = self
        rewardedAd?.load()
    }
    
    @IBAction func presentAd() {
        rewardedAd?.present(from: self)
    }

}

extension MobileMediationRewardedViewController: YMARewardedAdDelegate {
    
    // MARK: - YMARewardedAdDelegate
    
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        let message = "Rewarded ad did reward: \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.presentedViewController?.present(alertController, animated: true, completion: nil)
        print(message)
    }

    func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd) {
        self.showButton.isEnabled = true
        print("Rewarded ad loaded")
    }

    func rewardedAdDidFail(toLoad rewardedAd: YMARewardedAd, error: Error) {
        print("Loading failed. Error: %@", error)
    }

    func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad will leave application")
    }

    func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd, error: Error) {
        print("Failed to present rewarded ad. Error: %@", error)
    }

    func rewardedAdWillAppear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad will appear")
    }

    func rewardedAdDidAppear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad did appear")
    }

    func rewardedAdWillDisappear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad will disappear")
    }

    func rewardedAdDidDisappear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad did disappear")
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, willPresentScreen viewController: UIViewController?) {
        print("Rewarded ad will present screen")
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
