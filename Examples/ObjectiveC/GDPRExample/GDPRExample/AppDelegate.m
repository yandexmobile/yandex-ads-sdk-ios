/*
 * Version for iOS © 2015–2018 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "AppDelegate.h"
#import "UserDefaultsKeys.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [YMAMobileAds enableLogging];
    [self initializeUserDefaults];
    //Make sure you set user consent on each start of application
    BOOL userConsent = [[NSUserDefaults standardUserDefaults] boolForKey:kGDPRUserConsentKey];
    [YMAMobileAds setUserConsent:userConsent];
    return YES;
}

- (void)initializeUserDefaults
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kGDPRShouldShowDialogKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGDPRShouldShowDialogKey];
    }
}

@end
