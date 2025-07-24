/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import UIKit

enum YandexAdsCellModel: NavigationScreenDataSource, CaseIterable {
    case stickyBanner
    case inlineBanner
    case interstitial
    case rewarded
    case appOpenAd
    case native
    case instream

    var destinationViewController: UIViewController {
        switch self {
        case .stickyBanner:
            return StickyBannerViewController()
        case .inlineBanner:
            return InlineBannerViewController()
        case .interstitial:
            return InterstitialAdViewController()
        case .rewarded:
            return RewardedAdViewController()
        case .appOpenAd:
            return AppOpenAdViewController()
        case .native:
            return NativeViewController()
        case .instream:
            return InstreamListViewController()
        }
    }

    var title: String {
        String(describing: self).camelCaseToWords()
    }
    
    var accessibilityId: String? {
        switch self {
        case .stickyBanner:
            return YandexAdsAccessibility.sticky
        case .inlineBanner:
            return YandexAdsAccessibility.inline
        case .interstitial:
            return YandexAdsAccessibility.interstitial
        case .rewarded:
            return YandexAdsAccessibility.rewarded
        case .appOpenAd:
            return YandexAdsAccessibility.appOpenAd
        case .native:
            return YandexAdsAccessibility.native
        case .instream:
            return YandexAdsAccessibility.instream
        }
    }
}

final class YandexAdsViewController: NavigationTableViewController<YandexAdsCellModel> { }
