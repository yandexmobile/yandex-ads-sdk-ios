/*
 * Version for iOS © 2015–2018 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
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
    NSString *adUnit = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    self.adView = [[MPAdView alloc] initWithAdUnitId:adUnit size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    __typeof(self) __weak weakSelf = self;
    MPMoPubConfiguration *configuration = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:adUnit];
    [[MoPub sharedInstance] initializeSdkWithConfiguration:configuration completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.adView loadAd];
        });
    }];
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
    if (@available(iOS 11.0, *)) {
        [self configureLayoutAtBottomOfSafeAreaForView:view];
    } else {
        [self configureLayoutAtBottomForView:view];
    }
}

- (void)configureLayoutAtBottomForView:(MPAdView *)view
{
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

- (void)configureLayoutAtBottomOfSafeAreaForView:(MPAdView *)view NS_AVAILABLE_IOS(11_0)
{
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    NSArray *constraints = @[
                             [view.heightAnchor constraintEqualToConstant:MOPUB_BANNER_SIZE.height],
                             [view.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
                             [view.widthAnchor constraintEqualToConstant:MOPUB_BANNER_SIZE.width],
                             [view.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
    NSLog(@"Ad failed loading.");
}

@end
