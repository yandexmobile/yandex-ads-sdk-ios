#if COCOAPODS
import GoogleMobileAds

final class AdMobRewardedAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?

    private let adUnitId: String
    private weak var hostViewController: UIViewController?
    private var rewardedAd: GoogleMobileAds.RewardedAd?

    init(adUnitId: String, hostViewController: UIViewController) {
        self.adUnitId = adUnitId
        self.hostViewController = hostViewController
        super.init()
    }

    func load() {
        AdMobStarter.startIfNeeded { [weak self] in
            guard let self else { return }
            self.rewardedAd = nil
            print("AdMob Rewarded: start loading (\(self.adUnitId))")

            let request = GoogleMobileAds.Request()
            GoogleMobileAds.RewardedAd.load(with: self.adUnitId, request: request) { [weak self] ad, error in
                guard let self else { return }

                if let error = error {
                    print("AdMob Rewarded: failed to load \(error.localizedDescription)")
                    self.onEvent?(.failedToLoad(error))
                    return
                }

                self.rewardedAd = ad
                ad?.fullScreenContentDelegate = self
                print("AdMob Rewarded: didReceiveAd")
                self.onEvent?(.loaded)
            }
        }
    }

    func tearDown() {
        rewardedAd?.fullScreenContentDelegate = nil
        rewardedAd = nil
    }

    func present(from viewController: UIViewController) {
        guard let rewardedAd else {
            let error = AdMobError.adNotReady(adType: "Rewarded")
            onEvent?(.failedToShow(error))
            return
        }

        print("AdMob Rewarded: presenting...")
        rewardedAd.present(from: viewController) { [weak self] in
            guard let self else { return }
            let reward = rewardedAd.adReward
            print("AdMob Rewarded: user earned reward \(reward.amount) \(reward.type)")
            let rewarded = RewardBox(amount: reward.amount.intValue, type: reward.type)
            self.onEvent?(.rewarded(rewarded))
        }
    }
}

// MARK: - GoogleMobileAds.FullScreenContentDelegate

extension AdMobRewardedAdapter: GoogleMobileAds.FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Rewarded: willPresent")
        onEvent?(.shown)
    }

    func ad(_ ad: GoogleMobileAds.FullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("AdMob Rewarded: failedToPresent \(error.localizedDescription)")
        onEvent?(.failedToShow(error))
    }

    func adWillDismissFullScreenContent(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Rewarded: willDismiss")
    }

    func adDidDismissFullScreenContent(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Rewarded: didDismiss")
        rewardedAd = nil
        onEvent?(.dismissed)
    }

    func adDidRecordImpression(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Rewarded: didRecordImpression")
        onEvent?(.impression)
    }

    func adDidRecordClick(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Rewarded: didRecordClick")
        onEvent?(.clicked)
    }
}
#endif
