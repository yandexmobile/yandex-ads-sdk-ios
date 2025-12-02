import YandexMobileAds

final class YandexInlineBannerAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { adView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    // MARK: - Private
    
    private let adUnitId: String
    private let adView: AdView
    
    // MARK: - Init
    init(adUnitId: String, width: CGFloat = 320, height: CGFloat = 320) {
        self.adUnitId = adUnitId
        let size = BannerAdSize.inlineSize(withWidth: width, maxHeight: height)
        self.adView = AdView(adUnitID: adUnitId, adSize: size)
        super.init()
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.accessibilityIdentifier = CommonAccessibility.bannerView
    }
    
    // MARK: - Methods
    
    func load() {
        adView.loadAd()
    }
    
    func tearDown() {
        adView.delegate = nil
        adView.removeFromSuperview()
    }
}

// MARK: - AdViewDelegate
extension YandexInlineBannerAdapter: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        onEvent?(.loaded)
        print("Inline(\(adUnitId)) loaded")
    }
    
    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        onEvent?(.failedToLoad(error))
        let text = StateUtils.loadError(error)
        print("Inline(\(adUnitId)) \(text)")
    }
    
    func adViewDidClick(_ adView: AdView) {
        onEvent?(.clicked)
        print("Inline(\(adUnitId)) did click")
    }
    
    func adView(_ adView: AdView, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("Inline(\(adUnitId)) did track impression")
    }
    
    func adView(_ adView: AdView, willPresentScreen viewController: UIViewController?) {
        onEvent?(.shown)
        print("Inline(\(adUnitId)) will present screen")
    }
    
    func adView(_ adView: AdView, didDismissScreen viewController: UIViewController?) {
        onEvent?(.dismissed)
        print("Inline(\(adUnitId)) did dismiss screen")
    }
}
