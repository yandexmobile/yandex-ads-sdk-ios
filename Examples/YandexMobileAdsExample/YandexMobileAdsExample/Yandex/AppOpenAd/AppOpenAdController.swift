/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class AppOpenAdController: NSObject {
    static let shared = AppOpenAdController()

    weak var delegate: AppOpenAdControllerDelegate?

    private var appOpenAd: YMAAppOpenAd?

    private lazy var appOpenAdLoader: YMAAppOpenAdLoader = {
            let loader = YMAAppOpenAdLoader()
            loader.delegate = self
            return loader
    }()

    func loadAd() {
        // Replace demo-appopenad-yandex with actual Ad Unit ID
        let configuration = YMAAdRequestConfiguration(adUnitID: "demo-appopenad-yandex")
        appOpenAdLoader.loadAd(with: configuration)
    }

    func showAdIfAvailable(from window: UIWindow?) {
        guard let viewController = window?.rootViewController else { return }
        appOpenAd?.show(from: viewController)
    }

    private func makeMessageDescription(_ appOpenAd: YMAAppOpenAd) -> String {
        "AppOpenAd with Ad Unit ID: \(String(describing: appOpenAd.adInfo?.adUnitId))"
    }
}

// MARK: - YMAAppOpenAdDelegate

extension AppOpenAdController: YMAAppOpenAdDelegate {
    func appOpenAdDidDismiss(_ appOpenAd: YMAAppOpenAd) {
        self.appOpenAd = nil
        print("\(makeMessageDescription(appOpenAd)) did dismiss")
        delegate?.appOpenAdControllerDidDismiss(self)
    }

    func appOpenAd(
        _ appOpenAd: YMAAppOpenAd,
        didFailToShowWithError error: Error
    ) {
        self.appOpenAd = nil
        print("\(makeMessageDescription(appOpenAd)) failed to show. Error: \(String(describing: error))")
        delegate?.appOpenAdController(self, didFailToShowWithError: error)
    }

    func appOpenAdDidShow(_ appOpenAd: YMAAppOpenAd) {
        print("\(makeMessageDescription(appOpenAd)) did show")
    }

    func appOpenAdDidClick(_ appOpenAd: YMAAppOpenAd) {
        print("\(makeMessageDescription(appOpenAd)) did click")
    }

    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("\(makeMessageDescription(appOpenAd)) did track impression")
    }
}

// MARK: - YMAAppOpenAdLoaderDelegate

extension AppOpenAdController: YMAAppOpenAdLoaderDelegate {
    func appOpenAdLoader(
        _ adLoader: YMAAppOpenAdLoader,
        didLoad appOpenAd: YMAAppOpenAd
    ) {
        self.appOpenAd = appOpenAd
        self.appOpenAd?.delegate = self
        print("\(makeMessageDescription(appOpenAd)) did load")
        delegate?.appOpenAdControllerDidLoad(self)
    }

    func appOpenAdLoader(
        _ adLoader: YMAAppOpenAdLoader,
        didFailToLoadWithError error: YMAAdRequestError
    ) {
        appOpenAd = nil
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        delegate?.appOpenAdController(self, didFailToLoadWithError: error)
    }
}
