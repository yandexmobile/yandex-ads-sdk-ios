/*
 *  YMABannerCustomEvent.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "YMABannerCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPLogging.h"

@interface MPInstanceProvider (YandexBanners)

- (YMAAdView *)buildYMABannerViewWithBlockID:(NSString *)blockID
                                        size:(CGSize)size
                                    delegate:(id<YMAAdViewDelegate>)delegate;

@end

@implementation MPInstanceProvider (YandexBanners)

- (YMAAdView *)buildYMABannerViewWithBlockID:(NSString *)blockID
                                        size:(CGSize)size
                                    delegate:(id<YMAAdViewDelegate>)delegate
{
    YMAAdSize *adSize = [YMAAdSize fixedSizeWithCGSize:size];
    return [[YMAAdView alloc] initWithBlockID:blockID adSize:adSize delegate:delegate];
}

@end

@interface YMABannerCustomEvent() <YMAAdViewDelegate>

@property (nonatomic, assign) BOOL shouldOpenLinksInApp;
@property (nonatomic, strong) YMAAdView *adView;

@end

@implementation YMABannerCustomEvent

- (void)dealloc
{
    self.adView.delegate = nil;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
        MPLogError(@"Minimum supported OS version of Yandex Mobile Ads is iOS 7.0");
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }

    MPLogInfo(@"Requesting Yandex AppMetrica Ads banner");

    NSString *blockID = info[@"blockID"];
    self.shouldOpenLinksInApp = [info[@"openLinksInApp"] boolValue];
    if (blockID.length == 0) {
        MPLogInfo(@"Yandex Mobile Ads banner block ID not specified");
        NSError *error = [NSError errorWithDomain:kYMAAdsErrorDomain code:YMAAdErrorCodeEmptyBlockID userInfo:nil];
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }

    CGSize bannerSize = [self bannerSizeWithEventInfo:info localSize:size];
    self.adView = [[MPInstanceProvider sharedProvider] buildYMABannerViewWithBlockID:blockID
                                                                                size:bannerSize
                                                                            delegate:self];

    CLLocation *location = self.delegate.location;
    YMAAdRequest *request = [[YMAAdRequest alloc] initWithLocation:location contextQuery:nil contextTags:nil];

    [self.adView loadAdWithRequest:request];
}

- (CGSize)bannerSizeWithEventInfo:(NSDictionary *)info localSize:(CGSize)localSize
{
    NSNumber *widthNumber = info[@"adWidth"];
    NSNumber *heightNumber = info[@"adHeight"];
    CGSize size = localSize;
    if (widthNumber != nil && heightNumber != nil) {
        size = CGSizeMake(widthNumber.floatValue, heightNumber.floatValue);
    }
    return size;
}

#pragma mark - YMAAdViewDelegate

- (UIViewController *)viewControllerForPresentingModalView
{
    if (self.shouldOpenLinksInApp == NO) {
        return nil;
    }
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)adViewDidLoad:(YMAAdView *)adView
{
    MPLogInfo(@"Yandex Mobile Ads banner did load");
    [self.delegate bannerCustomEvent:self didLoadAd:adView];
}

- (void)adViewDidFailLoading:(YMAAdView *)adView error:(NSError *)error
{
    MPLogInfo(@"Yandex Mobile Ads banner did fail to load with error: %@", error.localizedDescription);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)adViewWillPresentScreen:(UIViewController *)viewController
{
    MPLogInfo(@"Yandex Mobile Ads banner will present screen");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)adViewDidDismissScreen:(UIViewController *)viewController
{
    MPLogInfo(@"Yandex Mobile Ads banner did dismiss screen");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)adViewWillLeaveApplication:(YMAAdView *)adView
{
    MPLogInfo(@"Yandex Mobile Ads banner will leave application");
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

@end
