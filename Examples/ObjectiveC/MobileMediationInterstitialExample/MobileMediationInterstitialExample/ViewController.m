/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "ViewController.h"

static NSString *const kAdMobBlockID = @"adf-279013/975869";
static NSString *const kAppLovinBlockID = @"adf-279013/1052107";
static NSString *const kFacebookBlockID = @"adf-279013/975872";
static NSString *const kIronSourceBlockID = @"adf-279013/1052109";
static NSString *const kMoPubBlockID = @"adf-279013/975870";
static NSString *const kMyTargetBlockID = @"adf-279013/975871";
static NSString *const kStartAppBlockID = @"adf-279013/1006406";
static NSString *const kUnityAdsBlockID = @"adf-279013/1006439";
static NSString *const kYandexBlockID = @"adf-279013/975873";

static int const kNetworkNameIndex = 0;
static int const kBlockIDIndex = 1;

@interface ViewController () <YMAInterstitialAdDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) YMAInterstitialAd *interstitialAd;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, copy, readonly) NSArray<NSArray<NSString *> *> *networks;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        _networks = @[
            @[@"AdMob", kAdMobBlockID],
            @[@"AppLovin", kAppLovinBlockID],
            @[@"Facebook", kFacebookBlockID],
            @[@"IronSource", kIronSourceBlockID],
            @[@"MoPub", kMoPubBlockID],
            @[@"myTarget", kMyTargetBlockID],
            @[@"StartApp", kStartAppBlockID],
            @[@"UnityAds", kUnityAdsBlockID],
            @[@"Yandex", kYandexBlockID]
        ];
    }
    return self;
}

- (IBAction)loadInterstitial
{
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
    /*
     Replace blockID with actual Block ID.
     Following demo block ids may be used for testing:
     AdMob mediation: kAdMobBlockID
     AppLovin mediation: kAppLovinBlockID
     Facebook mediation: kFacebookBlockID
     IronSource mediation: kIronSourceBlockID
     MoPub mediation: kMoPubBlockID
     MyTarget mediation: kMyTargetBlockID
     StartApp mediation: kStartAppBlockID
     UnityAds mediation kUnityAdsBlockID
     Yandex: kYandexBlockID
     */
    NSString *blockID = self.networks[selectedIndex][kBlockIDIndex];
    self.interstitialAd = [[YMAInterstitialAd alloc] initWithBlockID:blockID];
    self.interstitialAd.delegate = self;
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

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.networks[row][kNetworkNameIndex];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.networks.count;
}

@end
