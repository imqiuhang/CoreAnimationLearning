//
//  NSString+StringExtension.m
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "NSString+StringExtension.h"
#import <CommonCrypto/CommonDigest.h>

#define AliyunOSSPoint @"oss-cn-hangzhou.aliyuncs.com"

@implementation NSString (StringExtension)

- (BOOL)isNotBlank {

    NSString *curStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([curStr isEqualToString:@""]||[curStr isEqualToString:@"<null>"]) {
        return NO;
    }
    
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isNotBlankWithSpace {
    
    if ([self isEqualToString:@""]||[self isEqualToString:@"<null>"]) {
        return NO;
    }
    
    return YES;

}

- (BOOL)isEqualToStringByCaseInsensitive:(NSString *)aString {
    if (!aString||![aString isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return [self compare:aString options:NSCaseInsensitiveSearch]==NSOrderedSame;
}

- (NSString *)stringByTrim {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)URLEncodedString {
    return  [self  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSURL *)URLValue {
    
    if ([self isKindOfClass:[NSURL class]]) {
        return (NSURL *)self;
    }
    NSString *URLStr = [NSString stringWithFormat:@"%@",self];
    
    if ([URLStr rangeOfString:AliyunOSSPoint].length!=0) {
        if ([URLStr hasPrefix:@"https"]) {
            URLStr = [URLStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"http"];
        }
    }
    
    NSString * encodingString = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:encodingString];
}

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)UUIDString {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

- (NSString *)phone344String {
    
    NSString *phoneString  = self.originalPhoneString;
 
    if (phoneString.length>=4&&phoneString.length<=7) {
        return [NSString stringWithFormat:@"%@-%@",[phoneString substringWithRange:NSMakeRange(0, 3)],[phoneString substringWithRange:NSMakeRange(3, phoneString.length-3)]];
    }else if (phoneString.length>7&&phoneString.length<=11) {
        return [NSString stringWithFormat:@"%@-%@-%@",[phoneString substringWithRange:NSMakeRange(0, 3)],[phoneString substringWithRange:NSMakeRange(3, 4)],[phoneString substringWithRange:NSMakeRange(7, phoneString.length-7)]];
    }
    
    return self;
}

- (NSString *)exchangeCodeString {
    ///AAAA-BBBB-CCCC
    NSString *exchangeCodeString = [self stringByRemoveOccurrencesOfStrings:@[@" ",@"-"]].uppercaseString;
    
    if (exchangeCodeString.length>=5&&exchangeCodeString.length<=8) {
        return [NSString stringWithFormat:@"%@-%@",[exchangeCodeString substringWithRange:NSMakeRange(0, 4)],[exchangeCodeString substringWithRange:NSMakeRange(4, exchangeCodeString.length-4)]];
    }else if (exchangeCodeString.length>8&&exchangeCodeString.length<=12) {
        return [NSString stringWithFormat:@"%@-%@-%@",[exchangeCodeString substringWithRange:NSMakeRange(0, 4)],[exchangeCodeString substringWithRange:NSMakeRange(4, 4)],[exchangeCodeString substringWithRange:NSMakeRange(8, exchangeCodeString.length-8)]];
    }
    
    return exchangeCodeString;
}

- (NSString *)originalPhoneString {
    return [self stringByRemoveOccurrencesOfStrings:@[@"-",@" "]];
}

- (NSString *)IDCardNumberString {
 
    NSString *tmpString  = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (tmpString.length>=7&&tmpString.length<=10) {
        return [NSString stringWithFormat:@"%@ %@",[tmpString substringWithRange:NSMakeRange(0, 6)],[tmpString substringWithRange:NSMakeRange(6, tmpString.length-6)]];
    }else if (tmpString.length>10&&tmpString.length<15) {
        return [NSString stringWithFormat:@"%@ %@ %@",[tmpString substringWithRange:NSMakeRange(0, 6)],[tmpString substringWithRange:NSMakeRange(6, 4)],[tmpString substringWithRange:NSMakeRange(10, tmpString.length-10)]];
    }else if (tmpString.length>=15) {
        return [NSString stringWithFormat:@"%@ %@ %@ %@",[tmpString substringWithRange:NSMakeRange(0, 6)],[tmpString substringWithRange:NSMakeRange(6, 4)],[tmpString substringWithRange:NSMakeRange(10, 4)],[tmpString substringWithRange:NSMakeRange(14, tmpString.length-14)]];
    }else {
        return tmpString;
    }
}

- (NSString *)stringByReplacingOccurrencesOfStrings:(NSDictionary <NSString *,NSString *>*)replacingStringDatas {
    if (!replacingStringDatas||![replacingStringDatas isKindOfClass:[NSDictionary class]]||replacingStringDatas.count==0) {
        return self;
    }
    
    NSString *targetString  = [NSString stringWithString:self];
    
    for(NSString *replaceKey in replacingStringDatas.allKeys) {
        NSString *replaceValue = replacingStringDatas[replaceKey];
        
        if ([replaceValue isKindOfClass:[NSString class]]&&[replaceKey isKindOfClass:[NSString class]]) {
            targetString = [targetString stringByReplacingOccurrencesOfString:replaceKey withString:replaceValue];
        }
        
    }
    
    return targetString;
}

- (NSString *)stringByRemoveOccurrencesOfStrings:(NSArray <NSString *>*)removeStrings {
    if(!removeStrings||![removeStrings isKindOfClass:[NSArray class]]||removeStrings.count==0) {
        return self;
    }
    
    NSString *targetString  = [NSString stringWithString:self];
    
    for(NSString *replaceKey in removeStrings) {
        if ([replaceKey isKindOfClass:[NSString class]]) {
            targetString = [targetString stringByReplacingOccurrencesOfString:replaceKey withString:@""];
        }
        
    }
    
    return targetString;
}

- (NSString *)documentPath {
    
    NSString *filename = self;
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString *result=nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsFolder = [folders objectAtIndex:0];
    result = [documentsFolder stringByAppendingPathComponent:filename];
    
    return result;
}

+ (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

+ (NSString*)randomChineseString:(NSInteger)count{
    
    NSMutableString *randomChineseString = [NSMutableString string];
    
    for(NSInteger i =0; i < count; i++){
        
        NSInteger randomH =0xA1+arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL =0xB0+arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8)+randomL;
        
        NSData*data = [NSData dataWithBytes:&number length:2];
        
        NSString*string = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        [randomChineseString appendString:string];
        
    }
    
    return randomChineseString.copy;
    
}


+ (NSString *)bool2String:(BOOL)boolValue {
    return boolValue?@"YES":@"NO";
}

@end


@implementation NSString(Verify)

- (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)matchesRegex:(NSString *)regex {
    return [self matchesRegex:regex options:NSRegularExpressionCaseInsensitive];
}

- (BOOL)validatePhoneNumber {
    
    NSString *phoneString = self.originalPhoneString;
    
    if ([phoneString length]!=11) {
        return NO;
    }
    return [phoneString matchesRegex:@"^1\\d{10}$"];
}

- (BOOL)validateEmail {
    return [self matchesRegex:@"^\\w*@\\w*\\.\\w*$"];
}

- (BOOL)valiPostCode {
    return [self isPureNumandCharacters];
}

- (BOOL)isPureNumandCharacters {
    if (![self isNotBlank]) {
        return NO;
    }
    return !([self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length>0);
}

- (BOOL)isPureInt_ {
    if (![self isNotBlank]) {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureLong {
    if (![self isNotBlank]) {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:self];
    long long val;
    return[scan scanLongLong:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}


@end

@implementation NSString(Design)

- (NSAttributedString *)attributedStringWithLineSpacing:(float)lineSpacing  {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//行距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.string.length)];
    
    return [attributedString copy];
}

- (NSAttributedString *)attributedStringWithChangeString:(NSString *)changeString changeColor:(UIColor *)changeColor changeFont:(UIFont *)changeFont{
    NSMutableAttributedString *allAttString = [[NSMutableAttributedString alloc]initWithString:self];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (changeColor) {
        params[NSForegroundColorAttributeName] = changeColor;
    }
    if (changeFont) {
        params[NSFontAttributeName] = changeFont;
    }
    [allAttString addAttributes:params range:[self rangeOfString:changeString]];
    
    return [allAttString copy];
}

- (NSAttributedString *)attributedStringWithCharSpacing:(float)charSpacing  {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSKernAttributeName : @(charSpacing)}];
    
    return [attributedString copy];
}

- (NSMutableAttributedString *)attributedStringIfMatcherHTML {
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    return attrStr;
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}


@end


@implementation NSString (ImageURL)

- (NSString *)sizedImageURLStringWithWidth:(int)width height:(int)height {
    
    if ([self rangeOfString:AliyunOSSPoint].length==0) {
        return self;
    }
    
    //?x-oss-process=image/resize,m_fill,h_100,w_100
    
    if ([self rangeOfString:@"?x-oss-process=image"].length>0||width<=0||height<=0) {
        return self;
    }
    
    return [self stringByAppendingString:[NSString stringWithFormat:@"?x-oss-process=image/resize,m_fill,h_%i,w_%i",width,height ]];
}

@end

@implementation NSObject(StringExtension)

- (BOOL)isNotBlank {return NO;}
- (BOOL)isNotBlankWithSpace {return NO;}
- (NSString *)sizedImageURLStringWithWidth:(int)width height:(int)height {
    if ([self isKindOfClass:[NSURL class]]) {
        return [((NSURL *)self).absoluteString sizedImageURLStringWithWidth:width height:height];
    }
    return nil;
}
- (NSURL *)URLValue {
    if([self isKindOfClass:[NSURL class]])return (NSURL *)self;
    return nil;
}
- (NSString *)URLEncodedString{return nil;}
- (NSString *)MD5String{return nil;}
- (NSString *)documentPath{return nil;}
- (NSString *)phone344String {return nil;}
- (NSString *)exchangeCodeString{return nil;}
- (NSString *)originalPhoneString {return nil;}
- (NSString *)IDCardNumberString {return nil;}
- (NSString *)stringByReplacingOccurrencesOfStrings:(NSDictionary<NSString *,NSString *> *)replacingStringDatas{return nil;}
- (NSString *)stringByRemoveOccurrencesOfStrings:(NSArray<NSString *> *)removeStrings{return nil;}
- (NSAttributedString *)attributedStringWithLineSpacing:(float)lineSpacing{return nil;}
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {return CGSizeZero;}
- (CGFloat)widthForFont:(UIFont *)font {return 0.f;}
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width{return 0.f;}
- (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {return NO;}
- (BOOL)matchesRegex:(NSString *)regex {return NO;}
- (BOOL)validatePhoneNumber{return NO;}
- (BOOL)validateEmail{return NO;}
- (BOOL)valiPostCode{return NO;}
- (NSMutableAttributedString *)attributedStringIfMatcherHTML{return nil;}
- (BOOL)isPureNumandCharacters{return NO;}
- (BOOL)isPureLong{return NO;}
- (BOOL)isPureInt_{return NO;}
- (BOOL)isPureFloat{return NO;}
- (BOOL)isEqualToStringByCaseInsensitive:(NSString *)aString {return NO;}
-(NSAttributedString *)attributedStringWithCharSpacing:(float)charSpacing{return nil;}
@end


