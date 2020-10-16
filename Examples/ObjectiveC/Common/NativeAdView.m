/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileNativeAds.h>
#import "NativeAdView.h"
#import "StarRatingView.h"

@implementation NativeAdView

+ (NativeAdView *)nib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                         owner:nil
                                       options:nil].firstObject;
}

#pragma mark - Layout

- (void)prepareForDisplay
{
    YMANativeAdAssets *adAssets = self.ad.adAssets;
    self.iconImageView.hidden = adAssets.icon == nil;
}

@end
