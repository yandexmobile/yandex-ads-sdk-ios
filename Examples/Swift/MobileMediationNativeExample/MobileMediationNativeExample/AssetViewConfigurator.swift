/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class AssetViewConfigurator {
    private let feedbackButton: UIButton?
    private let mediaView: YMANativeMediaView?

    private var aspectRatioConstraint: NSLayoutConstraint?

    init(feedbackButton: UIButton?, mediaView: YMANativeMediaView?) {
        self.feedbackButton = feedbackButton
        self.mediaView = mediaView
    }

    func configure(with ad: YMANativeGenericAd?) {
        configureFeedbackButton(with: ad)
        configureMediaView(with: ad)
    }

    private func configureMediaView(with ad: YMANativeGenericAd?) {
        guard let mediaView = mediaView else { return }
        var aspectRatio: CGFloat = 0

        if let media = ad?.adAssets().media {
            aspectRatio = media.aspectRatio
        } else if let image = ad?.adAssets().image, image.size.height != 0 {
            aspectRatio = image.size.width / image.size.height
        }

        if let aspectRatioConstraint = aspectRatioConstraint {
            mediaView.removeConstraint(aspectRatioConstraint)
        }

        aspectRatioConstraint = NSLayoutConstraint(item: mediaView,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: mediaView,
                                                   attribute: .height,
                                                   multiplier: aspectRatio,
                                                   constant: 0)
        mediaView.addConstraint(aspectRatioConstraint!)
    }

    private func configureFeedbackButton(with ad: YMANativeGenericAd?) {
        if ad?.adAssets().feedbackAvailable == false {
            feedbackButton?.isHidden = true
        } else {
            feedbackButton?.isHidden = false
        }
    }
}
