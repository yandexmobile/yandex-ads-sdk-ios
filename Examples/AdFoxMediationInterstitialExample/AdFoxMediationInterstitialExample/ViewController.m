/*
 *  ViewController.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "ViewController.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface ViewController () <YMAInterstitialDelegate>

@property (nonatomic, strong) YMAInterstitialController *interstitialController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace demo R-M-206876-12 with actual Block ID.
    self.interstitialController = [[YMAInterstitialController alloc] initWithBlockID:@"R-M-206876-12"];
    self.interstitialController.delegate = self;
}

- (IBAction)loadInterstitial
{
    // Replace demo parameters with actual parameters.
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"adf_ownerid"] = @"168627";
    parameters[@"adf_p1"] = @"bxvfr";
    parameters[@"adf_p2"] = @"fhmf";

    YMAAdRequest *adRequest = [[YMAAdRequest alloc] initWithLocation:nil
                                                        contextQuery:nil
                                                         contextTags:nil
                                                          parameters:parameters];
    [self.interstitialController loadWithRequest:adRequest];
}

- (IBAction)presentInterstitial
{
    [self.interstitialController presentInterstitialFromViewController:self];
}

#pragma mark - YMAInterstitialDelegate

- (void)interstitialDidLoadAd:(YMAInterstitialController *)interstitial
{
    NSLog(@"Loaded");
}

- (void)interstitialDidFailToLoadAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSLog(@"Loading failed. Error: %@", error);
}

- (void)interstitialWillLeaveApplication:(YMAInterstitialController *)interstitial
{
    NSLog(@"Will leave application");
}

- (void)interstitialDidFailToPresentAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSLog(@"Failed to present interstitial. Error: %@", error);
}

- (void)interstitialWillAppear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial will appear");
}

- (void)interstitialDidAppear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial did appear");
}

- (void)interstitialWillDisappear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial will disappear");
}

- (void)interstitialDidDisappear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial did disappear");
}

- (void)interstitialWillPresentScreen:(UIViewController *)webBrowser
{
    NSLog(@"Interstitial will present screen");
}

@end
