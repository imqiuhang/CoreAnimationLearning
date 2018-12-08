//
//  UITextField+TextFieldExtension.m
//  BagStore
//
//  Created by imqiuhang on 2017/6/27.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import "UITextField+TextFieldExtension.h"

@implementation UITextField (TextFieldExtension)

- (void)adjustLeftViewWithWidth:(CGFloat)width {
    self.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    self.leftViewMode=UITextFieldViewModeAlways;
}

- (void)setCustomPlaceholderWithPlaceholder:(NSString *)placeholder font:(UIFont *)font color:(UIColor *)placeholderColor {
    
    self.placeholder = nil;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                      @{NSForegroundColorAttributeName:placeholderColor,
                                        NSFontAttributeName:font
                                        }];
    self.attributedPlaceholder = attrString;
}

@end
