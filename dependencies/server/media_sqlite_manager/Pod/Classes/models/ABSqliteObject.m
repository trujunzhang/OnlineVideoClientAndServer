//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ABSqliteObject.h"


@implementation ABSqliteObject {

}
- (instancetype)init {
   self = [super init];
   if (self) {
   }

   return self;
}


- (NSString *)sqlStringSerializationForUpdate {
   NSMutableDictionary * dictionary = [self getUpdateDictionary];

   NSMutableArray * videoIds = [[NSMutableArray alloc] init];

   NSArray * allKeys = dictionary.allKeys;
   for (NSString * key in allKeys) {
      NSString * value = [dictionary valueForKey:key];

      NSString * data = [NSString stringWithFormat:@"%@ = '%@'", key, value];
      [videoIds addObject:data];
   }


   return [videoIds componentsJoinedByString:@","];
}


- (NSArray *)sqlStringSerializationForInsert {
   NSMutableDictionary * dictionary = [self getInsertDictionary];

   NSArray * allKeys = dictionary.allKeys;
   NSString * tableFieldString = [allKeys componentsJoinedByString:@","];


   NSMutableArray * allValues = [[NSMutableArray alloc] init];
   for (NSString * value in dictionary.allValues) {
      NSString * string = [NSString stringWithFormat:@"'%@'", value];
      [allValues addObject:string];
   }
   NSString * tableValueString = [allValues componentsJoinedByString:@","];


   return @[ tableFieldString, tableValueString ];
}


- (void)updateSqliteObject:(ABSqliteObject *)object {
   self.sqliteObjectID = object.sqliteObjectID;
   self.sqliteObjectName = object.sqliteObjectName;
}


@end