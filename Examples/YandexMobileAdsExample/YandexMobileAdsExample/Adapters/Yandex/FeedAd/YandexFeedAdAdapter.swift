import UIKit
import YandexMobileAds

protocol FeedAdProviding: UnifiedAdProtocol {
    var collectionViewAdapter: FeedAdCollectionViewAdapter { get }
    var onUpdate: (() -> Void)? { get set }
    var onLoad: (() -> Void)? { get set }
}

final class YandexFeedAdAdapter: NSObject, FeedAdProviding {
    let collectionViewAdapter: FeedAdCollectionViewAdapter
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var onUpdate: (() -> Void)?
    var onLoad: (() -> Void)?

    private let feedAd: FeedAd

    init(adUnitID: String) {
        let request = AdRequest(adUnitID: adUnitID)
        let appearance = FeedAdAppearance(cardWidth: 320, cardCornerRadius: 16)
        feedAd = FeedAd(requestConfiguration: request, appearance: appearance)
        collectionViewAdapter = FeedAdCollectionViewAdapter(feedAd: feedAd)
        super.init()
        feedAd.delegate = self
    }

    func load() {
        feedAd.loadAd()
        onLoad?()
    }

    func tearDown() {
        feedAd.delegate = nil
    }
}

extension YandexFeedAdAdapter: FeedAdDelegate {
    func feedAdDidLoad(_ feedAd: FeedAd) {
        onEvent?(.loaded)
    }

    func feedAd(_ feedAd: FeedAd, didFailToLoadWithError error: Error) {
        onEvent?(.failedToLoad(error))
    }

    func feedAdDidClick(_ feedAd: FeedAd) {
        onEvent?(.clicked)
    }

    func feedAd(_ feedAd: FeedAd, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
    }

    func feedAdDidUpdateDataSource(_ feedAd: FeedAd) {
        onUpdate?()
    }
}
