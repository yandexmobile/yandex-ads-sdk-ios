/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ViewController.h"

@interface ViewController () <GADRewardedAdDelegate>

@property (nonatomic, weak, readonly) IBOutlet UIButton *presentButton;
@property (nonatomic, strong) GADRewardedAd *rewardedAd;

@end

@implementation ViewController

- (IBAction)loadAd
{
    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com.
    self.rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:@"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"];
    GADRequest *request = [GADRequest request];

    [self.rewardedAd loadRequest:request completionHandler:^(GADRequestError *error) {
        if (error) {
            NSLog(@"Loading failed. Error: %@", error);
        } else {
            self.presentButton.enabled = YES;
        }
    }];
}

- (IBAction)presentAd
{
    if (self.rewardedAd.isReady) {
        [self.rewardedAd presentFromRootViewController:self delegate:self];
    }
    else {
        NSLog(@"Rewarded ad wasn't ready");
    }
}

#pragma mark - YMARewardedAdDelegate

- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward
{
    NSString *message = [NSString stringWithFormat:@"Rewarded ad did reward: %@ %@", reward.amount, reward.type];
    NSLog(@"%@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reward"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error
{
    NSLog(@"Presenting failed. Error: %@", error);
}

- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad presented");
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad dismissed");
}

@end
