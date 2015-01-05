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
      self.projectFileInfos = [[NSMutableArray alloc] init];
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


- (void)appendFileInfo:(ABProjectFileInfo *)fileInfo {
   [self.projectFileInfos addObject:fileInfo];
}


- (ABProjectFileInfo *)getFirstABProjectFileInfo {
   if (self.projectFileInfos.count > 0) {
      ABProjectFileInfo * firstFileInfo = self.projectFileInfos[0];

      return firstFileInfo;
   }
   return nil;
}


- (NSNumber *)getSortNumber {

   return nil;
}

@end
