/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "UIKit/UIKit.h"
#import <YandexMobileAds/YandexMobileNativeAds.h>

/**
 * Sample native ad view which can be configured to display any set of assets.
 */
@interface NativeAdView : YMANativeAdView

+ (NativeAdView *)nib;

/**
 * Configures view depending on assets bound. 
 * Should be called after binding but before displaying native ad.
 */
- (void)prepareForDisplay;

@end
