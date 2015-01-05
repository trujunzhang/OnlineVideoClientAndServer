//
//  MFIReport.m
//  MobileApp
//
//  Created by Aaron Bratcher on 12/13/2012.
//  Copyright (c) 2012 Market Force. All rights reserved.
//

#import "ABProjectFileInfo.h"

#import "MobileDB.h"
#import "NSString+PJR.h"


@interface ABProjectFileInfo ()<NSCoding>

@end


@implementation ABProjectFileInfo
- (instancetype)init {
   self = [super init];
   if (self) {
      self.sqliteObjectID = [MobileDB uniqueID];

      self.sqliteObjectName = @"";
      self.subtitleName = @"";
      self.projectFullPath = @"";
   }

   return self;
}


- (instancetype)initWithFileInforName:(NSString *)fileInforName {
   self = [self init];
   if (self) {
      self.sqliteObjectName = fileInforName;
   }

   return self;
}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];

   [dictionary setObject:self.sqliteObjectName forKey:@"fileInforName"];
   [dictionary setObject:self.subtitleName forKey:@"subtitleName"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


- (NSString *)getOnlineVideoPlayUrl:(NSString *)domain {
   return [NSString stringWithFormat:@"%@%@", domain, [self encodeAbstractFilePath]];
}


- (NSString *)encodeAbstractFilePath {
   return [self.projectFullPath replaceCharcter:@" " withCharcter:@"%20"];
}


//- (NSString *)getCacheFileInfoThumbnail {
//   return [NSString stringWithFormat:@"%@%@.jpg", @"/.cache/thumbnail/", [self encodeAbstractFilePath]];
//}
- (ABProjectFileInfo *)checkExistForFileInfoWithFileInfoName:(NSString *)sqliteObjectName {


   return nil;
}


@end
