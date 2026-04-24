import YandexMobileAds
import UIKit

final class YandexAppOpenAdapter: NSObject, UnifiedAdProtocol, PresentableAdProtocol {
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { nil }
    
    private let adUnitID: String
    private let loader = AppOpenAdLoader()
    private weak var presentingVC: UIViewController?
    private var hasBeenInBackground = false
    private var isPresentingAd = false
    private var appOpenAd: AppOpenAd? {
        didSet { appOpenAd?.delegate = self }
    }
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        setupNotifications()
    }

    func load() {
        hasBeenInBackground = false
        isPresentingAd = false
        appOpenAd = nil
        let request = AdRequest(adUnitID: adUnitID)
        loader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let appOpenAd):
                self.appOpenAd = appOpenAd
                print("AppOpen(\(adUnitID)) did load")
                onEvent?(.loaded)
            case .failure(let error):
                self.appOpenAd = nil
                print("AppOpen load failed id=\(String(describing: adUnitID)) err=\(error)")
                onEvent?(.failedToLoad(error))
            }
        }
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

// MARK: - AppOpenAdDelegate

extension YandexAppOpenAdapter: AppOpenAdDelegate {
    func appOpenAdDidShow(_ appOpenAd: AppOpenAd) {
        presentingVC?.presentedViewController?.view.accessibilityIdentifier = CommonAccessibility.bannerView
        print("AppOpen(\(adUnitID)) did show")
        onEvent?(.shown)
    }

    func appOpenAdDidDismiss(_ appOpenAd: AppOpenAd) {
        print("AppOpen(\(adUnitID)) did dismiss")
        self.appOpenAd = nil
        isPresentingAd = false
        onEvent?(.dismissed)
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didFailToShow error: Error) {
        print("AppOpen(\(adUnitID)) failed to show: \(error)")
        self.appOpenAd = nil
        isPresentingAd = false
        onEvent?(.failedToShow(error))
    }

    func appOpenAdDidClick(_ appOpenAd: AppOpenAd) {
        print("AppOpen(\(adUnitID)) did click")
        onEvent?(.clicked)
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didTrackImpression impressionData: ImpressionData?) {
        print("AppOpen(\(adUnitID)) did track impression")
        onEvent?(.impression)
    }
}
