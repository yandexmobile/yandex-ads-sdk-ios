import YandexMobileAds

final class AdFoxSliderAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { sliderView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitId: String
    var adFoxParameters: [String: String] = [
        "adf_ownerid": "270901",
        "adf_p1": "ddfla",
        "adf_p2": "fksh"
    ]
    private let adLoader = NativeAdLoader()
    private var currentAd: NativeAd?
    
    private let sliderView: NativeSliderView = {
        let view = NativeSliderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
        adLoader.delegate = self
    }
    
    deinit {
        adLoader.delegate = nil
        currentAd?.delegate = nil
    }
    
    func load() {
        currentAd?.delegate = nil
        currentAd = nil
        sliderView.isHidden = true
        let config = MutableNativeAdRequestConfiguration(adUnitID: adUnitId)
        config.parameters = adFoxParameters
        
        debugPrint("AdFox Slider: start loading (unit=\(adUnitId), params=\(adFoxParameters))")
        adLoader.loadAd(with: config)
    }
    
    func tearDown() {
        currentAd?.delegate = nil
        currentAd = nil
        sliderView.isHidden = true
        sliderView.removeFromSuperview()
        debugPrint("AdFox Slider: tearDown (unit=\(adUnitId))")
    }
}

// MARK: - NativeAdLoaderDelegate

extension AdFoxSliderAdapter: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        currentAd = ad
        ad.delegate = self
        do {
            try sliderView.bind(with: ad)
            sliderView.isHidden = false
            debugPrint("AdFox Slider: loaded successfully (unit=\(adUnitId))")
            onEvent?(.loaded)
        } catch {
            debugPrint("AdFox Slider: bind failed (unit=\(adUnitId)) error=\(error)")
            onEvent?(.failedToLoad(error))
        }
    }
    
    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        debugPrint("AdFox Slider: failedToLoad (unit=\(adUnitId)) error=\(error)")
        onEvent?(.failedToLoad(error))
    }
}

// MARK: - NativeAdDelegate

extension AdFoxSliderAdapter: NativeAdDelegate {
    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        debugPrint("AdFox Slider: clicked (unit=\(adUnitId))")
        onEvent?(.clicked)
    }
    
    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        debugPrint("AdFox Slider: will present screen (unit=\(adUnitId))")
        onEvent?(.shown)
    }
    
    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        debugPrint("AdFox Slider: did dismiss screen (unit=\(adUnitId))")
        onEvent?(.dismissed)
    }
    
    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        debugPrint("AdFox Slider: impression tracked (unit=\(adUnitId))")
        onEvent?(.impression)
    }
    
    func close(_ ad: NativeAd) {
        debugPrint("AdFox Slider: closed (unit=\(adUnitId))")
        sliderView.isHidden = true
    }
}
