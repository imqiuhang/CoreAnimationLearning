//
//  UITextField+TextFieldExtension.h
//  BagStore
//
//  Created by imqiuhang on 2017/6/27.
//  Copyright © 2017年 Framework. All rights reserved.
//


@interface UITextField (TextFieldExtension)


//使textField文本的左边间距右移一段距离，默认的一般间距太小
- (void)adjustLeftViewWithWidth:(CGFloat)width;
- (void)setCustomPlaceholderWithPlaceholder:(NSString *)placeholder font:(UIFont *)font color:(UIColor *)placeholderColor;

@end
