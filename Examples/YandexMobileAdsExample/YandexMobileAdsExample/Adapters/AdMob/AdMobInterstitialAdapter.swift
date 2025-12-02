#if COCOAPODS
import GoogleMobileAds

final class AdMobInterstitialAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    private let adUnitId: String
    private weak var hostViewController: UIViewController?
    private var interstitial: GoogleMobileAds.InterstitialAd?
    
    init(adUnitId: String, hostViewController: UIViewController) {
        self.adUnitId = adUnitId
        self.hostViewController = hostViewController
        super.init()
    }
    
    func load() {
        AdMobStarter.startIfNeeded { [weak self] in
            guard let self else { return }
            self.interstitial = nil
            print("AdMob Interstitial: start loading (\(self.adUnitId))")
            
            let request = GoogleMobileAds.Request()
            GoogleMobileAds.InterstitialAd.load(
                with: self.adUnitId,
                request: request
            ) { [weak self] ad, error in
                guard let self else { return }
                
                if let error = error {
                    print("AdMob Interstitial: failed to load \(error.localizedDescription)")
                    self.onEvent?(.failedToLoad(error))
                    return
                }
                
                self.interstitial = ad
                ad?.fullScreenContentDelegate = self
                print("AdMob Interstitial: didReceiveAd")
                self.onEvent?(.loaded)
            }
        }
    }
    
    func tearDown() {
        interstitial?.fullScreenContentDelegate = nil
        interstitial = nil
    }
    
    func present(from viewController: UIViewController) {
        guard let interstitial else {
            print("AdMob Interstitial: not ready to present")
            let error = AdMobError.adNotReady(adType: "Interstitial")
            onEvent?(.failedToShow(error))
            return
        }
        
        print("AdMob Interstitial: presenting...")
        interstitial.present(from: viewController)
    }
}

// MARK: - GoogleMobileAds.FullScreenContentDelegate

extension AdMobInterstitialAdapter: GoogleMobileAds.FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Interstitial: willPresent")
        onEvent?(.shown)
    }
    
    func ad(_ ad: GoogleMobileAds.FullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("AdMob Interstitial: failedToPresent \(error.localizedDescription)")
        onEvent?(.failedToShow(error))
    }
    
    func adWillDismissFullScreenContent(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Interstitial: willDismiss")
    }
    
    func adDidDismissFullScreenContent(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Interstitial: didDismiss")
        interstitial = nil
        onEvent?(.dismissed)
    }
    
    func adDidRecordImpression(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Interstitial: didRecordImpression")
        onEvent?(.impression)
    }
    
    func adDidRecordClick(_ ad: GoogleMobileAds.FullScreenPresentingAd) {
        print("AdMob Interstitial: didrecordClick")
        onEvent?(.clicked)
    }
}
#endif
