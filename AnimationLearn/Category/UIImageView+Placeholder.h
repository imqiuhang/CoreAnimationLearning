//
//  UIImageView+Placeholder.h
//  imqiuhang
//
//  Created by imqiuhang on 15/7/31.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "UIImageView+WebCache.h"

@interface UIImageView (Placeholder)

- (void)setImageUsingAutoSizePlaceholder:(UIImage *)placeholder URL:(NSURL *)imgURL;

- (void)setImageUsingAutoSizePlaceholder:(UIImage *)placeholder URL:(NSURL *)imgURL backgroundColor:(UIColor*)bgColor;

- (void)setImageUsingAutoSizePlaceholder:(UIImage *)placeholder URL:(NSURL *)imgURL backgroundColor:(UIColor *)bgColor andCompletedBgColor:(UIColor *)cbgColor;

//使用默认背景色填充
- (void)setImageUsingPlaceholderBgColorWithURL:(NSURL *)imgURL;

@end
