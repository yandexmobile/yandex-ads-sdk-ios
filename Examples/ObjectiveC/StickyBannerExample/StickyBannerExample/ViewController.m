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

- (void)viewDidLoad
{
    [super viewDidLoad];

    YMAAdSize *adSize = [YMAAdSize stickySizeWithContainerWidth:[self containerWidth]];
    // Replace demo R-M-DEMO-adaptive-sticky with actual Block ID
    self.adView = [[YMAAdView alloc] initWithBlockID:@"R-M-DEMO-adaptive-sticky"
                                              adSize:adSize
                                            delegate:self];
    [self addAdView];
}

- (IBAction)loadAd:(UIButton *)sender
{
    self.adView.hidden = YES;
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
    self.adView.hidden = YES;
    self.adView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.adView];
    UIView *adView = self.adView;
    NSDictionary<NSString *, UIView *> *views = NSDictionaryOfVariableBindings(adView);
    NSArray<NSLayoutConstraint *> *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[adView]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views];
    NSArray<NSLayoutConstraint *> *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[adView]-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:views];
    [self.view addConstraints:horizontal];
    [self.view addConstraints:vertical];
}

#pragma mark - YMAAdViewDelegate

- (void)adViewDidLoad:(YMAAdView *)adView
{
    NSLog(@"Ad loaded");
    adView.hidden = NO;
}   

- (void)adViewDidFailLoading:(YMAAdView *)adView error:(NSError *)error
{
    NSLog(@"Ad failed loading. Error: %@", error);
}

@end
