/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import "NativeAssetsComposer.h"
#import "StarRatingView.h"

static CGFloat const kNativeViewOffset = 8.f;
static CGFloat const kNativeViewImageHeight = 150.f;

@interface NativeAssetsComposer ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) UILabel *age;
@property (nonatomic, strong) UILabel *body;
@property (nonatomic, strong) UILabel *callToAction;
@property (nonatomic, strong) UILabel *domain;
@property (nonatomic, strong) UIImageView *favicon;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *sponsored;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *warning;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) StarRatingView *rating;
@property (nonatomic, strong) UILabel *reviewCount;
@property (nonatomic, weak) UIView *leftView;

@end

@implementation NativeAssetsComposer

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self != nil) {
        _view = view;
        _age = [self label];
        _body = [self label];
        _callToAction = [self label];
        _callToAction.textColor = [UIColor colorWithRed:108.f / 255.f green:101.f / 255.f blue:169.f / 255.f alpha:1.f];
        _callToAction.font = [UIFont systemFontOfSize:14.f];
        _domain = [self label];
        _domain.textColor = [UIColor colorWithRed:2.f / 255.f green:124.f / 255.f blue:0.f alpha:1.f];
        _favicon = [self imageView];
        _icon = [self imageView];
        _image = [self imageView];
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
    imageView.userInteractionEnabled = YES;
    return imageView;
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

- (StarRatingView *)starRatingView
{
    UIImage *starImage = [UIImage imageNamed:@"star"];
    StarRatingView *ratingView = [[StarRatingView alloc] initWithFrame:CGRectZero starImage:starImage];
    ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    return ratingView;
}

#pragma mark - Layout

- (void)layoutAssetsWithMediaView:(UIView *)mediaView
{
    UILabel *title = self.title;
    UILabel *body = self.body;
    UILabel *age = self.age;
    UILabel *domain = self.domain;
    UILabel *warning = self.warning;
    UILabel *sponsored = self.sponsored;
    UILabel *callToAction = self.callToAction;
    UIImageView *icon = self.icon;
    UIImageView *image = self.image;
    UIImageView *favicon = self.favicon;
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
                                                         image,
                                                         favicon,
                                                         reviewCount,
                                                         price,
                                                         rating);
    [self configureSponsoredLabelWithViewBindings:views];
    [self configureAgeLabelWithViewBindings:views];
    [self configureFaviconWithViewBindings:views];
    [self configureIconWithViewBindings:views];
    [self configureTitleLabelWithViewBindings:views];
    [self configureBodyLabelWithViewBindings:views];
    [self configureDomainLabelWithViewBindings:views];
    [self configureImageWithViewBindings:views mediaView:mediaView];
    [self configureReviewCountLabelWithViewBindings:views];
    [self configureRatingWithViewBindings:views];
    [self configurePriceLabelWithViewBindings:views];
    [self configureButtonWithViewBindings:views];
    [self configureWarningWithViewBindings:views];
    [self configureViewBottomConstraint];
}

