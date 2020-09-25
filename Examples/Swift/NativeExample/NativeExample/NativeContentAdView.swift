/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class NativeContentAdView: YMANativeContentAdView {
    private var assetConfigurator: AssetViewConfigurator?

    override func awakeFromNib() {
        super.awakeFromNib()
        assetConfigurator = AssetViewConfigurator(feedbackButton: feedbackButton, mediaView: mediaView)
    }

    func configureAssetViews() {
        assetConfigurator?.configure(with: ad)
    }
}
