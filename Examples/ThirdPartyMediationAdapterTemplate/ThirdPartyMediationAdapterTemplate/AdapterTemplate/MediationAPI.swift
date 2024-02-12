/**
 This file describes one of the possible interfaces of the advertising network. The API of your advertising network doesn't have to be identical.
 This example is needed to show the main steps of integration with Yandex.
 */

import UIKit

//MARK: - DTO API objects

/// This is a mock of the object that represents the scope of parameters  for successful ad request.
/// You can pass these parameters as required by your network API, but it must be passed.
/// - Parameters:
///   - adUinitId: Is an unique identifier in the R-M-XXXXXX-Y format,
///which is assigned in the Partner interface.
///   - bidId: Used if ad network supported in-app bidding integration with Yandex.
struct AdData {
    let adUinitId: String
    let bidId: String?
}

/// This is a mock of the object that represents the scope of parameters  for successful adapter configuration and ads request. 
/// You can pass these parameters as required by your network API, but they must be passed.
/// - Parameters:
///   - adFormat: Requested ad format. Used if ad network supported in-app bidding integration with Yandex.
///   - adapterVersion: Version of your adapter you are using for Yandex mediation.
///   - adapterSdkVersion: Version of you ad network sdk.
///   - adapterNetworkName: Yor ad network name.
///   - userConsent: User consent  parameter.  False - by default.
///   - locationTracking: Used for collecting location data if the user allowed the app to track the location. True - by default.
///   - isTesting: Used for extended YandexSDK logging. Extended logging is disabled - by default.
struct AdapterParameters {
    let adFormat: MediationAdFormat
    let adapterVersion: String
    let adapterSdkVersion: String
    let adapterNetworkName: String
    let userConsent: Bool?
    let locationTracking: Bool?
    let isTesting: Bool?
}

/// This is a mock of the object that represents supported  ad formats.
enum MediationAdFormat {
    case banner(size: CGSize)
    case interstitial
    case rewarded
    case appOpen
}

/// List of adUnits for checking inegration with Yandex.
enum DemoAdUnit: String {
    case demoBannerAdUinitId = "demo-banner-yandex"
    case demoInterstititalAdUinitId = "demo-interstitital-yandex"
    case demoRewardedAdUnitId = "demo-rewarded-yandex"
    case demoAppOpenAdUnitId = "demo-appopenad-yandex"
}

//MARK: - Initialization API

/// This protocol describes methods for manual SDK initialization.
protocol MediationInitialization {
    static func initializeSDK()
}

//MARK: - Bidding API

/// This protocol describes methods for getting a bidding token in order to use it with in-app bidding integration with Yandex.
protocol MediationBidding {
    static func getBiddingToken(parameters: AdapterParameters, completion: @escaping (String?) -> Void)
}

//MARK: - Banner API

/// This protocol describes methods for banner ads.
protocol MediationBanner {
    ///Loads banner
    /// - Parameters:
    ///   - adData: Object that contains parameters for banner request.
    ///   - size: Size of requested banner.
    ///   - delegate: Delegate that implements your ad network banner callbacks.
    ///   - parameters: Additional parameters for ads request configuration.
    func loadBannerAd(with adData: AdData,
                size: CGSize,
                delegate: MediationBannerDelegate,
                parameters: AdapterParameters)
    
    /// The API of some ad networks require a destroy method.
    /// This method is called when an ad associated with this adapter should be destroyed. Necessary cleanup should be performed here.
    func destroy()
}

/// This protocol describes  your ad network banner callbacks.
protocol MediationBannerDelegate: AnyObject {
    ///  Notifies that the banner is loaded.
    func didLoadAd(with adview: UIView)

    /// Notifies that the banner failed to load.
    func didFailToLoadAdView(with error: Error)

    /// Notifies that the user has clicked on the banner.
    func didClickAdView()

    /// Notifies when an impression was tracked.
    func didTrackImpression()

    /// Notifies that the app will become inactive now because the user clicked on the banner ad.
    func adViewWillLeaveApplication()

    /// Notifies that the user has clicked on the banner and the in-app browser will open now.
    func adViewWillPresentScreen()

    /// Notifies that the user has closed the embedded browser.
    func adViewWillDismissScreen()
}

//MARK: - Interstitial API

/// This protocol describes methods for interstitial ads.
protocol MediationInterstitial {
    ///Loads interstitial
    /// - Parameters:
    ///   - adData: Object that contains parameters for interstitial request.
    ///   - delegate: Delegate that implements your ad network interstitial callbacks.
    ///   - parameters: Additional parameters for ads request configuration.
    func loadInterstitialAd(with adData: AdData,
                delegate: MediationInterstitialDelegate,
                parameters: AdapterParameters)

