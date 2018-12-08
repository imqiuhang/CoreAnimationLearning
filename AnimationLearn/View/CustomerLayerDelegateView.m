//
//  CustomerLayerDelegateView.m
//  AnimationLearn
//
//  Created by imqiuhang on 2018/11/12.
//  Copyright © 2018 imqiuhang. All rights reserved.
//

#import "CustomerLayerDelegateView.h"

@implementation CustomerLayerDelegateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.layer.delegate = self;
    }
    
    return self;
}


@end
