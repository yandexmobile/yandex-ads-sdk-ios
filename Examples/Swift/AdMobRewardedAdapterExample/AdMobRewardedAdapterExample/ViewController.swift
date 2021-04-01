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
        self.showButton.isEnabled = false

        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        GADRewardedAd .load(withAdUnitID: "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY",
                            request: GADRequest()) { [self] ad, error in
            if let error = error {
                print("Did fail to receive ad with error: \(error.localizedDescription)")
            } else {
                print("Did receive ad")
                rewardedAd = ad
                rewardedAd?.fullScreenContentDelegate = self
                self.showButton.isEnabled = true
            }
        }
    }

    @IBAction func showAd(_ sender: UIButton) {
        rewardedAd?.present(fromRootViewController: self
                            , userDidEarnRewardHandler: {
                                self.showReward()
                            })
    }

    func showReward() {
        let reward = rewardedAd!.adReward
        let message = "Rewarded ad did reward \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        presentedViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present with error: \(error.localizedDescription)")
    }
}