    ///Shows interstitial
    /// - Parameters:
    ///   - viewController:An object of the `UIViewController` class, which is used to display an interstitial ad.
    ///   - delegate: Delegate that implements your ad network interstitial callbacks.
    ///   - adData: Object that contains parameters for interstitial request.
    func showInterstitialAd(with viewController: UIViewController,
                delegate: MediationInterstitialDelegate,
                adData: AdData)

    /// The API of some ad networks require a destroy method.
    /// This method is called when an ad associated with this adapter should be destroyed. Necessary cleanup should be performed here.
    func destroy()
}

/// This protocol describes  your ad network interstitial callbacks.
protocol MediationInterstitialDelegate: AnyObject {
    /// Notifies that the interstitial is loaded.
    func interstitialDidLoad()

    /// Notifies that the interstitial is failed to load.
    func interstitialDidFailToLoad(with error: Error)

    /// Called after the interstitial ad shows.
    func interstitialDidShow()

    /// Notifies that the interstitial is failed to show.
    func interstitialDidFailToShow(with error: Error)

    /// Called after dismissing the interstitial ad.
    func interstitialDidDismiss()

    /// Notifies that the user has clicked on the interstitial.
    func interstitialDidClick()

    /// Notifies when an impression was tracked.
    func interstitialDidTrackImpression()
}

//MARK: - Rewarded API

/// This protocol describes methods for rewarded ads.
protocol MediationRewarded {
    ///Loads rewarded
    /// - Parameters:
    ///   - adData: Object that contains parameters for rewarded request.
    ///   - delegate: Delegate that implements your ad network rewarded callbacks.
    ///   - parameters: Additional parameters for ads request configuration.
    func loadRewardedAd(with adData: AdData,
                delegate: MediationRewardedDelegate,
                parameters: AdapterParameters)

    ///Shows rewarded
    /// - Parameters:
    ///   - viewController:An object of the `UIViewController` class, which is used to display a rewarded ad.
    ///   - delegate: Delegate that implements your ad network rewarded callbacks.
    ///   - adData: Object that contains parameters for rewarded request
    func showRewardedAd(with viewController: UIViewController,
                delegate: MediationRewardedDelegate,
                adData: AdData)

    /// The API of some ad networks require a destroy method.
    /// This method is called when an ad associated with this adapter should be destroyed. Necessary cleanup should be performed here.
    func destroy()
}

/// This protocol describes  your ad network rewarded callbacks.
protocol MediationRewardedDelegate: AnyObject {
    /// Notifies that the rewarded is loaded.
    func rewardedDidLoad()

    /// Notifies that the rewarded is failed to load.
    func rewardedDidFailToLoad(with error: Error)

    /// Called after the rewarded shows.
    func rewardedDidShow()

    /// Notifies that the rewarded is failed to show.
    func rewardedDidFailToShow(with error: Error)

    /// Called after rewarded the rewarded ad.
    func rewardedDidDismiss()

    /// Notifies that the user has clicked on the rewarded.
    func rewardedDidClick()

    /// Notifies when an impression was tracked.
    func rewardedDidTrackImpression()

    /// Notifies that rewarded ad has rewarded the user.
    func didRewardUser()
}

//MARK: - AppOpen API

/// This protocol describes methods for appOpen ads.
protocol MediationAppOpen {
    ///Loads appOpenAd
    /// - Parameters:
    ///   - adData: Object that contains parameters for appOpenAd request.
    ///   - delegate: Delegate that implements your ad network rewarded callbacks.
    ///   - parameters: Additional parameters for ads request configuration.
    func loadAd(with adData: AdData,
                delegate: MediationAppOpenDelegate,
                parameters: AdapterParameters)

    //Shows appOpenAd
    /// - Parameters:
    ///   - viewController:An object of the `UIViewController` class, which is used to display an appOpenAd ad.
    ///   - delegate: Delegate that implements your ad network appOpenAd callbacks.
    ///   - adData: Object that contains parameters for appOpenAd request.
    func showAd(with viewController: UIViewController,
                delegate: MediationAppOpenDelegate,
                adData: AdData)

    /// The API of some ad networks require a destroy method.
    /// This method is called when an ad associated with this adapter should be destroyed. Necessary cleanup should be performed here.
    func destroy()
}

/// This protocol describes  your ad network appOpen callbacks.
protocol MediationAppOpenDelegate: AnyObject {
    /// Notifies that the appOpenAd is loaded.
    func appOpenDidLoad()

    /// Notifies that the appOpenAd is failed to load.
    func appOpenDidFailToLoad(with error: Error)

    /// Called after the appOpenAd ad shows.
    func appOpenDidShow()

    /// Notifies that the appOpenAd is failed to show.
    func appOpenDidFailToShow(with error: Error)

    /// Called after dismissing the appOpenAd ad.
    func appOpenDidDismiss()

    /// Notifies that the user has clicked on the appOpenAd.
    func appOpenDidClick()

    /// Notifies when an impression was tracked.
    func appOpenDidTrackImpression()
}
