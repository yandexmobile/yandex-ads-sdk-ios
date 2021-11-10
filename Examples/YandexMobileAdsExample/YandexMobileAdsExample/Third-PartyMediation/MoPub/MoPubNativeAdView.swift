/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import MoPubSDK
import YandexMobileAds
import YandexMobileAdsMoPubAdapters

class MoPubNativeAdView: UIView {
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var callToActionButton: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var faviconImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var sponsoredLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!

    override func willMove(toWindow newWindow: UIWindow?) {
        guard newWindow != nil else { return }
        configureVisibility(for: ageLabel)
        configureVisibility(for: bodyLabel)
        configureVisibility(for: callToActionButton)
        configureVisibility(for: domainLabel)
        configureVisibility(for: faviconImage)
        configureVisibility(for: iconImage)
        configureVisibility(for: priceLabel)
        configureVisibility(for: reviewCountLabel)
        configureVisibility(for: sponsoredLabel)
        configureVisibility(for: starRatingView)
        configureVisibility(for: titleLabel)
        configureVisibility(for: warningLabel)
    }

    private func configureVisibility(for label: UILabel) {
        label.isHidden = (label.text == nil || label.text?.count == 0)
    }

    private func configureVisibility(for imageView: UIImageView) {
        imageView.isHidden = imageView.image == nil
    }

    private func configureVisibility(for starRatingView: StarRatingView) {
        if let rating = starRatingView.rating()?.intValue, rating > 0 {
            starRatingView.isHidden = false
        } else {
            starRatingView.isHidden = true
        }
    }
}

extension MoPubNativeAdView: MPNativeAdRendering {
    func nativeMainTextLabel() -> UILabel! {
        return self.bodyLabel
    }

    func nativeTitleTextLabel() -> UILabel! {
        return self.titleLabel
    }

    func nativeIconImageView() -> UIImageView! {
        return self.iconImage
    }

    func nativeMainImageView() -> UIImageView! {
        return self.image
    }

    func nativeCallToActionTextLabel() -> UILabel! {
        return self.callToActionButton
    }
    
    func layoutCustomAssets(withProperties customProperties: [AnyHashable : Any]!, imageLoader: MPNativeAdRenderingImageLoader!) {
        // configure visibility for nativeMainImageView in Yandex Ad
        let mediaView = customProperties[kAdMainMediaViewKey]
        self.image.isHidden = mediaView == nil
    }

    static func nibForAd() -> UINib! {
        return UINib(nibName: "MoPubNativeAdView", bundle: .main)
    }
}

extension MoPubNativeAdView: YMANativeCustomEventAdRendering {
    func nativeAgeLabel() -> UILabel! {
        return self.ageLabel
    }

    func nativeDomainLabel() -> UILabel! {
        return self.domainLabel
    }

    func nativeFaviconImageView() -> UIImageView! {
        return self.faviconImage
    }

    func nativePriceLabel() -> UILabel! {
        return self.priceLabel
    }

    func nativeRatingView() -> (UIView & YMARating)! {
        return self.starRatingView
    }

    func nativeReviewCountLabel() -> UILabel! {
        return self.reviewCountLabel
    }

    func nativeSponsoredLabel() -> UILabel! {
        return self.sponsoredLabel
    }

    func nativeWarningLabel() -> UILabel! {
        return self.warningLabel
    }
}
