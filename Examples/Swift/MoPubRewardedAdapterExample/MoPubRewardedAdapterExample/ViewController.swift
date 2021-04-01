/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import MoPubSDK

class ViewController: UIViewController {
    
    // Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com
    let adUnitID = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    @IBOutlet weak var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeMoPub()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        MPRewardedAds.loadRewardedAd(withAdUnitID: adUnitID, withMediationSettings: [])
    }
    
    @IBAction func showAd(_ sender: UIButton) {
        let reward = MPRewardedAds.selectedReward(forAdUnitID: adUnitID)
        MPRewardedAds.presentRewardedAd(forAdUnitID: adUnitID, from: self, with: reward)
    }
    
    private func initializeMoPub() {
        MPRewardedAds.setDelegate(self, forAdUnitId: adUnitID)
        let configuration = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitID)
        MoPub.sharedInstance().initializeSdk(with: configuration){ [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }
}

extension ViewController: MPRewardedAdsDelegate {

    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        let amount = reward.amount!
        let currencyType = reward.currencyType!
        let message = "Rewarded ad did reward: \(amount) \(currencyType)"
        let allertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        allertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        presentedViewController?.present(allertController, animated: true, completion: nil)
    }

    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        print("Rewarded ad did load")
    }

    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        print("Rewarded ad did fail to load ad with error: \(error.localizedDescription)")
    }

    func rewardedAdDidFailToShow(forAdUnitID adUnitID: String!, error: Error!) {
        print("Rewarded ad did fail to present ad with error: \(error.localizedDescription)")
    }
}
