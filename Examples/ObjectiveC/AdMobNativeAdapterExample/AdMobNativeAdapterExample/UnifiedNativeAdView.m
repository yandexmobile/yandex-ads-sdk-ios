/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "UnifiedNativeAdView.h"
#import "StarRatingView.h"

@interface UnifiedNativeAdView ()

@property (nonatomic, weak) NSLayoutConstraint *aspectRatioConstraint;

@end

@implementation UnifiedNativeAdView

- (void)configureAssetViews
{
    [self setAspectRatio];

    self.mediaView.mediaContent = self.nativeAd.mediaContent;

    ((UILabel *)self.headlineView).text = self.nativeAd.headline;

    ((UILabel *)self.bodyView).text = self.nativeAd.body;
    self.bodyView.hidden = self.nativeAd.body == nil;

    [((UIButton *)self.callToActionView) setTitle:self.nativeAd.callToAction forState:UIControlStateNormal];
    self.callToActionView.hidden = self.callToActionView == nil;

    ((UIImageView *)self.iconView).image = self.nativeAd.icon.image;
    self.iconView.hidden = self.nativeAd.icon == nil;

    ((UILabel *)self.storeView).text = self.nativeAd.store;
    self.storeView.hidden = self.nativeAd.store == nil;

    ((UILabel *)self.priceView).text = self.nativeAd.price;
    self.priceView.hidden = self.nativeAd.price == nil;

    ((UILabel *)self.advertiserView).text = self.nativeAd.advertiser;
    self.advertiserView.hidden = self.nativeAd.advertiser == nil;

    self.ageLabel.hidden = self.nativeAd.extraAssets[kYMAAdMobNativeAdAgeExtraAsset] == nil;

    self.faviconImageView.hidden = self.nativeAd.extraAssets[kYMAAdMobNativeAdFaviconExtraAsset] == nil;

    self.ratingView.hidden = self.nativeAd.starRating == nil;

    self.reviewCountLabel.hidden = self.nativeAd.extraAssets[kYMAAdMobNativeAdReviewCountExtraAsset] == nil;

    self.warningLabel.hidden = self.nativeAd.extraAssets[kYMAAdMobNativeAdWarningExtraAsset] == nil;
}

- (void)setAspectRatio
{
    [self.mediaView removeConstraint:self.aspectRatioConstraint];
    self.aspectRatioConstraint = [NSLayoutConstraint constraintWithItem:self.mediaView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.mediaView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:self.nativeAd.mediaContent.aspectRatio
                                                               constant:0];
    [self.mediaView addConstraint:self.aspectRatioConstraint];
}

#pragma mark - YMAAdMobCustomEventNativeAdView

- (UILabel *)nativeAgeLabel
{
    return self.ageLabel;
}

- (UIImageView *)nativeFaviconImageView
{
    return self.faviconImageView;
}

- (UIView<YMARating> *)nativeRatingView
{
    return self.ratingView;
}

- (UILabel *)nativeReviewCountLabel
{
    return self.reviewCountLabel;
}

- (UILabel *)nativeWarningLabel
{
    return self.warningLabel;
}

@end
