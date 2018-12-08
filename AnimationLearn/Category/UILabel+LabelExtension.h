//
//  UILabel+LabelExtension.h
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//


@interface UILabel (LabelExtension)

- (void)setText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;
- (void)setStrikethroughStyleText:(NSString *)text;
- (void)setStrikethroughStyleText:(NSString *)text range:(NSRange)range;

+ (float)heightWithAttributedString:(NSAttributedString *)att width:(float)width;

@end
