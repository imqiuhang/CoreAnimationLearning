//
//  UIView+WaveAnimation.m
//  BagStore
//
//  Created by imqiuhang on 2018/1/8.
//  Copyright © 2018年 Framework. All rights reserved.
//

#import "UIView+WaveAnimation.h"

@implementation UIView (WaveAnimation)

- (void)addWaveAnimationWithOptions:(NSArray<WaveAnimationOption *> *)animationOptions color:(UIColor *)color{
    for(WaveAnimationOption *option in animationOptions) {
        [self addWaveAnimationWithOption:option color:color];
    }
}

- (void)addWaveAnimationWithOption:(WaveAnimationOption *) animationOption color:(UIColor *)color{
    
    CALayer *waveLayer = [CALayer layer];
    waveLayer.bounds = CGRectMake(0, 0, animationOption.diameter, animationOption.diameter);
    waveLayer.cornerRadius = animationOption.diameter / 2; //设置圆角变为圆形
    waveLayer.position = self.center;
    waveLayer.backgroundColor = color.CGColor;
    [self.layer insertSublayer:waveLayer atIndex:0];//把扩散层放到播放按钮下面
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationOption.duration;
    animationGroup.repeatCount = INFINITY; //重复无限次
    animationGroup.removedOnCompletion = NO;
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0; //开始的大小
    scaleAnimation.toValue = @1.0; //最后的大小
    scaleAnimation.duration = animationOption.duration;
    scaleAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.0; //开始的大小
    opacityAnimation.toValue = @0.0; //最后的大小
    opacityAnimation.duration = animationOption.duration;
    opacityAnimation.removedOnCompletion = NO;
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [waveLayer addAnimation:animationGroup forKey:@"kPulseAnimation"];
}

@end


@implementation WaveAnimationOption

+ (instancetype)optionWithDiameter:(float)diameter duration:(float)duration {
    WaveAnimationOption *option = [WaveAnimationOption new];
    option.diameter = diameter;
    option.duration = duration;
    return option;
}

@end
