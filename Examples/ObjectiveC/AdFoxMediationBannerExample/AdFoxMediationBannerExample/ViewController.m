/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "ViewController.h"

static NSString *const kYandexBlockID = @"adf-279013/975838";
static NSString *const kAdMobBlockID = @"adf-279013/975832";
static NSString *const kFacebookBlockID = @"adf-279013/975836";
static NSString *const kMoPubBlockID = @"adf-279013/975834";
static NSString *const kMyTargetBlockID = @"adf-279013/975835";

@interface ViewController () <YMAAdViewDelegate>

@property (nonatomic, strong) YMAAdView *adView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    YMAAdSize *adSize = [YMAAdSize fixedSizeWithCGSize:YMAAdSizeBanner_320x50];

    /*
     Replace demo kAdMobBlockID with actual Block ID.
     Following demo block ids may be used for testing:
     Yandex: kYandexBlockID
     AdMob mediation: kAdMobBlockID
     Facebook mediation: kFacebookBlockID
     MoPub mediation: kMoPubBlockID
     MyTarget mediation: kMyTargetBlockID
     */
    self.adView = [[YMAAdView alloc] initWithBlockID:kAdMobBlockID
                                              adSize:adSize
                                            delegate:self];
    [self.adView loadAd];
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
