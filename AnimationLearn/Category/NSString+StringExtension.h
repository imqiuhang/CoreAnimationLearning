//
//  NSString+StringExtension.h
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//


@interface NSString (StringExtension)

- (BOOL)isNotBlank;
- (BOOL)isNotBlankWithSpace;
- (BOOL)isEqualToStringByCaseInsensitive:(NSString *)aString;

- (NSString *)stringByTrim;
- (NSString *)URLEncodedString;
- (NSURL *)URLValue;///String->URL
- (NSString *)MD5String;///string返回MD5值

///@todo ---下面几个格式化的代码可以找时间重写下 临时写的
- (NSString *)phone344String;///188-8888-8888
- (NSString *)originalPhoneString;///188-8888-8888 ->18888888888
- (NSString *)IDCardNumberString;///330821 1992 1124 8888
- (NSString *)exchangeCodeString;///AAAA-BBBB-CCCC

- (NSString *)stringByReplacingOccurrencesOfStrings:(NSDictionary <NSString *,NSString *>*)replacingStringDatas;
- (NSString *)stringByRemoveOccurrencesOfStrings:(NSArray <NSString *>*)removeStrings;
+ (NSString *)UUIDString;
+ (NSString *)randomStringWithLength:(int)len;
+ (NSString*)randomChineseString:(NSInteger)len;

- (NSString *)documentPath;

+ (NSString *)bool2String:(BOOL)boolValue;


@end


@interface NSString(Verify)

///正则匹配是否匹配
- (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;
- (BOOL)matchesRegex:(NSString *)regex;///默认NSRegularExpressionCaseInsensitive

- (BOOL)validatePhoneNumber;
- (BOOL)validateEmail;
- (BOOL)valiPostCode;

- (BOOL)isPureNumandCharacters;
- (BOOL)isPureInt_;
- (BOOL)isPureLong;
- (BOOL)isPureFloat;

@end


@interface NSString(Design)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)widthForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

- (NSAttributedString *)attributedStringWithLineSpacing:(float)lineSpacing;
- (NSAttributedString *)attributedStringWithChangeString:(NSString *)changeString changeColor:(UIColor *)changeColor changeFont:(UIFont *)changeFont;
//HTML->AttributedString
- (NSMutableAttributedString*)attributedStringIfMatcherHTML;

@end


@interface NSString (ImageURL)

- (NSString *)sizedImageURLStringWithWidth:(int)width height:(int)height;

@end


@interface NSObject (StringExtension)///为了防止不是String调用崩溃

- (BOOL)isNotBlank;
- (BOOL)isNotBlankWithSpace;
- (NSAttributedString *)attributedStringWithLineSpacing:(float)lineSpacing;
- (NSAttributedString *)attributedStringWithCharSpacing:(float)charSpacing;
- (NSString *)sizedImageURLStringWithWidth:(int)width height:(int)height;
- (NSURL *)URLValue;
- (NSString *)URLEncodedString;
- (NSString *)MD5String;
- (NSString *)phone344String;
- (NSString *)originalPhoneString;
- (NSString *)IDCardNumberString;
- (NSString *)exchangeCodeString;
- (NSString *)documentPath;
- (NSString *)stringByReplacingOccurrencesOfStrings:(NSDictionary <NSString *,NSString *>*)replacingStringDatas;
- (NSString *)stringByRemoveOccurrencesOfStrings:(NSArray <NSString *>*)removeStrings;
- (BOOL)isEqualToStringByCaseInsensitive:(NSString *)aString;
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)widthForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;
- (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;
- (BOOL)matchesRegex:(NSString *)regex;
- (BOOL)validatePhoneNumber;
- (BOOL)validateEmail;
- (BOOL)valiPostCode;
- (NSMutableAttributedString *)attributedStringIfMatcherHTML;
- (BOOL)isPureNumandCharacters;
- (BOOL)isPureLong;
- (BOOL)isPureFloat;
- (BOOL)isPureInt_;



@end



