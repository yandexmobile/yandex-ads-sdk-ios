/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "TrackingTableViewController.h"
#import <YandexMobileAds/YandexMobileVASTAds.h>

static NSString *kTrackingCellIdentifier = @"TrackCell";

@implementation TrackingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTrackingCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.ad.creatives.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *trackingEvents = section == 0 ? [self trackingEvents][@"ad"] : [self trackingEvents][@"creative"];
    return [trackingEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackingCellIdentifier forIndexPath:indexPath];
    NSArray *trackingEvents = indexPath.section == 0 ? [self trackingEvents][@"ad"] : [self trackingEvents][@"creative"];

    NSString *action = trackingEvents[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"track: %@", action];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"Ad" : @"Creative";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *action = [self trackingEvents][@"ad"][indexPath.row];
        [YMAVASTTracker trackAdEvent:self.ad eventName:action];
    }
    else {
        YMACreative *creative = self.ad.creatives[indexPath.section - 1];
        NSString *action = [self trackingEvents][@"creative"][indexPath.row];
        [YMAVASTTracker trackCreativeEvent:creative eventName:action];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSDictionary *)trackingEvents
{
    static NSArray *adEvents = nil;
    static NSArray *creativeEvents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adEvents = @[kYMAVASTAdImpression];
        creativeEvents = @[ kYMACreativeStart, kYMACreativeFirstQuartile, kYMACreativeMidpoint,
                            kYMACreativeThirdQuartile, kYMACreativeComplete, kYMACreativeMute,
                            kYMACreativeUnmute, kYMACreativeFullscreen, kYMACreativeExpand,
                            kYMACreativeCollapse, kYMACreativeClose, kYMACreativeClickTracking];
    });
    return @{ @"ad" : adEvents, @"creative" : creativeEvents  };
}

@end
