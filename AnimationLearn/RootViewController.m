//
//  RootViewController.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/9.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "RootViewController.h"
typedef enum  {
    RootBarButtonPositionLeft  = 0,
    RootBarButtonPositionRight = 1
}RootBarButtonPosition;

@interface RootViewController ()
@property (nonatomic,strong)UILabel *bottomLabel;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomLabel = [UILabel new];
    self.bottomLabel.font = [UIFont systemFontOfSize:18];
    self.bottomLabel.textColor = [UIColor blackColor];
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).inset(15);
        make.centerY.equalTo(self.view);
    }];
    [self setup];
}

#pragma mark - BarButton
- (void)rightBarButtonDidSelected {}
- (void)setLeftBarButtonTitle:(NSString *)title {
    [self setBarButtonWithButtonPosition:RootBarButtonPositionLeft value:title];
}

- (void)setLeftBarButtonImage:(UIImage *)image {
    [self setLeftBarButtonImage:image imageRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setLeftBarButtonImage:(UIImage *)image imageRenderingMode:(UIImageRenderingMode)imageRenderingMode {
    [self setBarButtonWithButtonPosition:RootBarButtonPositionLeft value:[image imageWithRenderingMode:imageRenderingMode]];
}

- (void)setRightBarButtonImage:(UIImage *)image {
    [self setRightBarButtonImage:image imageRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setRightBarButtonImage:(UIImage *)image imageRenderingMode:(UIImageRenderingMode)imageRenderingMode {
    [self setBarButtonWithButtonPosition:RootBarButtonPositionRight value:[image imageWithRenderingMode:imageRenderingMode]];
}

- (void)setRightBarButtonTitle:(NSString *)title {
    [self setBarButtonWithButtonPosition:RootBarButtonPositionRight value:title];
}

- (void)setBarButtonWithButtonPosition:(RootBarButtonPosition)barButtonPosition value:(id)value {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (barButtonPosition==RootBarButtonPositionLeft) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else{
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    //    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.tintColor = [UIColor blackColor];
    UIBarButtonItem *navBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setNormalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:UIColor.redColor];
    if ([value isKindOfClass:[UIImage class]]) {
        [button setImage:value forState:UIControlStateNormal];
    }else if ([value isKindOfClass:[NSString class]]) {
        [button setTitle:value forState:UIControlStateNormal];
    }
    
    [button sizeToFit];
    
    [button addTarget:self action:barButtonPosition==RootBarButtonPositionLeft?@selector(back):@selector(rightBarButtonDidSelected) forControlEvents:UIControlEventTouchUpInside];
    
    if (barButtonPosition==RootBarButtonPositionLeft) {
        self.leftBarButton = button;
        //        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //        space.width = 0;
        self.navigationItem.leftBarButtonItem = navBtnItem;
    }else {
        self.rightBarButton = button;
        self.navigationItem.rightBarButtonItem = navBtnItem;
    }
}

-(void)setRightBarButton:(UIButton *)rightBarButton{
    _rightBarButton = rightBarButton;
    [_rightBarButton addTarget:self action:@selector(rightBarButtonDidSelected) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
}

- (void)back {
    if (self.navigationController.viewControllers.count==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setup{}

- (void)addTextDescrib:(NSString *)describ {
    self.bottomLabel.text = describ;
}

- (void)remakeDescribLabelTopWithOffset:(CGFloat)offset {
    [self.bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).inset(15);
        make.top.equalTo(self.view).inset(offset);
    }];
    [self setup];
}

@end
