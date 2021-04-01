/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <mopub-ios-sdk/MoPub.h>
#import "ViewController.h"

// Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com
static NSString *const kMoPubBlockID = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

@interface ViewController () <MPRewardedAdsDelegate>

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
    [MPRewardedAds setDelegate:self forAdUnitId:kMoPubBlockID];
    [MPRewardedAds loadRewardedAdWithAdUnitID:kMoPubBlockID withMediationSettings:nil];
}

- (IBAction)presentAd
{
    MPReward *reward = [MPRewardedAds selectedRewardForAdUnitID:kMoPubBlockID];
    [MPRewardedAds presentRewardedAdForAdUnitID:kMoPubBlockID fromViewController:self withReward:reward];
}

#pragma mark - MPRewardedAdsDelegate

- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward
{
    NSString *message = [NSString stringWithFormat:@"Rewarded ad did reward: %@ %@", reward.amount, reward.currencyType];
    NSLog(@"%@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reward"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID
{
    NSLog(@"Rewarded ad loaded");
}

- (void)rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error
{
    NSLog(@"Loading failed. Error: %@", error);
}

@end
