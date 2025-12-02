import YandexMobileAds

protocol CustomControlsCapable: AnyObject {
    var canApplyCustomControls: Bool { get }
    func applyCustomControls()
}

final class YandexNativeCustomAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { adView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    // MARK: - Private
    
    private let adUnitId: String
    private let adLoader = NativeAdLoader()
    private var nativeAd: NativeAd?
    private var didApplyCustomControls = false
    private lazy var videoProgressControl = NativeVideoProgressControlView()
    private lazy var videoMuteControl = NativeVideoMuteControlView()
    
    private lazy var adView: NativeCustomAdView = {
        let view = NativeCustomAdView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Init
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
        adLoader.delegate = self
    }
    
    func load() {
        let request = NativeAdRequestConfiguration(adUnitID: adUnitId)
        adLoader.loadAd(with: request)
    }
    
    func tearDown() {
        removeCustomControlsIfAny()
        didApplyCustomControls = false
        nativeAd?.delegate = nil
        nativeAd = nil
        adView.removeFromSuperview()
        adView.isHidden = true
    }
    
    // MARK: - Helpers
    
    private func attachCustomControls(to mediaView: YMANativeMediaView) {
        guard !didApplyCustomControls else { return }
        
        let playback = NativeVideoPlaybackControls(
            progressControl: videoProgressControl,
            muteControl: videoMuteControl
        )
        playback.setupVideoPlaybackControls(to: mediaView)
        
        mediaView.addSubview(videoProgressControl)
        mediaView.addSubview(videoMuteControl)
        videoProgressControl.translatesAutoresizingMaskIntoConstraints = false
        videoMuteControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoProgressControl.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
            videoProgressControl.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor),
            videoProgressControl.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor),
            videoProgressControl.heightAnchor.constraint(equalToConstant: 6),
            
            videoMuteControl.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
            videoMuteControl.topAnchor.constraint(equalTo: mediaView.topAnchor)
        ])
        didApplyCustomControls = true
    }
    
    private func removeCustomControlsIfAny() {
        videoProgressControl.removeFromSuperview()
        videoMuteControl.removeFromSuperview()
    }
}

// MARK: - NativeAdLoaderDelegate

extension YandexNativeCustomAdapter: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        print("NativeCustom(\(adUnitId)) did load")
        nativeAd = ad
        ad.delegate = self
        do {
            try ad.bind(with: adView)
            adView.isHidden = false
            adView.callToActionButton?.accessibilityIdentifier = "call"
            onEvent?(.loaded)

        } catch {
            print("NativeCustom(\(adUnitId)) bind error: \(error)")
            onEvent?(.failedToLoad(error))
        }
    }
    
    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        print("NativeCustom(\(adUnitId)) failed to load: \(error)")
        onEvent?(.failedToLoad(error))
    }
}

// MARK: - NativeAdDelegate

extension YandexNativeCustomAdapter: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        print("NativeCustom(\(adUnitId)) did click")
        onEvent?(.clicked)
    }
    
    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        print("NativeCustom(\(adUnitId)) will leave application")
    }
    
    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        print("NativeCustom(\(adUnitId)) will present screen")
        onEvent?(.shown)
    }
    
    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("NativeCustom(\(adUnitId)) did track impression")
        onEvent?(.impression)
    }
    
    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        print("NativeCustom(\(adUnitId)) did dismiss screen")
        onEvent?(.dismissed)
    }
    
    func close(_ ad: NativeAd) {
        print("NativeCustom(\(adUnitId)) close called")
    }
}

// MARK: - CustomControlsCapable

extension YandexNativeCustomAdapter: CustomControlsCapable {
    var canApplyCustomControls: Bool {
        adView.mediaView != nil
    }
    
    func applyCustomControls() {
        guard let mediaView = adView.mediaView, !didApplyCustomControls else { return }
        attachCustomControls(to: mediaView)
        mediaView.bringSubviewToFront(videoMuteControl)
    }
}
