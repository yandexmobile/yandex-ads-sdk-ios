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
    private static let bidderTokenLoader = BidderTokenLoader(mediationNetworkName: "MEDIATION_NETWORK_NAME")

    /// This method implements obtaining a bid token in order to use it with in-app bidding integration with Yandex.
    /// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Classes/BidderTokenLoader.html
    static func getBiddingToken(parameters: AdapterParameters, completion: @escaping (String?) -> Void) {

        /// Configure all necessary parameters and create `BidderTokenRequestConfiguration`.
        let requestConfiguraton: BidderTokenRequestConfiguration
        switch parameters.adFormat {
        case .banner(let size):
            requestConfiguraton = BidderTokenRequestConfiguration.banner(size: BannerAdSize.fixedSize(withWidth: size.width, height: size.height))
        case .interstitial:
            requestConfiguraton = BidderTokenRequestConfiguration.interstitial()
        case .rewarded:
            requestConfiguraton = BidderTokenRequestConfiguration.rewarded()
        case .appOpen:
            requestConfiguraton = BidderTokenRequestConfiguration.appOpenAd()
        case .native:
            requestConfiguraton = BidderTokenRequestConfiguration.native()
        }

        requestConfiguraton.parameters = Self.makeConfigurationParameters(parameters)
        Self.setupYandexSDK(with: parameters)
        Self.bidderTokenLoader.loadBidderToken(requestConfiguration: requestConfiguraton) { token in
            completion(token)
        }
    }

    /// This method implements creation of general parameters that have to be presented in each request to the Yandex API.
    private static func makeConfigurationParameters(_ parameters: AdapterParameters) -> [String: String] {
        [
            "adapter_network_name": parameters.adapterNetworkName,
            "adapter_version": parameters.adapterVersion,
            "adapter_network_sdk_version": parameters.adapterSdkVersion
        ]
    }

    /// This method implements setting up `MobileAds` parameters, which must be current before each request to the Yandex API.
    static func setupYandexSDK(with parameters: AdapterParameters) {
        if let userConsent = parameters.userConsent {
            MobileAds.setUserConsent(userConsent)
        }

        if let ageRestrictedUser = parameters.ageRestrictedUser {
            MobileAds.setAgeRestrictedUser(ageRestrictedUser)
        }

        if let locationTracking = parameters.locationTracking {
            MobileAds.setLocationTrackingEnabled(locationTracking)
        }

        if let isTesting = parameters.isTesting, isTesting {
            MobileAds.enableLogging()
        }
    }

    /// Successfully initializing the Yandex Mobile Ads SDK is an important condition for correctly integrating the library.
    /// By default, SDK initialization happens automatically before ads load, but manual initialization will speed up how quickly the first ad loads
    /// and therefore increase revenue from monetization.
    /// https://yandex.ru/support2/mobile-ads/en/dev/ios/quick-start
    static func initializeSDK() {
        MobileAds.initializeSDK()
    }

    /// This method implements creation of `AdRequestConfiguration` with  all the necessary parameters.
    func makeAdRequestConfiguration(with adData: AdData, parameters: AdapterParameters) -> AdRequestConfiguration {
        let configuration = MutableAdRequestConfiguration(adUnitID: adData.adUinitId)
        let configParameters = Self.makeConfigurationParameters(parameters)

        configuration.parameters = configParameters

        if let biddingData = adData.bidId {
            configuration.biddingData = biddingData
        }

        return configuration
    }
    
    /// This method implements creation of `NativeAdRequestConfiguration` with  all the necessary parameters.
    func makeNativeAdRequestConfiguration(with adData: AdData, parameters: AdapterParameters) -> NativeAdRequestConfiguration {
        let configuration = MutableNativeAdRequestConfiguration(adUnitID: adData.adUinitId)
        let configParameters = Self.makeConfigurationParameters(parameters)

        configuration.parameters = configParameters

        if let biddingData = adData.bidId {
            configuration.biddingData = biddingData
        }

        return configuration
    }
}

