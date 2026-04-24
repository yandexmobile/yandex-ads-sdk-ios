import UIKit
import YandexMobileAds

final class AdFoxBannerAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { containerView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitID: String
    private let adWidth: CGFloat
    private let maxHeight: CGFloat
    
    private var bannerAdView: BannerAdView?
    private var didLoad = false
    
    private var adFoxParameters: [String: String] = [
        "adf_ownerid": "270901",
        "adf_p1": "cafol",
        "adf_p2": "fhma",
        "adf_pfc": "bskug",
        "adf_pfb": "flrlu",
        "adf_pt": "b"
    ]
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    init(adUnitID: String, adWidth: CGFloat, maxHeight: CGFloat) {
        self.adUnitID = adUnitID
        self.adWidth = adWidth
        self.maxHeight = maxHeight
        super.init()
    }
    
    func load() {
        tearDown()
        let size = BannerAdSize.inline(width: adWidth, maxHeight: maxHeight)
        let view = BannerAdView(adSize: size)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        bannerAdView = view
        containerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.widthAnchor.constraint(equalToConstant: adWidth),
            view.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
        
        let request = AdRequest(adUnitID: adUnitID, parameters: adFoxParameters)
        didLoad = false
        print("AdFox Banner: start loading (unit=\(adUnitID), width=\(adWidth), maxH=\(maxHeight))")
        view.loadAd(with: request)
    }
    
    func tearDown() {
        didLoad = false
        bannerAdView?.delegate = nil
        bannerAdView?.removeFromSuperview()
        bannerAdView = nil
    }
}

// MARK: - AdViewDelegate

extension AdFoxBannerAdapter: BannerAdViewDelegate {
    func bannerAdViewDidLoad(_ bannerAdView: BannerAdView) {
        didLoad = true
        print("AdFox Banner: loaded")
        onEvent?(.loaded)
    }
    
    func bannerAdViewDidFailLoading(_ bannerAdView: BannerAdView, error: Error) {
        print("AdFox Banner: failed \(error)")
        onEvent?(.failedToLoad(error))
    }
    
    func bannerAdView(_ bannerAdView: BannerAdView, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
    }

    func bannerAdViewDidClick(_ bannerAdView: BannerAdView) {
        onEvent?(.clicked)
    }
}
