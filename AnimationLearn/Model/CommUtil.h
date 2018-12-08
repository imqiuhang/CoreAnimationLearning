//
//  CommUtil.h
//  QHSimpleFrame
//
//  Created by imqiuhang on 15/3/31.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

/**
 *  @author imqiuhang
 *
 *  @brief  一些常用的公共方法
 */
#import "CommUtilAss.h"


@interface CommUtil: NSObject


+ (int)randomNumberIncludeFrom:(int)from includeTo:(int)to;
+ (BOOL)randomBOOL;

+ (NSString *)URL:(NSURL *)URL paramValueWithKey:(NSString *)key;
+ (NSString *)URLByAddParameter:(NSString *)parameterName parameterValue:(NSString *)parameterValue URL:(NSString *)URL;

+ (id)jsonString2Object:(id )jsonString;
+ (NSString *)jsonObject2String:(id)object;

+ (NSString *)fileNameWithExt:(NSString *)ext;


+ (UIWindow *)currentVisibleWindow;
+ (UIViewController *)currentVisibleController ;

+ (NSString *)getDeviceTokenStringWithDeviceTokenData:(NSData *)deviceTokenData;

+ (void)makeCallWithPhoneNumber:(NSString *)phoneNumer;
+ (void)openURL:(NSString *)URL;///兼容iOS 10

+ (NSComparisonResult)compareVersion:(NSString *)v1 to:(NSString *)v2;


+ (UIImage *)inviteImageWithBackgroundImage:(UIImage *)backgroundImage contentImage:(UIImage *)contentImage;
+ (UIImage *)inviteImageWithBackgroundImage:(UIImage *)backgroundImage string:(NSString *)str;
+ (UIImage *)createQRCodeWithString:(NSString*)str size:(CGFloat)size;

+ (BOOL)isUserNotificationEnable;
+ (void)goToAppSystemSetting;
+ (UIImage *)shareImageWithTopImage:(UIImage *)topImage qrUrl:(NSString *)qrUrl;
+ (NSArray *)blackList;
+ (UIImage *)compressOriginalImage:(UIImage *)image toScaleMaxLength:(CGFloat)maxLength;

@end