//MARK: - Banner Adapter

/// This class implements base methods for banner adapter.
final class YandexBannerAdapter: YandexBaseAdapter, MediationBanner {
    private weak var delegate: MediationBannerDelegate?
    private var adView: AdView?

    func loadBannerAd(with adData: AdData,
                      size: CGSize,
                      delegate: MediationBannerDelegate,
                      parameters: AdapterParameters) {

        /// Creates an object of the `BannerAdSize` class with the specified maximum height and width of the banner.
        /// Also you coud use another sizes: https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Classes/BannerAdSize.html
        let adSize = BannerAdSize.fixedSize(withWidth: size.width, height: size.height)
        let adView = AdView(adUnitID: adData.adUinitId,
                               adSize: adSize)
        let requestConfiguration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        let request = MutableAdRequest()
        request.biddingData = requestConfiguration.biddingData
        request.parameters = requestConfiguration.parameters

        adView.delegate = self
        Self.setupYandexSDK(with: parameters)
        adView.loadAd(with: request)
    }

    func destroy() {
        adView?.removeFromSuperview()
        adView?.delegate = nil
        adView = nil
    }
}

/// `AdViewDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/AdViewDelegate.html
extension YandexBannerAdapter: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        delegate?.didLoadAd(with: adView)
    }

    func adViewDidClick(_ adView: AdView) {
        delegate?.didClickAdView()
    }

    func adViewWillLeaveApplication(_ adView: AdView) {
        delegate?.adViewWillLeaveApplication()
    }

    func adView(_ adView: AdView, didDismissScreen viewController: UIViewController?) {
        delegate?.adViewWillDismissScreen()
    }

    func adView(_ adView: AdView, willPresentScreen viewController: UIViewController?) {
        delegate?.adViewWillPresentScreen()
    }

    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        delegate?.didFailToLoadAdView(with: error)
    }

    func adView(_ adView: AdView, didTrackImpression impressionData: ImpressionData?) {
        delegate?.didTrackImpression()
    }
}

//MARK: - Interstitial Adapter

/// This class implements base methods for interstitial adapter.
final class YandexInterstitialAdapter: YandexBaseAdapter, MediationInterstitial {
    private weak var delegate: MediationInterstitialDelegate?
    private lazy var loader: InterstitialAdLoader = {
        let loader = InterstitialAdLoader()
        loader.delegate = self
        return loader
    }()
    private var interstitialAd: InterstitialAd?

    func loadInterstitialAd(with adData: AdData,
                            delegate: MediationInterstitialDelegate,
                            parameters: AdapterParameters) {
        self.delegate  = delegate
        let configuration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
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

/// `InterstitialAdDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/InterstitialAdDelegate.html
extension YandexInterstitialAdapter: InterstitialAdDelegate {
    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        delegate?.interstitialDidShow()
    }

    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        delegate?.interstitialDidDismiss()
    }

    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        delegate?.interstitialDidClick()
    }

    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: ImpressionData?) {
        delegate?.interstitialDidTrackImpression()
    }

    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        delegate?.interstitialDidFailToShow(with: error)
    }
}

/// `InterstitialAdLoaderDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/InterstitialAdLoaderDelegate.html
extension YandexInterstitialAdapter: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        interstitialAd.delegate = self
        self.interstitialAd = interstitialAd
        delegate?.interstitialDidLoad()
    }
    
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        delegate?.interstitialDidFailToLoad(with: error.error)
    }
}

//MARK: - Rewarded Adapter

/// This class implements base methods for rewardedl adapter.
final class YandexRewardedAdapter: YandexBaseAdapter, MediationRewarded {
    private weak var delegate: MediationRewardedDelegate?
    private lazy var loader: RewardedAdLoader = {
        let loader = RewardedAdLoader()
        loader.delegate = self
        return loader
    }()
    private var rewardedAd: RewardedAd?

