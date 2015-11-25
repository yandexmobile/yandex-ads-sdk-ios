/*
 *  YMANativeAppInstallAd.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <Foundation/Foundation.h>

@class YMANativeAppInstallAdView;
@protocol YMANativeAdDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol YMANativeAppInstallAd <NSObject>

@property (nonatomic, weak, readonly) id<YMANativeAdDelegate> delegate;

/**
 * Sets values of all app install ad assets to native app install ad view, installs impression and click handlers.
 *
 * @param view Root ad view, superview for all asset views.
 * @param binder Provides views for ad assets.
 * @param error Binding error. @see YMANativeAdErrors.h for error codes.
 *
 * @return YES if binding succeeded, otherwise NO.
 */
- (BOOL)bindAppInstallAdToView:(YMANativeAppInstallAdView *)view
                      delegate:(id<YMANativeAdDelegate>)delegate
                         error:(NSError * __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
