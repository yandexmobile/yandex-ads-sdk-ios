/*
 *  AppDelegate.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "AppDelegate.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import <YandexMobileAds/YandexMobileAds.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // This is sample API key. Application API key can be requested at https://appmetrica.yandex.com".
    [YMMYandexMetrica activateWithApiKey:@"43614695-4bad-431c-9e14-fa588179b756"];

    [YMAMobileAds enableLogging];

    return YES;
}

@end
