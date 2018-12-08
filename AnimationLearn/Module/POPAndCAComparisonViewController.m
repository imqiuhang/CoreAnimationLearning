//
//  POPAndCAComparisonViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/18.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "POPAndCAComparisonViewController.h"

@interface POPAndCAComparisonViewController ()



@end

@implementation POPAndCAComparisonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *caView = [[UIView alloc]initWithFrame:CGRectMake(50,100, 100, 100)];
    caView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:caView];
    CABasicAnimation *caAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    caAnimation.toValue = @(M_PI);
    caAnimation.duration = 2.0;
    caAnimation.repeatCount = 500;
    [caView.layer addAnimation:caAnimation forKey:@"anim"];
    
    
    UIView *popView = [[UIView alloc]initWithFrame:caView.frame];
    popView.left =  caView.right +50;
    popView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:popView];
    POPBasicAnimation *popAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    popAnimation.toValue = @(M_PI);
    popAnimation.duration = 2.0;
    popAnimation.repeatCount = 500;
    [popView.layer pop_addAnimation:popAnimation forKey:@"rotation"];
    popAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self addTextDescrib:@"左边是个带有CA动画的view，右边是POP动画的view，sleep 5秒"];
    [self remakeDescribLabelTopWithOffset:popView.bottom+20];

    //5秒后可以直接手动断点调试,效果也一样
}

//sleep 5秒
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    sleep(5);
}

@end
