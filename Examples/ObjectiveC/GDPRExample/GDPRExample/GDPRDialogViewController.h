/*
 * Version for iOS © 2015–2018 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <UIKit/UIKit.h>

@protocol GDPRDialogDelegate;

@interface GDPRDialogViewController : UIViewController

@property (nonatomic, weak) id<GDPRDialogDelegate> delegate;

- (instancetype)initWithDelegate:(id<GDPRDialogDelegate>)delegate;

@end

@protocol GDPRDialogDelegate <NSObject>

- (void)dialogDidDismiss:(GDPRDialogViewController *)dialog;

@end