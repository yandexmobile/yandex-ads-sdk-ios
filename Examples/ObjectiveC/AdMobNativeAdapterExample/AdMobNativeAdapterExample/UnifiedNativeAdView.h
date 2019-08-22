/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <YandexMobileAdsAdMobAdapters/YMAAdMobCustomEventNativeAdView.h>

@class StarRatingView;

@interface UnifiedNativeAdView : GADUnifiedNativeAdView  <YMAAdMobCustomEventNativeAdView>

@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *faviconImageView;
@property (nonatomic, weak) IBOutlet StarRatingView *ratingView;
@property (nonatomic, weak) IBOutlet UILabel *reviewCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *warningLabel;

- (void)configureAssetViews;

@end
