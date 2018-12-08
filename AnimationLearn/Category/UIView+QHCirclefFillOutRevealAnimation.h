//
//  UIView+QHCirclefFillOutRevealAnimationView.h
//  Framework
//
//  Created by imqiuhang on 16/4/1.
//  Copyright © 2016年 imqiuhang. All rights reserved.
//

@interface QHCirclefFillOutRevealAnimationView : UIView

- (instancetype)initWithTargetView:(UIView *)view duration:(NSTimeInterval)duration;
- (void)beganRevealAnimation;
@property (nonatomic,readonly)NSTimeInterval animationDuration;

@end


@interface UIView (QHCirclefFillOutRevealAnimation)

- (void)setupForRevealAnimationWithDuration:(NSTimeInterval)duration;

- (void)beganRevealAnimation;

@end
