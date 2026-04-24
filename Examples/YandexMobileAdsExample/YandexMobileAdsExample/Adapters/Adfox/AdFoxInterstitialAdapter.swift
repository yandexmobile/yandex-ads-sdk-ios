import UIKit
import YandexMobileAds

final class AdFoxInterstitialAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitID: String
    private var adFoxParameters: [String: String] = [
        "adf_ownerid": "270901",
        "adf_p1": "caboi",
        "adf_p2": "fkbc",
        "adf_pfc": "bskug",
        "adf_pfb": "fkjam",
        "adf_pt": "b"
    ]
    private let interstitialAdLoader = InterstitialAdLoader()
    private var interstitialAd: InterstitialAd?
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }
    
    func load() {
        tearDown()
        let request = AdRequest(adUnitID: adUnitID, parameters: adFoxParameters)

        interstitialAdLoader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let interstitialAd):
                print("Interstitial Ad with Unit ID: \(adUnitID) loaded")
                self.interstitialAd = interstitialAd
                interstitialAd.delegate = self
                onEvent?(.loaded)
            case .failure(let error):
                print("Loading failed for Ad with Unit ID: \(String(describing: adUnitID)). Error: \(String(describing: error))")
                onEvent?(.failedToLoad(error))
            }
        }
    }
    
    func tearDown() {
        interstitialAd?.delegate = nil
        interstitialAd = nil
    }
    
    func present(from viewController: UIViewController) {
        interstitialAd?.show(from: viewController)
    }
}

// MARK: - InterstitialAdDelegate

extension AdFoxInterstitialAdapter: InterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShow error: Error) {
        print("Interstitial Ad with Unit ID: \(adUnitID) failed to show. Error: \(error)")
        onEvent?(.failedToShow(error))
    }
    
    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad with Unit ID: \(adUnitID) did show")
        if let topVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .presentedViewController
        {
            topVC.view.accessibilityIdentifier = CommonAccessibility.bannerView
        }
        onEvent?(.shown)
    }
    
    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad with Unit ID: \(adUnitID) did dismiss")
        onEvent?(.dismissed)
        self.interstitialAd = nil
    }
    
    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        print("Interstitial Ad with Unit ID: \(adUnitID) did click")
        onEvent?(.clicked)
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpression impressionData: ImpressionData?) {
        print("Interstitial Ad with Unit ID: \(adUnitID) did track impression")
        onEvent?(.impression)
    }
}
