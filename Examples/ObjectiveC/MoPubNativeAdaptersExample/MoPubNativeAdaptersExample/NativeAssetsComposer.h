/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <UIKit/UIKit.h>

@class StarRatingView;

@interface NativeAssetsComposer : NSObject

@property (nonatomic, strong, readonly) UILabel *age;
@property (nonatomic, strong, readonly) UILabel *body;
@property (nonatomic, strong, readonly) UILabel *callToAction;
@property (nonatomic, strong, readonly) UILabel *domain;
@property (nonatomic, strong, readonly) UIImageView *favicon;
@property (nonatomic, strong, readonly) UIImageView *icon;
@property (nonatomic, strong, readonly) UIImageView *image;
@property (nonatomic, strong, readonly) UILabel *sponsored;
@property (nonatomic, strong, readonly) UILabel *title;
@property (nonatomic, strong, readonly) UILabel *warning;
@property (nonatomic, strong, readonly) UILabel *price;
@property (nonatomic, strong, readonly) StarRatingView *rating;
@property (nonatomic, strong, readonly) UILabel *reviewCount;

- (instancetype)initWithView:(UIView *)view;

- (void)layoutAssets;

@end
