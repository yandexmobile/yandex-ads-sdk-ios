/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "ViewController.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface ViewController () <YMAAdViewDelegate>

@property (nonatomic, strong) YMAAdView *adView;

@end

@implementation ViewController

- (IBAction)loadAd:(UIButton *)sender
{
    [self.adView removeFromSuperview];
    
    YMAAdSize *adSize = [YMAAdSize stickySizeWithContainerWidth:[self containerWidth]];
    // Replace demo R-M-DEMO-adaptive-sticky with actual Block ID
    self.adView = [[YMAAdView alloc] initWithBlockID:@"R-M-DEMO-adaptive-sticky" adSize:adSize];
    self.adView.delegate = self;
    [self addAdView];
    [self.adView loadAd];
}

- (CGFloat)containerWidth
{
    CGFloat containerWidth = self.view.frame.size.width;
    if (@available(iOS 11.0, *)) {
        containerWidth = UIEdgeInsetsInsetRect(self.view.frame, self.view.safeAreaInsets).size.width;
    }
    return containerWidth;
}

- (void)addAdView
{
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adView];
    [self.adView displayAtBottomInView:self.view];
}

#pragma mark - YMAAdViewDelegate

- (void)adViewDidLoad:(YMAAdView *)adView
{
    NSLog(@"Ad loaded");
}

- (void)adViewDidFailLoading:(YMAAdView *)adView error:(NSError *)error
{
    NSLog(@"Ad failed loading. Error: %@", error);
}

@end
