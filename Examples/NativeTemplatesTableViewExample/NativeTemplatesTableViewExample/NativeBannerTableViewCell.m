/*
 *  NativeBannerTableViewCell.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "NativeBannerTableViewCell.h"
#import <YandexMobileAds/YandexMobileNativeAds.h>

@interface NativeBannerTableViewCell ()

@property (nonatomic, weak) YMANativeBannerView *adView;

@end

@implementation NativeBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        YMANativeBannerView *adView = [[YMANativeBannerView alloc] init];
        adView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:adView];
        NSDictionary *views = NSDictionaryOfVariableBindings(adView);
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[adView]-(10)-|" options:0 metrics:nil views:views];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[adView]-(10)-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:h];
        [self.contentView addConstraints:v];
        self.adView = adView;
    }
    return self;
}

- (void)setAd:(id<YMANativeGenericAd>)ad
{
    self.adView.ad = ad;
}

- (id<YMANativeGenericAd>)ad
{
    return self.adView.ad;
}

@end
