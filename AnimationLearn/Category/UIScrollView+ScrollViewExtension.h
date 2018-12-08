//
//  UIScrollView+ScrollViewExtension.h
//  imqiuhang
//
//  Created by imqiuhang on 14/12/15.
//  Copyright (c) 2014年 imqiuhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIScrollView (ScrollViewExtension)

//滚动到相应位置 animated:YES
- (void)qh_scrollToTop;
- (void)qh_scrollToBottom;
- (void)qh_scrollToLeft;
- (void)qh_scrollToRight;

- (void)qh_scrollToTopAnimated:(BOOL)animated;
- (void)qh_scrollToBottomAnimated:(BOOL)animated;
- (void)qh_scrollToLeftAnimated:(BOOL)animated;
- (void)qh_scrollToRightAnimated:(BOOL)animated;

@end