    func loadRewardedAd(with adData: AdData,
                        delegate: MediationRewardedDelegate,
                        parameters: AdapterParameters) {
        self.delegate  = delegate
        let configuration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
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

/// `RewardedAdDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/RewardedAdDelegate.html
extension YandexRewardedAdapter: RewardedAdDelegate {
    func rewardedAd(_ rewardedAd: RewardedAd, didReward reward: Reward) {
        delegate?.didRewardUser()
    }

    func rewardedAdDidShow(_ rewardedAd: RewardedAd) {
        delegate?.rewardedDidShow()
    }

    func rewardedAdDidDismiss(_ rewardedAd: RewardedAd) {
        delegate?.rewardedDidDismiss()
    }

    func rewardedAdDidClick(_ rewardedAd: RewardedAd) {
        delegate?.rewardedDidClick()
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpressionWith impressionData: ImpressionData?) {
        delegate?.rewardedDidTrackImpression()
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShowWithError error: Error) {
        delegate?.rewardedDidFailToShow(with: error)
    }
}

/// `RewardedAdLoaderDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/RewardedAdLoaderDelegate.html
extension YandexRewardedAdapter: RewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didLoad rewardedAd: RewardedAd) {
        rewardedAd.delegate = self
        self.rewardedAd = rewardedAd
        delegate?.rewardedDidLoad()
    }
    
    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didFailToLoadWithError error: AdRequestError) {
        delegate?.rewardedDidFailToShow(with: error.error)
    }
}

//MARK: - AppOpen Adapter

/// This class implements base methods for appOpen adapter.
final class YandexAppOpenAdapter: YandexBaseAdapter, MediationAppOpen {
    private weak var delegate: MediationAppOpenDelegate?
    private lazy var loader: AppOpenAdLoader = {
        let loader = AppOpenAdLoader()
        loader.delegate = self
        return loader
    }()
    private var appOpenAd: AppOpenAd?

    func loadAd(with adData: AdData,
                delegate: MediationAppOpenDelegate,
                parameters: AdapterParameters) {
        self.delegate  = delegate
        let configuration = makeAdRequestConfiguration(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
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

/// `AppOpenAdDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/AppOpenAdDelegate.html
extension YandexAppOpenAdapter: AppOpenAdDelegate {
    func appOpenAdDidShow(_ appOpenAd: AppOpenAd) {
        delegate?.appOpenDidShow()
    }

    func appOpenAdDidDismiss(_ appOpenAd: AppOpenAd) {
        delegate?.appOpenDidDismiss()
    }

    func appOpenAdDidClick(_ appOpenAd: AppOpenAd) {
        delegate?.appOpenDidClick()
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didTrackImpressionWith impressionData: ImpressionData?) {
        delegate?.appOpenDidTrackImpression()
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didFailToShowWithError error: Error) {
        delegate?.appOpenDidFailToShow(with: error)
    }
}

/// `AppOpenAdLoaderDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/AppOpenAdLoaderDelegate.html
extension YandexAppOpenAdapter: AppOpenAdLoaderDelegate {
    func appOpenAdLoader(_ adLoader: AppOpenAdLoader, didLoad appOpenAd: AppOpenAd) {
        appOpenAd.delegate = self
        self.appOpenAd = appOpenAd
        delegate?.appOpenDidLoad()
    }

    func appOpenAdLoader(_ adLoader: AppOpenAdLoader, didFailToLoadWithError error: AdRequestError) {
        delegate?.appOpenDidFailToLoad(with: error.error)
    }
}

//MARK: - Native Adapter

/// This class implements base methods for native adapter.
final class YandexNativeAdapter: YandexBaseAdapter, MediationNative {
    private weak var delegate: MediationNativeDelegate?
    private lazy var loader: NativeAdLoader = {
        let loader = NativeAdLoader()
        loader.delegate = self
        return loader
    }()
    private var nativeAd: NativeAd?
    
    func loadAd(with adData: AdData,
                delegate: MediationNativeDelegate,
                parameters: AdapterParameters) {
        self.delegate = delegate
        let configuration = makeNativeAdRequestConfiguration(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
        loader.loadAd(with: configuration)
    }
    
    func destroy() {
        nativeAd?.delegate = nil
        nativeAd = nil
    }
}

/// `NativeAdDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/NativeAdDelegate.html
extension YandexNativeAdapter: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        delegate?.nativeDidClick()
    }
    
    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        delegate?.nativeDidTrackImpression()
    }
    
    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        delegate?.nativeDidDismissScreen()
    }
    
