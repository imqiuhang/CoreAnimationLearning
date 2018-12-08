//
//  UITextField+Shake.m
//  UITextField+Shake
//
//  Created by Andrea Mazzini on 08/02/14.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

#import "UIView+Shake.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIView (Shake)

- (void)shake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self _shake:5 direction:1 currentTimes:0 withDelta:8 speed:0.04];
}

- (void)_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval{
    
    [UIView animateWithDuration:interval animations:^{
        self.transform = CGAffineTransformMakeTranslation(delta * direction, 0);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:NULL];
            return;
        }
        [self _shake:times
           direction:direction * -1
        currentTimes:current + 1
           withDelta:delta
               speed:interval
         ];
    }];
}

@end
