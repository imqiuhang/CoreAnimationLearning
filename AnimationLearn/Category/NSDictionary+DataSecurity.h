//
//  NSDictionary+DataSecurity.h
//  BagStore
//
//  Created by imqiuhang on 2017/6/26.
//  Copyright © 2017年 Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DictionaryDataSecurity)

- (id)qh_objForKeys:(id)key1, ... NS_REQUIRES_NIL_TERMINATION;

- (id)qh_objForKey:(id)key;

- (id)dictionaryByRemoveObjectForKey:(NSString *)key;

- (id)dictionaryByRemoveObjectForKeys:(id)key1, ... NS_REQUIRES_NIL_TERMINATION;

- (id)dictionaryByRemoveNilAndBlankKeyValue;
- (id)dictionaryByRemoveNilKeyValue;
//a+b
- (id)dictionaryByAddKeyValuesWithDictionary:(NSDictionary *)otherDictionary replaceExisValue:(BOOL)replaceExisValue;

@end

@interface NSObject(DictionaryDataSecurity)
- (id)qh_objForKeys:(id)key1, ... NS_REQUIRES_NIL_TERMINATION;
- (id)qh_objForKey:(id)key;
- (id)dictionaryByRemoveObjectForKey:(id)key;
- (id)dictionaryByRemoveObjectForKeys:(id)key1, ... NS_REQUIRES_NIL_TERMINATION;
- (id)dictionaryByRemoveNilAndBlankKeyValue;
- (id)dictionaryByRemoveNilKeyValue;
- (id)dictionaryByAddKeyValuesWithDictionary:(NSDictionary *)otherDictionary replaceExisValue:(BOOL)replaceExisValue;
@end
