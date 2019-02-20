/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileNativeAds.h>
#import "NativeAssetsComposer.h"
#import "StarRatingView.h"

static CGFloat const kNativeViewOffset = 8.f;

@interface NativeAssetsComposer ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) UILabel *age;
@property (nonatomic, strong) UILabel *body;
@property (nonatomic, strong) UIButton *callToAction;
@property (nonatomic, strong) UILabel *domain;
@property (nonatomic, strong) UIImageView *favicon;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) YMANativeMediaView *media;
@property (nonatomic, strong) UILabel *sponsored;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *warning;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) StarRatingView *rating;
@property (nonatomic, strong) UILabel *reviewCount;
@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) YMANativeMediaView *wideMedia;

@end

@implementation NativeAssetsComposer

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self != nil) {
        _view = view;
        _age = [self label];
        _body = [self label];
        _callToAction = [self button];
        _domain = [self label];
        _favicon = [self imageView];
        _feedback = [self feedbackButton];
        _icon = [self imageView];
        _media = [self mediaView];
        _price = [self label];
        _rating = [self starRatingView];
        _reviewCount = [self label];
        _sponsored = [self label];
        _title = [self label];
        _title.font = [UIFont systemFontOfSize:14.f];
        _warning = [self label];
    }
    return self;
}

- (UILabel *)label
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:12.f];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    return label;
}

- (UIImageView *)imageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (YMANativeMediaView *)mediaView
{
    YMANativeMediaView *mediaView = [[YMANativeMediaView alloc] initWithFrame:CGRectZero];
    mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    return mediaView;
}

- (UIButton *)button
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.f;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tintColor = [UIColor colorWithRed:108.f / 255.f green:101.f / 255.f blue:169.f / 255.f alpha:1.f];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    return button;
}

- (UIButton *)feedbackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (StarRatingView *)starRatingView
{
    UIImage *starImage = [UIImage imageNamed:@"star"];
    StarRatingView *ratingView = [[StarRatingView alloc] initWithFrame:CGRectZero starImage:starImage];
    ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    return ratingView;
}

#pragma mark - Layout

- (void)layoutAssets
{
    UILabel *title = self.title;
    UILabel *body = self.body;
    UILabel *age = self.age;
    UILabel *domain = self.domain;
    UILabel *warning = self.warning;
    UILabel *sponsored = self.sponsored;
    UIButton *callToAction = self.callToAction;
    UIImageView *icon = self.icon;
    YMANativeMediaView *media = self.media;
    UIImageView *favicon = self.favicon;
    UIButton *feedback = self.feedback;
    UILabel *reviewCount = self.reviewCount;
    UILabel *price = self.price;
    StarRatingView *rating = self.rating;
    NSDictionary *views = NSDictionaryOfVariableBindings(title,
                                                         body,
                                                         age,
                                                         domain,
                                                         warning,
                                                         sponsored,
                                                         callToAction,
                                                         icon,
                                                         media,
                                                         favicon,
                                                         feedback,
                                                         reviewCount,
                                                         price,
                                                         rating);
    [self configureSponsoredLabelWithViewBindings:views];
    [self configureAgeLabelWithViewBindings:views];
    [self configureFeedbackButtonWithViewBindings:views];
    [self configureMediaWithViewBindings:views];
    [self configureFaviconWithViewBindings:views];;
    [self configureIconWithViewBindings:views];
    [self configureLeftImageWithViewBindings:views];
    [self configureTitleLabelWithViewBindings:views];
    [self configureBodyLabelWithViewBindings:views];
    [self configureDomainLabelWithViewBindings:views];
    [self configureWideMediaViewWithViewBindings:views];
    [self configureReviewCountLabelWithViewBindings:views];
    [self configureRatingWithViewBindings:views];
    [self configurePriceLabelWithViewBindings:views];
    [self configureButtonWithViewBindings:views];
    [self configureWarningWithViewBindings:views];
    [self configureViewBottomConstraint];
}

- (void)configureSponsoredLabelWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.sponsored.length == 0) {
        [self.sponsored removeFromSuperview];
        return;
    }
    [self.view addSubview:self.sponsored];
    NSArray *vertical = [self topConstraintsForView:self.sponsored];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[sponsored(150)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:vertical];
    [self.view addConstraints:horizontal];
}

- (void)configureAgeLabelWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.age.length == 0) {
        [self.age removeFromSuperview];
        return;
    }
    [self.view addSubview:self.age];
    NSArray *vertical = [self topConstraintsForView:self.age];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[age(<=150)]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:vertical];
    [self.view addConstraints:horizontal];
}

- (void)configureFeedbackButtonWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.feedbackAvailable == NO) {
        [self.feedback removeFromSuperview];
        return;
    }
    [self.view addSubview:self.feedback];
    NSArray *vertical = [self topConstraintsForView:self.feedback];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[feedback(30)]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *height = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[feedback(30)]"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
    [self.view addConstraints:vertical];
    [self.view addConstraints:horizontal];
    [self.view addConstraints:height];
}

