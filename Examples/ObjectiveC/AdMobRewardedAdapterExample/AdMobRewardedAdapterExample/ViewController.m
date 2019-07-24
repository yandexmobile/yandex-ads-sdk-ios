/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ViewController.h"

@interface ViewController () <GADRewardBasedVideoAdDelegate>

@end

@implementation ViewController

- (IBAction)loadAd
{
    GADRewardBasedVideoAd *ad = [GADRewardBasedVideoAd sharedInstance];
    ad.delegate = self;
    GADRequest *request = [GADRequest request];
    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com.
    [ad loadRequest:request withAdUnitID:@"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"];
}

- (IBAction)presentAd
{
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
    else {
        NSLog(@"Rewarded ad wasn't ready");
    }
}

#pragma mark - YMARewardedAdDelegate

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward
{
    NSString *message = [NSString stringWithFormat:@"Rewarded ad did reward: %@ %@", reward.amount, reward.type];
    NSLog(@"%@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reward"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded ad loaded");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error
{
    NSLog(@"Loading failed. Error: %@", error);
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded ad will leave application");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded ad is opened");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded ad started playing");
}

- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded ad complete playing");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded ad is closed");
}

@end
