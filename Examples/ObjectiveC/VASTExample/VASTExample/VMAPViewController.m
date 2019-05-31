/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileVASTAds.h>
#import "VMAPViewController.h"
#import "VideoAdsDescriptionViewController.h"

static NSString *const kPageID = @"349941";
static NSString *const kCategoryID = @"0";

@interface VMAPViewController () <YMAVMAPLoaderDelegate, YMAVideoAdLoaderDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YMAVMAPLoader *VMAPLoader;
@property (nonatomic, strong) YMAVideoAdLoader *videoAdLoader;

@property (nonatomic, strong) YMAVMAP *VMAP;

@property (nonatomic, weak) IBOutlet UITableView *adBreaksTableView;

@end

@implementation VMAPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.VMAPLoader = [[YMAVMAPLoader alloc] init];
    self.VMAPLoader.delegate = self;
    
    self.videoAdLoader = [[YMAVideoAdLoader alloc] init];
    self.videoAdLoader.delegate = self;
    
    // Replace default values with actual Partner ID and category ID
    YMAMutableVMAPRequestConfiguration *requestConfiguration =
        [[YMAMutableVMAPRequestConfiguration alloc] initWithPageID:kPageID];
    requestConfiguration.categoryID = kCategoryID;
    [self.VMAPLoader loadVMAPWithRequestConfiguration:requestConfiguration];
}

- (void)requestVASTForAdBreakAtIndex:(NSUInteger)index
{
    YMAVMAPAdBreak *adBreak = self.VMAP.adBreaks[index];
    YMAVASTRequestConfiguration *VASTRequestConfiguration =
        [[YMAVASTRequestConfiguration alloc] initWithAdBreak:adBreak];
    [self.videoAdLoader loadVASTWithRequestConfiguration:VASTRequestConfiguration];
}

- (void)showError:(NSError *)error
{
    NSString *message = error.localizedDescription;
    
    UIAlertController *alert = [self alertControllerWithTitle:@"Error" message:message];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - YMAVMAPLoaderDelegate

- (void)loader:(YMAVMAPLoader *)loader didLoadVMAP:(YMAVMAP *)VMAP
{
    self.VMAP = VMAP;
    [self.adBreaksTableView reloadData];
}

- (void)loader:(YMAVMAPLoader *)loader didFailLoadingVMAPWithError:(NSError *)error
{
    [self showError:error];
}

#pragma mark - YMAVideoAdLoaderDelegate

- (void)loaderDidLoadVideoAds:(NSArray *)ads
{
    VideoAdsDescriptionViewController *descriptionViewController =
        [[VideoAdsDescriptionViewController alloc] initWithAds:ads];
    [self.navigationController pushViewController:descriptionViewController animated:YES];
}

- (void)loaderDidFailLoadingVideoAdsWithError:(NSError *)error
{
    [self showError:error];
}

- (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert =  [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    return alert;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Ad breaks";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.VMAP.adBreaks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"blockCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *text = [NSString stringWithFormat:@"AdBreak: %ld \n", indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self requestVASTForAdBreakAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
