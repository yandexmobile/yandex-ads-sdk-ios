import UIKit
import YandexMobileAds

final class YandexInterstitialAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    // MARK: - UnifiedAdProtocol
    
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { nil }
    
    // MARK: - Private
    
    private let adUnitID: String
    private let loader: InterstitialAdLoader = InterstitialAdLoader()
    private var interstitialAd: InterstitialAd? {
        didSet {
            interstitialAd?.delegate = self
        }
    }
    
    // MARK: - Init

    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }
    
    // MARK: - Methods
    
    func load() {
        let request = AdRequest(adUnitID: adUnitID)
        loader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let interstitialAd):
                self.interstitialAd = interstitialAd
                self.interstitialAd?.delegate = self
                onEvent?(.loaded)
                print("\(makeMessageDescription(interstitialAd)) loaded")
            case .failure(let error):
                onEvent?(.failedToLoad(error))
                print("Loading failed for Ad with Unit ID: \(String(describing: adUnitID)). Error: \(String(describing: error))")
            }
        }
    }
    
    func present(from viewController: UIViewController) {
        interstitialAd?.show(from: viewController)
    }
    
    func tearDown() {
        interstitialAd?.delegate = nil
        interstitialAd = nil
    }
    
    // MARK: - Helpers
    
    private func makeMessageDescription(_ interstitialAd: InterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(adUnitID)"
    }
}

extension YandexInterstitialAdapter: InterstitialAdDelegate {
    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        onEvent?(.shown)
        print("\(makeMessageDescription(interstitialAd)) did show")
    }
    
    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        self.interstitialAd = nil
        onEvent?(.dismissed)
        print("\(makeMessageDescription(interstitialAd)) did dismiss")
    }
    
    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        onEvent?(.clicked)
        print("\(makeMessageDescription(interstitialAd)) did сlick")
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpression impressionData: ImpressionData?) {
        onEvent?(.impression)
        print("\(makeMessageDescription(interstitialAd)) did track impression")
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShow error: Error) {
        self.interstitialAd = nil
        onEvent?(.failedToShow(error))
        print("\(makeMessageDescription(interstitialAd)) failed to show. Error: \(error)")
    }
}
