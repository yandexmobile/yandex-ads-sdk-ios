/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ViewController.h"
#import "NativeAdView.h"

@interface ViewController () <GADNativeAdLoaderDelegate>

@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, weak) NativeAdView *adView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureAdLoader];
}

- (IBAction)loadAd:(UIButton *)sender
{
    [self configureAdView];
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void)configureAdView
{
    NativeAdView *adView =
        [[[NSBundle mainBundle] loadNibNamed:@"NativeAdView" owner:nil options:nil] firstObject];
    adView.hidden = YES;
    [self addView:adView];
    [self.adView removeFromSuperview];
    self.adView = adView;
}

- (void)addView:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO; 
    [self.view addSubview:view];
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

- (void)configureAdLoader
{
    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"
                                       rootViewController:self
                                                  adTypes:@[ kGADAdLoaderAdTypeNative ]
                                                  options:nil];
    self.adLoader.delegate = self;
}

#pragma mark - GADNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Ad loader did fail to receive ad with error: %@", error);
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd
{
    NSLog(@"Ad loader did receive native ad");
    self.adView.nativeAd = nativeAd;
    [self.adView configureAssetViews];
    self.adView.hidden = NO;
}

@end
