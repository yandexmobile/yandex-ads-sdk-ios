/**
 This file describes implementation of `MediationAPI`.
 You could use it for a more simple adaptation to your advertising network API.
 */

import Foundation
import YandexMobileAds

//MARK: - Base Adapter

/// This struct is a mock for error  wich coud accour in adapter. Error object and error message depends from you ad network API.
struct AdapterError: LocalizedError {
    let errorDescription: String
}

private let mockPresentingError = AdapterError(errorDescription: "Ad Display Failed")

/// This class implements base methods for all other adapters.
class YandexBaseAdapter: NSObject, MediationBidding, MediationInitialization {
    private static let bidderTokenLoader = YMABidderTokenLoader()

    /// Get a bidding token in order to use it with in-app bidding integration with Yandex.
    /// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Classes/YMABidderTokenLoader.html
    static func getBiddingToken(completion: @escaping (String?) -> Void) {
        Self.bidderTokenLoader.loadBidderToken() { token in
            completion(token)
        }
    }

    /// Successfully initializing the Yandex Mobile Ads SDK is an important condition for correctly integrating the library.
    /// By default, SDK initialization happens automatically before ads load, but manual initialization will speed up how quickly the first ad loads
    /// and therefore increase revenue from monetization.
    /// https://yandex.ru/support2/mobile-ads/en/dev/ios/quick-start
    static func initializeSDK() {
        YMAMobileAds.initializeSDK()
    }

    /// Configure all necessary parameters and create YMAAdRequestConfiguration.
    func makeAdRequestConfiguration(with adData: AdData, parameters: AdapterParameters) -> YMAAdRequestConfiguration {
        let configParameters = [
            "adapter_network_name": parameters.adapterNetworkName,
            "adapter_version": parameters.adapterVersion,
            "adapter_network_sdk_version": parameters.adapterSdkVersion
        ]
        let configuration = YMAMutableAdRequestConfiguration(adUnitID: adData.adUinitId)
        
        configuration.parameters = configParameters

        if let biddingData = adData.bidId {
            configuration.biddingData = biddingData
        }

        if let userConsent = parameters.userConsent {
            YMAMobileAds.setUserConsent(userConsent)
        }

        if let locationTracking = parameters.locationTracking {
            YMAMobileAds.setLocationTrackingEnabled(locationTracking)
        }

        if let isTesting = parameters.isTesting, isTesting {
            YMAMobileAds.enableLogging()
        }

        return configuration
    }
}

//MARK: - Banner Adapter

/// This class implements base methods for banner adapter.
final class YandexBannerAdapter: YandexBaseAdapter, MediationBanner {
    private weak var delegate: MediationBannerDelegate?
    private var adView: YMAAdView?

    func loadBannerAd(with adData: AdData,
                      size: CGSize,
                      delegate: MediationBannerDelegate,
                      parameters: AdapterParameters) {

        /// Creates an object of the YMABannerAdSize class with the specified maximum height and width of the banner.
        /// Also you coud use another sizes: https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Classes/YMABannerAdSize.html
        let adSize = YMABannerAdSize.inlineSize(withWidth: size.width, maxHeight: size.height)
        let adView = YMAAdView(adUnitID: adData.adUinitId,
                               adSize: adSize)
        let requestConfiguration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        let request = YMAMutableAdRequest()
        request.biddingData = requestConfiguration.biddingData
        request.parameters = requestConfiguration.parameters

        adView.delegate = self
        adView.loadAd(with: request)
    }

    func destroy() {
        adView?.removeFromSuperview()
        adView?.delegate = nil
        adView = nil
    }
}

/// YMAAdViewDelegate implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/YMAAdViewDelegate.html
extension YandexBannerAdapter: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView) {
        delegate?.didLoadAd(with: adView)
    }

    func adViewDidClick(_ adView: YMAAdView) {
        delegate?.didClickAdView()
    }

    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        delegate?.adViewWillLeaveApplication()
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        delegate?.adViewWillDismissScreen()
    }

    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        delegate?.adViewWillPresentScreen()
    }

    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        delegate?.didFailToLoadAdView(with: error)
    }

    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        delegate?.didTrackImpression()
    }
}

//MARK: - Interstitial Adapter

/// This class implements base methods for interstitial adapter.
final class YandexInterstitialAdapter: YandexBaseAdapter, MediationInterstitial {
    private weak var delegate: MediationInterstitialDelegate?
    private lazy var loader: YMAInterstitialAdLoader = {
        let loader = YMAInterstitialAdLoader()
        loader.delegate = self
        return loader
    }()
    private var interstitialAd: YMAInterstitialAd?

    func loadInterstitialAd(with adData: AdData,
                            delegate: MediationInterstitialDelegate,
                            parameters: AdapterParameters) {
        self.delegate  = delegate
        let configuration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        loader.loadAd(with: configuration)
    }
    
    func showInterstitialAd(with viewController: UIViewController,
                            delegate: MediationInterstitialDelegate,
                            adData: AdData) {
        guard let interstitialAd else {
            delegate.interstitialDidFailToShow(with: mockPresentingError)
            return
        }

        interstitialAd.show(from: viewController)
    }

    func destroy() {
        interstitialAd?.delegate = nil
        interstitialAd = nil
    }
}

/// YMAInterstitialAdDelegate implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/YMAInterstitialAdDelegate.html
extension YandexInterstitialAdapter: YMAInterstitialAdDelegate {
    func interstitialAdDidShow(_ interstitialAd: YMAInterstitialAd) {
        delegate?.interstitialDidShow()
    }

