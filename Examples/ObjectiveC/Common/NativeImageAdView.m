/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "NativeImageAdView.h"
#import "StarRatingView.h"
#import "NativeAssetsComposer.h"

@interface NativeImageAdView ()

@property (nonatomic, strong, readonly) NativeAssetsComposer *assetsComposer;

@end

@implementation NativeImageAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _assetsComposer = [[NativeAssetsComposer alloc] initWithView:self];
    }
    return self;
}

- (YMANativeMediaView *)mediaView
{
    return self.assetsComposer.media;
}

- (void)prepareForDisplay
{
    self.assetsComposer.ad = self.ad;
    [self.assetsComposer layoutAssets];
}

@end
