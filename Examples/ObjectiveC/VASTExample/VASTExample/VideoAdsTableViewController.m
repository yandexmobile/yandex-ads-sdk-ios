/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileVASTAds.h>
#import "VideoAdsTableViewController.h"
#import "VideoAdDescriptionViewController.h"

static NSString *kYMAVideoAdCellIdentifier = @"AdCell";

@interface VideoAdsTableViewController ()

@property (nonatomic, copy, readonly) NSArray<YMAVASTAd *> *ads;

@end

@implementation VideoAdsTableViewController

- (instancetype)initWithAds:(NSArray<YMAVASTAd *> *)ads
{
    self = [super init];
    if (self != nil) {
        _ads = [ads copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYMAVideoAdCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYMAVideoAdCellIdentifier];
    cell.textLabel.text = self.ads[indexPath.row].adTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoAdDescriptionViewController *descriptionViewController =
        [[VideoAdDescriptionViewController alloc] initWithAd:self.ads[indexPath.row]];
    [self.navigationController pushViewController:descriptionViewController animated:YES];
}

@end
