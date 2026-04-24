/**
 This file describes implementation of `MediationAPI`.
 You could use it for a more simple adaptation to your advertising network API.
 */

import UIKit
import YandexMobileAds

//MARK: - Base Adapter

/// This struct is a mock for error  which could occur in adapter. Error object and error message depends from you ad network API.
struct AdapterError: LocalizedError {
    let errorDescription: String
}

private let mockPresentingError = AdapterError(errorDescription: "Ad Display Failed")

/// This class implements base methods for all other adapters.
class YandexBaseAdapter: NSObject, MediationBidding, MediationInitialization {
    private static let bidderTokenLoader = BidderTokenLoader()

    /// Adapter identity that have to be presented in each request to the Yandex API.
    private static var adapterIdentity: AdapterIdentity {
        AdapterIdentity(
            adapterNetworkName: "MEDIATION_NETWORK_NAME",
            adapterVersion: "YANDEX_ADAPTER_VERSION",
            adapterNetworkVersion: "MEDIATION_NETWORK_SDK_VERSION"
        )
    }

    /// This method implements obtaining a bid token in order to use it with in-app bidding integration with Yandex.
    /// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Classes/BidderTokenLoader.html
    static func getBiddingToken(parameters: AdapterParameters, completion: @escaping (String?) -> Void) {

        /// Configure all necessary parameters and create `BidderTokenRequest.
        let request: BidderTokenRequest
        switch parameters.adFormat {
        case .banner(let size):
            request = BidderTokenRequest.banner(size: BannerAdSize.fixed(width: size.width, height: size.height))
        case .interstitial:
            request = BidderTokenRequest.interstitial()
        case .rewarded:
            request = BidderTokenRequest.rewarded()
        case .appOpen:
            request = BidderTokenRequest.appOpenAd()
        case .native:
            request = BidderTokenRequest.native()
        }

        Self.setupYandexSDK(with: parameters)
        Self.bidderTokenLoader.loadBidderToken(request: request) { token in
            completion(token)
        }
    }

    /// This method implements setting up `MobileAds` parameters, which must be current before each request to the Yandex API.
    static func setupYandexSDK(with parameters: AdapterParameters) {
        if let userConsent = parameters.userConsent {
            YandexAds.setUserConsent(userConsent)
        }

        if let ageRestrictedUser = parameters.ageRestrictedUser {
            YandexAds.setAgeRestricted(ageRestrictedUser)
        }

        if let locationTracking = parameters.locationTracking {
            YandexAds.setLocationTracking(locationTracking)
        }

        if let isTesting = parameters.isTesting, isTesting {
            YandexAds.enableLogging()
        }
    }

    /// Successfully initializing the Yandex Mobile Ads SDK is an important condition for correctly integrating the library.
    /// By default, SDK initialization happens automatically before ads load, but manual initialization will speed up how quickly the first ad loads
    /// and therefore increase revenue from monetization.
    /// https://yandex.ru/support2/mobile-ads/en/dev/ios/quick-start
    static func initializeSDK() {
        YandexAds.setAdapterIdentity(Self.adapterIdentity)
        YandexAds.initializeSDK(completionHandler: nil)
    }

    /// This method implements creation of `AdRequestConfiguration` with  all the necessary parameters.
    func makeAdRequest(with adData: AdData, parameters: AdapterParameters) -> AdRequest {
        AdRequest(
            adUnitID: adData.adUnitId,
            biddingData: adData.bidId
        )
    }
}

//MARK: - Banner Adapter

/// This class implements base methods for banner adapter.
final class YandexBannerAdapter: YandexBaseAdapter, MediationBanner {
    private weak var delegate: MediationBannerDelegate?
    private var bannerAdView: BannerAdView?

    func loadBannerAd(with adData: AdData,
                      size: CGSize,
                      delegate: MediationBannerDelegate,
                      parameters: AdapterParameters) {

        /// Creates an object of the `BannerAdSize` class with the specified maximum height and width of the banner.
        /// Also you could use another sizes: https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Classes/BannerAdSize.html
        let adSize = BannerAdSize.fixed(width: size.width, height: size.height)
        let bannerAdView = BannerAdView(adSize: adSize)
        let request = makeAdRequest(with: adData, parameters: parameters)

        bannerAdView.delegate = self
        Self.setupYandexSDK(with: parameters)
        bannerAdView.loadAd(with: request)
    }

    func destroy() {
        bannerAdView?.removeFromSuperview()
        bannerAdView?.delegate = nil
        bannerAdView = nil
    }
}

/// `AdViewDelegate` implementation.
/// https://yastatic.net/s3/doc-binary/src/dev/mobile-ads/ru/jazzy/Protocols/AdViewDelegate.html
extension YandexBannerAdapter: BannerAdViewDelegate {
    func bannerAdViewDidLoad(_ bannerAdView: BannerAdView) {
        delegate?.didLoadAd(with: bannerAdView)
    }

    func bannerAdViewDidClick(_ bannerAdView: BannerAdView) {
        delegate?.didClickAdView()
    }

    func bannerAdViewDidFailLoading(_ bannerAdView: BannerAdView, error: Error) {
        delegate?.didFailToLoadAdView(with: error)
    }

