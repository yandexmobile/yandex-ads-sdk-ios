/*
 * Version for iOS © 2015–2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
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
    self.adView = [[YMAAdView alloc] initWithBlockID:@"R-M-243655-2"
                                              adSize:adSize
                                            delegate:self];
    // Replace demo parameters with actual parameters.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"adf_ownerid"] = @"168627";
    parameters[@"adf_p1"] = @"bxwrz";
    parameters[@"adf_p2"] = @"fkbd";
    parameters[@"adf_pt"] = @"b";

    YMAAdRequest *adRequest = [[YMAAdRequest alloc] initWithLocation:nil
                                                        contextQuery:nil
                                                         contextTags:nil
                                                          parameters:parameters];

    [self.adView loadAdWithRequest:adRequest];
}

- (void)adViewDidLoad:(YMAAdView *)adView
{
    NSLog(@"Ad loaded");
    [self.adView removeFromSuperview];
    if (@available(iOS 11.0, *)) {
        [self displayAtBottomOfSafeArea];
    } else {
        [self.adView displayAtBottomInView:self.view];
    }
}

// Ability to display ad in Safe Area will soon be added to `displayAtBottomOfSafeAreaInView:` method of SDK
- (void)displayAtBottomOfSafeArea NS_AVAILABLE_IOS(11_0)
{
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adView];
    NSArray *constraints = @[
                             [self.adView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                             [self.adView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
                             [self.adView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
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
