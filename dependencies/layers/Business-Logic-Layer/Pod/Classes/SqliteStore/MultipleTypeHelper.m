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
   NSMutableArray * singleOnlineVideoTypesArray = [[NSMutableArray alloc] init];

   for (ABOnlineVideoType * onlineVideoType in array) {
      [MultipleTypeHelper checkExistAndAppend:onlineVideoType to:singleOnlineVideoTypesArray from:array];
   }

   return singleOnlineVideoTypesArray;
}


+ (void)checkExistAndAppend:(ABOnlineVideoType *)onlineVideoType to:(NSMutableArray *)singleOnlineVideoTypesArray from:(NSMutableArray *)array {

   ABOnlineVideoType * lastOnlineVideoType = [MultipleTypeHelper checkExist:onlineVideoType.sqliteObjectName
                                                                         in:singleOnlineVideoTypesArray];

   if (lastOnlineVideoType) {
      [MultipleTypeHelper copyOnlineVideoTypeDictionary:onlineVideoType.onlineTypeDictionary
                            toLastProjectTypeDictionary:lastOnlineVideoType.onlineTypeDictionary];
   } else {
      [singleOnlineVideoTypesArray addObject:onlineVideoType];
   }

}


+ (void)copyOnlineVideoTypeDictionary:(NSMutableDictionary *)onlineTypeDictionary toLastProjectTypeDictionary:(NSMutableDictionary *)lastOnlineTypeDictionary {
   for (NSString * key in onlineTypeDictionary.allKeys) {
      //object.class:[ABProjectType]
      ABProjectType * object = [onlineTypeDictionary objectForKey:key];

      // if the same project type,then append
      if ([[lastOnlineTypeDictionary allKeys] containsObject:key]) {
         // contains key
         ABProjectType * lastObject = [lastOnlineTypeDictionary objectForKey:key];
         [lastObject addLastSqliteObjectArray:object.sqliteObjectArray];
         return;
      }

      // or replace
      [lastOnlineTypeDictionary setObject:object forKey:key];
   }
}


+ (ABOnlineVideoType *)checkExist:(NSString *)onlineVideoTypeName in:(NSMutableArray *)singleOnlineVideoTypesArray {
   for (ABOnlineVideoType * onlineVideoType in singleOnlineVideoTypesArray) {
      if ([onlineVideoTypeName isEqualToString:onlineVideoType.sqliteObjectName]) {
         return onlineVideoType;
      }
   }

   return nil;
}

@end
