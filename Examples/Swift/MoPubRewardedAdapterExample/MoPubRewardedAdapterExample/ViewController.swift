/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import MoPub

class ViewController: UIViewController {
    
    // Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com
    let adUnitID = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    @IBOutlet weak var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeMoPub()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        MPRewardedVideo.loadAd(withAdUnitID: adUnitID, withMediationSettings: nil)
    }
    
    @IBAction func showAd(_ sender: UIButton) {
        let reward = MPRewardedVideo.selectedReward(forAdUnitID: adUnitID)
        MPRewardedVideo.presentAd(forAdUnitID: adUnitID, from: self, with: reward)
    }
    
    private func initializeMoPub() {
        let configuration = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitID)
        MPRewardedVideo.setDelegate(self, forAdUnitId: adUnitID)
        MoPub.sharedInstance().initializeSdk(with: configuration){ [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }
}

extension ViewController: MPRewardedVideoDelegate {

    func rewardedVideoAdShouldReward(forAdUnitID adUnitID: String!, reward: MPRewardedVideoReward!) {
        let amount = reward.amount!
        let currencyType = reward.currencyType!
        let message = "Rewarded ad did reward: \(amount) \(currencyType)"
        let allertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        allertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        presentedViewController?.present(allertController, animated: true, completion: nil)
    }

    func rewardedVideoAdDidLoad(forAdUnitID adUnitID: String!) {
        print("Rewarded ad did load")
    }

    func rewardedVideoAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        print("Rewarded ad did fail to load ad with error: \(String(describing: error))")
    }
}
