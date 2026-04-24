import UIKit
import YandexMobileAds

final class YandexInlineBannerAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { bannerAdView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    // MARK: - Private
    
    private let adUnitID: String
    private let bannerAdView: BannerAdView
    
    // MARK: - Init
    init(adUnitID: String, width: CGFloat = 320, height: CGFloat = 320) {
        self.adUnitID = adUnitID
        let size = BannerAdSize.inline(width: width, maxHeight: height)
        self.bannerAdView = BannerAdView(adSize: size)
        super.init()
        bannerAdView.delegate = self
        bannerAdView.translatesAutoresizingMaskIntoConstraints = false
        bannerAdView.accessibilityIdentifier = CommonAccessibility.bannerView
    }
    
    // MARK: - Methods
    
    func load() {
        let request = AdRequest(adUnitID: adUnitID)
        bannerAdView.loadAd(with: request)
    }
    
    func tearDown() {
        bannerAdView.delegate = nil
        bannerAdView.removeFromSuperview()
    }
}

// MARK: - BannerAdViewDelegate
extension YandexInlineBannerAdapter: BannerAdViewDelegate {
    func bannerAdViewDidLoad(_ bannerAdView: BannerAdView) {
        onEvent?(.loaded)
        print("Inline(\(adUnitID)) loaded")
    }
    
    func bannerAdViewDidFailLoading(_ bannerAdView: BannerAdView, error: Error) {
        onEvent?(.failedToLoad(error))
        let text = StateUtils.loadError(error)
        print("Inline(\(adUnitID)) \(text)")
    }
    
    func bannerAdViewDidClick(_ bannerAdView: BannerAdView) {
        onEvent?(.clicked)
        print("Inline(\(adUnitID)) did click")
    }
    
    func bannerAdView(_ bannerAdView: BannerAdView, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("Inline(\(adUnitID)) did track impression")
    }
}
