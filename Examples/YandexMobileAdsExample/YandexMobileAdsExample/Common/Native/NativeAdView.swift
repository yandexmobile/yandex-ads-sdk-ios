/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class NativeAdView: YandexMobileAds.NativeAdView {
    static var nib: NativeAdView? {
        return Bundle.main.loadNibNamed("NativeAdView",
                                        owner: nil,
                                        options: nil)?.first as? NativeAdView
    }

    func configureAssetViews() {
        guard let adAssets = ad?.adAssets() else { return }

        iconImageView?.isHidden = adAssets.icon == nil
    }
}
