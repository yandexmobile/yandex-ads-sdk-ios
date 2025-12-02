import YandexMobileAds

final class YandexInterstitialAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    // MARK: - UnifiedAdProtocol
    
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { nil }
    
    // MARK: - Private
    
    private let adUnitId: String
    private let loader: InterstitialAdLoader = InterstitialAdLoader()
    private var interstitialAd: InterstitialAd? {
        didSet {
            interstitialAd?.delegate = self
        }
    }
    
    // MARK: - Init

    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
        loader.delegate = self
    }
    
    // MARK: - Methods
    
    func load() {
        let config = AdRequestConfiguration(adUnitID: adUnitId)
        loader.loadAd(with: config)
    }
    
    func present(from viewController: UIViewController) {
        interstitialAd?.show(from: viewController)
    }
    
    func tearDown() {
        interstitialAd?.delegate = nil
        interstitialAd = nil
    }
    
    // MARK: - Helpers
    
    private func makeMessageDescription(_ interstitialAd: InterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(adUnitId)"
    }
}

extension YandexInterstitialAdapter: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        self.interstitialAd = interstitialAd
        self.interstitialAd?.delegate = self
        onEvent?(.loaded)
        print("\(makeMessageDescription(interstitialAd)) loaded")
    }
    
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId
        let error = error.error
        onEvent?(.failedToLoad(error))
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
    }
}

extension YandexInterstitialAdapter: InterstitialAdDelegate {
    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        onEvent?(.shown)
        print("\(makeMessageDescription(interstitialAd)) did show")
    }
    
    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        self.interstitialAd = nil
        onEvent?(.dismissed)
        print("\(makeMessageDescription(interstitialAd)) did dismiss")
    }
    
    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        onEvent?(.clicked)
        print("\(makeMessageDescription(interstitialAd)) did сlick")
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("\(makeMessageDescription(interstitialAd)) did track impression")
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        self.interstitialAd = nil
        onEvent?(.failedToShow(error))
        print("\(makeMessageDescription(interstitialAd)) failed to show. Error: \(error)")
    }
}
