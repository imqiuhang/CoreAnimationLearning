//
//  LayerDelegateTestViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/12.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "LayerDelegateTestViewController.h"

@interface LayerDelegateTestViewController ()

@property (nonatomic,strong)UIView  *view1;//view
@property (nonatomic,strong)CALayer *layer1;//layer


@end

@implementation LayerDelegateTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarButtonTitle:@"change"];
    [self addTextDescrib:@"左变放一个layer，右边放一个view1，改变view1的layer的delegate是否为nil"];
    
    /* 左边放一个layer */
    self.layer1 = [CALayer layer];
    self.layer1.frame = CGRectMake(15, 100, 150, 150);
    self.layer1.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.layer1];
    
    /* 右边放一个View*/
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 150, 150)];
    self.view1.backgroundColor = [UIColor yellowColor];
    self.view1.right = self.view.width - 15;
    [self.view addSubview:self.view1];
    
    /*改变view的layer的delegate是否为nil*/
    UIButton *button = [UIButton new];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-90);
    }];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"现在view1的layer的delegate为view1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setViewDelegate:) forControlEvents:UIControlEventTouchUpInside];
    
    [self remakeDescribLabelTopWithOffset:self.view1.bottom + 50];
    
}

- (void)rightBarButtonDidSelected {
    
    UIColor *color = self.randomColor;
    self.view1.layer.backgroundColor = color.CGColor;
    self.layer1.backgroundColor = color.CGColor;
}

- (void)setViewDelegate:(UIButton *)sender {
    self.view1.layer.delegate = self.view1.layer.delegate?nil:self.view1;
    [sender setTitle:self.view1.layer.delegate?@"现在view1的layer的delegate为view1":@"现在view1的layer的delegate为nil" forState:UIControlStateNormal];
}

static BOOL colorflag;
- (UIColor *)randomColor {
    
    UIColor *color = colorflag?[UIColor redColor]:[UIColor blueColor];
    colorflag = !colorflag;
    return color;
    
}


@end
