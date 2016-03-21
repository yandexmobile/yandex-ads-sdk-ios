/*
 *  YMAMobileAds.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <Foundation/Foundation.h>

@interface YMAMobileAds : NSObject

/**
 * Enables SDK logs. Logs are disabled by default.
 */
+ (void)enableLogging;

/**
 * Returns SDK version.
 *
 * @return SDK version in X.YY format.
 */
+ (NSString *)SDKVersion;

@end
