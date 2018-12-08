//
//  NSTimer+Block.h
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end
