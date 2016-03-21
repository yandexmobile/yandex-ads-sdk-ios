/*
 *  YMANativeGenericAd.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMANativeAdDelegate;

@protocol YMANativeGenericAd <NSObject>

/**
 * Delegate is notified about clicks and transitions triggered by user interaction with ad.
 */
@property (nonatomic, weak, nullable) id<YMANativeAdDelegate> delegate;

/**
 * Returns ad type. @see YMANativeAdTypes.h.
 *
 * @return Ad type.
 */
- (NSString *)adType;

@end

NS_ASSUME_NONNULL_END
