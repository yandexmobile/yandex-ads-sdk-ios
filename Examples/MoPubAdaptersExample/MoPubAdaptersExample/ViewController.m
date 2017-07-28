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
#import <mopub-ios-sdk/MoPub.h>

@interface ViewController () <MPAdViewDelegate>

@property (nonatomic, strong) MPAdView *adView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com.
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView loadAd];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"Ad loaded.");
    [self.adView removeFromSuperview];
    [self.view addSubview:view];
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

- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
    NSLog(@"Ad failed loading.");
}

@end
