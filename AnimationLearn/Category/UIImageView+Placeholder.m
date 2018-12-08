//
//  UIImageView+Placeholder.m
//  imqiuhang
//
//  Created by imqiuhang on 15/7/31.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "UIImageView+Placeholder.h"
#define qh_image_placeholder_tag 38493264

@implementation UIImageView (Placeholder)


- (void)setImageUsingAutoSizePlaceholder:(UIImage *)placeholder URL:(NSURL *)imgURL {
    [self setImageUsingAutoSizePlaceholder:placeholder URL:imgURL backgroundColor:nil];
}

- (void)setImageUsingAutoSizePlaceholder:(UIImage *)placeholder URL:(NSURL *)imgURL backgroundColor:(UIColor *)bgColor {
    [self setImageUsingAutoSizePlaceholder:placeholder URL:imgURL backgroundColor:bgColor andCompletedBgColor:[UIColor clearColor]];
}

- (void)setImageUsingPlaceholderBgColorWithURL:(NSURL *)imgURL {
    [self setImageUsingAutoSizePlaceholder:nil URL:imgURL backgroundColor:BS_COLOR_PlaceHolder];
}

- (void)setImageUsingAutoSizePlaceholder:(UIImage *)placeholder URL:(NSURL *)imgURL backgroundColor:(UIColor *)bgColor andCompletedBgColor:(UIColor *)cbgColor{
    if (bgColor) {
        self.backgroundColor = bgColor;
    }
    
    if (placeholder) {
        [self addPlaceholderImageView:placeholder];
    }
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:imgURL
            placeholderImage:nil
                     options:SDWebImageRetryFailed
                    progress:^(NSInteger receivedSize, NSInteger expectedSize,NSURL *targetURL) {

                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (!error) {
                            [weakSelf removePlaceholderImageView];
                            if (cbgColor) {
                                self.backgroundColor = cbgColor;
                            }
                        }
                        
                    }];
    
}

- (void)addPlaceholderImageView:(UIImage *)placeholder {
    if ([self viewWithTag:qh_image_placeholder_tag]!=nil||placeholder==nil) {
        return;
    }
    UIImageView *placeholderimageView = [[UIImageView alloc] init];
    placeholderimageView.size         = placeholder.size;
    placeholderimageView.centerX      = self.width/2.f;
    placeholderimageView.centerY      = self.height/2.f;
    placeholderimageView.tag          = qh_image_placeholder_tag;
    placeholderimageView.image        = placeholder;
    placeholderimageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:placeholderimageView];
    
}

- (void)removePlaceholderImageView {
    [[self viewWithTag:qh_image_placeholder_tag] removeFromSuperview];
}

@end
