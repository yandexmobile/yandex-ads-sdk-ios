/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "ViewController.h"
#import "NativeBannerTableViewCell.h"
#import <YandexMobileAds/YandexMobileNativeAds.h>

static NSInteger const kAdStride = 10;
static CGFloat const kNativeBannerInsets = 20.f;
static NSString *const kContentCellIdentifier = @"ContentCellIdentifier";
static NSString *const kNativeBannerCellIdentifier = @"NativeBannerCellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, YMANativeAdLoaderDelegate, YMANativeAdDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YMANativeAdLoader *adLoader;
@property (nonatomic, strong) NSMutableArray *ads;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.ads = [NSMutableArray array];

    // Replace demo R-M-DEMO-native-c with actual Block ID.
    // Please, note, that configured image sizes don't affect demo ads.
    // Following demo Block IDs may be used for testing:
    // R-M-DEMO-native-video
    // R-M-DEMO-native-c
    // R-M-DEMO-native-i

    YMANativeAdLoaderConfiguration *configuration =
        [[YMANativeAdLoaderConfiguration alloc] initWithBlockID:@"R-M-DEMO-native-c"
                                                     imageSizes:@[ kYMANativeImageSizeLarge ]
                                        loadImagesAutomatically:NO];
    self.adLoader = [[YMANativeAdLoader alloc] initWithConfiguration:configuration];
    self.adLoader.delegate = self;

    [self.tableView registerClass:[NativeBannerTableViewCell class] forCellReuseIdentifier:kNativeBannerCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kContentCellIdentifier];
}

- (IBAction)loadAd:(id)sender
{
    [self.adLoader loadAdWithRequest:nil];
}

#pragma mark - YMANativeAdLoaderDelegate

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didLoadAd:(id<YMANativeAd>)ad
{
    ad.delegate = self;
    [self.ads addObject:ad];
    NSInteger adIndex = (self.ads.count - 1) * kAdStride;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < kAdStride; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:adIndex + i inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didFailLoadingWithError:(NSError *)error
{
    NSLog(@"Native ad loading error: %@", error);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % kAdStride == 0) {
        id<YMANativeAd> ad = self.ads[indexPath.row / kAdStride];
        CGFloat nativeContentHeight =
            [YMANativeBannerView heightWithAd:ad
                                        width:CGRectGetWidth(tableView.frame) - kNativeBannerInsets
                                   appearance:nil];
        return nativeContentHeight + kNativeBannerInsets;
    }
    return 45.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ads.count * kAdStride;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row % kAdStride == 0) {
        id<YMANativeAd> ad = self.ads[indexPath.row / kAdStride];
        NativeBannerTableViewCell *adCell =
            [tableView dequeueReusableCellWithIdentifier:kNativeBannerCellIdentifier forIndexPath:indexPath];
        adCell.ad = ad;
        [ad loadImages];
        return adCell;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kContentCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Content";
    }

    return cell;
}

#pragma  mark - YMANativeAdDelegate

// Uncomment to open web links in in-app browser

//- (UIViewController *)viewControllerForPresentingModalView
//{
//    return self;
//}

- (void)nativeAdWillLeaveApplication:(id<YMANativeAd>)ad
{
    NSLog(@"Will leave application");
}

- (void)nativeAd:(id<YMANativeAd>)ad willPresentScreen:(UIViewController *)viewController
{
    NSLog(@"Will present screen");
}

- (void)nativeAd:(id<YMANativeAd>)ad didDismissScreen:(UIViewController *)viewController
{
    NSLog(@"Did dismiss screen");
}

@end
