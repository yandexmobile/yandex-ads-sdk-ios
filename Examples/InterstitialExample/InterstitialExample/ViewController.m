/*
 *  ViewController.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "ViewController.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface ViewController () <YMAInterstitialDelegate>

@property (nonatomic, strong) YMAInterstitialController *interstitialController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Replace R-M-XXXXXX-Y with actual Block ID
    self.interstitialController = [[YMAInterstitialController alloc] initWithBlockID:@"R-M-XXXXXX-Y"];
    self.interstitialController.delegate = self;
}

- (IBAction)loadInterstitial
{
    [self.interstitialController load];
}

- (IBAction)presentInterstitial
{
    [self.interstitialController presentInterstitialFromViewController:self];
}

#pragma mark - YMAInterstitialDelegate

- (void)interstitialDidLoadAd:(YMAInterstitialController *)interstitial
{
    NSLog(@"Loaded");
}

- (void)interstitialDidFailToLoadAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSLog(@"Loading failed. Error: %@", error);
}

- (void)interstitialWillLeaveApplication:(YMAInterstitialController *)interstitial
{
    NSLog(@"Will leave application");
}

- (void)interstitialDidFailToPresentAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSLog(@"Failed to present interstitial. Error: %@", error);
}

- (void)interstitialWillAppear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial will appear");
}

- (void)interstitialDidAppear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial did appear");
}

- (void)interstitialWillDisappear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial will disappear");
}

- (void)interstitialDidDisappear:(YMAInterstitialController *)interstitial
{
    NSLog(@"Interstitial did disappear");
}

- (void)interstitialWillPresentScreen:(UIViewController *)webBrowser
{
    NSLog(@"Interstitial will present screen");
}

@end
