/*
 *  NativeAppInstallAdView.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "UIKit/UIKit.h"
#import <YandexMobileAds/YandexMobileNativeAds.h>

/**
 * Sample native app install ad view template which can be configured to display any set of assets.
 */
@interface NativeAppInstallAdView : YMANativeAppInstallAdView

/**
 * Configures view depending on assets bound.
 * Should be called after binding but before displaying native ad.
 */
- (void)prepareForDisplay;

@end
