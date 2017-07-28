/*
 *  ViewController.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "ViewController.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface ViewController () <YMAAdViewDelegate>

@property (nonatomic, strong) YMAAdView *adView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    YMAAdSize *adSize = [YMAAdSize fixedSizeWithCGSize:YMAAdSizeBanner_300x300];

    // Replace demo R-M-206876-13 with actual Block ID.
    self.adView = [[YMAAdView alloc] initWithBlockID:@"R-M-206876-13"
                                              adSize:adSize
                                            delegate:self];
    // Replace demo parameters with actual parameters.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"adf_ownerid"] = @"168627";
    parameters[@"adf_p1"] = @"bxvfs";
    parameters[@"adf_p2"] = @"fkbd";

    YMAAdRequest *adRequest = [[YMAAdRequest alloc] initWithLocation:nil
                                                        contextQuery:nil
                                                         contextTags:nil
                                                          parameters:parameters];

    [self.adView loadAdWithRequest:adRequest];
}

- (void)adViewDidLoad:(YMAAdView *)adView
{
    NSLog(@"Ad loaded");
    [self.adView displayAtBottomInView:self.view];
}

- (void)adViewDidFailLoading:(YMAAdView *)adView error:(NSError *)error
{
    NSLog(@"Ad failed loading. Error: %@", error);
}

- (void)adViewWillLeaveApplication:(YMAAdView *)adView
{
    NSLog(@"Ad will leave application");
}

- (void)adViewWillPresentScreen:(UIViewController *)viewController
{
    NSLog(@"Ad will present screen");
}

- (void)adViewDidDismissScreen:(UIViewController *)viewController
{
    NSLog(@"Ad did dismiss screen");
}

@end
