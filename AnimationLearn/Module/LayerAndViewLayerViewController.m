//
//  LayerAndViewLayerViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/9.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "LayerAndViewLayerViewController.h"
//@"layer和subview的layer属性改变"
@interface LayerAndViewLayerViewController ()

@property (nonatomic,strong)UIView  *view1;//view
@property (nonatomic,strong)CALayer *layer1;//layer

@end

@implementation LayerAndViewLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarButtonTitle:@"change"];
    [self addTextDescrib:@"左变放一个layer，右边放一个subview的layer，改变backgroundColor属性的值"];
    
    /* 左边放一个layer */
    self.layer1 = [CALayer layer];
    self.layer1.frame = CGRectMake(15, 100, 150, 150);
    self.layer1.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.layer1];
    
    /* 右边放一个View*/
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 150, 150)];
    self.view1.backgroundColor = [UIColor yellowColor];
    self.view1.right = self.view.width - 15;
//    [self.view addSubview:self.view1];
    [self.view.layer addSublayer:self.view1.layer];
    
    [self remakeDescribLabelTopWithOffset:self.view1.bottom];
}

- (void)rightBarButtonDidSelected {
    
    UIColor *color = self.randomColor;
    self.view1.layer.backgroundColor = color.CGColor;
    self.layer1.backgroundColor = color.CGColor;
}


static BOOL colorflag;
- (UIColor *)randomColor {
    
    UIColor *color = colorflag?[UIColor redColor]:[UIColor blueColor];
    colorflag = !colorflag;
    return color;
    
}

@end

