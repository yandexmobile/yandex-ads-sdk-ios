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
#import <YandexMobileAds/YandexMobileNativeAds.h>

@interface ViewController () <YMANativeAdLoaderDelegate, YMANativeAdDelegate>

@property (nonatomic, strong) YMANativeAdLoader *adLoader;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace demo R-M-187883-1 with actual Block ID.
    YMANativeAdLoaderConfiguration *configuration =
        [[YMANativeAdLoaderConfiguration alloc] initWithBlockID:@"R-M-187883-1"
                                                     imageSizes:@[ kYMANativeImageSizeMedium ]
                                        loadImagesAutomatically:YES];
    self.adLoader = [[YMANativeAdLoader alloc] initWithConfiguration:configuration];
    self.adLoader.delegate = self;

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"adf_ownerid"] = @"168627";
    parameters[@"adf_p1"] = @"bvyhx";
    parameters[@"adf_p2"] = @"fksh";
    parameters[@"adf_pfc"] = @"a";
    parameters[@"adf_pfb"] = @"a";
    parameters[@"adf_plp"] = @"a";
    parameters[@"adf_pli"] = @"a";
    parameters[@"adf_pop"] = @"a";
    parameters[@"adf_pt"] = @"b";

    YMAAdRequest *adRequest = [[YMAAdRequest alloc] initWithLocation:nil
                                                        contextQuery:nil
                                                         contextTags:nil
                                                          parameters:parameters];

    [self.adLoader loadAdWithRequest:adRequest];
}

- (void)didLoadAd:(id<YMANativeGenericAd>)ad
{
    NSLog(@"Info: %@", ad.info);
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

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didLoadImageAd:(nonnull id<YMANativeImageAd>)ad
{
    [self didLoadAd:ad];
}

- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader didFailLoadingWithError:(NSError * __nonnull)error
{
    NSLog(@"Native ad loading error: %@", error);
}

#pragma  mark - YMANativeAdDelegate

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
