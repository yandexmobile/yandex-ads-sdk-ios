/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class AppOpenAdController: NSObject {
    static let shared = AppOpenAdController()

    weak var delegate: AppOpenAdControllerDelegate?
    weak var presentingVC: UIViewController?

    private var appOpenAd: AppOpenAd?

    private lazy var appOpenAdLoader: AppOpenAdLoader = {
        let loader = AppOpenAdLoader()
            loader.delegate = self
            return loader
    }()

    func loadAd() {
        // Replace demo-appopenad-yandex with actual Ad Unit ID
        let configuration = AdRequestConfiguration(adUnitID: "demo-appopenad-yandex")
        appOpenAdLoader.loadAd(with: configuration)
    }

    func showAdIfAvailable(from window: UIWindow?) {
        guard let viewController = window?.rootViewController else { return }
        presentingVC = viewController
        appOpenAd?.show(from: presentingVC)
    }

    private func makeMessageDescription(_ appOpenAd: AppOpenAd) -> String {
        "AppOpenAd with Ad Unit ID: \(String(describing: appOpenAd.adInfo?.adUnitId))"
    }
}

// MARK: - YMAAppOpenAdDelegate

extension AppOpenAdController: AppOpenAdDelegate {
    func appOpenAdDidDismiss(_ appOpenAd: AppOpenAd) {
        self.appOpenAd = nil
        print("\(makeMessageDescription(appOpenAd)) did dismiss")
        delegate?.appOpenAdControllerDidDismiss(self)
    }

    func appOpenAd(
        _ appOpenAd: AppOpenAd,
        didFailToShowWithError error: Error
    ) {
        self.appOpenAd = nil
        print("\(makeMessageDescription(appOpenAd)) failed to show. Error: \(String(describing: error))")
        delegate?.appOpenAdController(self, didFailToShowWithError: error)
    }

    func appOpenAdDidShow(_ appOpenAd: AppOpenAd) {
        presentingVC?.presentedViewController?.view.accessibilityIdentifier = CommonAccessibility.bannerView
        print("\(makeMessageDescription(appOpenAd)) did show")
    }

    func appOpenAdDidClick(_ appOpenAd: AppOpenAd) {
        print("\(makeMessageDescription(appOpenAd)) did click")
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("\(makeMessageDescription(appOpenAd)) did track impression")
    }
}

// MARK: - YMAAppOpenAdLoaderDelegate

extension AppOpenAdController: AppOpenAdLoaderDelegate {
    func appOpenAdLoader(
        _ adLoader: AppOpenAdLoader,
        didLoad appOpenAd: AppOpenAd
    ) {
        self.appOpenAd = appOpenAd
        self.appOpenAd?.delegate = self
        print("\(makeMessageDescription(appOpenAd)) did load")
        delegate?.appOpenAdControllerDidLoad(self)
    }

    func appOpenAdLoader(
        _ adLoader: AppOpenAdLoader,
        didFailToLoadWithError error: AdRequestError
    ) {
        appOpenAd = nil
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        delegate?.appOpenAdController(self, didFailToLoadWithError: error)
    }
}
