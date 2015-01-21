//
// Created by djzhang on 1/1/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MultipleTypeHelper.h"
#import "ABOnlineVideoType.h"
#import "ABProjectType.h"


@implementation MultipleTypeHelper {

}

+ (NSMutableArray *)getSingleOnlineVideoTypesArray:(NSMutableArray *)array {
    NSMutableArray *singleArray = [[NSMutableArray alloc] init];

    for (ABOnlineVideoType *onlineVideoType in array) {
        [self checkExistAndAppend:onlineVideoType to:singleArray from:array];
    }

    return singleArray;
}


+ (void)checkExistAndAppend:(ABOnlineVideoType *)onlineVideoType to:(NSMutableArray *)singleArray from:(NSMutableArray *)array {

    ABOnlineVideoType *lastVideoType = [self checkExist:onlineVideoType.sqliteObjectName in:singleArray];

    if(lastVideoType) {
        [self copyCurrentTypeDictionary:onlineVideoType.onlineTypeDictionary toLastProjectTypeDictionary:lastVideoType.onlineTypeDictionary];
    } else {
        [singleArray addObject:onlineVideoType];
    }

}

//(5+6)-3=11-3=8(5)
+ (void)copyCurrentTypeDictionary:(NSMutableDictionary *)newDictionary toLastProjectTypeDictionary:(NSMutableDictionary *)lastDictionary {
    for (NSString *key in newDictionary.allKeys) {
        ABProjectType *object = [newDictionary objectForKey:key];

        if([[lastDictionary allKeys] containsObject:key]) {
            ABProjectType *lastObject = [lastDictionary objectForKey:key];
            [lastObject addLastSqliteObjectArray:object.sqliteObjectArray];

            continue;
        }

        // or replace
        [lastDictionary setObject:object forKey:key];
    }
}


+ (ABOnlineVideoType *)checkExist:(NSString *)onlineVideoTypeName in:(NSMutableArray *)singleArray {
    for (ABOnlineVideoType *onlineVideoType in singleArray) {
        if([onlineVideoTypeName isEqualToString:onlineVideoType.sqliteObjectName]) {
            return onlineVideoType;
        }
    }

    return nil;
}


@end
