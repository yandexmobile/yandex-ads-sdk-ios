/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import <StartApp/StartApp.h>
#import "ViewController.h"

static NSString *const kAdMobBlockID = @"adf-279013/975832";
static NSString *const kFacebookBlockID = @"adf-279013/975836";
static NSString *const kMoPubBlockID = @"adf-279013/975834";
static NSString *const kMyTargetBlockID = @"adf-279013/975835";
static NSString *const kStartAppBlockID = @"adf-279013/1006423";
static NSString *const kYandexBlockID = @"adf-279013/975838";

static int const kNetworkNameIndex = 0;
static int const kBlockIDIndex = 1;

@interface ViewController () <YMAAdViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) YMAAdView *adView;
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
            @[@"Facebook", kFacebookBlockID],
            @[@"MoPub", kMoPubBlockID],
            @[@"myTarget", kMyTargetBlockID],
            @[@"StartApp", kStartAppBlockID],
            @[@"Yandex", kYandexBlockID]
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [STAStartAppSDK sharedInstance].testAdsEnabled = YES;
}

- (IBAction)loadAd:(id)sender
{
    [self.adView removeFromSuperview];
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
    /*
     Replace blockID with actual Block ID.
     Following demo block ids may be used for testing:
     AdMob mediation: kAdMobBlockID
     Facebook mediation: kFacebookBlockID
     MoPub mediation: kMoPubBlockID
     MyTarget mediation: kMyTargetBlockID
     StartApp mediation: kStartAppBlockID
     Yandex: kYandexBlockID
     */
    NSString *blockID = self.networks[selectedIndex][kBlockIDIndex];
    YMAAdSize *adSize = [YMAAdSize fixedSizeWithCGSize:YMAAdSizeBanner_320x50];
    self.adView = [[YMAAdView alloc] initWithBlockID:blockID adSize:adSize];
    self.adView.delegate = self;
    [self.adView loadAd];
}

- (void)displayAtBottomOfSafeArea
{
    UILayoutGuide *guide = self.view.layoutMarginsGuide;
    if (@available(iOS 11.0, *)) {
        guide = self.view.safeAreaLayoutGuide;
    }
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adView];
    NSArray *constraints = @[
                             [self.adView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                             [self.adView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
                             [self.adView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - YMAAdViewDelegate

- (void)adViewDidLoad:(YMAAdView *)adView
{
    NSLog(@"Ad loaded");
    [self.adView removeFromSuperview];
    if (@available(iOS 11.0, *)) {
        [self displayAtBottomOfSafeArea];
    } else {
        [self.adView displayAtBottomInView:self.view];
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

- (void)adView:(YMAAdView *)adView willPresentScreen:(UIViewController *)viewController
{
    NSLog(@"Ad will present screen");
}

- (void)adView:(YMAAdView *)adView didDismissScreen:(UIViewController *)viewController
{
    NSLog(@"Ad did dismiss screen");
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
