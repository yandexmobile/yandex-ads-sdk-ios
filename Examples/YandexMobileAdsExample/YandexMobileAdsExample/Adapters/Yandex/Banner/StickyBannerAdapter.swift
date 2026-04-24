import UIKit
import YandexMobileAds

final class YandexStickyBannerAdapter: NSObject, UnifiedAdProtocol, AttachableAdProtocol {
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    // MARK: - Private
    
    private let adUnitID: String
    private weak var hostVC: UIViewController?
    private var bannerAdView: BannerAdView?

    // MARK: - Init
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }

    func load() {
        let request = AdRequest(adUnitID: adUnitID)
        bannerAdView?.loadAd(with: request)
    }

    func tearDown() {
        bannerAdView?.delegate = nil
        bannerAdView?.removeFromSuperview()
        bannerAdView = nil
        hostVC = nil
    }

    // MARK: - AttachableAdProtocol
    func attachIfNeeded(to viewController: UIViewController) {
        guard hostVC == nil else { return }
        hostVC = viewController

        viewController.view.layoutIfNeeded()
        let width = viewController.view.safeAreaLayoutGuide.layoutFrame.width

        let size = BannerAdSize.sticky(containerWidth: width)
        let ad = BannerAdView(adSize: size)
        ad.translatesAutoresizingMaskIntoConstraints = false
        ad.delegate = self
        ad.accessibilityIdentifier = CommonAccessibility.bannerView

        bannerAdView = ad
        ad.displayAtTop(in: viewController.view)
    }
}

// MARK: - BannerAdViewDelegate

extension YandexStickyBannerAdapter: BannerAdViewDelegate {
    func bannerAdViewDidLoad(_ bannerAdView: BannerAdView) {
        onEvent?(.loaded)
        print("Sticky(\(adUnitID)) loaded")
    }

    func bannerAdViewDidFailLoading(_ bannerAdView: BannerAdView, error: Error) {
        onEvent?(.failedToLoad(error))
        let text = StateUtils.loadError(error)
        print("Sticky(\(adUnitID)) \(text)")
    }

    func bannerAdViewDidClick(_ bannerAdView: BannerAdView) {
        onEvent?(.clicked)
        print("Sticky(\(adUnitID)) did click")
    }

    func bannerAdView(_ bannerAdView: BannerAdView, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("Sticky(\(adUnitID)) did track impression")
    }
}
