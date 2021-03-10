/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileNativeAds.h>
#import "ViewController.h"
#import "NativeAdView.h"

static NSString *const kAdMobBlockID = @"adf-279013/975874";
static NSString *const kFacebookBlockID = @"adf-279013/975877";
static NSString *const kMoPubBlockID = @"adf-279013/975875";
static NSString *const kMyTargetBlockID = @"adf-279013/975876";
static NSString *const kYandexBlockID = @"adf-279013/975878";

static int const kNetworkNameIndex = 0;
static int const kBlockIDIndex = 1;

@interface ViewController () <YMANativeAdLoaderDelegate, YMANativeAdDelegate>

@property (nonatomic, copy, readonly) NSArray<NSArray<NSString *> *> *networks;
@property (nonatomic, strong, readonly) NativeAdView *adView;
@property (nonatomic, strong) YMANativeAdLoader *adLoader;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

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
            @[@"Yandex", kYandexBlockID]
        ];
        _adView = [NativeAdView nib];
        _adLoader = [[YMANativeAdLoader alloc] init];
        _adLoader.delegate = self;
    }
    return self;
}

- (IBAction)loadAd:(id)sender
{
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
    /*
     Replace blockID with actual Block ID.
     Following demo block ids may be used for testing:
     AdMob mediation: kAdMobBlockID
     Facebook mediation: kFacebookBlockID
     MoPub mediation: kMoPubBlockID
     MyTarget mediation: kMyTargetBlockID
     Yandex: kYandexBlockID
     */
    NSString *blockID = self.networks[selectedIndex][kBlockIDIndex];
    YMANativeAdRequestConfiguration *requestConfiguration =
        [[YMANativeAdRequestConfiguration alloc] initWithBlockID:blockID];
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
    NSError * __autoreleasing error = nil;
    ad.delegate = self;
    [ad bindWithAdView:self.adView error:&error];
    if (error != nil) {
        NSLog(@"Binding finished with error: %@", error);
    }
    else {
        [self.view addSubview:self.adView];
        [self addConstraintsToAdView:self.adView];
        [self.adView prepareForDisplay];
    }
}

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didFailLoadingWithError:(NSError *)error
{
    NSLog(@"Native ad loading error: %@", error);
}

#pragma mark - YMANativeAdDelegate

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
