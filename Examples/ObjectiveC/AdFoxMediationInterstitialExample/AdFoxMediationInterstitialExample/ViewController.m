/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "ViewController.h"

static NSString *const kAdMobBlockID = @"adf-279013/975869";
static NSString *const kAppLovinBlockID = @"adf-279013/1052107";
static NSString *const kFacebookBlockID = @"adf-279013/975872";
static NSString *const kMoPubBlockID = @"adf-279013/975870";
static NSString *const kStartAppBlockID = @"adf-279013/1006406";
static NSString *const kUnityAdsBlockID = @"adf-279013/1006439";
static NSString *const kYandexBlockID = @"adf-279013/975873";

@interface ViewController () <YMAInterstitialDelegate>

@property (nonatomic, strong) YMAInterstitialController *interstitialController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*
     Replace demo kAdMobBlockID with actual Block ID.
     Following demo block ids may be used for testing:
     AdMob mediation: kAdMobBlockID
     AppLovin mediation: kAppLovinBlockID
     Facebook mediation: kFacebookBlockID
     MoPub mediation: kMoPubBlockID
     StartApp mediation: kStartAppBlockID
     UnityAds mediation kUnityAdsBlockID
     Yandex: kYandexBlockID
     */
    self.interstitialController = [[YMAInterstitialController alloc] initWithBlockID:kAdMobBlockID];
    self.interstitialController.delegate = self;
}

- (IBAction)loadInterstitial
{
    [self.interstitialController load];
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
