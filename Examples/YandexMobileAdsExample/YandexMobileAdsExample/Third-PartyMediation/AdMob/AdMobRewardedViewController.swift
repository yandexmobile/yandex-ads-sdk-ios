/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class AdMobRewardedViewController: UIViewController {
    var rewardedAd: GADRewardedAd?
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdMob()
    }

    func initializeAdMob() {
        loadButton.isUserInteractionEnabled = false
        GADMobileAds.sharedInstance().start { [weak self] status in
            DispatchQueue.main.async {
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }

    @IBAction func loadAd(_ sender: UIButton) {
        self.showButton.isEnabled = false

        // Replace ca-app-pub-4449457472880521/8830996342 with Ad Unit ID generated at https://apps.admob.com".
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-4449457472880521/8830996342",
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
        rewardedAd?.present(fromRootViewController: self) { [weak self] in
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
    }
}

extension AdMobRewardedViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present with error: \(error.localizedDescription)")
    }
}
