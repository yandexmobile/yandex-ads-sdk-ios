#if COCOAPODS
import GoogleMobileAds

final class AdMobNativeAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { containerView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitId: String
    private weak var hostViewController: UIViewController?
    private var adLoader: GoogleMobileAds.AdLoader?
    private var currentNativeAd: GoogleMobileAds.NativeAd?
    private var adView: AdMobNativeAdView?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    init(adUnitId: String, hostViewController: UIViewController) {
        self.adUnitId = adUnitId
        self.hostViewController = hostViewController
        super.init()
        setupAdView()
    }
    
    private func setupAdView() {
        if let view = Bundle.main.loadNibNamed("AdMobNativeAdView", owner: nil, options: nil)?.first as? AdMobNativeAdView {
            adView = view
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isHidden = true
            containerView.addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                view.topAnchor.constraint(equalTo: containerView.topAnchor),
                view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        } else {
            print("AdMobNativeAdapter: failed to load AdMobNativeAdView.xib")
        }
    }
    
    func load() {
        AdMobStarter.startIfNeeded { [weak self] in
            guard let self else { return }
            guard let rootVC = self.hostViewController else {
                let error = AdMobError.attachNotCalled(adType: "Native")
                print("AdMobNativeAdapter: no hostViewController")
                self.onEvent?(.failedToLoad(error))
                return
            }
            
            self.tearDown(keepView: true)
            
            self.adLoader = GoogleMobileAds.AdLoader(
                adUnitID: self.adUnitId,
                rootViewController: rootVC,
                adTypes: [.native],
                options: nil
            )
            self.adLoader?.delegate = self
            
            print("AdMob Native: start loading (\(self.adUnitId))")
            self.adLoader?.load(GoogleMobileAds.Request())
        }
    }
    
    func tearDown() {
        tearDown(keepView: false)
    }
    
    private func tearDown(keepView: Bool) {
        adLoader?.delegate = nil
        adLoader = nil
        
        currentNativeAd?.delegate = nil
        currentNativeAd = nil
        
        if keepView {
            adView?.isHidden = true
            adView?.nativeAd = nil
        } else {
            adView?.removeFromSuperview()
            adView = nil
            setupAdView()
        }
    }
    
}

// MARK: - GAD AdLoader Delegate

extension AdMobNativeAdapter: GoogleMobileAds.AdLoaderDelegate, GoogleMobileAds.NativeAdLoaderDelegate {
    func adLoader(_ adLoader: GoogleMobileAds.AdLoader, didFailToReceiveAdWithError error: Error) {
        print("AdMob Native: failed to load \(error.localizedDescription)")
        onEvent?(.failedToLoad(error))
    }
    
    func adLoader(_ adLoader: GoogleMobileAds.AdLoader, didReceive nativeAd: GoogleMobileAds.NativeAd) {
        print("AdMob Native: didReceiveAd")
        currentNativeAd?.delegate = nil
        currentNativeAd = nativeAd
        nativeAd.delegate = self
        
        guard let adView = adView else {
            print("AdMob Native: adView is nil (xib not loaded?)")
            onEvent?(.failedToLoad(AdMobError.templateNotFound(adType: "Native")))
            return
        }
        adView.nativeAd = nativeAd
        adView.configureAssetViews()
        adView.isHidden = false
        onEvent?(.loaded)
    }
}

// MARK: - GAD NativeAd Delegate

extension AdMobNativeAdapter: GoogleMobileAds.NativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: GoogleMobileAds.NativeAd) {
        debugPrint("AdMob Native: impression recorded (unit=\(adUnitId))")
        onEvent?(.impression)
    }
    
    func nativeAdDidRecordClick(_ nativeAd: GoogleMobileAds.NativeAd) {
        debugPrint("AdMob Native: clicked (unit=\(adUnitId))")
        onEvent?(.clicked)
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GoogleMobileAds.NativeAd) {
        debugPrint("AdMob Native: will present screen (unit=\(adUnitId))")
        onEvent?(.shown)
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GoogleMobileAds.NativeAd) {
        debugPrint("AdMob Native: will dismiss screen (unit=\(adUnitId))")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GoogleMobileAds.NativeAd) {
        debugPrint("AdMob Native: did dismiss screen (unit=\(adUnitId))")
        onEvent?(.dismissed)
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GoogleMobileAds.NativeAd) {
        debugPrint("AdMob Native: will leave application (unit=\(adUnitId))")
    }
}
#endif
