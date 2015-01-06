//
//  MFIReport.m
//  MobileApp
//
//  Created by Aaron Bratcher on 12/13/2012.
//  Copyright (c) 2012 Market Force. All rights reserved.
//

#import "ABProjectList.h"

#import "ABProjectFileInfo.h"
#import "MobileDB.h"


@interface ABProjectList ()<NSCoding>

@end


@implementation ABProjectList
- (instancetype)init {
   self = [super init];
   if (self) {
      self.sqliteObjectID = [MobileDB uniqueID];

      self.sqliteObjectName = @"";
      self.sqliteObjectArray = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithProjectListName:(NSString *)projectListName {
   self = [self init];
   if (self) {
      self.sqliteObjectName = projectListName;
   }

   return self;
}


- (BOOL)isEqual:(id)object {
   ABProjectList * compareReport = object;

   return self.sqliteObjectID == compareReport.sqliteObjectID;
}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

   [dictionary setObject:self.sqliteObjectName forKey:@"projectListName"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}



- (ABProjectFileInfo *)getFirstABProjectFileInfo {
   if (self.sqliteObjectArray.count > 0) {
      ABProjectFileInfo * firstFileInfo = self.sqliteObjectArray[0];

      return firstFileInfo;
   }
   return nil;
}


- (ABProjectFileInfo *)checkExistInSubDirectoryWithObjectName:(NSString *)sqliteObjectName {
   for (ABProjectFileInfo * sqliteObject in self.lastsubDirectoryListsArray) {
      if ([sqliteObject.sqliteObjectName isEqualToString:sqliteObjectName]) {
         return sqliteObject;
      }
   }
   return nil;
}


@end
