//
//  CAEmitterCellDemoViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/18.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "CAEmitterCellDemoViewController.h"

#define ScreenWidth               [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight              [[UIScreen mainScreen] bounds].size.height
#define APP_MAIN_WINDOW  [UIApplication sharedApplication].delegate.window


@interface CAEmitterCellDemoViewController ()

@end

@implementation CAEmitterCellDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarButtonTitle:@"发射"];
    self.view.backgroundColor = [UIColor blackColor];
    [self snow];
}

- (void)rightBarButtonDidSelected {
    [self rocket];
}

- (void)snow {
    
    CGRect emitterFrame =  APP_MAIN_WINDOW.bounds;
    
    ///生成发射器
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = emitterFrame;
    emitter.emitterPosition = CGPointMake(ScreenWidth/2.f, 0);
    emitter.emitterSize = emitterFrame.size;
    emitter.emitterMode = kCAEmitterLayerVolume;//发射模式
    emitter.emitterShape = kCAEmitterLayerLine;//发射源的形状
    [APP_MAIN_WINDOW.layer addSublayer:emitter];
    emitter.renderMode = kCAEmitterLayerAdditive;
    
    //发射器里面的粒子
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"icon_snowflake"].CGImage;
    cell.name = @"snow";
    cell.birthRate = 10;
    cell.lifetime = 50.f ;
    cell.velocity = 50;
    float minSize = 0.05f;
    float maxSize = 0.35f;
    cell.scale = (maxSize+minSize)/2.f;
    cell.scaleRange = (maxSize - minSize)/2.f;
    cell.velocityRange = 20;
    cell.emissionLongitude = M_PI;
    cell.emissionRange = M_PI/4 ;
    cell.spin = M_PI/12; // 子旋转角度
    cell.spinRange = M_PI/12;
    emitter.emitterCells = @[cell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ///停止发射器的
        [emitter setValue:@(0) forKeyPath:@"emitterCells.snow.birthRate"];
    });
}

- (void)rocket {
    
    ///创建
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    fireworksEmitter.emitterSize = CGSizeZero;
    fireworksEmitter.emitterMode = kCAEmitterLayerOutline;//发射模式
    fireworksEmitter.emitterShape = kCAEmitterLayerLine;//发射源的形状
    
    fireworksEmitter.frame = APP_MAIN_WINDOW.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(ScreenWidth/2.f, ScreenHeight-80);
    fireworksEmitter.renderMode = kCAEmitterLayerAdditive;//发射源的渲染模式
    fireworksEmitter.seed = (arc4random()%100)+1;
    [APP_MAIN_WINDOW.layer addSublayer:fireworksEmitter];
    
    //火箭
    CAEmitterCell* rocket  = [CAEmitterCell emitterCell];
    rocket.name = @"rocket";
    rocket.birthRate = 3;
    rocket.velocity = 500;
    rocket.velocityRange = 80;
    rocket.yAcceleration = 75;
    rocket.lifetime = 1.02;
    rocket.contents = (id) [[UIImage imageNamed:@"icon_fireworks_rocket"] CGImage];
    rocket.scale = 0.6;
    rocket.emissionRange = (M_PI/6); // 周围发射角度
    
    rocket.emissionLongitude = -M_PI/25;
    
    //爆炸
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    burst.birthRate = 1.0;
    burst.velocity = 0;
    burst.scale = 0.2;
    burst.lifetime = 0.15;
    
    //烟花
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    spark.birthRate = 400;
    spark.velocity = 125;
    spark.emissionRange = 2* M_PI;
    spark.yAcceleration = 75;
    spark.lifetime = 3;
    spark.contents = (id) [[UIImage imageNamed:@"icon_fireworks_flower"] CGImage];
    spark.scaleSpeed =-0.2;
    spark.greenSpeed =0.5;
    spark.redSpeed = 1;
    spark.blueSpeed = 0;
    spark.alphaSpeed =-0.45;
    spark.spin = 2* M_PI;
    spark.spinRange = 2* M_PI;
    spark.scale = 3.f;
    spark.alphaRange = 0.3;
    
    ///把烟花，爆炸等各种粒子组加入到发射器里
    fireworksEmitter.emitterCells = [NSArray arrayWithObject:rocket];
    rocket.emitterCells = [NSArray arrayWithObject:burst];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fireworksEmitter setValue:@(0) forKeyPath:@"emitterCells.rocket.birthRate"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fireworksEmitter removeFromSuperlayer];
    });
}

@end
