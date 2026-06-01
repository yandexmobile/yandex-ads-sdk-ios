/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

@MainActor
final class YandexNativeTemplateAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { adView }
    var onEvent: ((UnifiedAdEvent) -> Void)?

    private let adUnitID: String
    private let adLoader = NativeAdLoader()
    private var nativeAd: NativeAd?
    private let adView = NativeAdBannerView()

    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        adView.isHidden = true
    }

    func load() {
        nativeAd?.delegate = nil
        nativeAd = nil
        adView.isHidden = true
        let request = AdRequest(adUnitID: adUnitID)

        debugPrint("Yandex Native Template: start loading (unit=\(adUnitID))")
        adLoader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let ad):
                nativeAd = ad
                ad.delegate = self
                do {
                    try ad.bind(with: adView)
                    adView.isHidden = false
                    adView.accessibilityIdentifier = CommonAccessibility.bannerView
                    debugPrint("Yandex Native Template: loaded successfully (unit=\(adUnitID))")
                    onEvent?(.loaded)
                } catch {
                    debugPrint("Yandex Native Template: bind failed (unit=\(adUnitID)) error=\(error)")
                    onEvent?(.failedToLoad(error))
                }
            case .failure(let error):
                debugPrint("Yandex Native Template: failedToLoad (unit=\(adUnitID)) error=\(error)")
                onEvent?(.failedToLoad(error))
            }
        }
    }

    func tearDown() {
        nativeAd?.delegate = nil
        nativeAd = nil
        adView.isHidden = true
        adView.removeFromSuperview()
        debugPrint("Yandex Native Template: tearDown (unit=\(adUnitID))")
    }
}

// MARK: - NativeAdDelegate

extension YandexNativeTemplateAdapter: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        debugPrint("Yandex Native Template: clicked (unit=\(adUnitID))")
        onEvent?(.clicked)
    }

    func nativeAd(_ ad: NativeAd, didTrackImpression impressionData: ImpressionData?) {
        debugPrint("Yandex Native Template: impression tracked (unit=\(adUnitID))")
        onEvent?(.impression)
    }
}
