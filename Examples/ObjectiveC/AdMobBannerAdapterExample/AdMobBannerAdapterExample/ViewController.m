/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
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

#pragma mark GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"Ad loaded.");
    [self.adView removeFromSuperview];
    [self.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *layoutGuide = self.view.layoutMarginsGuide;
    if (@available(iOS 11.0, *)) {
        layoutGuide = self.view.safeAreaLayoutGuide;
    }
    [self configureLayoutAtBottomOfSafeAreaForView:view layoutGuide:layoutGuide];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Ad failed loading.");
}

#pragma mark Private

- (void)configureLayoutAtBottomOfSafeAreaForView:(GADBannerView *)view
                                     layoutGuide:(UILayoutGuide *)layoutGuide
{
    NSArray *constraints = @[
                             [view.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor],
                             [view.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor],
                             [view.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor]
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
