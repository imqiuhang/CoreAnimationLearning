//
//  ExplicitTransactionViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/9.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "ExplicitTransactionViewController.h"

@interface ExplicitTransactionViewController ()

@property (nonatomic,strong)CALayer  *layer2;
@property (nonatomic,strong)CALayer *layer1;

@property (nonatomic,strong)UISwitch *switch1;

@end

@implementation ExplicitTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarButtonTitle:@"change"];
    [self addTextDescrib:@"左右各放一个layer，开关控制右边layer是否开启动作，改变backgroundColor属性的值"];
    
    /*左右各放一个layer*/
    
    self.layer1 = [CALayer layer];
    self.layer1.frame = CGRectMake(15, 100, 150, 150);
    self.layer1.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.layer1];
    
    self.layer2 = [CALayer layer];
    self.layer2.frame = CGRectMake(15, 100, 150, 150);
    self.layer2.right = self.view.width-15;
    self.layer2.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.layer2];
    
    /*开关控制右边layer是否开启动作*/
    self.switch1 = [UISwitch new];
    self.switch1.centerX= CGRectGetMidX(self.layer2.frame);
    self.switch1.top = self.layer2.bottom + 20;
    [self.view addSubview:self.switch1];
    
    [self remakeDescribLabelTopWithOffset:self.switch1.bottom+10];

}

- (void)rightBarButtonDidSelected {

    UIColor *color = self.randomColor;
    self.layer1.backgroundColor = color.CGColor;

    [CATransaction begin];
    [CATransaction setDisableActions:!self.switch1.on];/*默认是NO， 设置YES来禁用过度*/
    [CATransaction setAnimationDuration:0.25];/*默认的是0.25秒*/
    self.layer2.backgroundColor = color.CGColor;
    [CATransaction commit];
    
}


static BOOL colorflag;
- (UIColor *)randomColor {
    
    UIColor *color = colorflag?[UIColor redColor]:[UIColor blueColor];
    colorflag = !colorflag;
    return color;
    
}

@end
