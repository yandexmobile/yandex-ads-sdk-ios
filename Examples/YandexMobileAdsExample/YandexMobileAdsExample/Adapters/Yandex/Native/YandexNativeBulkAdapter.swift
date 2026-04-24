import UIKit
import YandexMobileAds

protocol NativeBulkProviding: UnifiedAdProtocol {
    var ads: [NativeAd] { get }
    var onAdsChange: (([NativeAd]) -> Void)? { get set }
}

final class YandexNativeBulkAdapter: NSObject, NativeBulkProviding {
    private let adUnitID: String
    private let loader = NativeBulkAdLoader()
    private(set) var ads: [NativeAd] = []
    
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var onAdsChange: (([NativeAd]) -> Void)?
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }
    
    func load() {
        let request = AdRequest(adUnitID: adUnitID)
        loader.loadAds(with: request, adsCount: 3) {
            switch $0 {
            case .success(let ads):
                self.ads = ads
                self.onAdsChange?(ads)
                self.onEvent?(.loaded)
            case .failure(let error):
                self.onEvent?(.failedToLoad(error))
            }
        }
    }
    
    func tearDown() {
        ads.removeAll()
    }
}
