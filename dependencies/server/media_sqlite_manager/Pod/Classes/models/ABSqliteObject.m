//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ABProjectType.h"
#import "ABSqliteObject.h"
#import "MobileDB.h"


@implementation ABSqliteObject {

}
- (instancetype)init {
   self = [super init];
   if (self) {
      self.sqliteObjectID = [MobileDB uniqueID];
      self.sqliteObjectName = @"";
      self.objectFullPath = @"";

      self.sqliteObjectArray = [[NSMutableArray alloc] init];
      self.lastsubDirectoryListsArray = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithSqliteObjectID:(NSString *)sqliteObjectID sqliteObjectName:(NSString *)sqliteObjectName {
   self = [self init];
   if (self) {
      self.sqliteObjectID = sqliteObjectID;
      self.sqliteObjectName = sqliteObjectName;
   }

   return self;
}


- (instancetype)initWithSqliteObjectID:(NSString *)sqliteObjectID sqliteObjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
   self = [self init];
   if (self) {
      self.sqliteObjectID = sqliteObjectID;
      self.sqliteObjectName = sqliteObjectName;
      self.objectFullPath = projectFullPath;
   }

   return self;
}


- (void)appendSqliteObjectToArray:(id)sqliteObject {
   [self.sqliteObjectArray addObject:sqliteObject];
}


- (void)addLastSqliteObjectArray:(NSMutableArray *)array {
   for (id object in array) {
      [self appendSqliteObjectToArray:object];
   }
}


- (NSString *)sqlStringSerializationForUpdate {
   NSMutableDictionary * dictionary = [self appendCommonDictionary:[self getUpdateDictionary]];

   NSMutableArray * videoIds = [[NSMutableArray alloc] init];

   NSArray * allKeys = dictionary.allKeys;
   for (NSString * key in allKeys) {
      NSString * value = [dictionary valueForKey:key];

      NSString * data = [NSString stringWithFormat:@"%@ = \"%@\"", key, [ABSqliteObject adjustSpecialCharactor:value]];
      [videoIds addObject:data];
   }

   return [videoIds componentsJoinedByString:@","];
}


+ (NSString *)adjustSpecialCharactor:(NSString *)value {
//   return [value replaceCharcter:@"'" withCharcter:@"\'"];
   return value;
}


- (NSArray *)sqlStringSerializationForInsert {
   NSMutableDictionary * dictionary = [self appendCommonDictionary:[self getInsertDictionary]];

   NSArray * allKeys = dictionary.allKeys;
   NSString * tableFieldString = [allKeys componentsJoinedByString:@","];


   NSMutableArray * allValues = [[NSMutableArray alloc] init];
   for (NSString * value in dictionary.allValues) {
      NSString * string = [NSString stringWithFormat:@"\"%@\"", [ABSqliteObject adjustSpecialCharactor:value]];
      [allValues addObject:string];
   }
   NSString * tableValueString = [allValues componentsJoinedByString:@","];


   return @[ tableFieldString, tableValueString ];
}


- (NSMutableDictionary *)appendCommonDictionary:(NSMutableDictionary *)dictionary {
   [dictionary setObject:self.objectFullPath forKey:@"objectFullPath"];

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

      NSString * data = [NSString stringWithFormat:@"%@ = \"%@\"", key, [ABSqliteObject adjustSpecialCharactor:value]];
      [videoIds addObject:data];
   }


   return [videoIds componentsJoinedByString:@" and "];
}


- (void)updateSqliteObject:(ABSqliteObject *)object {
   self.sqliteObjectID = object.sqliteObjectID;
   self.sqliteObjectName = object.sqliteObjectName;
}


- (NSString *)makeObjectFullPath:(NSString *)parentFullPath {
   self.objectFullPath = [NSString stringWithFormat:@"%@/%@", parentFullPath, self.sqliteObjectName];
   return self.objectFullPath;
}


@end