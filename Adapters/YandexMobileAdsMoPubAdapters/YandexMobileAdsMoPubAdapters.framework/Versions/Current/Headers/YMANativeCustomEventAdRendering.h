/*
 * Version for iOS © 2015–2018 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <UIKit/UIKit.h>

@protocol YMARating;

@protocol YMANativeCustomEventAdRendering <NSObject>

@required

/**
 * Returns UILabel that is used for age restrictions.
 *
 * @return UILabel that is used for age restrictions.
 */
- (UILabel *)nativeAgeLabel;

/**
 * Returns UILabel that is used for ad network attribution text.
 *
 * @return UILabel that is used for ad network attribution text.
 */
- (UILabel *)nativeSponsoredLabel;

/**
 * Returns UILabel that is used for warning.
 *
 * @return UILabel that is used for warning.
 */
- (UILabel *)nativeWarningLabel;

@optional

/**
 * Returns UILabel that is used for advertiser's domain.
 *
 * @return UILabel that is used for advertiser's domain.
 */
- (UILabel *)nativeDomainLabel;

/**
 * Returns UIImageView that is used for website favicon.
 *
 * @return UIImageView that is used for website favicon.
 */
- (UIImageView *)nativeFaviconImageView;

/**
 * Returns UILabel that is used for price.
 *
 * @return UILabel that is used for price.
 */
- (UILabel *)nativePriceLabel;

/**
 * Returns UIView which conforms to YMARating protocol that is used for app rating.
 *
 * @return UIView which conforms to YMARating protocol that is used for app rating.
 */
- (UIView<YMARating> *)nativeRatingView;

/**
 * Returns UILabel that is used for number of reviews.
 *
 * @return UILabel that is used for number of reviews.
 */
- (UILabel *)nativeReviewCountLabel;

@end
