/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
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
    // Following demo Block IDs may be used for testing:
    // R-M-DEMO-320x50
    // R-M-DEMO-320x50-app_install
    // R-M-DEMO-728x90
    // R-M-DEMO-320x100-context
    // R-M-DEMO-300x250
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
    if (@available(iOS 11.0, *)) {
        [self displayAdAtBottomOfSafeArea];
    } else {
        [self.bottomAdView displayAtBottomInView:self.view];
    }
    [self.bottomAdView loadAd];
}

// Ability to display ad at top of Safe Area will soon be added to `displayAtBottomOfSafeAreaInView:` method of SDK
- (void)displayAdAtBottomOfSafeArea NS_AVAILABLE_IOS(11_0)
{
    [self.bottomAdView removeFromSuperview];
    NSLayoutConstraint *anchorConstraint =
        [self.bottomAdView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    [self displayAdView:self.bottomAdView withAnchorConstraint:anchorConstraint];
}

// Ability to display ad at bottom of Safe Area will soon be added to `displayAdAtTopOfSafeAreaInView:` method of SDK
- (void)displayAdAtTopOfSafeArea NS_AVAILABLE_IOS(11_0)
{
    [self.topAdView removeFromSuperview];
    NSLayoutConstraint *anchorConstraint =
        [self.topAdView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
    [self displayAdView:self.topAdView withAnchorConstraint:anchorConstraint];
}

- (void)displayAdView:(UIView *)view withAnchorConstraint:(NSLayoutConstraint *)anchorConstraint NS_AVAILABLE_IOS(11_0)
{
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    NSArray *constraints = @[
                             [view.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                             [view.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
                             anchorConstraint
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
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
        if (@available(iOS 11.0, *)) {
            [self displayAdAtTopOfSafeArea];
        } else {
            [self.topAdView displayAtTopInView:self.view];
        }
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
