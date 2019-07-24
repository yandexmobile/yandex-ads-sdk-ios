/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
    }

    @IBAction func loadAd(_ sender: UIButton) {
        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY")
    }

    @IBAction func showAd(_ sender: UIButton) {
        if GADRewardBasedVideoAd.sharedInstance().isReady {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        } else {
            print("Rewarded ad wasn't ready")
        }
    }
}

extension ViewController: GADRewardBasedVideoAdDelegate {

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad did receive")
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        let message = "Rewarded ad did reward \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        presentedViewController?.present(alertController, animated: true, completion: nil)
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Reward based video ad did fail to load with error: \(error)")
    }
}
