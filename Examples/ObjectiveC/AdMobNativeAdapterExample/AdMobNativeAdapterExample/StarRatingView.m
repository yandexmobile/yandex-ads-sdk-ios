/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "StarRatingView.h"

@interface StarRatingView ()

@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, copy) NSArray *starViews;

@end

@implementation StarRatingView

- (void)setRating:(NSNumber *)rating
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

    if (self.rating == 0) {
        return;
    }

    NSUInteger numberOfViews = [self numberOfStars];
    for (int i = 0; i < numberOfViews; ++i) {
        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
        if (i == 0) {
            [self showStarImageView:starImageView atLeftView:self attribute:NSLayoutAttributeLeading];
        }
        else {
            [self showStarImageView:starImageView atLeftView:[starViews lastObject] attribute:NSLayoutAttributeTrailing];
        }
        [starViews addObject:starImageView];
    }
    self.starViews = [starViews copy];
}

- (void)showStarImageView:(UIImageView *)starImageView atLeftView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
    [starImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:starImageView];
    NSArray *constraints = @[
                             [NSLayoutConstraint constraintWithItem:starImageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:starImageView.frame.size.height],
                             [NSLayoutConstraint constraintWithItem:starImageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:starImageView.frame.size.width],
                             [NSLayoutConstraint constraintWithItem:starImageView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:attribute
                                                         multiplier:1
                                                           constant:0],
                             [NSLayoutConstraint constraintWithItem:starImageView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]
                             ];
    [self addConstraints:constraints];
}

@end