    func interstitialAdDidDismiss(_ interstitialAd: YMAInterstitialAd) {
        delegate?.interstitialDidDismiss()
    }

    func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
        delegate?.interstitialDidClick()
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        delegate?.interstitialDidTrackImpression()
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didFailToShowWithError error: Error) {
        delegate?.interstitialDidFailToShow(with: error)
    }
}

/// YMAInterstitialAdLoaderDelegate implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/YMAInterstitialAdLoaderDelegate.html
extension YandexInterstitialAdapter: YMAInterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didLoad interstitialAd: YMAInterstitialAd) {
        interstitialAd.delegate = self
        self.interstitialAd = interstitialAd
        delegate?.interstitialDidLoad()
    }
    
    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        delegate?.interstitialDidFailToLoad(with: error.error)
    }
}

//MARK: - Rewarded Adapter

/// This class implements base methods for rewardedl adapter.
final class YandexRewardedAdapter: YandexBaseAdapter, MediationRewarded {
    private weak var delegate: MediationRewardedDelegate?
    private lazy var loader: YMARewardedAdLoader = {
        let loader = YMARewardedAdLoader()
        loader.delegate = self
        return loader
    }()
    private var rewardedAd: YMARewardedAd?

    func loadRewardedAd(with adData: AdData,
                        delegate: MediationRewardedDelegate,
                        parameters: AdapterParameters) {
        self.delegate  = delegate
        let configuration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        loader.loadAd(with: configuration)
    }
    
    func showRewardedAd(with viewController: UIViewController,
                        delegate: MediationRewardedDelegate,
                        adData: AdData) {
        guard let rewardedAd else {
            delegate.rewardedDidFailToShow(with: mockPresentingError)
            return
        }

        rewardedAd.show(from: viewController)
    }

    func destroy() {
        rewardedAd?.delegate = nil
        rewardedAd = nil
    }
}

/// YMARewardedAdDelegate implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/YMARewardedAdDelegate.html
extension YandexRewardedAdapter: YMARewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        delegate?.didRewardUser()
    }

    func rewardedAdDidShow(_ rewardedAd: YMARewardedAd) {
        delegate?.rewardedDidShow()
    }

    func rewardedAdDidDismiss(_ rewardedAd: YMARewardedAd) {
        delegate?.rewardedDidDismiss()
    }

    func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
        delegate?.rewardedDidClick()
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        delegate?.rewardedDidTrackImpression()
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didFailToShowWithError error: Error) {
        delegate?.rewardedDidFailToShow(with: error)
    }
}

/// YMARewardedAdLoaderDelegate implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/YMARewardedAdLoaderDelegate.html
extension YandexRewardedAdapter: YMARewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: YMARewardedAdLoader, didLoad rewardedAd: YMARewardedAd) {
        rewardedAd.delegate = self
        self.rewardedAd = rewardedAd
        delegate?.rewardedDidLoad()
    }
    
    func rewardedAdLoader(_ adLoader: YMARewardedAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        delegate?.rewardedDidFailToShow(with: error.error)
    }
}

//MARK: - AppOpen Adapter

/// This class implements base methods for appOpen adapter.
final class YandexAppOpenAdapter: YandexBaseAdapter, MediationAppOpen {
    private weak var delegate: MediationAppOpenDelegate?
    private lazy var loader: YMAAppOpenAdLoader = {
        let loader = YMAAppOpenAdLoader()
        loader.delegate = self
        return loader
    }()
    private var appOpenAd: YMAAppOpenAd?

    func loadAd(with adData: AdData,
                delegate: MediationAppOpenDelegate,
                parameters: AdapterParameters) {
        self.delegate  = delegate
        let configuration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        loader.loadAd(with: configuration)
    }

    func showAd(with viewController: UIViewController,
                delegate: MediationAppOpenDelegate,
                adData: AdData) {
        guard let appOpenAd else {
            delegate.appOpenDidFailToShow(with: mockPresentingError)
            return
        }

        appOpenAd.show(from: viewController)
    }

    func destroy() {
        appOpenAd?.delegate = nil
        appOpenAd = nil
    }
}

/// YMAAppOpenAdDelegate implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/YMAAppOpenAdDelegate.html
extension YandexAppOpenAdapter: YMAAppOpenAdDelegate {
    func appOpenAdDidShow(_ appOpenAd: YMAAppOpenAd) {
        delegate?.appOpenDidShow()
    }

    func appOpenAdDidDismiss(_ appOpenAd: YMAAppOpenAd) {
        delegate?.appOpenDidDismiss()
    }

    func appOpenAdDidClick(_ appOpenAd: YMAAppOpenAd) {
        delegate?.appOpenDidClick()
    }

    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        delegate?.appOpenDidTrackImpression()
    }

    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didFailToShowWithError error: Error) {
        delegate?.appOpenDidFailToShow(with: error)
    }
}

/// YMAAppOpenAdLoaderDelegate implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/YMAAppOpenAdLoaderDelegate.html
extension YandexAppOpenAdapter: YMAAppOpenAdLoaderDelegate {
    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didLoad appOpenAd: YMAAppOpenAd) {
        appOpenAd.delegate = self
        self.appOpenAd = appOpenAd
        delegate?.appOpenDidLoad()
    }

    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        delegate?.appOpenDidFailToLoad(with: error.error)
    }
}
