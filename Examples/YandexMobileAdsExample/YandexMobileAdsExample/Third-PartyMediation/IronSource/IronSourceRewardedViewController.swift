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
        IronSource.setLevelPlayRewardedVideoManualDelegate(self)
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

extension IronSourceRewardedViewController: LevelPlayRewardedVideoManualDelegate {
    func didLoad(with adInfo: ISAdInfo!) {
        print("Rewarded did load")
        showButton.isEnabled = true
    }

    func didFailToLoadWithError(_ error: Error!) {
        print("Rewarded did fail to load")
        showButton.isEnabled = false
    }

    func hasAvailableAd(with adInfo: ISAdInfo!) {
        print("Rewarded ad is available")
        showButton.isEnabled = true
    }

    func hasNoAvailableAd() {
        print("Rewarded ad isn't available")
        showButton.isEnabled = false
    }

    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) {
        let message = String(
            format: "Did reward: %@ %@ %@",
            placementInfo.placementName,
            placementInfo.rewardName,
            placementInfo.rewardAmount
        )
        print(message)
    }

    func didFailToShowWithError(_ error: Error!, andAdInfo adInfo: ISAdInfo!) {
        print("Rewarded ad failed to load: \(error.localizedDescription)")
    }

    func didOpen(with adInfo: ISAdInfo!) {
        print("Did open rewarded video")
    }

    func didClose(with adInfo: ISAdInfo!) {
        print("Did close rewarded video")
    }

    func didClick(_ placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) {
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
