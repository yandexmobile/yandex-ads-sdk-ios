/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "UIKit/UIKit.h"
#import <YandexMobileAdsMoPubAdapters/YMANativeCustomEventAdRendering.h>
#import "MPNativeAdRendering.h"

/**
 * Sample native content ad view template which can be configured to display any set of assets.
 */
@interface NativeAdView : UIView <MPNativeAdRendering, YMANativeCustomEventAdRendering>

@end
