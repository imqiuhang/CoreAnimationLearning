//
//  UIScrollView+ScrollViewExtension.m
//  imqiuhang
//
//  Created by imqiuhang on 14/12/15.
//  Copyright (c) 2014年 imqiuhang. All rights reserved.
//


#import "UIScrollView+ScrollViewExtension.h"



@implementation UIScrollView (ScrollViewExtension)

- (void)qh_scrollToTop {
    [self qh_scrollToTopAnimated:YES];
}

- (void)qh_scrollToBottom {
    [self qh_scrollToBottomAnimated:YES];
}

- (void)qh_scrollToLeft {
    [self qh_scrollToLeftAnimated:YES];
}

- (void)qh_scrollToRight {
    [self qh_scrollToRightAnimated:YES];
}

- (void)qh_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)qh_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)qh_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)qh_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
