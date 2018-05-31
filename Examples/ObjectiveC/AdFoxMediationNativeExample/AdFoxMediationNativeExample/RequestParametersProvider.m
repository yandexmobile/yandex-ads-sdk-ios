
#import "RequestParametersProvider.h"

@implementation RequestParametersProvider

+ (NSDictionary<NSString *, NSString *> *)yandexParameters
{
    return @{
             @"adf_ownerid" : @"270901",
             @"adf_p1" : @"cawxd",
             @"adf_p2" : @"fksh",
             @"adf_pt" : @"b"
             };
}

+ (NSDictionary<NSString *, NSString *> *)adMobParameters
{
    return @{
             @"adf_ownerid" : @"270901",
             @"adf_p1" : @"cabag",
             @"adf_p2" : @"fksh",
             @"adf_pt" : @"b",
             };
}

+ (NSDictionary<NSString *, NSString *> *)facebookParameters
{
    return @{
             @"adf_ownerid" : @"270901",
             @"adf_p1" : @"caank",
             @"adf_p2" : @"fksh",
             @"adf_pt" : @"b",
             };
}

+ (NSDictionary<NSString *, NSString *> *)moPubParameters
{
    return @{
             @"adf_ownerid" : @"270901",
             @"adf_p1" : @"caanl",
             @"adf_p2" : @"fksh",
             @"adf_pt" : @"b",
             };
}

+ (NSDictionary<NSString *, NSString *> *)myTargetParameters
{
    return @{
             @"adf_ownerid" : @"270901",
             @"adf_p1" : @"caanm",
             @"adf_p2" : @"fksh",
             @"adf_pt" : @"b",
             };
}

@end
