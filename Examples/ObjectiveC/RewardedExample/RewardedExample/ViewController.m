/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileAds.h>
#import "ViewController.h"

@interface ViewController () <YMARewardedAdDelegate>

@property (nonatomic, strong) YMARewardedAd *rewardedAd;

@end


@implementation ViewController

- (IBAction)loadAd
{
    // Replace demo R-M-DEMO-rewarded-client-side-rtb with actual Block ID
    self.rewardedAd = [[YMARewardedAd alloc] initWithBlockID:@"R-M-DEMO-rewarded-client-side-rtb"];
    self.rewardedAd.delegate = self;
    [self.rewardedAd load];
}

- (IBAction)presentAd
{
    [self.rewardedAd presentFromViewController:self];
}

#pragma mark - YMARewardedAdDelegate

- (void)rewardedAd:(YMARewardedAd *)rewardedAd didReward:(id<YMAReward>)reward
{
    NSString *message = [NSString stringWithFormat:@"Rewarded ad did reward: %zd %@", reward.amount, reward.type];
    NSLog(@"%@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reward"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)rewardedAdDidLoad:(YMARewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad loaded");
}

- (void)rewardedAdDidFailToLoad:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    NSLog(@"Loading failed. Error: %@", error);
}

- (void)rewardedAdWillLeaveApplication:(YMARewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad will leave application");
}

- (void)rewardedAdDidFailToPresentAd:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    NSLog(@"Failed to present rewarded ad. Error: %@", error);
}

- (void)rewardedAdWillAppear:(YMARewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad will appear");
}

- (void)rewardedAdDidAppear:(YMARewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad did appear");
}

- (void)rewardedAdWillDisappear:(YMARewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad will disappear");
}

- (void)rewardedAdDidDisappear:(YMARewardedAd *)rewardedAd
{
    NSLog(@"Rewarded ad did disappear");
}

- (void)rewardedAd:(YMARewardedAd *)rewardedAd willPresentScreen:(UIViewController *)viewController
{
    NSLog(@"Rewarded ad will present screen");
}

@end
