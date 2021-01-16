/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileNativeAds.h>
#import "ViewController.h"
#import "UserDefaultsKeys.h"
#import "GDPRDialogViewController.h"

@interface ViewController () <YMANativeAdLoaderDelegate, GDPRDialogDelegate>

@property (nonatomic, strong) YMANativeAdLoader *adLoader;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    YMANativeAdLoaderConfiguration *configuration =
        [[YMANativeAdLoaderConfiguration alloc] initWithBlockID:@"R-M-DEMO-native-c"
                                                     imageSizes:@[ kYMANativeImageSizeMedium ]
                                        loadImagesAutomatically:YES];
    self.adLoader = [[YMANativeAdLoader alloc] initWithConfiguration:configuration];
    self.adLoader.delegate = self;
}

- (IBAction)loadAd:(UIButton *)sender
{
    BOOL shouldShowDialog = [[NSUserDefaults standardUserDefaults] boolForKey:kGDPRShouldShowDialogKey];
    if (shouldShowDialog) {
        [self showGDPRDialog];
    }
    else {
        [self.adLoader loadAdWithRequest:nil];
    }
}

- (void)showGDPRDialog
{
    // This is sample GDPR dialog which is used to demonstrate the GDPR user consent retrieval logic.
    // Please, do not use this dialog in production app.
    // Replace it with one which is suitable for the app.
    GDPRDialogViewController *dialog = [[GDPRDialogViewController alloc] initWithDelegate:self];
    dialog.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:dialog animated:YES completion:nil];
}

- (void)configureLayoutAtBottomForView:(UIView *)bannerView
{
    UILayoutGuide *guide = self.view.layoutMarginsGuide;
    if (@available(iOS 11.0, *)) {
        guide = self.view.safeAreaLayoutGuide;
    }
    NSArray *constraints = @[
        [bannerView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:10.f],
        [bannerView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-10.f],
        [bannerView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor constant:-10.f]
    ];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - GDPRDialogDelegate

- (void)dialogDidDismiss:(GDPRDialogViewController *)dialog
{
    [self.adLoader loadAdWithRequest:nil];
}

#pragma mark - YMANativeAdLoaderDelegate

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didLoadAd:(id<YMANativeAd>)ad
{
    YMANativeBannerView *bannerView = [[YMANativeBannerView alloc] init];
    bannerView.ad = ad;
    [self.view addSubview:bannerView];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureLayoutAtBottomForView:bannerView];
}

- (void)nativeAdLoader:(YMANativeAdLoader *)loader didFailLoadingWithError:(NSError *)error
{
    NSLog(@"Native ad loading error: %@", error);
}

@end
