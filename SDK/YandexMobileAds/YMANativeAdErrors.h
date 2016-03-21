/*
 *  YMANativeAdErrors.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <Foundation/Foundation.h>

extern NSString *const kYMANativeAdErrorDomain;

typedef NS_ENUM(NSUInteger, YMANativeErrorCode) {
    YMANativeAdErrorCodeNoViewForAsset,
    YMANativeAdErrorCodeInvalidViewForBinding,
    YMANativeAdErrorCodeInvalidBinder,
    YMANativeAdErrorCodeAdTypeMismatch
};
