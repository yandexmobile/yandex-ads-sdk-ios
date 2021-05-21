/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <MoPubSDK/MoPub.h>
#import "ViewController.h"

// Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com.
static NSString *const kMoPubBlockID = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

@interface ViewController () <MPInterstitialAdControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *loadButton;
@property (nonatomic, strong) MPInterstitialAdController *interstitial;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeMoPub];
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:kMoPubBlockID];
    self.interstitial.delegate = self;
}

- (IBAction)loadAd:(UIButton *)sender
{
    [self.interstitial loadAd];
}

- (IBAction)showAd:(UIButton *)sender
{
    [self.interstitial showFromViewController:self];
}

- (void)initializeMoPub
{
    MPMoPubConfiguration *configuration =
        [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:kMoPubBlockID];
    __typeof(self) __weak weakSelf = self;
    [[MoPub sharedInstance] initializeSdkWithConfiguration:configuration completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.loadButton.userInteractionEnabled = YES;
        });
    }];
}

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"Interstitial did load ad");
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error
{
    NSLog(@"Interstitial did fail to load ad with error: %@", error);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"Interstitial will appear");
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial;
{
    NSLog(@"Interstitial did appear");
}

- (void)interstitialWillDismiss:(MPInterstitialAdController *)interstitial
{
    NSLog(@"Interstitial will dismiss");
}

- (void)interstitialDidDismiss:(MPInterstitialAdController *)interstitial
{
    NSLog(@"Interstitial did dismiss");
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial
{
    NSLog(@"Interstitial did receive tap event");
}

- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData *)impressionData
{
    NSLog(@"Interstitial did track impression");
}

@end
