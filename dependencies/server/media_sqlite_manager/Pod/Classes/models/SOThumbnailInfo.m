//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "SOThumbnailInfo.h"


@implementation SOThumbnailInfo {

}


#pragma mark -
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
   [dictionary setObject:self.fileInfoID forKey:@"fileInfoID"];
   [dictionary setObject:self.sqliteObjectName forKey:@"fileInforName"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


@end