//
//  LWUtil.m
//  QHSimpleFrame
//
//  Created by imqiuhang on 15/3/31.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "CommUtil.h"


@implementation CommUtil


+ (int)randomNumberIncludeFrom:(int)from includeTo:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (BOOL)randomBOOL {
    return [@([self randomNumberIncludeFrom:0 includeTo:1])boolValue];
}

+ (NSString *)bool2String:(BOOL)boolValue {
    return boolValue?@"YES":@"NO";
}

+ (NSString *)URL:(NSURL *)URL paramValueWithKey:(NSString *)key {
    
    NSString *webaddress = URL.absoluteString;
    
    if (![webaddress isNotBlank]||![key isNotBlank]) {
        return nil;
    }
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",key];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                            error:&error];
    if (error) {
        return nil;
    }
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];
        
        return tagValue;
    }
    return nil;
}

+ (NSString *)URLByAddParameter:(NSString *)parameterName parameterValue:(NSString *)parameterValue URL:(NSString *)URL {
    
    if (![parameterName isNotBlank]||![parameterValue isNotBlank]) {
        return URL;
    }
    
    if (![URL isNotBlank]) {
        return nil;
    }
    
    if ([[self URL:URL.URLValue paramValueWithKey:parameterName] isNotBlank]) {
        return URL;
    }
    
    if ([URL rangeOfString:@"?"].length==0) {
        URL = [URL  stringByAppendingString:@"?"];
    }
    
    URL = [URL stringByAppendingFormat:@"&%@=%@",parameterName,parameterValue];
    
    return URL;
}

+ (NSString *)getDeviceTokenStringWithDeviceTokenData:(NSData *)deviceTokenData {
    NSString *token = [[deviceTokenData description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    return token;
}

+ (id)jsonString2Object:(id )jsonString {
    
    if ([jsonString isKindOfClass:[NSArray class]]||[jsonString isKindOfClass:[NSDictionary class]]) {
        return jsonString;
    }
    jsonString = [NSString stringWithFormat:@"%@",jsonString];
    
    if (![jsonString isNotBlank]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:kNilOptions
                                                      error:&error];
    
    if (jsonObject != nil&&error == nil){
        return jsonObject;
    }
    return nil;
}

+ (NSString *)jsonObject2String:(id)object {
    
    if (!object) {
        return nil;
    }
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData&&!error) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}


+ (NSString *)fileNameWithExt:(NSString *)ext {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@",uuidStr];
    return [ext length] ? [NSString stringWithFormat:@"%@.%@",name,ext]:name;
}

+ (UIWindow *)currentVisibleWindow {
    NSEnumerator *frontToBackWindows =
    [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            return window;
        }
    }
    return [[[UIApplication sharedApplication] delegate] window];
}

+ (UIViewController *)currentVisibleController {
    
    UIViewController* vc = [[self currentVisibleWindow] rootViewController];
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    
    return vc;
}


+ (void)makeCallWithPhoneNumber:(NSString *)phoneNumer {
    
    if (![phoneNumer isNotBlank]) {
        return;
    }
    
    [self openURL:[NSString stringWithFormat:@"telprompt://%@", NonNilStringFromValue(phoneNumer)]];
}

+ (void)openURL:(NSString *)URL {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[CommUtilAss nonNilURLFromValue:URL] options:@{} completionHandler:nil];
    }else {
        [[UIApplication sharedApplication] openURL:[CommUtilAss nonNilURLFromValue:URL]];
    }
}

+ (NSComparisonResult)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    
    if (!v1 && !v2) {
        return NSOrderedSame;
    }
    
    if (!v1 && v2) {
        return NSOrderedAscending;
    }
    if (v1 && !v2) {
        return NSOrderedDescending;
    }
    
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];

    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array qh_objAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array qh_objAtIndex:i] integerValue];
        if (value1 > value2) {
            return NSOrderedDescending;
        } else if (value1 < value2) {
            return NSOrderedAscending;
        }
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return NSOrderedDescending;
    } else if (v1Array.count < v2Array.count) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
    
    return NSOrderedSame;
}


+ (UIImage *)inviteImageWithBackgroundImage:(UIImage *)backgroundImage contentImage:(UIImage *)contentImage{
    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, [UIScreen mainScreen].scale);
//    UIGraphicsBeginImageContext(backgroundImage.scale);
    
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    CGFloat gap = (backgroundImage.size.width - contentImage.size.width)/2;
    
    [contentImage drawInRect:CGRectMake(gap, gap, contentImage.size.width, contentImage.size.height)];
    
    UIImage *qrImage = [CommUtil createQRCodeWithString:@"www.baidu.com" size:333];
    [qrImage drawInRect:CGRectMake(backgroundImage.size.width-106, backgroundImage.size.height-29, 333, 333)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)inviteImageWithBackgroundImage:(UIImage *)backgroundImage string:(NSString *)str{
    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, [UIScreen mainScreen].scale);
    //    UIGraphicsBeginImageContext(backgroundImage.scale);
    
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    UIImage *qrImage = [CommUtil createQRCodeWithString:str size:333];
    [qrImage drawInRect:CGRectMake(backgroundImage.size.width-50-161, backgroundImage.size.height-14-161, 161, 161)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)createQRCodeWithString:(NSString*)str size:(CGFloat)size{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrCode = [filter outputImage];
    
    return [CommUtil adjustQRImageSize:qrCode QRSize:size];
}

+ (UIImage*)adjustQRImageSize:(CIImage*)ciImage QRSize:(CGFloat)qrSize{

    CGRect ciImageRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(qrSize / CGRectGetWidth(ciImageRect), qrSize / CGRectGetHeight(ciImageRect));
    
    size_t width = CGRectGetWidth(ciImageRect) * scale;
    size_t height = CGRectGetHeight(ciImageRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:ciImageRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, ciImageRect, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

+ (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}



+(NSArray *)blackList{
    return @[@"TZPhotoPickerController",
             @"TZGifPhotoPreviewController",
             @"TZAlbumPickerController",
             @"TZPhotoPreviewController",
             @"TZVideoPlayerController",
             @"TZImagePickerController"
             ];
}

+(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage *resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    return resultImage;
}

+(UIImage *)compressOriginalImage:(UIImage *)image toScaleMaxLength:(CGFloat)maxLength{
    UIImage *resultImage = image;
    CGSize size = CGSizeMake(0, 0);
    if (image.size.height > maxLength || image.size.width > maxLength) {
        if (image.size.height < image.size.width) {
            size.width = maxLength;
            size.height = maxLength/image.size.width * image.size.height;
        }
        else{
            size.height = maxLength;
            size.width = maxLength/image.size.height * image.size.width;
        }
    }
    else{
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    return resultImage;
}

@end
