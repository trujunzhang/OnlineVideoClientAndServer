//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ABOnlineVideoType.h"
#import "ABProjectType.h"
#import "MobileDB.h"


@implementation ABOnlineVideoType {

}


- (instancetype)init {
   self = [super init];
   if (self) {
      self.sqliteObjectID = [MobileDB uniqueID];
      self.onlineTypeDictionary = [[NSMutableDictionary alloc] init];
   }

   return self;
}


- (instancetype)initWithOnlineTypeName:(NSString *)onlineTypeName projectFullPath:(NSString *)projectFullPath withDictionary:(NSMutableDictionary *)dictionary {
   self = [self init];
   if (self) {
      self.sqliteObjectName = onlineTypeName;
      self.projectFullPath = projectFullPath;

      [self appendProjectTypeDictionary:dictionary];
   }

   return self;
}


- (void)appendProjectTypeDictionary:(NSMutableDictionary *)dictionary {
   for (ABProjectType * projectType in dictionary.allValues) {
      [self appendProjectType:projectType];
   }
}


- (void)appendProjectType:(ABProjectType *)projectType {
   [self.onlineTypeDictionary setObject:projectType forKey:projectType.sqliteObjectName];
}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
   [dictionary setObject:self.sqliteObjectName forKey:@"onlineVideoTypeName"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


@end