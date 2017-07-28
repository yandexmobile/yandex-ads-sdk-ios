/*
 *  ViewController.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "ViewController.h"
#import <YandexMobileAds/YandexMobileNativeAds.h>

@interface ViewController () <YMANativeAdLoaderDelegate, YMANativeAdDelegate>

@property (nonatomic, strong) YMANativeAdLoader *adLoader;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace demo R-M-DEMO-native-c with actual Block ID.
    // Please, note, that configured image sizes don't affect demo ads.
    // Following demo Block IDs may be used for testing:
    // R-M-DEMO-native-c
    // R-M-DEMO-native-c-noage
    // R-M-DEMO-native-c-nowarning
    // R-M-DEMO-native-c-wide
    // R-M-DEMO-native-c-large34
    // R-M-DEMO-native-c-large43
    // R-M-DEMO-native-c-large11
    // R-M-DEMO-native-i
    // R-M-DEMO-native-i-noage
    // R-M-DEMO-native-i-nowarning
    // R-M-DEMO-native-i-wide
    // R-M-DEMO-native-i-large34
    // R-M-DEMO-native-i-large43
    // R-M-DEMO-native-i-large11
    YMANativeAdLoaderConfiguration *configuration =
        [[YMANativeAdLoaderConfiguration alloc] initWithBlockID:@"R-M-DEMO-native-c"
                                                     imageSizes:@[ kYMANativeImageSizeMedium ]
                                        loadImagesAutomatically:YES];
    self.adLoader = [[YMANativeAdLoader alloc] initWithConfiguration:configuration];
    self.adLoader.delegate = self;
    [self.adLoader loadAdWithRequest:nil];
}

- (void)didLoadAd:(id<YMANativeGenericAd>)ad
{
    ad.delegate = self;
    YMANativeBannerView *bannerView = [[YMANativeBannerView alloc] init];
    bannerView.ad = ad;
    [self.view addSubview:bannerView];

    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(bannerView);
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[bannerView]-(10)-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bannerView]-(10)-|"
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    [self.view addConstraints:horizontal];
    [self.view addConstraints:vertical];
}

#pragma mark - YMANativeAdLoaderDelegate

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didLoadAppInstallAd:(id<YMANativeAppInstallAd>)ad
{
    [self didLoadAd:ad];
}

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didLoadContentAd:(id<YMANativeContentAd>)ad
{
    [self didLoadAd:ad];
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

- (void)nativeAdWillLeaveApplication:(id)ad
{
    NSLog(@"Will leave application");
}

- (void)nativeAd:(id)ad willPresentScreen:(UIViewController *)viewController
{
    NSLog(@"Will present screen");
}

- (void)nativeAd:(id)ad didDismissScreen:(UIViewController *)viewController
{
    NSLog(@"Did dismiss screen");
}

@end
