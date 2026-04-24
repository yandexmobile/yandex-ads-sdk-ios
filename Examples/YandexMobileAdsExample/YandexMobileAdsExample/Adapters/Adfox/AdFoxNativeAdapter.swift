import UIKit
import YandexMobileAds

@MainActor
final class AdFoxNativeAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { adView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitID: String
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
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        self.adView = NativeAdView.nib ?? NativeAdView()
        super.init()
        adView.isHidden = true
    }
    
    func load() {
        nativeAd?.delegate = nil
        nativeAd = nil
        adView.isHidden = true
        let request = AdRequest(adUnitID: adUnitID, parameters: adFoxParameters)

        debugPrint("AdFox Native: start loading (unit=\(adUnitID), params=\(adFoxParameters))")
        adLoader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let ad):
                nativeAd = ad
                ad.delegate = self
                do {
                    try ad.bind(with: adView)
                    adView.configureAssetViews()
                    adView.isHidden = false
                    adView.accessibilityIdentifier = CommonAccessibility.bannerView
                    debugPrint("AdFox Native: loaded successfully (unit=\(adUnitID))")
                    onEvent?(.loaded)
                } catch {
                    debugPrint("AdFox Native: bind failed (unit=\(adUnitID)) error=\(error)")
                    onEvent?(.failedToLoad(error))
                }
            case .failure(let error):
                debugPrint("AdFox Native: failedToLoad (unit=\(adUnitID)) error=\(error)")
                onEvent?(.failedToLoad(error))
            }
        }
    }
    
    func tearDown() {
        nativeAd?.delegate = nil
        nativeAd = nil
        adView.isHidden = true
        adView.removeFromSuperview()
        debugPrint("AdFox Native: tearDown (unit=\(adUnitID))")
    }
}

// MARK: - NativeAdDelegate

extension AdFoxNativeAdapter: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        debugPrint("AdFox Native: clicked (unit=\(adUnitID))")
        onEvent?(.clicked)
    }
    
    func nativeAd(_ ad: NativeAd, didTrackImpression impressionData: ImpressionData?) {
        debugPrint("AdFox Native: impression tracked (unit=\(adUnitID))")
        onEvent?(.impression)
    }
}
