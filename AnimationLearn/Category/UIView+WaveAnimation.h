//
//  UIView+WaveAnimation.h
//  BagStore
//
//  Created by imqiuhang on 2018/1/8.
//  Copyright © 2018年 Framework. All rights reserved.
//


@class WaveAnimationOption;

@interface UIView (WaveAnimation)

///animationOptions 多层波纹
- (void)addWaveAnimationWithOptions:(NSArray <WaveAnimationOption *>*)animationOptions color:(UIColor *)color;

@end


@interface WaveAnimationOption : NSObject

@property (nonatomic)float diameter;///波纹的半径
@property (nonatomic)float duration;///波纹的动画时间

+ (instancetype)optionWithDiameter:(float)diameter duration:(float)duration;

@end
