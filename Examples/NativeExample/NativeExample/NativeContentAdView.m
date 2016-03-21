/*
 *  NativeContentAdView.h
 *
 * This file is a part of the Yandex Advertising Network.
 *
 * Version for iOS © 2016 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://legal.yandex.com/partner_ch/
 */

#import "NativeContentAdView.h"

@interface NativeContentAdView ()

@property (nonatomic, strong) UIImageView *iconAssetImageView;
@property (nonatomic, strong) UIImageView *imageAssetImageView;

@end

@implementation NativeContentAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        UILabel *titleLabel = [self commonLabel];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        UILabel *bodyLabel = [self commonLabel];
        UILabel *domainLabel = [self commonLabel];
        UILabel *ageLabel = [self commonLabel];
        UILabel *warningLabel = [self commonLabel];
        UILabel *sponsoredByLabel = [self commonLabel];
        _iconAssetImageView = [self commonImageView];
        _imageAssetImageView = [self commonImageView];
        [self addSubview:titleLabel];
        [self addSubview:bodyLabel];
        [self addSubview:domainLabel];
        [self addSubview:ageLabel];
        [self addSubview:warningLabel];
        [self addSubview:sponsoredByLabel];
        self.titleLabel = titleLabel;
        self.bodyLabel = bodyLabel;
        self.domainLabel = domainLabel;
        self.ageLabel = ageLabel;
        self.warningLabel = warningLabel;
        self.sponsoredLabel = sponsoredByLabel;
        self.iconImageView = _iconAssetImageView;
        self.imageView = _imageAssetImageView;
    }
    return self;
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

- (void)cleanup
{
    [self.imageView removeFromSuperview];
    [self.iconImageView removeFromSuperview];
    [self removeConstraints:self.constraints];
}

- (void)prepareForDisplay
{
    UILabel *title = self.titleLabel;
    UILabel *body = self.bodyLabel;
    UILabel *age = self.ageLabel;
    UILabel *domain = self.domainLabel;
    UILabel *warning = self.warningLabel;
    UILabel *sponsored = self.sponsoredLabel;
    UIImageView *image = self.imageView;
    UIImageView *icon = self.iconImageView;
    NSDictionary *views = NSDictionaryOfVariableBindings(title,
                                                         body,
                                                         age,
                                                         domain,
                                                         warning,
                                                         sponsored,
                                                         image,
                                                         icon);
    [self cleanup];
    [self configureSponsoredLabelWithViewBindings:views];
    if (self.imageView.image != nil) {
        [self configureImageLayoutWithViewBindings:views];
    }
    else if (self.iconImageView.image != nil) {
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

- (void)configureBottomLayoutWithViewBindings:(NSDictionary *)views
{
    NSLayoutConstraint *domainVertical = [NSLayoutConstraint constraintWithItem:self.domainLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.ageLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.f
                                                                       constant:0.f];
    NSArray *domainHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[domain]-[age]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
    NSArray *warningVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[domain]-[warning]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *warningHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[warning]-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    [self addConstraints:domainHorizontal];
    [self addConstraint:domainVertical];
    [self addConstraints:warningVertical];
    [self addConstraints:warningHorizontal];
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

- (void)configureImageLayoutWithViewBindings:(NSDictionary *)views
{
    [self addSubview:self.imageView];
    NSArray *imageConstraints = [self imageConstraintsForImageView:self.imageView width:100.f];

    NSArray *titleVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[sponsored]-[title]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    NSArray *titleHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[title]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *bodyVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-[body]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    NSArray *bodyHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[body]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray *ageConstraints = [self ageConstraintsWithTopViews:@[self.bodyLabel, self.imageView]];

    [self addConstraints:imageConstraints];
    [self addConstraints:titleVertical];
    [self addConstraints:titleHorizontal];
    [self addConstraints:bodyVertical];
    [self addConstraints:bodyHorizontal];
    [self addConstraints:ageConstraints];
}

- (void)configureIconLayoutWithViewBindings:(NSDictionary *)views
{
    [self addSubview:self.iconImageView];
    NSArray *iconConstraints = [self imageConstraintsForImageView:self.iconImageView width:16.f];

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
    NSArray *bodyHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[body]-|"
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

@end
