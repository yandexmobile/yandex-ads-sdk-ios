/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <UIKit/UIKit.h>
#import <YandexMobileAds/YandexMobileNativeAds.h>

/**
 * Sample rating view which implements YMARating protocol and can be used as ratingView for app install ad.
 */

@interface StarRatingView : UIView <YMARating>

@property (nonatomic, strong) IBInspectable UIImage *starImage;

- (instancetype)initWithFrame:(CGRect)frame starImage:(UIImage *)starImage;

@end
