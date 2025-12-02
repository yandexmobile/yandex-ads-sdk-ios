#if COCOAPODS
import GoogleMobileAds

final class AdMobBannerAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { containerView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    private let adUnitId: String
    private weak var hostViewController: UIViewController?
    private var bannerView: GoogleMobileAds.BannerView?
    private var didReceiveAd = false
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        return view
    }()
    
    init(adUnitId: String, hostViewController: UIViewController) {
        self.adUnitId = adUnitId
        self.hostViewController = hostViewController
        super.init()
    }
    
    func load() {
        guard let rootVC = hostViewController else {
            let error = AdMobError.attachNotCalled(adType: "Banner")
            print("AdMob Banner: load aborted — hostViewController is nil")
            onEvent?(.failedToLoad(error))
            return
        }
        
        AdMobStarter.startIfNeeded { [weak self] in
            guard let self else { return }
            self.didReceiveAd = false
            self.bannerView?.delegate = nil
            self.bannerView?.removeFromSuperview()
            self.bannerView = nil
            
            let banner = GoogleMobileAds.BannerView(adSize: GoogleMobileAds.AdSizeBanner)
            banner.translatesAutoresizingMaskIntoConstraints = false
            banner.adUnitID = self.adUnitId
            banner.rootViewController = rootVC
            banner.delegate = self
            self.bannerView = banner
            print("AdMob Banner: load start (\(self.adUnitId))")
            banner.load(GoogleMobileAds.Request())
        }
    }
    
    func tearDown() {
        didReceiveAd = false
        bannerView?.delegate = nil
        bannerView?.removeFromSuperview()
        bannerView = nil
    }
    
}

// MARK: - GADBannerViewDelegate

extension AdMobBannerAdapter: GoogleMobileAds.BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GoogleMobileAds.BannerView) {
        didReceiveAd = true
        bannerView.removeFromSuperview()
        containerView.addSubview(bannerView)
        
        let size = bannerView.adSize.size
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalToConstant: size.width),
            bannerView.heightAnchor.constraint(equalToConstant: size.height),
            bannerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bannerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        debugPrint("AdMob Banner: didReceiveAd (unit=\(adUnitId), size=\(size.width)x\(size.height))")
        onEvent?(.loaded)
    }
    
    func bannerView(_ bannerView: GoogleMobileAds.BannerView, didFailToReceiveAdWithError error: Error) {
        debugPrint("AdMob Banner: didFailToReceiveAd (unit=\(adUnitId)) error=\(error.localizedDescription)")
        onEvent?(.failedToLoad(error))
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GoogleMobileAds.BannerView) {
        debugPrint("AdMob Banner: impression recorded (unit=\(adUnitId))")
        onEvent?(.impression)
    }
    
    func bannerViewDidRecordClick(_ bannerView: GoogleMobileAds.BannerView) {
        debugPrint("AdMob Banner: click recorded (unit=\(adUnitId))")
        onEvent?(.clicked)
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GoogleMobileAds.BannerView) {
        debugPrint("AdMob Banner: will present screen (unit=\(adUnitId))")
        onEvent?(.shown)
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GoogleMobileAds.BannerView) {
        debugPrint("AdMob Banner: will dismiss screen (unit=\(adUnitId))")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GoogleMobileAds.BannerView) {
        debugPrint("AdMob Banner: did dismiss screen (unit=\(adUnitId))")
        onEvent?(.dismissed)
    }
    
    func bannerViewWillLeaveApplication(_ bannerView: GoogleMobileAds.BannerView) {
        debugPrint("AdMob Banner: will leave application (unit=\(adUnitId))")
    }
}
#endif
