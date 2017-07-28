/*
 *  NativeContentAdView.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <YandexMobileAds/YandexMobileNativeAds.h>
#import "NativeContentAdView.h"
#import "NativeAssetsComposer.h"

@interface NativeContentAdView ()

@property (nonatomic, strong) NativeAssetsComposer *assetsComposer;

@end

@implementation NativeContentAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _assetsComposer = [[NativeAssetsComposer alloc] initWithView:self];
    }
    return self;
}

- (UILabel *)ageLabel
{
    return self.assetsComposer.age;
}

- (UILabel *)bodyLabel
{
    return self.assetsComposer.body;
}

- (UIButton *)callToActionButton
{
    return self.assetsComposer.callToAction;
}

- (UILabel *)domainLabel
{
    return self.assetsComposer.domain;
}

- (UIImageView *)iconImageView
{
    return self.assetsComposer.favicon;
}

- (UIImageView *)imageView
{
    return self.assetsComposer.image;
}

- (UILabel *)sponsoredLabel
{
    return self.assetsComposer.sponsored;
}

- (UILabel *)titleLabel
{
    return self.assetsComposer.title;
}

- (UILabel *)warningLabel
{
    return self.assetsComposer.warning;
}

#pragma mark - Layout

- (void)prepareForDisplay
{
    self.assetsComposer.ad = self.ad;
    [self.assetsComposer layoutAssets];
}

@end
