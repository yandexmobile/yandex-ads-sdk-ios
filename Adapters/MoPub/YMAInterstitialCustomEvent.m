/*
 *  YMAInterstitialCustomEvent.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "YMAInterstitialCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPLogging.h"

@interface MPInstanceProvider (YandexBanners)

- (YMAInterstitialController *)buildYMAInterstitialAdWithBlockID:(NSString *)blockID;

@end

@implementation MPInstanceProvider (YandexBanners)

- (YMAInterstitialController *)buildYMAInterstitialAdWithBlockID:(NSString *)blockID
{
    return [[YMAInterstitialController alloc] initWithBlockID:blockID];
}

@end

@interface YMAInterstitialCustomEvent () <YMAInterstitialDelegate>

@property (nonatomic, strong) YMAInterstitialController *interstitialController;

@end

@implementation YMAInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
        MPLogError(@"Minimum supported OS version of Yandex Mobile Ads is iOS 7.0");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }

    MPLogInfo(@"Requesting Yandex AppMetrica Ads Interstitial");
    
    NSString *blockID = [info objectForKey:@"blockID"];
    if (blockID.length == 0) {
        MPLogInfo(@"Yandex Mobile Ads Interstitial block ID not specified");
        NSError *error = [NSError errorWithDomain:kYMAAdsErrorDomain code:YMAAdErrorCodeEmptyBlockID userInfo:nil];
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }
    
    self.interstitialController = [[MPInstanceProvider sharedProvider] buildYMAInterstitialAdWithBlockID:blockID];
    self.interstitialController.shouldOpenLinksInApp = [info[@"openLinksInApp"] boolValue];
    self.interstitialController.delegate = self;
    
    CLLocation *location = self.delegate.location;
    YMAAdRequest *request = [[YMAAdRequest alloc] initWithLocation:location contextQuery:nil contextTags:nil];
    
    [self.interstitialController loadWithRequest:request];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    [self.interstitialController presentInterstitialFromViewController:rootViewController];
}

- (void)dealloc
{
    self.interstitialController.delegate = nil;
}

#pragma mark - YMAInterstitialDelegate

- (void)interstitialDidLoadAd:(YMAInterstitialController *)interstitial
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:self];
}

- (void)interstitialDidFailToLoadAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial did fail to load with error: %@", error.localizedDescription);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)interstitialWillAppear:(YMAInterstitialController *)interstitial
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial will appear");
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)interstitialDidAppear:(YMAInterstitialController *)interstitial
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial did appear");
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitialWillDisappear:(YMAInterstitialController *)interstitial
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial will disappear");
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)interstitialDidDisappear:(YMAInterstitialController *)interstitial
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial did disappear");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)interstitialWillLeaveApplication:(YMAInterstitialController *)interstitial
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial will leave application");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

- (void)interstitialWillPresentScreen:(UIViewController *)webBrowser
{
    MPLogInfo(@"Yandex Mobile Ads Interstitial will present screen");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

@end
