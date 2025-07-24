/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class AdMobRewardedViewController: UIViewController {
    var rewardedAd: GoogleMobileAds.RewardedAd?
    @IBOutlet var showButton: UIButton!
    @IBOutlet var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdMob()
    }

    func initializeAdMob() {
        loadButton.isUserInteractionEnabled = false
        GoogleMobileAds.MobileAds.shared.start { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }

    @IBAction func loadAd(_: UIButton) {
        showButton.isEnabled = false

        // Replace ca-app-pub-4651572829019143/6476005590 with Ad Unit ID generated at https://apps.admob.com".
        GoogleMobileAds.RewardedAd.load(
            with: "ca-app-pub-4651572829019143/6476005590",
            request: GoogleMobileAds.Request()
        ) { [self] ad, error in
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

    @IBAction func showAd(_: UIButton) {
        rewardedAd?.present(from: self) { [weak self] in
            self?.showReward()
        }
    }

    func showReward() {
        guard let rewardedAd = rewardedAd else {
            return
        }

        let reward = rewardedAd.adReward
        let message = "Rewarded ad did reward \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        presentedViewController?.present(alertController, animated: true, completion: nil)

        showButton.isEnabled = false
    }
}

extension AdMobRewardedViewController: GoogleMobileAds.FullScreenContentDelegate {
    func ad(_: GoogleMobileAds.FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present with error: \(error.localizedDescription)")
    }
}
