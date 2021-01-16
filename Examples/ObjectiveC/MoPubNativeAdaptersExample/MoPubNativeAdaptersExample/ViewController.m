/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "ViewController.h"
#import <mopub-ios-sdk/MoPub.h>
#import <YandexMobileAdsMoPubAdapters/YMANativeCustomEventAdRenderer.h>
#import "NativeAdView.h"

@interface ViewController () <MPNativeAdDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MPNativeAd *nativeAd;
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, copy) NSArray<MPNativeAdRendererConfiguration *> *rendererConfigurations;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureRenderer];
    // Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com.
    NSString *adUnit = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    __typeof(self) __weak weakSelf = self;
    MPMoPubConfiguration *configuration = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:adUnit];
    [[MoPub sharedInstance] initializeSdkWithConfiguration:configuration completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf loadAdWithAdUnit:adUnit];
        });
    }];
}

- (void)configureRenderer
{
    MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
    settings.renderingViewClass = [NativeAdView class];

    MPNativeAdRendererConfiguration *commonConfig =
        [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    MPNativeAdRendererConfiguration *yandexConfig =
        [YMANativeCustomEventAdRenderer rendererConfigurationWithRendererSettings:settings];
    self.rendererConfigurations = @[ commonConfig, yandexConfig ];
}

- (void)loadAdWithAdUnit:(NSString *)adUnit
{
    MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:adUnit
                                                           rendererConfigurations:self.rendererConfigurations];
    [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (error != nil) {
            NSLog(@"Loading error: %@", error.localizedDescription);
        }
        else {
            self.nativeAd = response;
            self.nativeAd.delegate = self;
            [self displayAd];
            NSLog(@"Received Native Ad");
        }
    }];
}

- (void)displayAd
{
    [self.adView removeFromSuperview];
    self.adView = [self.nativeAd retrieveAdViewWithError:nil];
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adView];
    if (@available(iOS 11.0, *)) {
        [self configureLayoutAtBottomOfSafeAreaForView:self.adView];
    } else {
        [self configureLayoutAtBottomForView:self.adView];
    }
}

- (void)configureLayoutAtBottomForView:(UIView *)bannerView
{
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

- (void)configureLayoutAtBottomOfSafeAreaForView:(UIView *)bannerView NS_AVAILABLE_IOS(11_0)
{
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    NSArray *constraints = @[
                             [bannerView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                             [bannerView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
                             [bannerView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
                             ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - MPNativeAdDelegate

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd
{
    NSLog(@"Will present modal for native ad.");
}

- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd
{
    NSLog(@"Did dismiss modal for native ad.");
}

- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd
{
    NSLog(@"Will leave application from native ad.");
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

@end
