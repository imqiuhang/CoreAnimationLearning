//
//  NSArray+DataSecurity.h
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<__covariant ObjectType> (DataSecurity)

- (ObjectType)qh_objAtIndex:(NSUInteger)index;

- (NSUInteger)qh_count;
- (__kindof NSArray *)qh_arrayByAddObject:(id)obj;
- (__kindof NSArray *)qh_arrayByInsertObject:(id)obj atIndex:(int)index;
- (__kindof NSArray *)qh_arrayByRemoveObject:(id)obj;
- (__kindof NSArray *)qh_arrayByRemoveObjectAtIndex:(NSInteger)index;
- (__kindof NSArray *)qh_arrayByReplaceObjectAtIndex:(NSInteger)index withObject:(id)object;

- (BOOL)isEqualIgnoreOrderWithArray:(NSArray *)otherArray;
- (BOOL)containStringByCaseInsensitive:(NSString *)string;
- (NSInteger)indexOfStringByCaseInsensitive:(NSString *)string;

- (ObjectType)randomObject;
- (NSArray *)shuffle;///返回随机打乱顺序

@end


@interface NSObject(ArrayDataSecurity)

- (id)qh_objAtIndex:(NSUInteger)index;
- (NSUInteger)qh_count;
- (__kindof NSArray *)qh_arrayByAddObject:(id)obj;
- (__kindof NSArray *)qh_arrayByRemoveObject:(id)obj;
- (__kindof NSArray *)qh_arrayByRemoveObjectAtIndex:(NSInteger)index;
- (BOOL)isEqualIgnoreOrderWithArray:(NSArray *)otherArray;
- (__kindof NSArray *)qh_arrayByReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
- (__kindof NSArray *)qh_arrayByInsertObject:(id)obj atIndex:(int)index;
- (BOOL)containStringByCaseInsensitive:(NSString *)string;
- (NSInteger)indexOfStringByCaseInsensitive:(NSString *)string;
- (id)randomObject;
- (NSArray *)shuffle;

@end
