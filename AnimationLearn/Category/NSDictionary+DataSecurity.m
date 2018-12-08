//
//  NSDictionary+DataSecurity.m
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import "NSDictionary+DataSecurity.h"

@implementation NSDictionary (DictionaryDataSecurity)
//请参照.h的文档
- (id)qh_objForKey:(id)key {
    if (!key) {
        return nil;
    }
    return ((NSDictionary *)self)[key];
}

//多级获取数据
- (id)qh_objForKeys:(id)key1, ... {
    
    if (!key1) {
        return nil;
    }
    
    va_list arguments;
    id eachKey;
    id obj;
    if (key1) {
        obj = [self qh_objForKey:key1];
        va_start(arguments, key1);
        while ((eachKey = va_arg(arguments, id))) {
            obj = [obj qh_objForKey:eachKey];
        }
        va_end(arguments);
    }
    
    return obj;
}

- (id)dictionaryByRemoveObjectForKey:(id)key {
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self];
    if (key) {
        [muDic removeObjectForKey:key];
    }
    return [muDic copy];
}

- (id)dictionaryByRemoveObjectForKeys:(id)key1, ...  {
    
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self];
    va_list arguments;
    id eachKey;

    if (key1) {
        [muDic removeObjectForKey:key1];
    }

    va_start(arguments, key1);
    while ((eachKey = va_arg(arguments, id))) {
        if (eachKey) {
            [muDic removeObjectForKey:eachKey];
        }
    }
    va_end(arguments);
  
    
    return [muDic copy];
}



- (id)dictionaryByRemoveNilAndBlankKeyValue {
    return [self dictionaryByRemoveNilKeyValueAndShouldRemoveBlankKeyValue:YES];
}

- (id)dictionaryByRemoveNilKeyValue {
    return [self dictionaryByRemoveNilKeyValueAndShouldRemoveBlankKeyValue:NO];
}

- (id)dictionaryByRemoveNilKeyValueAndShouldRemoveBlankKeyValue:(BOOL)removeBlankKeyValue {
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:self];
    NSMutableArray *removekeys = [NSMutableArray array];
    
    for(id key in self.allKeys) {
        id value  = [self objectForKey:key];
        if (!value||value==[NSNull null]||value==nil||value==NULL) {
            [removekeys addObject:key];
            continue;
        }
        
        if (removeBlankKeyValue&&[value isKindOfClass:[NSString class]]) {
            if (![value isNotBlank]) {
                [removekeys addObject:key];
                continue;
            }
        }
    }
    
    if (removekeys.count>0) {
        [muDic removeObjectsForKeys:removekeys];
    }
    
    return muDic.copy;
}

- (id)dictionaryByAddKeyValuesWithDictionary:(NSDictionary *)otherDictionary replaceExisValue:(BOOL)replaceExisValue {
    
    if (!otherDictionary||![otherDictionary isKindOfClass:[NSDictionary class]]||otherDictionary.count==0) {
        return self;
    }
    
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] initWithDictionary:self];
   
    for(id key in otherDictionary.allKeys) {
        if (![self objectForKey:key]||replaceExisValue) {
            [tmpDic setObject:[otherDictionary objectForKey:key] forKey:key];
        }
    }
    
    return [tmpDic copy];
}

@end


@implementation NSObject(DictionaryDataSecurity)

- (id)qh_objForKeys:(id)key1, ... NS_REQUIRES_NIL_TERMINATION {return nil;}
- (id)qh_objForKey:(id)key {return nil;}
- (id)dictionaryByRemoveObjectForKey:(id)key {return nil;}
- (id)dictionaryByRemoveObjectForKeys:(id)key1, ... NS_REQUIRES_NIL_TERMINATION {return nil;}
- (id)dictionaryByRemoveNilAndBlankKeyValue{return nil;}
- (id)dictionaryByAddKeyValuesWithDictionary:(NSDictionary *)otherDictionary replaceExisValue:(BOOL)replaceExisValue {return nil;}
- (id)dictionaryByRemoveNilKeyValue{return nil;}
@end
