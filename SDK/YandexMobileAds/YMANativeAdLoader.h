/*
 *  YMANativeAdLoader.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import <Foundation/Foundation.h>

@class YMAAdRequest;
@protocol YMANativeContentAd;
@protocol YMANativeAppInstallAd;
@protocol YMANativeAdLoaderDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 * YMANativeAdLoader loads native ad for specific block ID.
 */
@interface YMANativeAdLoader : NSObject

/**
 * Unique ad placement ID created at partner interface.
 * Identifies ad placement for specific application.
 * Example: R-128282-4
 */
@property (nonatomic, copy, readonly) NSString *blockID;

/**
 * Delegates of YMANativeAdLoader receive ads or errors if loading fails.
 */
@property (nonatomic, weak, nullable) id<YMANativeAdLoaderDelegate> delegate;

- (instancetype)init __attribute__((unavailable("Use designated initializer")));

/**
 * Returns native ad loader, whci can load ads for specific block ID.
 *
 * @param blockID Unique ad placement ID created at partner interface (partner.yandex.ru).
 *
 * @return Native ad loader initialized with corresponding block ID.
 */
- (instancetype)initWithBlockID:(NSString *)blockID;

/**
 * Loads ad.
 * @param request Request containing ad targeting.
 */
- (void)loadAdWithRequest:(nullable YMAAdRequest *)request;

@end

@protocol YMANativeAdLoaderDelegate <NSObject>

@optional

/**
 * Notifies delegate when content ad is loaded.
 *
 * @param loader Loader sending the message.
 * @param ad Native ad of content type, which is ready to be bound to view.
 */
- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader didLoadContentAd:(id<YMANativeContentAd>)ad;

/**
 * Notifies delegate when app install ad is loaded.
 *
 * @param loader Loader sending the message.
 */
- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader didLoadAppInstallAd:(id<YMANativeAppInstallAd>)ad;

/**
 * Notifies delegate when loader fails to load ad.
 *
 * @param loader Loader sending the message.
 * @param error Error which occured while loading ad. @see YMANativeAdErrors for error codes.
 */
- (void)nativeAdLoader:(null_unspecified YMANativeAdLoader *)loader didFailLoadingWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
