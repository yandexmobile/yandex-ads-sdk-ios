/*
 * Version for iOS © 2015–2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "BlockViewController.h"
#import "TrackingTableViewController.h"
#import <YandexMobileAds/YandexMobileVASTAds.h>

@interface BlockViewController () <YMAVideoAdLoaderDelegate>

@property (nonatomic, weak) IBOutlet UITextView *blockDescription;
@property (nonatomic, copy) NSArray *ads;

@end

@implementation BlockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Pass actual pageRef and targetRef
    YMAVideoAdsRequest *request = [[YMAVideoAdsRequest alloc] initWithBlockID:self.block.ID
                                                                   blocksInfo:self.blocksInfo
                                                                      pageRef:@"https://example.com"
                                                                    targetRef:@"https://example.com"];
    [YMAYandexVASTAds loadVideoAdsWithRequest:request delegate:self];
}

- (void)loaderDidLoadVideoAds:(NSArray *)ads
{
    self.ads = ads;
    NSMutableString *description = [NSMutableString string];
    for (YMAVASTAd *ad in ads) {
        [description appendString:ad.description];
        [description appendString:@"\n"];
    }
    self.blockDescription.text = description;
}

- (void)loaderDidFailLoadingVideoAdsWithError:(NSError *)error
{
    NSLog(@"Failed loading. Error: %@", error);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TrackingTableViewController *viewController = segue.destinationViewController;
    viewController.ad = self.ads.firstObject;
}


@end
