import UIKit
@preconcurrency import YandexMobileAds

protocol CustomControlsCapable: AnyObject {
    var canApplyCustomControls: Bool { get }
    func applyCustomControls()
}

final class YandexNativeCustomAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { adView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    // MARK: - Private
    
    private let adUnitID: String
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
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }
    
    func load() {
        let request = AdRequest(adUnitID: adUnitID)
        adLoader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let ad):
                print("NativeCustom(\(adUnitID)) did load")
                nativeAd = ad
                ad.delegate = self
                do {
                    try ad.bind(with: adView)
                    adView.isHidden = false
                    adView.callToActionButton?.accessibilityIdentifier = "call"
                    onEvent?(.loaded)

                } catch {
                    print("NativeCustom(\(adUnitID)) bind error: \(error)")
                    onEvent?(.failedToLoad(error))
                }
            case .failure(let error):
                print("NativeCustom(\(adUnitID)) failed to load: \(error)")
                onEvent?(.failedToLoad(error))
            }
        }
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
    
    private func attachCustomControls(to mediaView: YandexMobileAds.NativeMediaView) {
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

// MARK: - NativeAdDelegate

extension YandexNativeCustomAdapter: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        print("NativeCustom(\(adUnitID)) did click")
        onEvent?(.clicked)
    }
    
    func nativeAd(_ ad: NativeAd, didTrackImpression impressionData: ImpressionData?) {
        print("NativeCustom(\(adUnitID)) did track impression")
        onEvent?(.impression)
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
