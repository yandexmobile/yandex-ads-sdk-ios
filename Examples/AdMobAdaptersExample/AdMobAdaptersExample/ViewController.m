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
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *adView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
    self.adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.adView.adUnitID = @"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY";
    self.adView.rootViewController = self;
    self.adView.delegate = self;
    [self.adView loadRequest:[GADRequest request]];
}

#pragma mark Ad Request Lifecycle Notifications

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"Ad loaded.");
    [self.adView removeFromSuperview];
    [self.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSArray *vertical =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(50)]|" options:0 metrics:nil views:views];
    NSArray *horizontal =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(320)]" options:0 metrics:nil views:views];
    NSLayoutConstraint *center = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.f
                                                               constant:0.f];
    [self.view addConstraints:vertical];
    [self.view addConstraints:horizontal];
    [self.view addConstraint:center];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Ad failed loading.");
}

@end
