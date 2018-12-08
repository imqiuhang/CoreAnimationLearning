//
//  NSObject+ObjectExtend.h
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (ObjectExtend)

///调换实例的方法
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

///调换类的方法
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

///设置关联属性
- (void)setAssociateValue:(id)value withKey:(void *)key;
- (void)setAssociateWeakValue:(id)value withKey:(void *)key;
- (id)getAssociatedValueForKey:(void *)key;
- (void)removeAssociatedValues;

//- (id)deepCopy;
//
//- (id)deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;

@end



@interface NSObject(KVO)

///键值对观察
- (void)addObserverBlockForKeyPath:(NSString*)keyPath
                             block:(void (^)(id  obj, id  oldVal, id  newVal))block;

- (void)removeObserverBlocksForKeyPath:(NSString*)keyPath;

- (void)removeObserverBlocks;

@end
