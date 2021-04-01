/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark GADBannerViewDelegate

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView
{
    NSLog(@"Ad loaded.");
    [self.bannerView removeFromSuperview];
    [self.view addSubview:bannerView];
    UILayoutGuide *layoutGuide = self.view.layoutMarginsGuide;
    if (@available(iOS 11.0, *)) {
        layoutGuide = self.view.safeAreaLayoutGuide;
    }
    [self configureLayoutAtBottomOfSafeAreaForView:bannerView layoutGuide:layoutGuide];
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error
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
