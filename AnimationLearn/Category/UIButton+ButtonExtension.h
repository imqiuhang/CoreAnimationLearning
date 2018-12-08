//
//  UIButton+ButtonExtension.h
//  imqiuhang
//
//  Created by imqiuhang on 15/8/17.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//


@interface UIButton (ButtonExtension)

///[self setTitle:title forState:UIControlStateNormal];
- (void)setNormalTitle:(NSString *)title;
- (void)setNormalImage:(UIImage *)image;
///快速设置
- (void)setTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor radius:(float)radius;

- (void)removeAllActionforControlEvent:(UIControlEvents)controlEvent target:(id)target;

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor highlightedBackgroundColor:(UIColor *)highlightedBackgroundColor;

- (void)setNormalTitleColor:(UIColor *)normalTitleColor highlightedTitleColor:(UIColor *)highlightedTitleColor;

@end
