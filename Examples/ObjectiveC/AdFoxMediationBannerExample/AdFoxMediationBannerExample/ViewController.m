/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "ViewController.h"
#import "RequestParametersProvider.h"

@interface ViewController () <YMAAdViewDelegate>

@property (nonatomic, strong) YMAAdView *adView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    YMAAdSize *adSize = [YMAAdSize fixedSizeWithCGSize:YMAAdSizeBanner_320x50];

    // Replace demo R-M-243655-8 with actual Block ID.
    self.adView = [[YMAAdView alloc] initWithBlockID:@"R-M-243655-8"
                                              adSize:adSize
                                            delegate:self];
    // Replace demo parameters with actual parameters.
    // Following demo parameters may be used for testing:
    // Yandex: [RequestParametersProvider yandexParameters]
    // AdMob mediation: [RequestParametersProvider adMobParameters]
    // Facebook mediation: [RequestParametersProvider facebookParameters]
    // MoPub mediation: [RequestParametersProvider moPubParameters]
    // MyTarget mediation: [RequestParametersProvider myTargetParameters]
    // StartApp mediation: [RequestParametersProvider startAppParameters]
    NSDictionary *parameters = [RequestParametersProvider adMobParameters];
    YMAAdRequest *adRequest = [[YMAAdRequest alloc] initWithLocation:nil
                                                        contextQuery:nil
                                                         contextTags:nil
                                                          parameters:parameters];

    [self.adView loadAdWithRequest:adRequest];
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

#pragma mark - YMAAdViewDelegate

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
