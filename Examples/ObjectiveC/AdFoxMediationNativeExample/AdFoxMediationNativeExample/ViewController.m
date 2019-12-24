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

static NSString *const kAdMobBlockID = @"adf-279013/975874";
static NSString *const kFacebookBlockID = @"adf-279013/975877";
static NSString *const kMoPubBlockID = @"adf-279013/975875";
static NSString *const kYandexBlockID = @"adf-279013/975878";

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

    /*
     Replace demo kYandexBlockID with actual Block ID.
     Following demo block ids may be used for testing:
     AdMob mediation: kAdMobBlockID
     Facebook mediation: kFacebookBlockID
     MoPub mediation: kMoPubBlockID
     Yandex: kYandexBlockID
     */
    YMANativeAdLoaderConfiguration *configuration =
        [[YMANativeAdLoaderConfiguration alloc] initWithBlockID:kYandexBlockID
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

@end
