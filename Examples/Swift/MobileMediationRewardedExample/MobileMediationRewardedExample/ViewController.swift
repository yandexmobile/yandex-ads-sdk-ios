/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

let adMobBlockID = "adf-279013/966332"
let appLovinBlockID = "adf-279013/1052108"
let facebookBlockID = "adf-279013/966335"
let ironSourceBlockID = "adf-279013/1052110"
let moPubBlockID = "adf-279013/966333"
let myTargetBlockID = "adf-279013/966334"
let startAppBlockID = "adf-279013/1006617"
let unityAdsBlockID = "adf-279013/1006614"
let yandexBlockID = "adf-279013/967178"

class ViewController: UIViewController {

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

    @IBOutlet private var pickerView: UIPickerView!
    
    private var rewardedAd: YMARewardedAd?
    
    @IBAction func loadAd() {
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace blockID with actual Block ID.
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
        rewardedAd = YMARewardedAd(blockID: blockID)
        rewardedAd?.delegate = self
        rewardedAd?.load()
    }
    
    @IBAction func presentAd() {
        rewardedAd?.present(from: self)
    }

}

extension ViewController: YMARewardedAdDelegate {
    
    // MARK: - YMARewardedAdDelegate
    
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        let message = "Rewarded ad did reward: \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.presentedViewController?.present(alertController, animated: true, completion: nil)
        print(message)
    }

    func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd) {
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

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
