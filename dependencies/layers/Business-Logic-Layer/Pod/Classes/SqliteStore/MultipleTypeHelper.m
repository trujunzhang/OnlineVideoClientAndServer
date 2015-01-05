//
// Created by djzhang on 1/1/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MultipleTypeHelper.h"
#import "ABOnlineVideoType.h"


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
      [MultipleTypeHelper copyOnlineVideoTypeDictionary:onlineVideoType.onlineTypeDictionary to:lastOnlineVideoType];
   } else {
      [singleOnlineVideoTypesArray addObject:onlineVideoType];
   }

}


+ (void)copyOnlineVideoTypeDictionary:(NSMutableDictionary *)onlineTypeDictionary to:(ABOnlineVideoType *)lastOnlineVideoType {
   for (NSString * key in onlineTypeDictionary.allKeys) {
      [lastOnlineVideoType.onlineTypeDictionary setObject:[onlineTypeDictionary objectForKey:key] forKey:key];
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


+ (NSMutableDictionary *)getOnlineVideoTypePathDictionary:(NSMutableArray *)array {
   NSMutableDictionary * onlineVideoTypePathDictionary = [[NSMutableDictionary alloc] init];
   for (ABOnlineVideoType * onlineVideoType in array) {

//      [onlineVideoTypePathDictionary setObject:onlineVideoType.onlineVideoTypePath
//                                        forKey:[NSString stringWithFormat:@"%i", onlineVideoType.onlineVideoTypeID]];
   }

   return onlineVideoTypePathDictionary;
}
@end
