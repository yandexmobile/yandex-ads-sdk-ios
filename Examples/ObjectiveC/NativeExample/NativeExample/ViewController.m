/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileNativeAds.h>
#import "ViewController.h"
#import "NativeAdView.h"

@interface ViewController () <YMANativeAdLoaderDelegate, YMANativeAdDelegate>

@property (nonatomic, strong) NativeAdView *adView;
@property (nonatomic, strong) YMANativeAdLoader *adLoader;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.adView = [NativeAdView nib];
    self.adLoader = [[YMANativeAdLoader alloc] init];
    self.adLoader.delegate = self;

    // Replace demo R-M-DEMO-native-c with actual Block ID
    // Following demo Block IDs may be used for testing:
    // R-M-DEMO-native-video
    // R-M-DEMO-native-c
    // R-M-DEMO-native-i

    YMANativeAdRequestConfiguration *requestConfiguration =
        [[YMANativeAdRequestConfiguration alloc] initWithBlockID:@"R-M-DEMO-native-c"];
    [self.adLoader loadAdWithRequestConfiguration:requestConfiguration];
}

- (void)addConstraintsToAdView:(UIView *)adView
{
    adView.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *guide = self.view.layoutMarginsGuide;
    if (@available(iOS 11.0, *)) {
        guide = self.view.safeAreaLayoutGuide;
    }
    NSArray *constraints = @[
        [adView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
        [adView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
        [adView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
    ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - YMANativeAdLoaderDelegate

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didLoadAd:(id<YMANativeAd>)ad
{
    [self.adView removeFromSuperview];

    NSError * __autoreleasing error = nil;
    ad.delegate = self;
    [ad bindWithAdView:self.adView error:&error];
    if (error != nil) {
        NSLog(@"Binding finished with error: %@", error);
    }
    else {
        [self.adView prepareForDisplay];
        [self.view addSubview:self.adView];
        [self addConstraintsToAdView:self.adView];
    }
}

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didFailLoadingWithError:(NSError *)error
{
    NSLog(@"Native ad loading error: %@", error);
}

#pragma  mark - YMANativeAdDelegate

// Uncomment to open web links in in-app browser

//- (UIViewController *)viewControllerForPresentingModalView
//{
//    return self;
//}

- (void)nativeAdWillLeaveApplication:(id<YMANativeAd>)ad
{
    NSLog(@"Will leave application");
}

- (void)nativeAd:(id<YMANativeAd>)ad willPresentScreen:(UIViewController *)viewController
{
    NSLog(@"Will present screen");
}

- (void)nativeAd:(id<YMANativeAd>)ad didDismissScreen:(UIViewController *)viewController
{
    NSLog(@"Did dismiss screen");
}

- (void)closeNativeAd:(id<YMANativeAd>)ad
{
    [self.adView removeFromSuperview];
}

@end
