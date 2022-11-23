/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class RewardedViewController: UIViewController {
    @IBOutlet weak var showButton: UIButton!
    var rewardedAd: YMARewardedAd?
    
    @IBAction func loadAd() {
        self.showButton.isEnabled = false
        // Replace demo-rewarded-yandex with actual Ad Unit ID
        self.rewardedAd = YMARewardedAd(adUnitID: "demo-rewarded-yandex")
        self.rewardedAd?.delegate = self
        self.rewardedAd?.load()
    }
    
    @IBAction func presentAd() {
        self.rewardedAd?.present(from: self)
    }
}

extension RewardedViewController: YMARewardedAdDelegate {
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

    func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
        print("Ad clicked")
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("Impression tracked")
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
