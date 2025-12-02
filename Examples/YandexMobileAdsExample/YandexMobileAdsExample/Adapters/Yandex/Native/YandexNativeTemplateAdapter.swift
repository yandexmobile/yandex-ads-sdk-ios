import YandexMobileAds

final class YandexNativeTemplateAdapter: NSObject, UnifiedAdProtocol {
    // MARK: UnifiedAdProtocol
    var inlineView: UIView? { nativeView }
    var onEvent: ((UnifiedAdEvent) -> Void)?

    // MARK: Private
    private let adUnitId: String
    private let loader: NativeAdLoader = NativeAdLoader()
    
    private lazy var nativeView: NativeBannerView = {
        let view = NativeBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var nativeAd: NativeAd? {
        didSet { nativeAd?.delegate = self }
    }

    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
        loader.delegate = self
    }

    func load() {
        let config = NativeAdRequestConfiguration(adUnitID: adUnitId)
        loader.loadAd(with: config)
    }

    func tearDown() {
        nativeView.ad = nil
        nativeAd?.delegate = nil
        nativeAd = nil
        nativeView.removeFromSuperview()
    }
}

// MARK: - NativeAdLoaderDelegate
extension YandexNativeTemplateAdapter: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        nativeAd = ad
        nativeView.ad = ad
        onEvent?(.loaded)
        print("Native(\(adUnitId)) loaded")
    }

    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        onEvent?(.failedToLoad(error))
        print("Native(\(adUnitId)) failed to load: \(error.localizedDescription)")
    }
}

// MARK: - NativeAdDelegate
extension YandexNativeTemplateAdapter: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        onEvent?(.clicked)
        print("Native(\(adUnitId)) did click")
    }

    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("Native(\(adUnitId)) did track impression")
    }

    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        onEvent?(.shown)
        print("Native(\(adUnitId)) will present screen")
    }

    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        onEvent?(.dismissed)
        print("Native(\(adUnitId)) did dismiss screen")
    }

    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        print("Native(\(adUnitId)) will leave application")
    }

    func close(_ ad: NativeAd) {
        print("Native(\(adUnitId)) close")
    }
}
