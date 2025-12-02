import YandexMobileAds

final class AdFoxNativeAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { adView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitId: String
    private var adFoxParameters: [String: String] = [
        "adf_ownerid": "270901",
        "adf_p1": "caboj",
        "adf_p2": "fksh",
        "adf_pfc": "bskug",
        "adf_pfb": "fkjas",
        "adf_pt": "b"
    ]
    
    private let adLoader = NativeAdLoader()
    private var nativeAd: NativeAd?
    private let adView: NativeAdView
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        self.adView = NativeAdView.nib ?? NativeAdView()
        super.init()
        adLoader.delegate = self
        adView.isHidden = true
    }
    
    func load() {
        nativeAd?.delegate = nil
        nativeAd = nil
        adView.isHidden = true
        let config = MutableNativeAdRequestConfiguration(adUnitID: adUnitId)
        config.parameters = adFoxParameters
        
        debugPrint("AdFox Native: start loading (unit=\(adUnitId), params=\(adFoxParameters))")
        adLoader.loadAd(with: config)
    }
    
    func tearDown() {
        nativeAd?.delegate = nil
        nativeAd = nil
        adView.isHidden = true
        adView.removeFromSuperview()
        debugPrint("AdFox Native: tearDown (unit=\(adUnitId))")
    }
}

// MARK: - NativeAdLoaderDelegate

extension AdFoxNativeAdapter: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        nativeAd = ad
        ad.delegate = self
        do {
            try ad.bind(with: adView)
            adView.configureAssetViews()
            adView.isHidden = false
            adView.accessibilityIdentifier = CommonAccessibility.bannerView
            debugPrint("AdFox Native: loaded successfully (unit=\(adUnitId))")
            onEvent?(.loaded)
        } catch {
            debugPrint("AdFox Native: bind failed (unit=\(adUnitId)) error=\(error)")
            onEvent?(.failedToLoad(error))
        }
    }
    
    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        debugPrint("AdFox Native: failedToLoad (unit=\(adUnitId)) error=\(error)")
        onEvent?(.failedToLoad(error))
    }
}

// MARK: - NativeAdDelegate

extension AdFoxNativeAdapter: NativeAdDelegate {
    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        debugPrint("AdFox Native: clicked (unit=\(adUnitId))")
        onEvent?(.clicked)
    }
    
    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        debugPrint("AdFox Native: will present screen (unit=\(adUnitId))")
        onEvent?(.shown)
    }
    
    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        debugPrint("AdFox Native: did dismiss screen (unit=\(adUnitId))")
        onEvent?(.dismissed)
    }
    
    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        debugPrint("AdFox Native: impression tracked (unit=\(adUnitId))")
        onEvent?(.impression)
    }
    
    func close(_ ad: NativeAd) {
        debugPrint("AdFox Native: closed (unit=\(adUnitId))")
        adView.isHidden = true
    }
}
