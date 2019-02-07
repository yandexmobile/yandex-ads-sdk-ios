/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <mopub-ios-sdk/MoPub.h>
#import "ViewController.h"

// Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com
static NSString *const kMoPubBlockID = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

@interface ViewController () <MPRewardedVideoDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loadButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MPMoPubConfiguration *configuration =
        [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:kMoPubBlockID];
    __typeof(self) __weak weakSelf = self;
    [[MoPub sharedInstance] initializeSdkWithConfiguration:configuration completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.loadButton.userInteractionEnabled = YES;
        });
    }];
}

- (IBAction)loadAd
{
    [MPRewardedVideo setDelegate:self forAdUnitId:kMoPubBlockID];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:kMoPubBlockID withMediationSettings:nil];
}

- (IBAction)presentAd
{
    MPRewardedVideoReward *reward = [MPRewardedVideo selectedRewardForAdUnitID:kMoPubBlockID];
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:kMoPubBlockID
                                    fromViewController:self
                                            withReward:reward];
}

#pragma mark - YMARewardedAdDelegate

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward
{
    NSString *message = [NSString stringWithFormat:@"Rewarded ad did reward: %@ %@", reward.amount, reward.currencyType];
    NSLog(@"%@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reward"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad loaded");
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error
{
    NSLog(@"Loading failed. Error: %@", error);
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad will appear");
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad did appear");
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad will disappear");
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad did disappear");
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad did expire");
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad tapped");
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad will leave application");
}

@end
