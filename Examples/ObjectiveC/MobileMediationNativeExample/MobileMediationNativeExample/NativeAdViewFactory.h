/*
* Version for iOS © 2015–2020 YANDEX
*
* You may not use this file except in compliance with the License.
* You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
*/

#import <Foundation/Foundation.h>

@class NativeContentAdView;
@class NativeAppInstallAdView;
@class NativeImageAdView;

NS_ASSUME_NONNULL_BEGIN

@interface NativeAdViewFactory : NSObject

- (NativeContentAdView *)contentAdView;

- (NativeAppInstallAdView *)appInstallAdView;

- (NativeImageAdView *)imageAdView;

@end

NS_ASSUME_NONNULL_END
