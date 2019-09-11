/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "NativeAdView.h"
#import "NativeAssetsComposer.h"
#import "StarRatingView.h"
#import "MPNativeAdConstants.h"

@interface NativeAdView ()

@property (nonatomic, strong) NativeAssetsComposer *assetsComposer;

@end

@implementation NativeAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _assetsComposer = [[NativeAssetsComposer alloc] initWithView:self];
    }
    return self;
}

// MoPub Common assets -

#pragma mark - MoPub Common assets (MPNativeAdRendering)

- (UILabel *)nativeMainTextLabel
{
    return self.assetsComposer.body;
}

- (UILabel *)nativeTitleTextLabel
{
    return self.assetsComposer.title;
}

- (UILabel *)nativeCallToActionTextLabel
{
    return self.assetsComposer.callToAction;
}

- (UIImageView *)nativeIconImageView
{
    return self.assetsComposer.icon;
}

- (UIImageView *)nativeMainImageView
{
    return self.assetsComposer.image;
}

#pragma mark - Yandex required assets (YMANativeCustomEventAdRendering)

- (UILabel *)nativeAgeLabel
{
    return self.assetsComposer.age;
}

- (UILabel *)nativeSponsoredLabel
{
    return self.assetsComposer.sponsored;
}

- (UILabel *)nativeWarningLabel
{
    return self.assetsComposer.warning;
}

#pragma mark - Yandex optional recommended assets

- (UILabel *)nativeDomainLabel
{
    return self.assetsComposer.domain;
}

- (UIImageView *)nativeFaviconImageView
{
    return self.assetsComposer.favicon;
}

- (UILabel *)nativePriceLabel
{
    return self.assetsComposer.price;
}

- (UIView<YMARating> *)nativeRatingView
{
    return self.assetsComposer.rating;
}

- (UILabel *)nativeReviewCountLabel
{
    return self.assetsComposer.reviewCount;
}

- (void)layoutCustomAssetsWithProperties:(NSDictionary *)customProperties imageLoader:(MPNativeAdRenderingImageLoader *)imageLoader
{
    UIView *mediaView = customProperties[kAdMainMediaViewKey];
    [self.assetsComposer layoutAssetsWithMediaView:mediaView];
}

@end
