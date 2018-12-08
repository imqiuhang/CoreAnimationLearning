//
//  RootViewController.h
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/9.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController


@property (nonatomic,strong)UIButton * rightBarButton;
@property (nonatomic,strong)UIButton * leftBarButton;

- (void)rightBarButtonDidSelected ;
- (void)setRightBarButtonTitle:(NSString *)title;
- (void)setRightBarButtonImage:(UIImage *)image;
- (void)setRightBarButtonImage:(UIImage *)image imageRenderingMode:(UIImageRenderingMode)imageRenderingMode;

- (void)setLeftBarButtonImage:(UIImage *)image;
- (void)setLeftBarButtonTitle:(NSString *)title;
- (void)setLeftBarButtonImage:(UIImage *)image imageRenderingMode:(UIImageRenderingMode)imageRenderingMode;
- (void)back;
- (void)setup;

- (void)addTextDescrib:(NSString *)describ;
- (void)remakeDescribLabelTopWithOffset:(CGFloat)offset;
@end

