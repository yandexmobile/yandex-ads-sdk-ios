/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ViewController.h"

@interface ViewController () <GADFullScreenContentDelegate>

@property (nonatomic, weak) IBOutlet UIButton *presentButton;
@property (nonatomic, strong) GADRewardedAd *rewardedAd;

@end

@implementation ViewController

- (IBAction)loadAd
{
    self.presentButton.enabled = NO;

    // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com.
    [GADRewardedAd loadWithAdUnitID:@"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"
                            request:[GADRequest request]
                  completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error != nil) {
            NSLog(@"Rewarded did fail to receive ad with error: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"Rewarded did receive ad");
            self.rewardedAd = ad;
            self.rewardedAd.fullScreenContentDelegate = self;
            self.presentButton.enabled = YES;
        }
    }];
}

- (IBAction)presentAd
{
    [self.rewardedAd presentFromRootViewController:self userDidEarnRewardHandler:^{
        [self showReward];
    }];
}

- (void)showReward
{
    GADAdReward *reward = self.rewardedAd.adReward;
    NSString *message = [NSString stringWithFormat:@"Rewarded ad did reward: %@ %@", reward.amount, reward.type];
    NSLog(@"%@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reward"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - GADFullScreenContentDelegate

- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error
{
    NSLog(@"Presenting failed. Error: %@", error);
}

@end
