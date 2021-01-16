/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "ViewController.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface ViewController () <YMAInterstitialAdDelegate>

@property (nonatomic, strong) YMAInterstitialAd *interstitialAd;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace demo R-M-DEMO-240x400-context with actual Block ID
    // Following demo Block IDs may be used for testing:
    // R-M-DEMO-240x400-context
    // R-M-DEMO-400x240-context
    // R-M-DEMO-320x480
    // R-M-DEMO-480x320
    // R-M-DEMO-video-interstitial
    self.interstitialAd = [[YMAInterstitialAd alloc] initWithBlockID:@"R-M-DEMO-240x400-context"];
    self.interstitialAd.delegate = self;
}

- (IBAction)loadInterstitial
{
    [self.interstitialAd load];
}

- (IBAction)presentInterstitial
{
    [self.interstitialAd presentFromViewController:self];
}

#pragma mark - YMAInterstitialAdDelegate

- (void)interstitialAdDidLoad:(YMAInterstitialAd *)interstitialAd
{
    NSLog(@"Loaded");
}

- (void)interstitialAdDidFailToLoad:(YMAInterstitialAd *)interstitialAd error:(NSError *)error
{
    NSLog(@"Loading failed. Error: %@", error);
}

- (void)interstitialAdWillLeaveApplication:(YMAInterstitialAd *)interstitialAd
{
    NSLog(@"Will leave application");
}

- (void)interstitialAdDidFailToPresent:(YMAInterstitialAd *)interstitialAd error:(NSError *)error
{
    NSLog(@"Failed to present interstitial. Error: %@", error);
}

- (void)interstitialAdWillAppear:(YMAInterstitialAd *)interstitialAd
{
    NSLog(@"Interstitial will appear");
}
- (void)interstitialAdDidAppear:(YMAInterstitialAd *)interstitialAd
{
    NSLog(@"Interstitial did appear");
}

- (void)interstitialAdWillDisappear:(YMAInterstitialAd *)interstitialAd
{
    NSLog(@"Interstitial will disappear");
}

- (void)interstitialAdDidDisappear:(YMAInterstitialAd *)interstitialAd
{
    NSLog(@"Interstitial did disappear");
}

- (void)interstitialAd:(YMAInterstitialAd *)interstitialAd willPresentScreen:(UIViewController *)webBrowser
{
    NSLog(@"Interstitial will present screen");
}

@end
