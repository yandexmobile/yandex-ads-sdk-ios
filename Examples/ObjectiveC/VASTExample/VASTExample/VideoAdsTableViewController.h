/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <UIKit/UIKit.h>
#import <YandexMobileAds/YandexMobileAds.h>

@interface VideoAdsTableViewController : UITableViewController

- (instancetype)initWithAds:(NSArray<YMAVASTAd *> *)ads;

@end
