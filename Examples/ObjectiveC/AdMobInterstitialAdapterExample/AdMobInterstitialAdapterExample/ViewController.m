/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "ViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <GADFullScreenContentDelegate>

@property (nonatomic, strong) GADInterstitialAd *interstitial;

@end

@implementation ViewController

- (IBAction)loadAd:(id)sender
{
    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"
                                request:[GADRequest request]
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error != nil) {
            NSLog(@"Interstitial did fail to receive ad with error: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"Interstitial did receive ad");
            self.interstitial = ad;
            self.interstitial.fullScreenContentDelegate = self;
        }
    }];
}

- (IBAction)showAd:(id)sender
{
    [self.interstitial presentFromRootViewController:self];
}

#pragma mark OGADFullScreenContentDelegate

- (void)ad:(id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(NSError *)error
{
    NSLog(@"Interstitial did fail to present ad with error: %@", [error localizedDescription]);
}

@end
