/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController, YMARewardedAdDelegate {
    
    var rewardedAd: YMARewardedAd!
    
    @IBAction func loadAd() {
        // Replace demo R-M-DEMO-rewarded-client-side-rtb with actual Block ID
        self.rewardedAd = YMARewardedAd(blockID: "R-M-DEMO-rewarded-client-side-rtb")
        self.rewardedAd.delegate = self
        self.rewardedAd.load()
    }
    
    @IBAction func presentAd() {
        self.rewardedAd.present(from: self)
    }
    
    // MARK: - YMARewardedAdDelegate
    
    func rewardedAd(_ rewardedAd: YMARewardedAd!, didReward reward: YMAReward!) {
        let message = "Rewarded ad did reward: \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.presentedViewController?.present(alertController, animated: true, completion: nil)
        print(message)
    }
    
    func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd!) {
        print("Rewarded ad loaded")
    }
    
    func rewardedAdDidFail(toLoad rewardedAd: YMARewardedAd!, error: Error!) {
        print("Loading failed. Error: %@", error)
    }
    
    func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd!) {
        print("Rewarded ad will leave application")
    }
    
    func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd!, error: Error!) {
        print("Failed to present rewarded ad. Error: %@", error)
    }
    
    func rewardedAdWillAppear(_ rewardedAd: YMARewardedAd!) {
        print("Rewarded ad will appear")
    }
    
    func rewardedAdDidAppear(_ rewardedAd: YMARewardedAd!) {
        print("Rewarded ad did appear")
    }
    
    func rewardedAdWillDisappear(_ rewardedAd: YMARewardedAd!) {
        print("Rewarded ad will disappear")
    }
    
    func rewardedAdDidDisappear(_ rewardedAd: YMARewardedAd!) {
        print("Rewarded ad did disappear")
    }
    
    func rewardedAd(_ rewardedAd: YMARewardedAd!, willPresentScreen viewController: UIViewController!) {
        print("Rewarded ad will present screen")
    }
}