- (void)configureFaviconWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.favicon == nil || (self.ad.adAssets.image != nil && [self hasWideMedia] == NO)) {
        [self.favicon removeFromSuperview];
        return;
    }
    [self.view addSubview:self.favicon];
    NSArray *constraints = [self constraintsForView:self.favicon asset:self.ad.adAssets.favicon width:16.f];
    [self.view addConstraints:constraints];
    self.leftView = self.favicon;
}

- (void)configureMediaWithViewBindings:(NSDictionary *)views
{
    if ([self shouldShowMedia]) {
        [self.view addSubview:self.media];
    }
    else {
        [self.media removeFromSuperview];
    }
}

- (void)configureLeftImageWithViewBindings:(NSDictionary *)views
{
    if ([self shouldShowMedia] == NO || [self hasWideMedia]) {
        return;
    }
    [self.view addConstraints:[self constraintsForView:self.media asset:self.ad.adAssets.image width:100.f]];
    self.leftView = self.media;
}

- (void)configureIconWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.icon == nil) {
        [self.icon removeFromSuperview];
        return;
    }
    [self.view addSubview:self.icon];
    [self.view addConstraints:[self constraintsForView:self.icon asset:self.ad.adAssets.icon width:40.f]];
    self.leftView = self.icon;
}

- (void)configureTitleLabelWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.title.length == 0) {
        [self.title removeFromSuperview];
        return;
    }
    [self.view addSubview:self.title];
    NSArray *topViews = @[ self.sponsored ];
    [self.view addConstraints:[self verticalConstraintsForView:self.title topViews:topViews]];
    [self.view addConstraints:[self textBlockHorizontalConstraintsForView:self.title]];
}

- (void)configureBodyLabelWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.body.length == 0) {
        [self.body removeFromSuperview];
        return;
    }
    [self.view addSubview:self.body];
    NSArray *topViews = @[ self.title ];
    [self.view addConstraints:[self verticalConstraintsForView:self.body topViews:topViews]];
    [self.view addConstraints:[self textBlockHorizontalConstraintsForView:self.body]];
}

- (void)configureDomainLabelWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.domain.length == 0) {
        [self.domain removeFromSuperview];
        return;
    }
    [self.view addSubview:self.domain];
    NSArray *topViews = @[ self.body ];
    [self.view addConstraints:[self verticalConstraintsForView:self.domain topViews:topViews]];
    [self.view addConstraints:[self textBlockHorizontalConstraintsForView:self.domain]];
}

- (void)configureWideMediaViewWithViewBindings:(NSDictionary *)views
{
    if ([self shouldShowMedia] == NO || [self hasWideMedia] == NO) {
        return;
    }
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[media]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views];
    CGFloat aspectRatio = [self mediaAspectRatio];
    NSLayoutConstraint *ratioConstraint = [self aspectRatioConstraintForView:self.media aspectRatio:aspectRatio];
    NSArray *topViews = [self viewByAddingTopViews:@[ self.body, self.domain ]];
    NSArray *mediaVerticalConstraints = [self verticalConstraintsForView:self.media topViews:topViews];
    [self.view addConstraint:ratioConstraint];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:mediaVerticalConstraints];
    self.wideMedia = self.media;
}

- (void)configureReviewCountLabelWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.reviewCount.length == 0) {
        [self.reviewCount removeFromSuperview];
        return;
    }
    [self.view addSubview:self.reviewCount];
    NSArray *topViews = [self viewByAddingTopViews:@[ self.body, self.domain ]];
    [self.view addConstraints:[self verticalConstraintsForView:self.reviewCount topViews:topViews]];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[reviewCount(<=150)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:horizontal];
}

- (void)configureRatingWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.rating == nil) {
        [self.rating removeFromSuperview];
        return;
    }
    [self.view addSubview:self.rating];
    NSArray *topViews = [self viewByAddingTopViews:@[ self.body, self.domain ]];
    [self.view addConstraints:[self verticalConstraintsForView:self.rating topViews:topViews]];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rating]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:horizontal];
}

- (void)configurePriceLabelWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.price.length == 0) {
        [self.price removeFromSuperview];
        return;
    }
    [self.view addSubview:self.price];
    NSArray *topViews = [self viewByAddingTopViews:@[ self.body, self.domain, self.rating, self.reviewCount ]];
    [self.view addConstraints:[self verticalConstraintsForView:self.price topViews:topViews]];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[price(<=150)]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:horizontal];
}

- (void)configureButtonWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.callToAction.length == 0) {
        [self.callToAction removeFromSuperview];
        return;
    }
    [self.view addSubview:self.callToAction];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[callToAction]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *topViews = @[ self.body, self.domain, self.rating, self.reviewCount, self.price ];
    topViews = [self viewByAddingTopViews:topViews];
    [self.view addConstraints:[self verticalConstraintsForView:self.callToAction topViews:topViews]];
    [self.view addConstraints:horizontal];
}

