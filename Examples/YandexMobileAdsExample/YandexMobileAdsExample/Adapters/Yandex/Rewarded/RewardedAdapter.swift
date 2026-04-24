import UIKit
import YandexMobileAds

@MainActor
final class YandexRewardedAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {

    // MARK: UnifiedAdProtocol
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { nil }

    // MARK: Private
    private let adUnitID: String
    private let loader = RewardedAdLoader()
    private var rewardedAd: RewardedAd? {
        didSet { rewardedAd?.delegate = self }
    }

    // MARK: Init
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }

    // MARK: API
    func load() {
        let request = AdRequest(adUnitID: adUnitID)
        loader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let rewardedAd):
                self.rewardedAd = rewardedAd
                onEvent?(.loaded)
                print("\(makeMessageDescription(rewardedAd))) loaded")
            case .failure(let error):
                onEvent?(.failedToLoad(error))
                print("Loading failed for Ad with Unit ID: \(String(describing: adUnitID)). Error: \(String(describing: error))")
            }
        }
    }

    func present(from viewController: UIViewController) {
        rewardedAd?.show(from: viewController)
    }

    func tearDown() {
        rewardedAd?.delegate = nil
        rewardedAd = nil
    }

    // MARK: Helpers
    private func makeMessageDescription(_ rewardedAd: RewardedAd) -> String {
        "Rewarded Ad with Unit ID: \(adUnitID)"
    }
}

// MARK: - RewardedAdDelegate
extension YandexRewardedAdapter: RewardedAdDelegate {
    func rewardedAd(_ rewardedAd: RewardedAd, didReward reward: Reward) {
        let message = "\(makeMessageDescription(rewardedAd)) did reward: \(reward.amount) \(reward.type)"
        onEvent?(.rewarded(reward))
        print(message)
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShow error: Error) {
        onEvent?(.failedToShow(error))
        print("\(makeMessageDescription(rewardedAd)) failed to show. Error: \(error)")
        self.rewardedAd = nil
    }

    func rewardedAdDidShow(_ rewardedAd: RewardedAd) {
        onEvent?(.shown)
        print("\(makeMessageDescription(rewardedAd)) did show")
    }

    func rewardedAdDidDismiss(_ rewardedAd: RewardedAd) {
        onEvent?(.dismissed)
        print("\(makeMessageDescription(rewardedAd)) did dismiss")
        self.rewardedAd = nil
    }

    func rewardedAdDidClick(_ rewardedAd: RewardedAd) {
        onEvent?(.clicked)
        print("\(makeMessageDescription(rewardedAd)) did click")
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("\(makeMessageDescription(rewardedAd)) did track impression")
    }
}
