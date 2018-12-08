//
//  LayerActionForLayerTestViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/13.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "LayerActionForLayerTestViewController.h"

@interface LayerActionForLayerTestViewController ()
@property (nonatomic,strong)UIView  *view1;//view
@end

@implementation LayerActionForLayerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 右边放一个View*/
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 150, 150)];
    self.view1.backgroundColor = [UIColor yellowColor];
    self.view1.right = self.view.width - 15;
    [self.view addSubview:self.view1];
    [self remakeDescribLabelTopWithOffset:self.view1.bottom+20];
    
    NSMutableString *logs = @"".mutableCopy;
    
    /*打印一下动画前后的改变*/
    [logs appendFormat:@"动画前：%@\n",[self.view1 actionForLayer:self.view1.layer forKey:@"backgroundColor"]];
    [self addTextDescrib:logs.copy];
    
    [UIView animateWithDuration:5 animations:^{
        self.view1.backgroundColor = [UIColor redColor];
       id value =  [self.view1 actionForLayer:self.view1.layer forKey:@"backgroundColor"];
        [logs appendString:[NSString stringWithFormat:@"添加动画后：%@",value]];
        [self addTextDescrib:logs.copy];
    }];
    

}


@end
