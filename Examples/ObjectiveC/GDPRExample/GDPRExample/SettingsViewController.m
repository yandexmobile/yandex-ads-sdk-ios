/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YMAMobileAds.h>
#import "SettingsViewController.h"
#import "UserDefaultsKeys.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *userConsentSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userConsentSwitch.on = [[self userDefaults] boolForKey:kGDPRUserConsentKey];
}

- (IBAction)userConsentDidChange:(UISwitch *)sender
{
    [self setUserConsent:sender.isOn];
}

- (IBAction)resetUserConsent:(UIButton *)sender
{
    [self setUserConsent:NO];
    [self.userConsentSwitch setOn:NO];
    [[self userDefaults] setBool:YES forKey:kGDPRShouldShowDialogKey];
}

- (void)setUserConsent:(BOOL)userConsent
{
    [[self userDefaults] setBool:userConsent forKey:kGDPRUserConsentKey];
    [YMAMobileAds setUserConsent:userConsent];
}

- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
