import YandexMobileAds

final class YandexRewardedAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {

    // MARK: UnifiedAdProtocol
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { nil }

    // MARK: Private
    private let adUnitId: String
    private let loader = RewardedAdLoader()
    private var rewardedAd: RewardedAd? {
        didSet { rewardedAd?.delegate = self }
    }

    // MARK: Init
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
        loader.delegate = self
    }

    // MARK: API
    func load() {
        let config = AdRequestConfiguration(adUnitID: adUnitId)
        loader.loadAd(with: config)
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
        "Rewarded Ad with Unit ID: \(adUnitId)"
    }
}

// MARK: - RewardedAdLoaderDelegate
extension YandexRewardedAdapter: RewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didLoad rewardedAd: RewardedAd) {
        self.rewardedAd = rewardedAd
        onEvent?(.loaded)
        print("\(makeMessageDescription(rewardedAd))) loaded")
    }

    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId
        let error  = error.error
        onEvent?(.failedToLoad(error))
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
    }
}

// MARK: - RewardedAdDelegate
extension YandexRewardedAdapter: RewardedAdDelegate {
    func rewardedAd(_ rewardedAd: RewardedAd, didReward reward: Reward) {
        let message = "\(makeMessageDescription(rewardedAd)) did reward: \(reward.amount) \(reward.type)"
        onEvent?(.rewarded(reward))
        print(message)
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShowWithError error: Error) {
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

    func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpressionWith impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("\(makeMessageDescription(rewardedAd)) did track impression")
    }
}
