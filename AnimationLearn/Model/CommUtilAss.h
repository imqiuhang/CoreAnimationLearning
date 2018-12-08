//
//  CommUtilAss.h
//  imqiuhang
//
//  Created by imqiuhang on 15/8/20.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//


#define NonNilStringFromValue(value) [CommUtilAss nonNilStringFromValue:value]

@interface CommUtilAss : NSObject

+ (NSString *)nonNilStringFromValue:(id)info defaultString:(NSString *)defaultString;
+ (NSString *)nonNilStringFromValue:(id)info;
+ (NSURL *)nonNilURLFromValue:(id)info;


@end





