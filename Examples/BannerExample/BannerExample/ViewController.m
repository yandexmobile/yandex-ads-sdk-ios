/*
 *  ViewController.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "ViewController.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface ViewController () <YMAAdViewDelegate>

@property (nonatomic, strong) YMAAdView *topAdView;
@property (nonatomic, strong) YMAAdView *bottomAdView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace demo R-M-DEMO-320x50 with actual Block ID
    // Following demo Block IDs may be used for testing
    // R-M-DEMO-728x90
    // R-M-DEMO-320x100-context
    // R-M-DEMO-300x250-context
    // R-M-DEMO-300x300-context
    YMAAdSize *adSize = [YMAAdSize flexibleSizeWithContainerWidth:CGRectGetWidth(self.view.frame)];
    self.topAdView = [[YMAAdView alloc] initWithBlockID:@"R-M-DEMO-320x50"
                                              adSize:adSize
                                            delegate:self];
    [self.topAdView loadAd];

    self.bottomAdView = [[YMAAdView alloc] initWithBlockID:@"R-M-DEMO-320x100-context"
                                                    adSize:[YMAAdSize flexibleSize]
                                                  delegate:self];
    [self.bottomAdView displayAtBottomInView:self.view];
    [self.bottomAdView loadAd];
}

#pragma mark - YMAAdViewDelegate

// Uncomment to open web links in in-app browser

//- (UIViewController *)viewControllerForPresentingModalView
//{
//    return self;
//}

- (void)adViewDidLoad:(YMAAdView *)adView
{
    NSLog(@"Ad loaded");
    if (adView == self.topAdView) {
        [self.topAdView displayAtTopInView:self.view];
    }
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
