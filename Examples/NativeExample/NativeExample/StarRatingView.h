/*
 *  StarRatingView.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <UIKit/UIKit.h>
#import <YandexMobileAds/YandexMobileNativeAds.h>

/**
 * Sample rating view which implements YMARating protocol and can be used as ratingView for app install ad.
 */
@interface StarRatingView : UIView <YMARating>

- (instancetype)initWithFrame:(CGRect)frame starImage:(UIImage *)starImage;

@end
