/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds
import YandexMobileAdsAdMobAdapters
import YandexMobileAds

class AdMobNativeAdView: GoogleMobileAds.NativeAdView {
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var faviconImageView: UIImageView!

    private var aspectRatioConstraint: NSLayoutConstraint?

    func configureAssetViews() {
        setAspectRatio()

        (advertiserView as? UILabel)?.text = nativeAd?.advertiser
        advertiserView?.isHidden = nativeAd?.advertiser == nil

        (bodyView as? UILabel)?.text = nativeAd?.body
        bodyView?.isHidden = nativeAd?.body == nil

        (callToActionView as? UIButton)?.setTitle(nativeAd?.callToAction, for: .normal)
        callToActionView?.isHidden = nativeAd?.callToAction == nil

        (headlineView as? UILabel)?.text = nativeAd?.headline
        headlineView?.isHidden = nativeAd?.headline == nil

        (iconView as? UIImageView)?.image = nativeAd?.icon?.image
        iconView?.isHidden = nativeAd?.icon == nil

        mediaView?.mediaContent = nativeAd?.mediaContent

        (priceView as? UILabel)?.text = nativeAd?.price
        priceView?.isHidden = nativeAd?.price == nil

        ratingView.isHidden = nativeAd?.starRating == nil

        (storeView as? UILabel)?.text = nativeAd?.store
        storeView?.isHidden = nativeAd?.store == nil

        ageLabel.isHidden = nativeAd?.extraAssets?[kYMAAdMobNativeAdAgeExtraAsset] == nil
        faviconImageView.isHidden = nativeAd?.extraAssets?[kYMAAdMobNativeAdFaviconExtraAsset] == nil
        reviewCountLabel.isHidden = nativeAd?.extraAssets?[kYMAAdMobNativeAdReviewCountExtraAsset] == nil
        warningLabel.isHidden = nativeAd?.extraAssets?[kYMAAdMobNativeAdWarningExtraAsset] == nil
    }

    private func setAspectRatio() {
        guard let mediaView = mediaView, let nativeAd = nativeAd else { return }

        if let aspectRatioConstraint = aspectRatioConstraint {
            mediaView.removeConstraint(aspectRatioConstraint)
        }

        aspectRatioConstraint = NSLayoutConstraint(item: mediaView,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: mediaView,
                                                   attribute: .height,
                                                   multiplier: nativeAd.mediaContent.aspectRatio,
                                                   constant: 0)
        mediaView.addConstraint(aspectRatioConstraint!)
    }
}

extension AdMobNativeAdView: YandexAdMobCustomEventNativeAdView {
    func nativeAgeLabel() -> UILabel? {
        return ageLabel
    }

    func nativeFaviconImageView() -> UIImageView? {
        return faviconImageView
    }

    func nativeRatingView() -> (UIView & Rating)? {
        return ratingView
    }

    func nativeReviewCountLabel() -> UILabel? {
        return reviewCountLabel
    }

    func nativeWarningLabel() -> UILabel? {
        return warningLabel
    }
}
