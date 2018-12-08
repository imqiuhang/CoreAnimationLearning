//
//  NSArray+DataSecurity.m
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import "NSArray+DataSecurity.h"

@implementation NSArray (DataSecurity)


- (id)qh_objAtIndex:(NSUInteger)index {
    if (index>=[((NSArray *)self) count]) {
        return nil;
    }
    
    return ((NSArray *)self)[index];
}

- (NSUInteger)qh_count {
    return self.count;
}


- (__kindof NSArray *)qh_arrayByAddObject:(id)obj {
    if (!obj) {
        return (NSArray *)self;
    }
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) addObject:obj];
        return [(NSMutableArray *)self copy];
    }
    
    NSMutableArray *tmpMuArray = [[NSMutableArray alloc] initWithArray:(NSArray *)self];
    [tmpMuArray addObject:obj];
    return [tmpMuArray copy];
    
    
}

- (__kindof NSArray *)qh_arrayByRemoveObject:(id)obj {
    
    if (!obj) {
        return (NSArray *)self;
    }
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) removeObject:obj];
        return [(NSMutableArray *)self copy];
    }
    
    NSMutableArray *tmpMuArray = [[NSMutableArray alloc] initWithArray:(NSArray *)self];
    [tmpMuArray removeObject:obj];
    return [tmpMuArray copy];
}

- (__kindof NSArray *)qh_arrayByRemoveObjectAtIndex:(NSInteger)index {
    if (index<0||index==NSNotFound||index>=((NSArray *)self).count) {
        return (NSArray *)self;
    }

    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) removeObjectAtIndex:index];
        return [(NSMutableArray *)self copy];
    }
    
    NSMutableArray *tmpMuArray = [[NSMutableArray alloc] initWithArray:(NSArray *)self];
    [tmpMuArray removeObjectAtIndex:index];
    return [tmpMuArray copy];
}

- (__kindof NSArray *)qh_arrayByReplaceObjectAtIndex:(NSInteger)index withObject:(id)object {
    
    if (index<0||index==NSNotFound||index>=((NSArray *)self).count) {
        return (NSArray *)self;
    }
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) replaceObjectAtIndex:index withObject:object];
        return [(NSMutableArray *)self copy];
    }
    
    NSMutableArray *tmpMuArray = [[NSMutableArray alloc] initWithArray:(NSArray *)self];
    [tmpMuArray replaceObjectAtIndex:index withObject:object];
    return [tmpMuArray copy];
    
}

- (__kindof NSArray *)qh_arrayByInsertObject:(id)obj atIndex:(int)index {
    
    if (index<0||index==NSNotFound||index>=((NSArray *)self).count) {
        return (NSArray *)self;
    }
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *)self) insertObject:obj atIndex:index];
        return [(NSMutableArray *)self copy];
    }
    
    NSMutableArray *tmpMuArray = [[NSMutableArray alloc] initWithArray:(NSArray *)self];
    [tmpMuArray insertObject:obj atIndex:index];
    return [tmpMuArray copy];
    
}


- (BOOL)isEqualIgnoreOrderWithArray:(NSArray *)otherArray {
    if (!otherArray) {
        return NO;
    }
    
    if(![otherArray isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if(self.count!=otherArray.count) {
        return NO;
    }
    
    return  [[NSSet setWithArray:self] isEqualToSet:[NSSet setWithArray:otherArray]];
}

- (BOOL)containStringByCaseInsensitive:(NSString *)string {
    for(id object in self) {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToStringByCaseInsensitive:string]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSInteger)indexOfStringByCaseInsensitive:(NSString *)string {
    for(int i=0;i<self.count;i++) {
        if ([self[i] isKindOfClass:[NSString class]]&&[self[i] isEqualToStringByCaseInsensitive:string]) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSArray *)shuffle {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    for (NSUInteger i = array.count; i > 1; i--) {
        [array exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    
    return [array copy];
}

- (id)randomObject {
    if (!self.count) {
        return nil;
    }
    
    return self[[CommUtil randomNumberIncludeFrom:0 includeTo:(int)self.count-1]];
}


@end


@implementation NSObject(ArrayDataSecurity)

- (id)qh_objAtIndex:(NSUInteger)index{return nil;}
- (NSUInteger)qh_count{return 0;}
- (__kindof NSArray *)qh_arrayByAddObject:(id)obj{return nil;}
- (__kindof NSArray *)qh_arrayByRemoveObject:(id)obj{return nil;}
- (__kindof NSArray *)qh_arrayByRemoveObjectAtIndex:(NSInteger)index{return nil;}
- (BOOL)isEqualIgnoreOrderWithArray:(NSArray *)otherArray{return NO;}
- (NSArray *)qh_arrayByReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object {return nil;}
- (NSArray *)shuffle{return nil;}
- (id)randomObject{return nil;}
- (__kindof NSArray *)qh_arrayByInsertObject:(id)obj atIndex:(int)index{return nil;}
- (BOOL)containStringByCaseInsensitive:(NSString *)string{return NO;}
- (NSInteger)indexOfStringByCaseInsensitive:(NSString *)string{return  NSNotFound;}
@end