- (void)configureWarningWithViewBindings:(NSDictionary *)views
{
    if (self.ad.adAssets.warning.length == 0) {
        [self.warning removeFromSuperview];
        return;
    }
    [self.view addSubview:self.warning];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[warning]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *topViews = @[ self.body, self.domain, self.rating, self.reviewCount, self.price, self.callToAction ];
    topViews = [self viewByAddingTopViews:topViews];
    [self.view addConstraints:[self verticalConstraintsForView:self.warning topViews:topViews]];
    [self.view addConstraints:horizontal];
}

- (void)configureViewBottomConstraint
{
    for (UIView *view in self.view.subviews) {
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.f
                                                                   constant:kNativeViewOffset];
        [self.view addConstraint:bottom];
    }
}

#pragma mark - Helpers

- (CGFloat)mediaAspectRatio
{
    return [self hasVideo]
        ? self.ad.adAssets.media.aspectRatio
        : [self aspectRatioWithImageAsset:self.ad.adAssets.image];
}

- (CGFloat)aspectRatioWithImageAsset:(YMANativeAdImage *)imageAsset
{
    return imageAsset.size.width / imageAsset.size.height;
}

- (NSLayoutConstraint *)aspectRatioConstraintForView:(UIView *)view asset:(YMANativeAdImage *)asset
{
    CGFloat aspectRatio = [self aspectRatioWithImageAsset:asset];
    return [self aspectRatioConstraintForView:view aspectRatio:aspectRatio];
}

- (NSLayoutConstraint *)aspectRatioConstraintForView:(UIView *)view aspectRatio:(CGFloat)aspectRatio
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:aspectRatio
                                         constant:0.f];
}

- (NSArray *)constraintsForView:(UIView *)view asset:(YMANativeAdImage *)asset width:(CGFloat)width
{
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSArray *topViews = @[ self.sponsored ];
    NSArray *imageHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:width];
    NSLayoutConstraint *aspectRatio = [self aspectRatioConstraintForView:view asset:asset];
    NSArray *imageVertical = [self verticalConstraintsForView:view topViews:topViews];
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:imageVertical];
    [constraints addObjectsFromArray:imageHorizontal];
    [constraints addObject:widthConstraint];
    [constraints addObject:aspectRatio];
    return [constraints copy];
}

- (NSArray *)topConstraintsForView:(UIView *)view
{
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    return [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]"
                                                   options:0
                                                   metrics:nil
                                                     views:views];
}

- (NSArray *)topConstraintsForUpperView:(UIView *)upperView
                              lowerView:(UIView *)lowerView
                               relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:lowerView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:relation
                                                                     toItem:upperView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:kNativeViewOffset];
    return @[ constraint ];
}

- (NSArray *)verticalConstraintsForView:(UIView *)view topViews:(NSArray *)topViews
{
    NSArray *constraints = nil;
    if (topViews.count == 0) {
        constraints = [self topConstraintsForView:view];
    }
    else if (topViews.count == 1) {
        UIView *topView = topViews.firstObject;
        if (topView.superview != nil) {
            constraints = [self topConstraintsForUpperView:topView lowerView:view relation:NSLayoutRelationEqual];
        }
        else {
            constraints = [self topConstraintsForView:view];
        }
    }
    else {
        NSMutableArray *topConstraints = [[NSMutableArray alloc] init];
        for (UIView *topView in topViews) {
            if (topView.superview != nil) {
                NSArray *constraints = [self topConstraintsForUpperView:topView
                                                              lowerView:view
                                                               relation:NSLayoutRelationGreaterThanOrEqual];
                [topConstraints addObjectsFromArray:constraints];
            }
        }
        constraints = [topConstraints copy];
    }
    return constraints;
}

- (NSArray *)viewByAddingTopViews:(NSArray *)topViews
{
    NSMutableArray *views = [topViews mutableCopy];
    if (self.leftView != nil) {
        [views addObject:self.leftView];
    }
    if (self.wideMedia != nil) {
        [views addObject:self.wideMedia];
    }
    return [views copy];
}

- (NSArray *)textBlockHorizontalConstraintsForView:(UIView *)view
{
    UIView *leftView = self.leftView;
    NSArray *constraints = nil;
    if (leftView == nil) {
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
    }
    else {
        NSDictionary *views = NSDictionaryOfVariableBindings(leftView, view);
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView]-[view]-|"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
    }
    return constraints;
}

- (BOOL)shouldShowMedia
{
    if ([self hasImage] == NO && [self hasVideo] == NO) {
        return NO;
    }
    BOOL hasSmallAppImage = [self.ad.adType isEqualToString:kYMANativeAdTypeAppInstall] && [self hasWideMedia] == NO;
    return hasSmallAppImage == NO;
}

- (BOOL)hasWideMedia
{
    return [self hasVideo] || [self hasWideImage];
}

- (BOOL)hasImage
{
    return self.ad.adAssets.image != nil;
}

- (BOOL)hasVideo
{
    return self.ad.adAssets.media != nil;
}

- (BOOL)hasWideImage
{
    CGSize size = self.ad.adAssets.image.size;
    BOOL isWide = size.width / size.height > 1.5f;
    BOOL isLarge = size.width >= 450.f;
    return isWide && isLarge;
}

@end
