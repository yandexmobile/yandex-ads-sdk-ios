/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <UIKit/UIKit.h>

@protocol YMANativeAd;
@class YMANativeBannerView;

@interface NativeBannerTableViewCell : UITableViewCell

@property (nonatomic, strong) id<YMANativeAd> ad;
@property (nonatomic, weak, readonly) YMANativeBannerView *adView;

@end
