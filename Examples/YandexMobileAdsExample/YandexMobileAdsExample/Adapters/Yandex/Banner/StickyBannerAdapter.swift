import YandexMobileAds

final class YandexStickyBannerAdapter: NSObject, UnifiedAdProtocol, AttachableAdProtocol {
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    // MARK: - Private
    
    private let adUnitId: String
    private weak var hostVC: UIViewController?
    private var adView: AdView?

    // MARK: - Init
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
    }

    func load() {
        adView?.loadAd()
    }

    func tearDown() {
        adView?.delegate = nil
        adView?.removeFromSuperview()
        adView = nil
        hostVC = nil
    }

    // MARK: - AttachableAdProtocol
    func attachIfNeeded(to viewController: UIViewController) {
        guard hostVC == nil else { return }
        hostVC = viewController

        viewController.view.layoutIfNeeded()
        let width = viewController.view.safeAreaLayoutGuide.layoutFrame.width

        let size = BannerAdSize.stickySize(withContainerWidth: width)
        let ad = AdView(adUnitID: adUnitId, adSize: size)
        ad.translatesAutoresizingMaskIntoConstraints = false
        ad.delegate = self
        ad.accessibilityIdentifier = CommonAccessibility.bannerView

        adView = ad
        ad.displayAtTop(in: viewController.view)
    }
}

// MARK: - AdViewDelegate

extension YandexStickyBannerAdapter: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        onEvent?(.loaded)
        print("Sticky(\(adUnitId)) loaded")
    }

    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        onEvent?(.failedToLoad(error))
        let text = StateUtils.loadError(error)
        print("Sticky(\(adUnitId)) \(text)")
    }

    func adViewDidClick(_ adView: AdView) {
        onEvent?(.clicked)
        print("Sticky(\(adUnitId)) did click")
    }

    func adView(_ adView: AdView, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("Sticky(\(adUnitId)) did track impression")
    }

    func adView(_ adView: AdView, willPresentScreen viewController: UIViewController?) {
        onEvent?(.shown)
        print("Sticky(\(adUnitId)) will present screen")
    }

    func adView(_ adView: AdView, didDismissScreen viewController: UIViewController?) {
        onEvent?(.dismissed)
        print("Sticky(\(adUnitId)) did dismiss screen")
    }

    func adViewWillLeaveApplication(_ adView: AdView) {
        print("Sticky(\(adUnitId)) will leave application")
    }
}
