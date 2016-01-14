/*
 *  BlocksTableViewController.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "BlocksTableViewController.h"
#import "BlockViewController.h"
#import <YandexMobileAds/YandexMobileVASTAds.h>

static NSString *kBlockCellIdentifier = @"BlockCell";

@interface BlocksTableViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation BlocksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBlockCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.blocksInfo.blocks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlockCellIdentifier forIndexPath:indexPath];
    YMABlock *block = self.blocksInfo.blocks[indexPath.row];
    cell.textLabel.text = block.ID;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"ShowBlock" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = self.selectedIndexPath;
    YMABlock *block = self.blocksInfo.blocks[indexPath.row];
    BlockViewController *viewController = segue.destinationViewController;
    viewController.blocksInfo = self.blocksInfo;
    viewController.block = block;
}

@end