- (void)configureSponsoredLabelWithViewBindings:(NSDictionary *)views
{
    if (self.sponsored.text.length == 0) {
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
    if (self.age.text.length == 0) {
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

- (void)configureFaviconWithViewBindings:(NSDictionary *)views
{
    if (self.favicon.image == nil) {
        [self.favicon removeFromSuperview];
        return;
    }
    [self.view addSubview:self.favicon];
    NSArray *constraints = [self imageConstraintsForImageView:self.favicon width:16.f];
    [self.view addConstraints:constraints];
    self.leftView = self.favicon;
}

- (void)configureIconWithViewBindings:(NSDictionary *)views
{
    if (self.icon.image == nil) {
        [self.icon removeFromSuperview];
        return;
    }
    [self.view addSubview:self.icon];
    [self.view addConstraints:[self imageConstraintsForImageView:self.icon width:40.f]];
    self.leftView = self.icon;
}

- (void)configureTitleLabelWithViewBindings:(NSDictionary *)views
{
    if (self.title.text.length == 0) {
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
    if (self.body.text.length == 0) {
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
    if (self.domain.text.length == 0) {
        [self.domain removeFromSuperview];
        return;
    }
    [self.view addSubview:self.domain];
    NSArray *topViews = @[ self.body ];
    [self.view addConstraints:[self verticalConstraintsForView:self.domain topViews:topViews]];
    [self.view addConstraints:[self textBlockHorizontalConstraintsForView:self.domain]];
}

- (void)configureImageWithViewBindings:(NSDictionary *)views mediaView:(UIView *)mediaView
{
    if ([self shouldShowImageWithMediaView:mediaView] == NO) {
        [self.image removeFromSuperview];
        return;
    }
    
    [self.view addSubview:self.image];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[image]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSLayoutConstraint *vertical = [self heightConstraintForView:self.image height:kNativeViewImageHeight];
    NSArray *topViews = [self imagesByAddingTopViews:@[ self.body, self.domain ]];
    NSArray *imageVertical = [self verticalConstraintsForView:self.image topViews:topViews];
    [self.view addConstraint:vertical];
    [self.view addConstraints:horizontal];
    [self.view addConstraints:imageVertical];
}

- (void)configureReviewCountLabelWithViewBindings:(NSDictionary *)views
{
    if (self.reviewCount.text.length == 0) {
        [self.reviewCount removeFromSuperview];
        return;
    }
    [self.view addSubview:self.reviewCount];
    NSArray *topViews = [self imagesByAddingTopViews:@[ self.body, self.domain ]];
    [self.view addConstraints:[self verticalConstraintsForView:self.reviewCount topViews:topViews]];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[reviewCount(<=150)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:horizontal];
}

- (void)configureRatingWithViewBindings:(NSDictionary *)views
{
    if (self.rating.rating == nil) {
        [self.rating removeFromSuperview];
        return;
    }
    [self.view addSubview:self.rating];
    NSArray *topViews = [self imagesByAddingTopViews:@[ self.body, self.domain ]];
    [self.view addConstraints:[self verticalConstraintsForView:self.rating topViews:topViews]];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rating]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:horizontal];
}

- (void)configurePriceLabelWithViewBindings:(NSDictionary *)views
{
    if (self.price.text.length == 0) {
        [self.price removeFromSuperview];
        return;
    }
    [self.view addSubview:self.price];
    NSArray *topViews = [self imagesByAddingTopViews:@[ self.body, self.domain, self.rating, self.reviewCount ]];
    [self.view addConstraints:[self verticalConstraintsForView:self.price topViews:topViews]];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[price(<=150)]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    [self.view addConstraints:horizontal];
}

- (void)configureButtonWithViewBindings:(NSDictionary *)views
{
    if (self.callToAction.text.length == 0) {
        [self.callToAction removeFromSuperview];
        return;
    }
    [self.view addSubview:self.callToAction];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[callToAction]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *topViews = @[ self.body, self.domain, self.rating, self.reviewCount, self.price ];
    topViews = [self imagesByAddingTopViews:topViews];
    [self.view addConstraints:[self verticalConstraintsForView:self.callToAction topViews:topViews]];
    [self.view addConstraints:horizontal];
}

- (void)configureWarningWithViewBindings:(NSDictionary *)views
{
    if (self.warning.text.length == 0) {
        [self.warning removeFromSuperview];
        return;
    }
    [self.view addSubview:self.warning];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[warning]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *topViews = @[ self.body, self.domain, self.rating, self.reviewCount, self.price, self.callToAction ];
    topViews = [self imagesByAddingTopViews:topViews];
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

- (NSLayoutConstraint *)heightConstraintForView:(UIView *)view height:(CGFloat)height
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.f
                                         constant:height];
}

- (NSLayoutConstraint *)aspectRatioConstraintForImageView:(UIImageView *)imageView
{
    CGFloat ratio = imageView.image.size.width / imageView.image.size.height;
    return [NSLayoutConstraint constraintWithItem:imageView
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:imageView
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:ratio
                                         constant:0.f];
}

- (NSArray *)imageConstraintsForImageView:(UIImageView *)imageView width:(CGFloat)width
{
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
    NSArray *topViews = @[ self.sponsored ];
    NSArray *imageHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[imageView]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:width];
    NSLayoutConstraint *aspectRatio = [self aspectRatioConstraintForImageView:imageView];
    NSArray *imageVertical = [self verticalConstraintsForView:imageView topViews:topViews];
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
    NSMutableArray *viewsWithSuperView = [[NSMutableArray alloc] init];
    for (UIView *topView in topViews) {
        if (topView.superview != nil) {
            [viewsWithSuperView addObject:topView];
        }
    }
    if (viewsWithSuperView.count == 0) {
        constraints = [self topConstraintsForView:view];
    }
    else if (viewsWithSuperView.count == 1) {
        UIView *topView = viewsWithSuperView.firstObject;
        constraints = [self topConstraintsForUpperView:topView lowerView:view relation:NSLayoutRelationEqual];
    }
    else {
        NSMutableArray *topConstraints = [[NSMutableArray alloc] init];
        for (UIView *topView in viewsWithSuperView) {
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

- (NSArray *)imagesByAddingTopViews:(NSArray *)topViews
{
    NSMutableArray *views = [topViews mutableCopy];
    if (self.leftView != nil) {
        [views addObject:self.leftView];
    }
    if (self.image.superview != nil) {
        [views addObject:self.image];
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

- (BOOL)shouldShowImageWithMediaView:(UIView *)mediaView
{
    return mediaView != nil;
}

@end
