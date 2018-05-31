
#import <Foundation/Foundation.h>

@interface RequestParametersProvider : NSObject

+ (NSDictionary<NSString *, NSString *> *)yandexParameters;
+ (NSDictionary<NSString *, NSString *> *)adMobParameters;
+ (NSDictionary<NSString *, NSString *> *)facebookParameters;
+ (NSDictionary<NSString *, NSString *> *)moPubParameters;
+ (NSDictionary<NSString *, NSString *> *)myTargetParameters;
+ (NSDictionary<NSString *, NSString *> *)startAppParameters;

@end
