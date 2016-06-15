/*
 *  ViewController.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "ViewController.h"
#import "NativeAppInstallAdView.h"
#import "NativeContentAdView.h"
#import <YandexMobileAds/YandexMobileNativeAds.h>

@interface ViewController () <YMANativeAdLoaderDelegate, YMANativeAdDelegate>

@property (nonatomic, strong) NativeContentAdView *contentAdView;
@property (nonatomic, strong) NativeAppInstallAdView *appInstallAdView;
@property (nonatomic, strong) YMANativeAdLoader *adLoader;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contentAdView = [[NativeContentAdView alloc] initWithFrame:CGRectZero];
    self.contentAdView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentAdView.backgroundColor = [UIColor yellowColor];

    self.appInstallAdView = [[NativeAppInstallAdView alloc] initWithFrame:CGRectZero];
    self.appInstallAdView.translatesAutoresizingMaskIntoConstraints = NO;
    self.appInstallAdView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f];

    // Replace demo R-M-DEMO-native-c with actual Block ID
    // Following demo Block IDs may be used for testing:
    // R-M-DEMO-native-c
    // R-M-DEMO-native-i
    YMANativeAdLoaderConfiguration *configuration =
        [[YMANativeAdLoaderConfiguration alloc] initWithBlockID:@"R-M-DEMO-native-c"
                                        loadImagesAutomatically:YES];
    self.adLoader = [[YMANativeAdLoader alloc] initWithConfiguration:configuration];
    self.adLoader.delegate = self;
    [self.adLoader loadAdWithRequest:nil];
}

- (void)removeCurrentAdView
{
    [self.appInstallAdView removeFromSuperview];
    [self.contentAdView removeFromSuperview];
}

- (void)addConstraintsToAdView:(UIView *)adView
{
    NSDictionary *views = NSDictionaryOfVariableBindings(adView);
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[adView]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[adView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *constraints = [vertical arrayByAddingObjectsFromArray:horizontal];
    [self.view addConstraints:constraints];
}

#pragma mark - YMANativeAdLoaderDelegate

- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader
   didLoadAppInstallAd:(id<YMANativeAppInstallAd> __nonnull)ad
{
    [self removeCurrentAdView];

    NSError * __autoreleasing error = nil;
    [ad bindAppInstallAdToView:self.appInstallAdView delegate:self error:&error];
    NSLog(@"Binding finished with error: %@", error);

    [self.appInstallAdView prepareForDisplay];

    [self.view addSubview:self.appInstallAdView];
    [self addConstraintsToAdView:self.appInstallAdView];
}

- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader
      didLoadContentAd:(id<YMANativeContentAd> __nonnull)ad
{
    [self removeCurrentAdView];

    NSError * __autoreleasing error = nil;
    [ad bindContentAdToView:self.contentAdView delegate:self error:&error];
    NSLog(@"Binding finished with error: %@", error);

    [self.contentAdView prepareForDisplay];

    [self.view addSubview:self.contentAdView];
    [self addConstraintsToAdView:self.contentAdView];
}

- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader didFailLoadingWithError:(NSError * __nonnull)error
{
    NSLog(@"Native ad loading error: %@", error);
}

#pragma  mark - YMANativeAdDelegate

// Uncomment to open web links in in-app browser

//- (UIViewController *)viewControllerForPresentingModalView
//{
//    return self;
//}

- (void)nativeAdWillLeaveApplication:(null_unspecified id)ad
{
    NSLog(@"Will leave application");
}

- (void)nativeAd:(null_unspecified id)ad willPresentScreen:(UIViewController *)viewController
{
    NSLog(@"Will present screen");
}

- (void)nativeAd:(null_unspecified id)ad didDismissScreen:(UIViewController *)viewController
{
    NSLog(@"Did dismiss screen");
}

@end
