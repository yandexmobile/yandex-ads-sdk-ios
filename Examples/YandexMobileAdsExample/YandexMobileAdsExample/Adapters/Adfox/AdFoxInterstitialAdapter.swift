import YandexMobileAds

final class AdFoxInterstitialAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitId: String
    private var adFoxParameters: [String: String] = [
        "adf_ownerid": "270901",
        "adf_p1": "caboi",
        "adf_p2": "fkbc",
        "adf_pfc": "bskug",
        "adf_pfb": "fkjam",
        "adf_pt": "b"
    ]
    private let interstitialAdLoader = InterstitialAdLoader()
    private var interstitialAd: InterstitialAd?
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
    }
    
    func load() {
        tearDown()
        let config = MutableAdRequestConfiguration(adUnitID: adUnitId)
        config.parameters = adFoxParameters
        
        interstitialAdLoader.delegate = self
        interstitialAdLoader.loadAd(with: config)
    }
    
    func tearDown() {
        interstitialAd?.delegate = nil
        interstitialAd = nil
        interstitialAdLoader.delegate = nil
    }
    
    func present(from viewController: UIViewController) {
        interstitialAd?.show(from: viewController)
    }
}

// MARK: - InterstitialAdLoaderDelegate

extension AdFoxInterstitialAdapter: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        print("Interstitial Ad with Unit ID: \(adUnitId) loaded")
        self.interstitialAd = interstitialAd
        interstitialAd.delegate = self
        onEvent?(.loaded)
    }
    
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId
        let error  = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        onEvent?(.failedToLoad(error))
    }
}

// MARK: - InterstitialAdDelegate

extension AdFoxInterstitialAdapter: InterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        print("Interstitial Ad with Unit ID: \(adUnitId) failed to show. Error: \(error)")
        onEvent?(.failedToShow(error))
    }
    
    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad with Unit ID: \(adUnitId) did show")
        if let topVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .presentedViewController
        {
            topVC.view.accessibilityIdentifier = CommonAccessibility.bannerView
        }
        onEvent?(.shown)
    }
    
    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad with Unit ID: \(adUnitId) did dismiss")
        onEvent?(.dismissed)
        self.interstitialAd = nil
    }
    
    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad with Unit ID: \(adUnitId) did click")
        onEvent?(.clicked)
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("Interstitial Ad with Unit ID: \(adUnitId) did track impression")
        onEvent?(.impression)
    }
}
