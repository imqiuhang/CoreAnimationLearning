//
//  UILabel+LabelExtension.m
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import "UILabel+LabelExtension.h"

@implementation UILabel (LabelExtension)


- (void)setText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    self.text      = text;
    self.font      = font;
    self.textColor = color;
}

- (void)setStrikethroughStyleText:(NSString *)text {
    if (![text isNotBlank]) {
        return;
    }
    [self setStrikethroughStyleText:text range:NSMakeRange(0, text.length)];
}

- (void)setStrikethroughStyleText:(NSString *)text range:(NSRange)range {
    
    if (![text isNotBlank]) {
        return;
    }
    
    self.text = @"";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    
    ///兼容iOS 10.3SDK的删除线bug
    ///@see https://stackoverflow.com/questions/43070335/nsstrikethroughstyleattributename-how-to-strike-out-the-string-in-ios-10-3
    [attributedString addAttributes:@{NSBaselineOffsetAttributeName:@(0)} range:range];
    
    self.attributedText = attributedString.copy;
}

+ (float)heightWithAttributedString:(NSAttributedString *)att width:(float)width {
        
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    stringLabel.attributedText = att;
    return [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

@end
