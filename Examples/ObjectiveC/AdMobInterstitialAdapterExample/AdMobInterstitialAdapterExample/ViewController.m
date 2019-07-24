/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation ViewController

- (IBAction)loadAd:(id)sender
{
    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
}

- (IBAction)showAd:(id)sender
{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
    else {
        NSLog(@"Interstitial ad wasn't ready");
    }
}

#pragma mark GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"interstitial did receive ad");
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"did fail to receive ad with error: %@", error);
}

@end
