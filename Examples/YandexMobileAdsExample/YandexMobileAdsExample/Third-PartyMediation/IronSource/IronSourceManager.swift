/*
 * Version for iOS © 2015–2022 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit

class IronSourceManager: NSObject {
    static let shared = IronSourceManager()

    //Mediator is used because IronSource.setRewardedVideoManualDelegate(...) creates a strong link
    //and handles it during the application lifecycle
    private weak var delegate: ISRewardedVideoManualDelegate?

    private override init() {
        super.init()
    }

    func set(rewardedVideoManualDelegate: ISRewardedVideoManualDelegate?) {
        delegate = rewardedVideoManualDelegate
    }

    func initializeSDK() {
        IronSource.setRewardedVideoManualDelegate(self)
        // Replace 121255e8d with app key generated at https://www.is.com/
        IronSource.initWithAppKey("121255e8d", adUnits: [IS_INTERSTITIAL, IS_REWARDED_VIDEO])
    }
}

extension IronSourceManager: ISRewardedVideoManualDelegate {
    func rewardedVideoDidLoad() {
        delegate?.rewardedVideoDidLoad()
    }

    func rewardedVideoDidFailToLoadWithError(_ error: Error!) {
        delegate?.rewardedVideoDidFailToLoadWithError(error)
    }

    // MARK: - ISRewardedVideoDelegate
    func rewardedVideoHasChangedAvailability(_ available: Bool) {
        delegate?.rewardedVideoHasChangedAvailability(available)
    }

    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {
        delegate?.didReceiveReward(forPlacement: placementInfo)
    }

    func rewardedVideoDidFailToShowWithError(_ error: Error!) {
        delegate?.rewardedVideoDidFailToShowWithError(error)
    }

    func rewardedVideoDidOpen() {
        delegate?.rewardedVideoDidOpen()
    }

    func rewardedVideoDidClose() {
        delegate?.rewardedVideoDidClose()
    }

    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
        delegate?.didClickRewardedVideo(placementInfo)
    }

    func rewardedVideoDidStart() {
        delegate?.rewardedVideoDidStart()
    }

    func rewardedVideoDidEnd() {
        delegate?.rewardedVideoDidEnd()
    }
}
