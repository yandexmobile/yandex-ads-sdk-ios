/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class ViewController: UIViewController {

    var rewardedAd: GADRewardedAd?
    @IBOutlet weak var showButton: UIButton!

    @IBAction func loadAd(_ sender: UIButton) {
        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        let rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY")
        self.rewardedAd = rewardedAd
        rewardedAd.load(GADRequest()) { error in
            if let error = error {
                print("Reward based video ad did fail to load with error: \(error)")
            } else {
                self.showButton.isEnabled = true
            }
        }
    }

    @IBAction func showAd(_ sender: UIButton) {
        if rewardedAd?.isReady ?? false {
            rewardedAd?.present(fromRootViewController: self, delegate: self)
        } else {
            print("Rewarded ad wasn't ready")
        }
    }
}

extension ViewController: GADRewardedAdDelegate {

    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        let message = "Rewarded ad did reward \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        presentedViewController?.present(alertController, animated: true, completion: nil)
    }
}
