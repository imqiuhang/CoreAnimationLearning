//
//  UIView+QHCirclefFillOutRevealAnimationView.m
//  Framework
//
//  Created by imqiuhang on 16/4/1.
//  Copyright © 2016年 imqiuhang. All rights reserved.
//

#import "UIView+QHCirclefFillOutRevealAnimation.h"

@interface QHCirclefFillOutRevealAnimationView ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, assign) CGFloat outsideDiameter;

@end

@implementation QHCirclefFillOutRevealAnimationView

- (instancetype)initWithTargetView:(UIView *)view duration:(NSTimeInterval)duration {
    if (self = [super initWithFrame:view.bounds]) {
        _animationDuration = duration;
        self.outsideDiameter = sqrt(self.width*self.width + self.height*self.height);
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

- (void)beganRevealAnimation {
    
    self.backgroundColor = [UIColor clearColor];
    [self.circleLayer removeFromSuperlayer];
    self.superview.layer.mask = self.circleLayer;
    
    //让圆的变大的动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    UIBezierPath *toPath = [self pathWithDiameter:self.outsideDiameter];
    pathAnimation.toValue = (id)toPath.CGPath;
    pathAnimation.duration = self.animationDuration;
 
    //让圆的线的宽度变大的动画，效果是内圆变小
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(lineWidth))];
    lineWidthAnimation.toValue = @(self.outsideDiameter);
    lineWidthAnimation.duration = self.animationDuration;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[pathAnimation, lineWidthAnimation];
    group.removedOnCompletion = NO;//这两句的效果是让动画结束后不会回到原处，必须加
    group.duration = self.animationDuration;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    [self.circleLayer addAnimation:group forKey:@"revealAnimation"];
}

///根据直径生成圆的path
- (UIBezierPath *)pathWithDiameter:(CGFloat)diameter {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake((CGRectGetWidth(self.bounds) - diameter) / 2, (CGRectGetHeight(self.bounds) - diameter) / 2, diameter, diameter)];
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.superview.layer.mask = nil;
    [self removeFromSuperview];
}

#pragma mark - property

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _circleLayer.path = [self pathWithDiameter:0].CGPath;
    }
    return _circleLayer;
}

@end


@implementation UIView (QHCirclefFillOutRevealAnimation)

NSInteger const kRevealViewTag = 9527;

- (void)setupForRevealAnimationWithDuration:(NSTimeInterval)duration {
    QHCirclefFillOutRevealAnimationView *revealView = [[QHCirclefFillOutRevealAnimationView alloc] initWithTargetView:self duration:duration];
    revealView.tag = kRevealViewTag;
    [self addSubview:revealView];
    [self bringSubviewToFront:revealView];
}

- (void)beganRevealAnimation {
    QHCirclefFillOutRevealAnimationView *revealView = (QHCirclefFillOutRevealAnimationView *)[self viewWithTag:kRevealViewTag];
    [revealView beganRevealAnimation];
}

@end
