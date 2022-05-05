/*
 * Version for iOS © 2015–2022 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit

class IronSourceRewardedViewController: UIViewController {
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        IronSourceManager.shared.set(rewardedVideoManualDelegate: self)
        IronSourceManager.shared.initializeSDK()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        showButton.isEnabled = false
        IronSource.loadRewardedVideo()
    }

    @IBAction func showAd(_ sender: UIButton) {
        IronSource.showRewardedVideo(with: self)
    }
}

extension IronSourceRewardedViewController: ISRewardedVideoManualDelegate {
    func rewardedVideoDidLoad() {
        print("Rewarded did load")
        showButton.isEnabled = true
    }

    func rewardedVideoDidFailToLoadWithError(_ error: Error!) {
        print("Rewarded did fail to load")
        showButton.isEnabled = false
    }

    // MARK: - ISRewardedVideoDelegate
    func rewardedVideoHasChangedAvailability(_ available: Bool) {
        print(String(format: "Rewarded ad changed availability: %@", String(available)))
        showButton.isEnabled = available
    }

    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {
        let message = String(
            format: "Did reward: %@ %@ %@",
            placementInfo.placementName,
            placementInfo.rewardName,
            placementInfo.rewardAmount
        )
        print(message)
    }

    func rewardedVideoDidFailToShowWithError(_ error: Error!) {
        print("Rewarded ad failed to load: \(error.localizedDescription)")
    }

    func rewardedVideoDidOpen() {
        print("Did open rewarded video")
    }

    func rewardedVideoDidClose() {
        print("Did close rewarded video")
    }

    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
        let message = String(
            format: "Did click rewarded video: %@ %@ %@",
            placementInfo.placementName,
            placementInfo.rewardName,
            placementInfo.rewardAmount
        )
        print(message)
    }

    func rewardedVideoDidStart() {
        print("Did start rewarded video")
    }

    func rewardedVideoDidEnd() {
        print("Did end rewarded video")
    }
}
