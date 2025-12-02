import UIKit
import YandexMobileAds

protocol NativeBulkProviding: UnifiedAdProtocol {
    var ads: [NativeAd] { get }
    var onAdsChange: (([NativeAd]) -> Void)? { get set }
}

final class YandexNativeBulkAdapter: NSObject, NativeBulkProviding {
    private let adUnitId: String
    private let loader = NativeBulkAdLoader()
    private(set) var ads: [NativeAd] = []
    
    var inlineView: UIView? { nil }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var onAdsChange: (([NativeAd]) -> Void)?
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
        loader.delegate = self
    }
    
    func load() {
        let config = NativeAdRequestConfiguration(adUnitID: adUnitId)
        loader.loadAds(with: config, adsCount: 3)
    }
    
    func tearDown() {
        ads.removeAll()
    }
}

extension YandexNativeBulkAdapter: NativeBulkAdLoaderDelegate {
    func nativeBulkAdLoader(_ loader: NativeBulkAdLoader, didLoad ads: [NativeAd]) {
        self.ads = ads
        self.onAdsChange?(ads)
        self.onEvent?(.loaded)
    }
    
    func nativeBulkAdLoader(_ loader: NativeBulkAdLoader, didFailLoadingWithError error: Error) {
        self.onEvent?(.failedToLoad(error))
    }
}