    func nativeAd(_ ad: any NativeAd, willPresentScreen viewController: UIViewController?) {
        delegate?.nativeWillPresentScreen()
    }
    
    func close(_ ad: NativeAd) {
        delegate?.nativeDidDismiss()
    }
}

/// `NativeAdLoaderDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/NativeAdLoaderDelegate.html
extension YandexNativeAdapter: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        ad.delegate = self
        nativeAd = ad
        let assets = ad.adAssets()
        
        let mediationNativeAd = YandexNativeAd(nativeAd: ad)
        mediationNativeAd.delegate = delegate
        mediationNativeAd.age = assets.age
        mediationNativeAd.body = assets.body
        mediationNativeAd.callToAction = assets.callToAction
        mediationNativeAd.domain = assets.domain
        mediationNativeAd.favicon = assets.favicon?.imageValue
        mediationNativeAd.icon = assets.icon?.imageValue
        mediationNativeAd.image = assets.image?.imageValue
        mediationNativeAd.media = YMANativeMediaView()
        mediationNativeAd.price = assets.price
        mediationNativeAd.rating = assets.rating
        mediationNativeAd.reviewCount = assets.reviewCount
        mediationNativeAd.sponsored = assets.sponsored
        mediationNativeAd.title = assets.title
        mediationNativeAd.warning = assets.warning
        
        delegate?.nativeDidLoad(ad: mediationNativeAd)
    }
    
    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        delegate?.nativeDidFailToLoad(with: error)
    }
}

/// This class implements a native ad object that the ad network SDK expects after it is loaded.
final class YandexNativeAd: MediationNativeAd {
    weak var delegate: MediationNativeDelegate?
    let nativeAd: NativeAd
    
    init(nativeAd: NativeAd) {
        self.nativeAd = nativeAd
    }
    
    /// Method for properly binding views in native ad format.
    /// In the real case this logic is strongly depends on the ad network SDK and should be changed to match it.
    func trackViews(adNetworkView: MediationNativeAdView) {
        let viewData = NativeAdViewData()
        viewData.ageLabel = adNetworkView.ageLabel
        viewData.bodyLabel = adNetworkView.bodyLabel
        viewData.callToActionButton = adNetworkView.callToActionButton
        viewData.domainLabel = adNetworkView.domainLabel
        viewData.faviconImageView = adNetworkView.faviconImageView
        viewData.iconImageView = adNetworkView.iconImageView
        viewData.mediaView = adNetworkView.mediaView as? YMANativeMediaView
        viewData.priceLabel = adNetworkView.priceLabel
        viewData.ratingView = adNetworkView.priceLabel as? (UIView & Rating)
        viewData.reviewCountLabel = adNetworkView.reviewCountLabel
        viewData.sponsoredLabel = adNetworkView.sponsoredLabel
        viewData.titleLabel = adNetworkView.titleLabel
        viewData.warningLabel = adNetworkView.warningLabel
        do {
            try nativeAd.bindAd(to: adNetworkView, viewData: viewData)
        } catch {
            delegate?.nativeDidFailToBind(with: error)
        }
    }
    
    var age: String?
    var body: String?
    var callToAction: String?
    var domain: String?
    var favicon: UIImage?
    var icon: UIImage?
    var image: UIImage?
    var media: UIView?
    var price: String?
    var rating: NSNumber?
    var reviewCount: String?
    var sponsored: String?
    var title: String?
    var warning: String?
}
