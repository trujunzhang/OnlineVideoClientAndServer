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
      self.projectFullPath = @"";
   }

   return self;
}


- (instancetype)initWithSqliteObjectID:(int)sqliteObjectID sqliteObjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
   self = [super init];
   if (self) {
      self.sqliteObjectID = sqliteObjectID;
      self.sqliteObjectName = sqliteObjectName;
      self.projectFullPath = projectFullPath;
   }

   return self;
}


- (NSString *)sqlStringSerializationForUpdate {
   NSMutableDictionary * dictionary = [self appendCommonDictionary:[self getUpdateDictionary]];

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
   NSMutableDictionary * dictionary = [self appendCommonDictionary:[self getInsertDictionary]];

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


- (NSMutableDictionary *)appendCommonDictionary:(NSMutableDictionary *)dictionary {
   [dictionary setObject:self.projectFullPath forKey:@"projectFullPath"];

   return dictionary;
}


+ (NSString *)getSqlStringSerializationForFilter:(NSMutableDictionary *)filterDictionary {
   if (filterDictionary.count == 0) {
      return @"0 = 0";
   }

   NSMutableArray * videoIds = [[NSMutableArray alloc] init];

   NSArray * allKeys = filterDictionary.allKeys;
   for (NSString * key in allKeys) {
      NSString * value = [filterDictionary valueForKey:key];

      NSString * data = [NSString stringWithFormat:@"%@ = '%@'", key, value];
      [videoIds addObject:data];
   }


   return [videoIds componentsJoinedByString:@" and "];
}


- (void)updateSqliteObject:(ABSqliteObject *)object {
   self.sqliteObjectID = object.sqliteObjectID;
   self.sqliteObjectName = object.sqliteObjectName;
}


@end