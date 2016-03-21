/*
 *  StarRatingView.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "StarRatingView.h"

static CGFloat const kStarRatingMargin = 2.f;

@interface StarRatingView ()

@property (nonatomic, strong) UIImage *starImage;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, copy) NSArray *starViews;
@property (nonatomic, copy) NSArray *starConstraints;

@end

@implementation StarRatingView

- (instancetype)initWithFrame:(CGRect)frame starImage:(UIImage *)starImage
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _starImage = starImage;
    }
    return self;
}

- (void)setRating:(nullable NSNumber *)rating
{
    if ([_rating isEqualToNumber:rating] == NO) {
        _rating = rating;
        [self update];
    }
}

- (NSUInteger)numberOfStars
{
    return (NSUInteger)ceil([self.rating doubleValue]);
}

- (void)update
{
    for (UIView *starView in self.starViews) {
        [starView removeFromSuperview];
    }
    NSMutableArray *starViews = [NSMutableArray array];
    NSUInteger numberOfViews = [self numberOfStars];
    for (int i = 0; i < numberOfViews; ++i) {
        CGFloat widthPercent = 1.f;
        if (i == numberOfViews - 1) {
            widthPercent = self.rating.doubleValue - (CGFloat)i;
        }
        UIImageView *imageView = [self starImageViewWithWidthPercent:widthPercent];
        [self addSubview:imageView];
        [starViews addObject:imageView];
    }

    self.starViews = starViews;
    [self setNeedsUpdateConstraints];
}

- (UIImageView *)starImageViewWithWidthPercent:(CGFloat)percent
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self croppedStarImageForWidthPercent:percent]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeLeft;
    return imageView;
}

- (UIImage *)croppedStarImageForWidthPercent:(CGFloat)widthPercent
{
    CGFloat width = self.starImage.size.width * widthPercent * self.starImage.scale;
    CGFloat height = self.starImage.size.height * self.starImage.scale;
    CGRect cropRegion = CGRectMake(0.f, 0.f, width, height);
    CGImageRef subImage = CGImageCreateWithImageInRect(self.starImage.CGImage, cropRegion);
    UIImage *croppedImage = [UIImage imageWithCGImage:subImage
                                                scale:self.starImage.scale
                                          orientation:self.starImage.imageOrientation];
    return croppedImage;
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self removeConstraints:self.starConstraints];
    if ([self numberOfStars] != 0) {
        NSMutableArray *constraints = [NSMutableArray array];

        NSArray *boundaryViewsConstraints = [self boundaryStarViewsConstraints];
        NSArray *viewsInterConstraints = [self starViewsInterConstraints];
        [constraints addObjectsFromArray:boundaryViewsConstraints];
        [constraints addObjectsFromArray:viewsInterConstraints];
        self.starConstraints = constraints;
        [self addConstraints:constraints];
    }
}

- (NSArray *)boundaryStarViewsConstraints
{
    UIView *firstView = self.starViews.firstObject;
    UIView *lastView = self.starViews.lastObject;
    NSDictionary *views = NSDictionaryOfVariableBindings(firstView, lastView);
    NSArray *firstHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[firstView]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *lastHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
    return [firstHorizontal arrayByAddingObjectsFromArray:lastHorizontal];
}

- (NSArray *)starViewsInterConstraints
{
    NSMutableArray *constraints = [NSMutableArray array];
    UIView *previousView = nil;
    for (UIView *view in self.starViews) {
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        if (previousView != nil) {
            views = NSDictionaryOfVariableBindings(previousView, view);
            NSDictionary *metrics = @{ @"margin" : @(kStarRatingMargin) };
            NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-margin-[view]"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views];
            [constraints addObjectsFromArray:horizontal];
        }
        NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
        NSLayoutConstraint *widthToHeightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:view
                                                                                   attribute:NSLayoutAttributeHeight
                                                                                  multiplier:1.f
                                                                                    constant:0.f];
        [constraints addObjectsFromArray:vertical];
        [constraints addObject:widthToHeightConstraint];
        previousView = view;
    }
    return [constraints copy];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeZero;
    NSUInteger numberOfStars = [self numberOfStars];
    if (numberOfStars != 0) {
        CGFloat height = self.starImage.size.height;
        CGFloat width = numberOfStars * self.starImage.size.width + (numberOfStars - 1) * kStarRatingMargin;
        size = CGSizeMake(width, height);
    }
    return size;
}

@end
