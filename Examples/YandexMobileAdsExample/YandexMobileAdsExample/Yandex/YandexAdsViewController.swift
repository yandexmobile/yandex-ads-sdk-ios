/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation

enum YandexAdsCellModel: NavigationScreenDataSource, CaseIterable {
    case stickyBanner
    case inlineBanner
    case interstitial
    case rewarded
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
        case .native:
            return UIViewController()
        case .instream:
            return InstreamListViewController()
        }
    }

    var title: String {
        String(describing: self).camelCaseToWords()
    }
}

final class YandexAdsViewController: NavigationTableViewController<YandexAdsCellModel> { }
