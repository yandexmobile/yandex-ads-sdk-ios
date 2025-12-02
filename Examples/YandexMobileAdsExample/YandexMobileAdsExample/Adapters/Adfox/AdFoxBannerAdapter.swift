import YandexMobileAds

final class AdFoxBannerAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { containerView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitId: String
    private let adWidth: CGFloat
    private let maxHeight: CGFloat
    
    private var adView: AdView?
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
    
    init(adUnitId: String, adWidth: CGFloat, maxHeight: CGFloat) {
        self.adUnitId = adUnitId
        self.adWidth = adWidth
        self.maxHeight = maxHeight
        super.init()
    }
    
    func load() {
        tearDown()
        let size = BannerAdSize.inlineSize(withWidth: adWidth, maxHeight: maxHeight)
        let view = AdView(adUnitID: adUnitId, adSize: size)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        adView = view
        containerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.widthAnchor.constraint(equalToConstant: adWidth),
            view.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
        
        let request = MutableAdRequest()
        request.parameters = adFoxParameters
        didLoad = false
        print("AdFox Banner: start loading (unit=\(adUnitId), width=\(adWidth), maxH=\(maxHeight))")
        view.loadAd(with: request)
    }
    
    func tearDown() {
        didLoad = false
        adView?.delegate = nil
        adView?.removeFromSuperview()
        adView = nil
    }
}

// MARK: - AdViewDelegate

extension AdFoxBannerAdapter: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        didLoad = true
        print("AdFox Banner: loaded")
        onEvent?(.loaded)
    }
    
    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        print("AdFox Banner: failed \(error)")
        onEvent?(.failedToLoad(error))
    }
    
    func adViewWillLeaveApplication(_ adView: AdView) {
        onEvent?(.clicked)
    }
    
    func adView(_ adView: AdView, willPresentScreen viewController: UIViewController?) {
        onEvent?(.shown)
    }
    
    func adView(_ adView: AdView, didDismissScreen viewController: UIViewController?) {
        onEvent?(.dismissed)
    }
    
    func adView(_ adView: AdView, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
    }
}
