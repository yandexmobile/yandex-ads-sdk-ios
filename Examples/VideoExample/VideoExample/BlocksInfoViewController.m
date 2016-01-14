/*
 *  BlocksInfoViewController.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "BlocksInfoViewController.h"
#import "BlocksTableViewController.h"
#import <YandexMobileAds/YandexMobileVASTAds.h>

@interface BlocksInfoViewController () <YMABlocksInfoLoaderDelegate>

@property (nonatomic, weak) IBOutlet UITextView *blockInfoDescription;
@property (nonatomic, strong) YMABlocksInfo *blocksInfo;

@end

@implementation BlocksInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace 111111 and 0 with actual Partner ID and category ID
    [YMAYandexVASTAds loadBlocksInfoForPartnerID:@"111111" categoryID:@"0" delegate:self];
}

- (void)loaderDidLoadBlocksInfo:(YMABlocksInfo *)blocksInfo
{
    self.blocksInfo = blocksInfo;
    self.blockInfoDescription.text = self.blocksInfo.description;
}

- (void)loaderDidFailLoadingBlocksInfoWithError:(NSError *)error
{
    NSLog(@"Failed loading. Error: %@", error);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BlocksTableViewController *viewController = segue.destinationViewController;
    viewController.blocksInfo = self.blocksInfo;
}

@end
