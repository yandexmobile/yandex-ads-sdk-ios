/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YMAMobileAds.h>
#import "GDPRDialogViewController.h"
#import "UserDefaultsKeys.h"

@implementation GDPRDialogViewController

- (instancetype)initWithDelegate:(id<GDPRDialogDelegate>)delegate
{
    self = [super init];
    if (self != nil) {
        _delegate = delegate;
    }
    return self;
}

- (IBAction)about:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://yandex.com/legal/confidential/"]];
}

- (IBAction)decline:(UIButton *)sender
{
    [self setUserConsent:NO];
    [self dismiss];
}

- (IBAction)accept:(UIButton *)sender
{
    [self setUserConsent:YES];
    [self dismiss];
}

- (void)setUserConsent:(BOOL)userConsent
{
    //Make sure you store user consent value
    [[NSUserDefaults standardUserDefaults] setBool:userConsent forKey:kGDPRUserConsentKey];
    [YMAMobileAds setUserConsent:userConsent];
}

- (void)dismiss
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kGDPRShouldShowDialogKey];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate dialogDidDismiss:self];
}

@end
