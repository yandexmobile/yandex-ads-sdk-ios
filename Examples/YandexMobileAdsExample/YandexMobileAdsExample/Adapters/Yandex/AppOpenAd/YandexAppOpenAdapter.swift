import YandexMobileAds
import UIKit

final class YandexAppOpenAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { nil }
    
    private let adUnitId: String
    private let loader = AppOpenAdLoader()
    private weak var presentingVC: UIViewController?
    private var hasBeenInBackground = false
    private var isPresentingAd = false
    private var appOpenAd: AppOpenAd? {
        didSet { appOpenAd?.delegate = self }
    }
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
        loader.delegate = self
        setupNotifications()
    }

    func load() {
        hasBeenInBackground = false
        isPresentingAd = false
        appOpenAd = nil
        let config = AdRequestConfiguration(adUnitID: adUnitId)
        loader.loadAd(with: config)
    }

    func tearDown() {
        NotificationCenter.default.removeObserver(self)
        appOpenAd?.delegate = nil
        appOpenAd = nil
        presentingVC = nil
        hasBeenInBackground = false
        isPresentingAd = false
    }

    func present(from viewController: UIViewController) {
        presentingVC = viewController
        appOpenAd?.show(from: viewController)
    }
    
    func setPresentingViewController(_ viewController: UIViewController) {
        presentingVC = viewController
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc
    private func onWillEnterForeground() {
        guard let presentingVC = presentingVC,
              appOpenAd != nil,
              hasBeenInBackground,
              !isPresentingAd else { return }
        
        isPresentingAd = true
        appOpenAd?.show(from: presentingVC)
    }
    
    @objc
    private func onDidEnterBackground() {
        hasBeenInBackground = true
    }
}

// MARK: - AppOpenAdLoaderDelegate

extension YandexAppOpenAdapter: AppOpenAdLoaderDelegate {
    func appOpenAdLoader(_ adLoader: AppOpenAdLoader, didLoad appOpenAd: AppOpenAd) {
        self.appOpenAd = appOpenAd
        print("AppOpen(\(adUnitId)) did load")
        onEvent?(.loaded)
    }

    func appOpenAdLoader(_ adLoader: AppOpenAdLoader, didFailToLoadWithError error: AdRequestError) {
        self.appOpenAd = nil
        print("AppOpen load failed id=\(String(describing: error.adUnitId)) err=\(error.error)")
        onEvent?(.failedToLoad(error.error))
    }
}

// MARK: - AppOpenAdDelegate

extension YandexAppOpenAdapter: AppOpenAdDelegate {
    func appOpenAdDidShow(_ appOpenAd: AppOpenAd) {
        presentingVC?.presentedViewController?.view.accessibilityIdentifier = CommonAccessibility.bannerView
        print("AppOpen(\(adUnitId)) did show")
        onEvent?(.shown)
    }

    func appOpenAdDidDismiss(_ appOpenAd: AppOpenAd) {
        print("AppOpen(\(adUnitId)) did dismiss")
        self.appOpenAd = nil
        isPresentingAd = false
        onEvent?(.dismissed)
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didFailToShowWithError error: Error) {
        print("AppOpen(\(adUnitId)) failed to show: \(error)")
        self.appOpenAd = nil
        isPresentingAd = false
        onEvent?(.failedToShow(error))
    }

    func appOpenAdDidClick(_ appOpenAd: AppOpenAd) {
        print("AppOpen(\(adUnitId)) did click")
        onEvent?(.clicked)
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("AppOpen(\(adUnitId)) did track impression")
        onEvent?(.impression)
    }
}
