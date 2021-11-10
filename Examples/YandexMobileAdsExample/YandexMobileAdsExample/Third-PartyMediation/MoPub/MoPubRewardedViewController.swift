/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import MoPubSDK

class MoPubRewardedViewController: UIViewController {
    // Replace 78243a7cb876486ba75da21769844dde with Ad Unit ID generated at https://app.mopub.com
    let adUnitID = "78243a7cb876486ba75da21769844dde";

    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMoPub()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        self.showButton.isEnabled = false
        MPRewardedAds.loadRewardedAd(withAdUnitID: adUnitID, withMediationSettings: [])
    }
    
    @IBAction func showAd(_ sender: UIButton) {
        let reward = MPRewardedAds.selectedReward(forAdUnitID: adUnitID)
        MPRewardedAds.presentRewardedAd(forAdUnitID: adUnitID, from: self, with: reward)
    }
    
    private func initializeMoPub() {
        MPRewardedAds.setDelegate(self, forAdUnitId: adUnitID)
        let isMoPubInitialized = MoPub.sharedInstance().isSdkInitialized
        if !isMoPubInitialized {
            loadButton.isUserInteractionEnabled = false
            let configuration = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitID)
            MoPub.sharedInstance().initializeSdk(with: configuration) { [weak self] in
                DispatchQueue.main.async {
                    self?.loadButton.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension MoPubRewardedViewController: MPRewardedAdsDelegate {

    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        let amount = reward.amount!
        let currencyType = reward.currencyType!
        let message = "Rewarded ad did reward: \(amount) \(currencyType)"
        let allertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        allertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        presentedViewController?.present(allertController, animated: true, completion: nil)
    }

    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        self.showButton.isEnabled = true
        print("Rewarded ad did load")
    }

    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        print("Rewarded ad did fail to load ad with error: \(error.localizedDescription)")
    }

    func rewardedAdDidFailToShow(forAdUnitID adUnitID: String!, error: Error!) {
        print("Rewarded ad did fail to present ad with error: \(error.localizedDescription)")
    }

    func rewardedAdWillPresent(forAdUnitID adUnitID: String!) {
        print("Rewarded ad will present")
    }

    func rewardedAdDidPresent(forAdUnitID adUnitID: String!) {
        print("Rewarded ad did present")
    }

    func rewardedAdWillDismiss(forAdUnitID adUnitID: String!) {
        print("Rewarded ad will dismiss")
    }

    func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
        print("Rewarded ad did dismiss")
    }

    func rewardedAdDidReceiveTapEvent(forAdUnitID adUnitID: String!) {
        print("Rewarded ad did track tap")
    }

    func rewardedAdWillLeaveApplication(forAdUnitID adUnitID: String!) {
        print("Rewarded ad will leave application")
    }

    func didTrackImpression(withAdUnitID adUnitID: String!, impressionData: MPImpressionData!) {
        print("Rewarded ad did track impression")
    }
}
