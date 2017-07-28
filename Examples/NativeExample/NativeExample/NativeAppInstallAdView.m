/*
 *  NativeAppInstallAdView.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2017 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "NativeAppInstallAdView.h"
#import "StarRatingView.h"
#import "NativeAssetsComposer.h"

@interface NativeAppInstallAdView ()

@property (nonatomic, strong) NativeAssetsComposer *assetsComposer;

@end

@implementation NativeAppInstallAdView

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
    return self.assetsComposer.icon;
}

- (UIImageView *)imageView
{
    return self.assetsComposer.image;
}

- (UILabel *)priceLabel
{
    return self.assetsComposer.price;
}

- (id<YMARating>)ratingView
{
    return self.assetsComposer.rating;
}

- (UILabel *)reviewCountLabel
{
    return self.assetsComposer.reviewCount;
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

- (void)prepareForDisplay
{
    self.assetsComposer.ad = self.ad;
    [self.assetsComposer layoutAssets];
}

@end
