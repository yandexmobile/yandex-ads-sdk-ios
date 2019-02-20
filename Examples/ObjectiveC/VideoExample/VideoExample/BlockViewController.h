/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <UIKit/UIKit.h>

@class YMABlock;
@class YMABlocksInfo;

@interface BlockViewController : UIViewController

@property (nonatomic, strong) YMABlocksInfo *blocksInfo;
@property (nonatomic, strong) YMABlock *block;

@end