    func bannerAdView(_ bannerAdView: BannerAdView, didTrackImpression impressionData: ImpressionData?) {
        delegate?.didTrackImpression()
    }

    func close(_ bannerAdView: BannerAdView) {}
}

//MARK: - Interstitial Adapter

/// This class implements base methods for interstitial adapter.
@MainActor
final class YandexInterstitialAdapter: YandexBaseAdapter, MediationInterstitial {
    private weak var delegate: MediationInterstitialDelegate?
    private let loader = InterstitialAdLoader()
    private var interstitialAd: InterstitialAd?

    func loadInterstitialAd(with adData: AdData,
                            delegate: MediationInterstitialDelegate,
                            parameters: AdapterParameters) {
        self.delegate  = delegate
        let request = makeAdRequest(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
        loader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let interstitialAd):
                interstitialAd.delegate = self
                self.interstitialAd = interstitialAd
                delegate.interstitialDidLoad()
            case .failure(let error):
                delegate.interstitialDidFailToLoad(with: error)
            }
        }
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

    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpression impressionData: ImpressionData?) {
        delegate?.interstitialDidTrackImpression()
    }

    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShow error: Error) {
        delegate?.interstitialDidFailToShow(with: error)
    }
}

//MARK: - Rewarded Adapter

/// This class implements base methods for rewardedl adapter.
@MainActor
final class YandexRewardedAdapter: YandexBaseAdapter, MediationRewarded {
    private weak var delegate: MediationRewardedDelegate?
    private let loader = RewardedAdLoader()
    private var rewardedAd: RewardedAd?

    func loadRewardedAd(with adData: AdData,
                        delegate: MediationRewardedDelegate,
                        parameters: AdapterParameters) {
        self.delegate  = delegate
        let request = makeAdRequest(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
        loader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let rewardedAd):
                rewardedAd.delegate = self
                self.rewardedAd = rewardedAd
                delegate.rewardedDidLoad()
            case .failure(let error):
                delegate.rewardedDidFailToShow(with: error)
            }
        }
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

    func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpression impressionData: ImpressionData?) {
        delegate?.rewardedDidTrackImpression()
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShow error: Error) {
        delegate?.rewardedDidFailToShow(with: error)
    }
}

//MARK: - AppOpen Adapter

/// This class implements base methods for appOpen adapter.
@MainActor
final class YandexAppOpenAdapter: YandexBaseAdapter, MediationAppOpen {
    private weak var delegate: MediationAppOpenDelegate?
    private let loader = AppOpenAdLoader()
    private var appOpenAd: AppOpenAd?

    func loadAd(with adData: AdData,
                delegate: MediationAppOpenDelegate,
                parameters: AdapterParameters) {
        self.delegate  = delegate
        let request = makeAdRequest(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
        loader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let appOpenAd):
                appOpenAd.delegate = self
                self.appOpenAd = appOpenAd
                delegate.appOpenDidLoad()
            case .failure(let error):
                delegate.appOpenDidFailToLoad(with: error)
            }
        }
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

    func appOpenAd(_ appOpenAd: AppOpenAd, didTrackImpression impressionData: ImpressionData?) {
        delegate?.appOpenDidTrackImpression()
    }

    func appOpenAd(_ appOpenAd: AppOpenAd, didFailToShow error: Error) {
        delegate?.appOpenDidFailToShow(with: error)
    }
}

//MARK: - Native Adapter

/// This class implements base methods for native adapter.
final class YandexNativeAdapter: YandexBaseAdapter, MediationNative {
    private weak var delegate: MediationNativeDelegate?
    private let loader = NativeAdLoader()
    private var nativeAd: NativeAd?
    
    func loadAd(with adData: AdData,
                delegate: MediationNativeDelegate,
                parameters: AdapterParameters) {
        self.delegate = delegate
        let request = makeAdRequest(with: adData, parameters: parameters)
        Self.setupYandexSDK(with: parameters)
        loader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let ad):
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
                mediationNativeAd.media = NativeMediaView()
                mediationNativeAd.price = assets.price
                mediationNativeAd.rating = assets.rating
                mediationNativeAd.reviewCount = assets.reviewCount
                mediationNativeAd.sponsored = assets.sponsored
                mediationNativeAd.title = assets.title
                mediationNativeAd.warning = assets.warning?.value
                
                delegate.nativeDidLoad(ad: mediationNativeAd)
            case .failure(let error):
                delegate.nativeDidFailToLoad(with: error)
            }
        }
    }
    
    @MainActor
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
    
    func nativeAd(_ ad: NativeAd, didTrackImpression impressionData: ImpressionData?) {
        delegate?.nativeDidTrackImpression()
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
    @MainActor
    func trackViews(adNetworkView: MediationNativeAdView) {
        let viewData = NativeAdViewData()
        viewData.ageLabel = adNetworkView.ageLabel
        viewData.bodyLabel = adNetworkView.bodyLabel
        viewData.callToActionButton = adNetworkView.callToActionButton
        viewData.domainLabel = adNetworkView.domainLabel
        viewData.faviconImageView = adNetworkView.faviconImageView
        viewData.iconImageView = adNetworkView.iconImageView
        viewData.mediaView = adNetworkView.mediaView as? NativeMediaView
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
