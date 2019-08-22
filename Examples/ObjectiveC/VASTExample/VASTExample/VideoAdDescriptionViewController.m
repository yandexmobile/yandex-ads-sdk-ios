/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

#import <YandexMobileAds/YandexMobileVASTAds.h>
#import "VideoAdDescriptionViewController.h"
#import "TrackingTableViewController.h"

@interface VideoAdDescriptionViewController ()

@property (nonatomic, strong, readonly) YMAVASTAd *ad;

@end

@implementation VideoAdDescriptionViewController

- (instancetype)initWithAd:(YMAVASTAd *)ad
{
    self = [super init];
    if (self != nil) {
        _ad = ad;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Video ads";
    
    UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    descriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionTextView.editable = NO;
    descriptionTextView.text = self.ad.description;
    [self.view addSubview:descriptionTextView];
    NSDictionary *views = NSDictionaryOfVariableBindings(descriptionTextView);
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[descriptionTextView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[descriptionTextView]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    [self.view addConstraints:[horizontal arrayByAddingObjectsFromArray:vertical]];
    
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Tracking"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(displayTracking)];
}

- (void)displayTracking
{
    TrackingTableViewController *controller = [[TrackingTableViewController alloc] init];
    controller.ad = self.ad;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
