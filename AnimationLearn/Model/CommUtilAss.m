//
//  CommUtilAss.m
//  imqiuhang
//
//  Created by imqiuhang on 15/8/20.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "CommUtilAss.h"

@implementation CommUtilAss

+ (NSURL *)nonNilURLFromValue:(id)info {
    if ([info isKindOfClass:[NSURL class]]) {
        return info;
    }
    return [[self nonNilStringFromValue:info] URLValue];
}
+ (NSString *)nonNilStringFromValue:(id)info {
    return [self nonNilStringFromValue:info defaultString:@""];
}

+ (NSString *)nonNilStringFromValue:(id)info defaultString:(NSString *)defaultString {
    
    if (!defaultString) {
        defaultString = @"";
    }
    
    if (!info) {
        return defaultString;
    }
    
    if ([info isKindOfClass:[NSNull class]]) {
        return defaultString;
    }
    
    if ([info isKindOfClass:[NSString class]]) {
        if ([info isNotBlankWithSpace]) {
            //for service
            //@discuss if need?
            if ([info isEqualToString:@"<null>"]) {
                return defaultString;
            }
            return [NSString stringWithFormat:@"%@", info];
        } else {
            return defaultString;
        }
    }

    return [NSString stringWithFormat:@"%@", info];
}


@end


