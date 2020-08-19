/*
* Version for iOS © 2015–2020 YANDEX
*
* You may not use this file except in compliance with the License.
* You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
*/

#import "NativeAdViewFactory.h"
#import "NativeAppInstallAdView.h"
#import "NativeContentAdView.h"
#import "NativeImageAdView.h"

@implementation NativeAdViewFactory

- (NativeContentAdView *)contentAdView
{
    NativeContentAdView *contentAdView = [[NativeContentAdView alloc] initWithFrame:CGRectZero];
    contentAdView.translatesAutoresizingMaskIntoConstraints = NO;
    return contentAdView;
}

- (NativeAppInstallAdView *)appInstallAdView
{
    NativeAppInstallAdView *appInstallAdView = [[NativeAppInstallAdView alloc] initWithFrame:CGRectZero];
    appInstallAdView.translatesAutoresizingMaskIntoConstraints = NO;
    return appInstallAdView;
}

- (NativeImageAdView *)imageAdView
{
    NativeImageAdView *imageAdView = [[NativeImageAdView alloc] initWithFrame:CGRectZero];
    imageAdView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageAdView;
}

@end
