/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileNativeAds.h>
#import "ViewController.h"
#import "NativeAppInstallAdView.h"
#import "NativeContentAdView.h"
#import "NativeImageAdView.h"
#import "NativeAdViewFactory.h"

static NSString *const kAdMobBlockID = @"adf-279013/975874";
static NSString *const kFacebookBlockID = @"adf-279013/975877";
static NSString *const kMoPubBlockID = @"adf-279013/975875";
static NSString *const kMyTargetBlockID = @"adf-279013/975876";
static NSString *const kYandexBlockID = @"adf-279013/975878";

static int const kNetworkNameIndex = 0;
static int const kBlockIDIndex = 1;

@interface ViewController () <YMANativeAdLoaderDelegate, YMANativeAdDelegate>

@property (nonatomic, strong) NativeAdViewFactory *adViewFactory;
@property (nonatomic, strong) NativeContentAdView *contentAdView;
@property (nonatomic, strong) NativeAppInstallAdView *appInstallAdView;
@property (nonatomic, strong) NativeImageAdView *imageAdView;
@property (nonatomic, strong) YMANativeAdLoader *adLoader;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, copy, readonly) NSArray<NSArray<NSString *> *> *networks;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        _adViewFactory = [[NativeAdViewFactory alloc] init];
        _networks = @[
            @[@"AdMob", kAdMobBlockID],
            @[@"Facebook", kFacebookBlockID],
            @[@"MoPub", kMoPubBlockID],
            @[@"myTarget", kMyTargetBlockID],
            @[@"Yandex", kYandexBlockID]
        ];
    }
    return self;
}

- (IBAction)loadAd:(id)sender
{
    [self removeCurrentAdView];
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
    YMANativeAdLoaderConfiguration *configuration =
    [[YMANativeAdLoaderConfiguration alloc] initWithBlockID:blockID
                                    loadImagesAutomatically:YES];
    self.adLoader = [[YMANativeAdLoader alloc] initWithConfiguration:configuration];
    self.adLoader.delegate = self;
    [self.adLoader loadAdWithRequest:nil];
}

- (void)removeCurrentAdView
{
    [self.appInstallAdView removeFromSuperview];
    [self.contentAdView removeFromSuperview];
    [self.imageAdView removeFromSuperview];
}

- (void)addConstraintsToAdView:(UIView *)adView
{
    if (@available(iOS 11.0, *)) {
        [self configureLayoutAtBottomOfSafeArea:adView];
    } else {
        [self configureLayoutAtBottom:adView];
    }
}

- (void)configureLayoutAtBottom:(UIView *)bannerView
{
    NSDictionary *views = NSDictionaryOfVariableBindings(bannerView);
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bannerView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bannerView]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    [self.view addConstraints:horizontal];
    [self.view addConstraints:vertical];
}

- (void)configureLayoutAtBottomOfSafeArea:(UIView *)bannerView NS_AVAILABLE_IOS(11_0)
{
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    NSArray *constraints = @[
                             [bannerView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                             [bannerView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
                             [bannerView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - YMANativeAdLoaderDelegate

- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader
   didLoadAppInstallAd:(id<YMANativeAppInstallAd> __nonnull)ad
{
    [self removeCurrentAdView];
    self.appInstallAdView = [self.adViewFactory appInstallAdView];
    
    NSError * __autoreleasing error = nil;
    [ad bindAppInstallAdToView:self.appInstallAdView delegate:self error:&error];
    if (error != nil) {
        NSLog(@"Binding finished with error: %@", error);
    } else {
        [self.appInstallAdView prepareForDisplay];
        
        [self.view addSubview:self.appInstallAdView];
        [self addConstraintsToAdView:self.appInstallAdView];
    }
}

- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader
      didLoadContentAd:(id<YMANativeContentAd> __nonnull)ad
{
    [self removeCurrentAdView];
    self.contentAdView = [self.adViewFactory contentAdView];
    
    NSError * __autoreleasing error = nil;
    [ad bindContentAdToView:self.contentAdView delegate:self error:&error];
    if (error != nil) {
        NSLog(@"Binding finished with error: %@", error);
    } else {
        [self.contentAdView prepareForDisplay];
        
        [self.view addSubview:self.contentAdView];
        [self addConstraintsToAdView:self.contentAdView];
    }
}

- (void)nativeAdLoader:(YMANativeAdLoader *)loader
        didLoadImageAd:(id<YMANativeImageAd> __nonnull)ad
{
    [self removeCurrentAdView];
    self.imageAdView = [self.adViewFactory imageAdView];

    NSError * __autoreleasing error = nil;
    [ad bindImageAdToView:self.imageAdView delegate:self error:&error];
    if (error != nil) {
        NSLog(@"Binding finished with error: %@", error);
    } else {
        [self.imageAdView prepareForDisplay];

        [self.view addSubview:self.imageAdView];
        [self addConstraintsToAdView:self.imageAdView];
    }
}

- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader didFailLoadingWithError:(NSError * __nonnull)error
{
    NSLog(@"Native ad loading error: %@", error);
}

#pragma mark - YMANativeAdDelegate

// Uncomment to open web links in in-app browser

//- (UIViewController *)viewControllerForPresentingModalView
//{
//    return self;
//}

- (void)nativeAdWillLeaveApplication:(null_unspecified id)ad
{
    NSLog(@"Will leave application");
}

- (void)nativeAd:(null_unspecified id)ad willPresentScreen:(nullable UIViewController *)viewController
{
    NSLog(@"Will present screen");
}

- (void)nativeAd:(null_unspecified id)ad didDismissScreen:(nullable UIViewController *)viewController
{
    NSLog(@"Did dismiss screen");
}

- (void)closeNativeAd:(null_unspecified id)ad
{
    [self removeCurrentAdView];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.networks[row][kNetworkNameIndex];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.networks.count;
}

@end
