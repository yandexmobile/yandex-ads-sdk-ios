/*
 *  NativeAppInstallAdView.m
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "NativeAppInstallAdView.h"
#import "StarRatingView.h"

@interface NativeAppInstallAdView ()

@property (nonatomic, strong) UIImageView *iconAssetImageView;

@end

@implementation NativeAppInstallAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        UILabel *titleLabel = [self commonLabel];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        UILabel *bodyLabel = [self commonLabel];
        UILabel *ageLabel = [self secondaryLabel];
        UILabel *warningLabel = [self secondaryLabel];
        UILabel *sponsoredByLabel = [self commonLabel];
        UILabel *priceLabel = [self commonLabel];
        StarRatingView *ratingView = [self starRatingView];
        UIButton *callToActionButton = [self button];
        _iconAssetImageView = [self commonImageView];
        [self addSubview:titleLabel];
        [self addSubview:bodyLabel];
        [self addSubview:ageLabel];
        [self addSubview:warningLabel];
        [self addSubview:sponsoredByLabel];
        [self addSubview:callToActionButton];
        [self addSubview:priceLabel];
        [self addSubview:ratingView];
        self.titleLabel = titleLabel;
        self.bodyLabel = bodyLabel;
        self.ageLabel = ageLabel;
        self.warningLabel = warningLabel;
        self.sponsoredLabel = sponsoredByLabel;
        self.iconImageView = _iconAssetImageView;
        self.callToActionButton = callToActionButton;
        self.priceLabel = priceLabel;
        self.ratingView = ratingView;
    }
    return self;
}

- (StarRatingView *)starRatingView
{
    UIImage *starImage = [UIImage imageNamed:@"star"];
    StarRatingView *ratingView = [[StarRatingView alloc] initWithFrame:CGRectZero starImage:starImage];
    ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    return ratingView;
}

- (UILabel *)secondaryLabel
{
    UILabel *label = [self commonLabel];
    label.textColor = [UIColor colorWithRed:253.f / 255.f green:137.f / 255.f blue:28.f / 255.f alpha:1.f];
    return label;
}

- (UILabel *)commonLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:12.f];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    return label;
}

- (UIImageView *)commonImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (UIButton *)button
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tintColor = [UIColor colorWithRed:108.f / 255.f green:101.f / 255.f blue:169.f / 255.f alpha:1.f];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    return button;
}

- (void)cleanup
{
    [self.iconImageView removeFromSuperview];
    [self removeConstraints:self.constraints];
}

- (void)prepeareForDisplay
{
    UILabel *title = self.titleLabel;
    UILabel *body = self.bodyLabel;
    UILabel *age = self.ageLabel;
    UILabel *warning = self.warningLabel;
    UILabel *sponsored = self.sponsoredLabel;
    UIButton *callToAction = self.callToActionButton;
    UILabel *price = self.priceLabel;
    UIView *rating = self.ratingView;
    UIImageView *icon = self.iconImageView;
    NSDictionary *views = NSDictionaryOfVariableBindings(title,
                                                         body,
                                                         age,
                                                         warning,
                                                         sponsored,
                                                         callToAction,
                                                         price,
                                                         rating,
                                                         icon);
    [self cleanup];
    [self configureSponsoredLabelWithViewBindings:views];
    if (self.iconImageView.image != nil) {
        [self configureIconLayoutWithViewBindings:views];
    }
    else {
        [self configureTextLayoutWithViewBindings:views];
    }
    [self configureBottomLayoutWithViewBindings:views];
    [self configureViewBottomConstraint];
}

- (void)configureSponsoredLabelWithViewBindings:(NSDictionary *)views
{
    NSArray *sponsoredVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[sponsored]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    NSArray *sponsoredHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[sponsored]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [self addConstraints:sponsoredVertical];
    [self addConstraints:sponsoredHorizontal];
}

- (void)configureBottomLayoutWithViewBindings:(NSDictionary *)bindings
{
    NSArray *topViews = @[ self.warningLabel, self.ageLabel ];
    [self addConstraints:[self warningConstraintsWithViewBindings:bindings]];
    [self addConstraints:[self callToActionConstraintsWithViewBindings:bindings topViews:topViews]];
    [self addConstraints:[self ratingConstraintsWithViewBindings:bindings topViews:topViews]];
    [self addConstraints:[self priceConstraintsWithViewBindings:bindings topViews:topViews]];
}

- (void)configureViewBottomConstraint
{
    for (UIView *view in self.subviews) {
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.f
                                                                   constant:8.f];
        [self addConstraint:bottom];
    }
}

- (void)configureIconLayoutWithViewBindings:(NSDictionary *)views
{
    [self addSubview:self.iconImageView];
    NSArray *iconConstraints = [self imageConstraintsForImageView:self.iconImageView width:60.f];

    NSArray *titleVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[sponsored]-[title]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    NSArray *titleHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[icon]-[title]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *bodyVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-[body]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    NSArray *bodyHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[icon]-[body]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
    NSArray *ageConstraints = [self ageConstraintsWithTopViews:@[self.bodyLabel, self.iconImageView]];

    [self addConstraints:iconConstraints];
    [self addConstraints:titleVertical];
    [self addConstraints:titleHorizontal];
    [self addConstraints:bodyVertical];
    [self addConstraints:bodyHorizontal];
    [self addConstraints:ageConstraints];
}

- (void)configureTextLayoutWithViewBindings:(NSDictionary *)views
{
    NSArray *titleVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[sponsored]-[title]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    NSArray *titleHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *bodyVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-[body]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    NSArray *bodyHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[body]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
    NSArray *ageConstraints = [self ageConstraintsWithTopViews:@[self.bodyLabel]];

    [self addConstraints:titleVertical];
    [self addConstraints:titleHorizontal];
    [self addConstraints:bodyVertical];
    [self addConstraints:bodyHorizontal];
    [self addConstraints:ageConstraints];
}

- (NSArray *)warningConstraintsWithViewBindings:(NSDictionary *)views
{
    NSLayoutConstraint *vertical = [NSLayoutConstraint constraintWithItem:self.warningLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.ageLabel
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.f
                                                                 constant:0.f];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[warning]-[age]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    return [horizontal arrayByAddingObject:vertical];
}

- (NSArray *)callToActionConstraintsWithViewBindings:(NSDictionary *)bindings topViews:(NSArray *)topViews
{
    NSMutableArray *constraints = [NSMutableArray arrayWithArray:[self topToBottomConstraintsForView:self.callToActionButton
                                                                                            topViews:topViews]];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[warning]-[callToAction]"
                                                                options:0
                                                                metrics:nil
                                                                  views:bindings];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[callToAction(<=150)]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:bindings];
    [constraints addObjectsFromArray:vertical];
    [constraints addObjectsFromArray:horizontal];
    return [constraints copy];
}

- (NSArray *)ratingConstraintsWithViewBindings:(NSDictionary *)bindings topViews:(NSArray *)topViews
{
    NSMutableArray *constraints = [NSMutableArray arrayWithArray:[self topToBottomConstraintsForView:self.ratingView
                                                                                            topViews:topViews]];
    NSLayoutConstraint *verticalCenter = [NSLayoutConstraint constraintWithItem:self.ratingView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.callToActionButton
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.f
                                                                       constant:0.f];
    verticalCenter.priority = UILayoutPriorityDefaultLow;

    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[rating]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:bindings];
    [constraints addObject:verticalCenter];
    [constraints addObjectsFromArray:horizontal];
    return [constraints copy];
}

- (NSArray *)priceConstraintsWithViewBindings:(NSDictionary *)bindings topViews:(NSArray *)topViews
{
    NSMutableArray *constraints = [NSMutableArray arrayWithArray:[self topToBottomConstraintsForView:self.priceLabel
                                                                                            topViews:topViews]];

    NSLayoutConstraint *verticalCenter = [NSLayoutConstraint constraintWithItem:self.priceLabel
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.callToActionButton
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.f
                                                                       constant:0.f];
    verticalCenter.priority = UILayoutPriorityDefaultLow;

    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rating]-[price(<=90)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:bindings];
    [constraints addObject:verticalCenter];
    [constraints addObjectsFromArray:horizontal];
    return constraints;
}

- (NSArray *)ageConstraintsWithTopViews:(NSArray *)topViews
{
    UILabel *age = self.ageLabel;
    NSDictionary *views = NSDictionaryOfVariableBindings(age);
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in topViews) {
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.ageLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                  toItem:view
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:8.f];
        [constraints addObject:top];
    }
    NSArray *ageHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[age(30)]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    return [ageHorizontal arrayByAddingObjectsFromArray:constraints];
}

- (NSArray *)imageConstraintsForImageView:(UIImageView *)imageView width:(CGFloat)width
{
    UILabel *sponsored = self.sponsoredLabel;
    NSDictionary *views = NSDictionaryOfVariableBindings(sponsored, imageView);
    CGFloat ratio = imageView.image.size.width / imageView.image.size.height;
    NSArray *imageVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[sponsored]-[imageView]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
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
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:imageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:imageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:ratio
                                                                    constant:0.f];
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:imageVertical];
    [constraints addObjectsFromArray:imageHorizontal];
    [constraints addObject:widthConstraint];
    [constraints addObject:aspectRatio];
    return [constraints copy];
}

- (NSArray *)topToBottomConstraintsForView:(UIView *)view topViews:(NSArray *)topViews
{
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *topView in topViews) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:topView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.f
                                                                       constant:8.f];
        constraint.priority = UILayoutPriorityDefaultHigh;
        [constraints addObject:constraint];
    }
    return [constraints copy];
}

@end
