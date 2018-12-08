//
//  UIButton+ButtonExtension.m
//  imqiuhang
//
//  Created by imqiuhang on 15/8/17.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "UIButton+ButtonExtension.h"

@implementation UIButton (ButtonExtension)

- (void)setNormalTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setNormalImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)bgColor radius:(float)radius {
    
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = font;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    if (bgColor) {
        self.backgroundColor = bgColor;
    }
    
    if (radius>=0) {
        self.layer.cornerRadius = radius;
    }
}

- (void)removeAllActionforControlEvent:(UIControlEvents)controlEvent target:(id)target {
    if (!target) {
        return;
    }
    
    NSArray *actionNames = [self actionsForTarget:target forControlEvent:controlEvent];
    
    
    for(NSString *actionName in actionNames) {
        if ([actionName isNotBlank]) {
            [self removeTarget:target action:NSSelectorFromString(actionName) forControlEvents:controlEvent];
        }
    }
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor highlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    self.backgroundColor = nil;
    [self setBackgroundImage:[UIImage imageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor highlightedTitleColor:(UIColor *)highlightedTitleColor {
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

@end
